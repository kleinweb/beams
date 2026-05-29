# SPDX-FileCopyrightText: 2024-2025 Temple University <kleinweb@temple.edu>
# SPDX-License-Identifier: GPL-3.0-or-later

# Citrix Secure Access client (package `nsgclient`) for Linux — the NetScaler
# Gateway VPN client. Unlike `citrix-workspace`, upstream ships a plain Debian
# package with a fixed file tree, so this derivation is just:
#
#   unpack .deb  ->  autoPatchelfHook  ->  wrap for GTK
#
# The `NSGClient` binary hardcodes absolute `/opt/Citrix/...` paths for its
# resources, config files and the IPC socket-path file, so it only *runs*
# correctly when the companion NixOS module (`./module.nix`) has materialised
# that tree. Building the package alone is not enough.
{
  lib,
  stdenv,
  requireFile,
  dpkg,
  autoPatchelfHook,
  wrapGAppsHook3,
  makeWrapper,

  # Runtime libraries — the union of the `DT_NEEDED` entries of NSGClient,
  # service/nsgverctl and EPA/libepalib.so (see `patchelf --print-needed`).
  curl,
  dconf,
  glib,
  glib-networking,
  gpgme,
  gsettings-desktop-schemas,
  gtk3,
  libarchive,
  libayatana-appindicator,
  libnl,
  libnotify,
  libproxy,
  libuuid,
  # libxml2 2.14 bumped its soname to libxml2.so.16; NSGClient is linked
  # against the old libxml2.so.2, so we need the pinned 2.13 series.
  libxml2_13,
  networkmanager,
  openssl,
  procps,
  pugixml,
  webkitgtk_4_1,
  xorg,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "citrix-secure-access";
  version = "25.8.2";

  # Unfree, EULA-gated: the .deb cannot be fetched inside the build sandbox.
  # `requireFile` makes the build fail with the message below until the file
  # has been added to the store manually.
  src = requireFile {
    name = "nsginstaller64.deb";
    sha256 = "1cq95i3i3bd67aknwxz4bdkqfj288dp0fvsa80w7g166jma0klsn";
    message = ''
      Citrix Secure Access is distributed under the Citrix EULA and cannot be
      downloaded automatically. Obtain the "Citrix Secure Access client for
      Ubuntu" .deb (named `nsginstaller64.deb`) from:

        https://www.citrix.com/downloads/citrix-gateway/

      then add it to the Nix store with:

        nix-prefetch-url file://$PWD/nsginstaller64.deb
    '';
  };

  # stdenv has no built-in unpacker for `.deb`; a Debian package is an `ar`
  # archive whose `data.tar.*` member holds the file tree. `dpkg-deb -x`
  # extracts exactly that tree.
  unpackCmd = "dpkg-deb -x $curSrc source";
  sourceRoot = "source";

  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
    makeWrapper
    wrapGAppsHook3
  ];

  buildInputs = [
    curl
    dconf
    glib
    glib-networking
    gpgme
    gsettings-desktop-schemas
    gtk3
    libarchive
    libayatana-appindicator
    libnl
    libnotify
    libproxy
    libuuid
    (lib.getLib libxml2_13) # libxml2's default output is `bin` (no .so)
    (lib.getLib networkmanager) # provides libnm.so.0
    openssl
    # nixpkgs builds pugixml as a static archive by default; the client needs
    # the shared libpugixml.so.1.
    (pugixml.override { shared = true; })
    stdenv.cc.cc # libstdc++ / libgcc_s
    webkitgtk_4_1
    xorg.libX11
    xorg.libXScrnSaver # libXss.so.1
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/applications
    cp -r opt $out/opt

    # `$out/bin/NSGClient` is a convenience entry point. The NixOS module
    # re-wraps it through `security.wrappers` to grant CAP_NET_RAW; the cap
    # propagates through this wrapper via ambient capabilities.
    makeWrapper $out/opt/Citrix/NSGClient/bin/NSGClient $out/bin/NSGClient \
      --prefix PATH : "${
        lib.makeBinPath [
          dpkg
          procps
        ]
      }" \
      --prefix GIO_EXTRA_MODULES : "${glib-networking}/lib/gio/modules"

    # Desktop entry: strip the hardcoded /opt path so it launches `NSGClient`
    # from PATH (which, on a NixOS host with the module, resolves to the
    # capability wrapper in /run/wrappers/bin first).
    install -Dm644 opt/Citrix/NSGClient/bin/nsgclient.desktop \
      $out/share/applications/citrix-secure-access.desktop
    substituteInPlace $out/share/applications/citrix-secure-access.desktop \
      --replace-fail "/opt/Citrix/NSGClient/bin/NSGClient" "NSGClient" \
      --replace-fail \
        "Icon=/opt/Citrix/NSGClient/resx/images/icon_vpn.ico" \
        "Icon=$out/opt/Citrix/NSGClient/resx/images/icon_vpn.ico"

    runHook postInstall
  '';

  meta = {
    description = "Citrix Secure Access client (NetScaler Gateway VPN) for Linux";
    homepage = "https://www.citrix.com/downloads/citrix-gateway/";
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "NSGClient";
  };
})
