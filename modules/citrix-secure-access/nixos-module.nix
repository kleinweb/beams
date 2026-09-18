# SPDX-FileCopyrightText: 2024-2025 Temple University <kleinweb@temple.edu>
# SPDX-License-Identifier: GPL-3.0-or-later

# The package on its own only produces a patched binary tree in the Nix
# store.  The `NSGClient` binary hardcodes absolute `/opt/Citrix/...`
# paths and needs three pieces of system integration that a package
# cannot provide:
#
#   1. CAP_NET_RAW on the binary  — it opens raw sockets for the VPN data path.
#   2. The `nsgverctl` system service — privileged route/nftables setup.
#   3. The `/opt/Citrix` tree on disk — because the paths are not relocatable.
{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.citrix-secure-access;

  optTree = "${cfg.package}/opt/Citrix";

  readOnlyEntries = [
    "resx"
    "service"
    "libAnalyticsInterface.so"
    "libsentry.so"
    "crashpad_handler"
    "pubkey.asc"
    "citrix_va.conf"
    "rt_csa.conf"
    "globalConfiguration.conf"
    "userConfiguration.conf"
    "bin/nsgclient.desktop"
    "bin/nsgtsb.sh"
    "bin/startnsgclient.sh"
  ];

  mkCopy = entry: "C /opt/Citrix/NSGClient/${entry} 0644 root root - ${optTree}/NSGClient/${entry}";
  mkSymlink = entry: "L+ /opt/Citrix/NSGClient/${entry} - - - - ${optTree}/NSGClient/${entry}";

  staticTreeRules = [
    "d /opt/Citrix 0755 root root -"
    "d /opt/Citrix/NSGClient 0755 root root -"
    "d /opt/Citrix/NSGClient/bin 0755 root root -"
    # The EPA (Endpoint Analysis) library is dlopen()ed by absolute path.
    "L+ /opt/Citrix/EPA - - - - ${optTree}/EPA"
    # `nsgverctl` authenticates each packet by reading the sender's
    # `/proc/<pid>/exe` and comparing it against this exact path, so the client
    # must *be* this file rather than a symlink to it -- `exe` resolves through
    # symlinks and would report the store path, failing the check ("Path match
    # fail. Packet received from unauthentic NSGClient") and leaving the
    # command silently unanswered.  A copy carries CAP_NET_RAW, which cannot be
    # set on the read-only store path.
    "C+ /opt/Citrix/NSGClient/bin/NSGClient 0755 root root - ${cfg.package}/opt/Citrix/NSGClient/bin/NSGClient"
  ]
  ++ map mkSymlink readOnlyEntries;

  # ----------------------------------------------------------------------
  # TODO(learning): define `runtimeStateRules` — the writable parts of the tree.
  #
  # Three paths CANNOT be store symlinks, because the running client (or the
  # root `nsgverctl` service) writes to them:
  #
  #   /opt/Citrix/NSGClient/.socketpath     AF_UNIX datagram socket that
  #                                         nsgverctl binds. Must NOT be
  #                                         pre-created -- see the rule below.
  #   /opt/Citrix/NSGClient/nft_commands.txt  nftables ruleset scratch file
  #                                           written by nsgverctl. 0644.
  #   /opt/Citrix/NSGClient/tmp             scratch *directory* the service
  #                                         expects. 0755.
  #
  # And one genuine design decision — `globalConfiguration.json`:
  #   - The upstream installer MERGES the previous file into the new one, which
  #     implies admins are expected to tune it and have edits survive upgrades.
  #   - Option A: `C /opt/.../globalConfiguration.json 0644 root root - SOURCE`
  #     copies the package's copy ONCE; later edits persist, but a package
  #     upgrade will NOT refresh it (state drifts from the Nix store).
  #   - Option B: `L+ ...` symlink — fully reproducible and always matches the
  #     package, but the client cannot persist any change to it.
  #
  # systemd-tmpfiles line types you need:
  #   d  PATH MODE UID GID AGE        create a directory
  #   f  PATH MODE UID GID - -        create an empty file if absent
  #   C  PATH MODE UID GID - SOURCE   copy SOURCE to PATH if absent
  #   L+ PATH - - - - TARGET          create a symlink, replacing what's there
  #
  # `${optTree}/NSGClient/globalConfiguration.json` is the package's copy.
  # Implement the list below (~5 lines): the three writable paths, plus the
  # globalConfiguration.json rule for whichever option fits this deployment.
  runtimeStateRules = [
    # nsgverctl bind(2)s this path itself; bind fails EADDRINUSE if anything
    # already exists there, so ensure it is absent rather than pre-creating it.
    "r /opt/Citrix/NSGClient/.socketpath"
    "f /opt/Citrix/NSGClient/nft_commands.txt 0644 root root - -"
    "d /opt/Citrix/NSGClient/tmp 0755 root root -"
    (mkCopy "globalConfiguration.json")
  ];

in
{
  options.services.citrix-secure-access = {
    enable = lib.mkEnableOption "the Citrix Secure Access VPN client";

    package = lib.mkOption {
      type = lib.types.package;
      defaultText = lib.literalMD "`packages.citrix-secure-access` from the beams flake";
      description = "The citrix-secure-access package to use.";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    # NSGClient needs CAP_NET_RAW for the VPN data path.  A `security.wrappers`
    # entry cannot serve here: launching through it makes `/proc/<pid>/exe`
    # report the wrapper, which `nsgverctl` rejects (see the tmpfiles rule
    # above).  Set the capability directly on the copy instead.
    # tmpfiles places the copy; this must run after it and before the client
    # is launched.  `nsgverctl` needs it in place too, hence the ordering.
    systemd.services.citrix-secure-access-setcap = {
      description = "Grant CAP_NET_RAW to the Citrix Secure Access client";
      wantedBy = [ "multi-user.target" ];
      before = [ "nsgverctl.service" ];
      after = [ "systemd-tmpfiles-setup.service" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = "${pkgs.libcap}/bin/setcap cap_net_raw+eip /opt/Citrix/NSGClient/bin/NSGClient";
      };
    };

    # Privileged daemon: route/nftables/DNS plumbing for the tunnel.
    systemd.services.nsgverctl = {
      description = "Citrix NSG Version Control Service";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      # The daemon shells out to route/firewall tooling at runtime.
      path = with pkgs; [
        iproute2
        nftables
        procps
      ];
      serviceConfig = {
        # `nsgverctl` invokes these by absolute path rather than resolving them
        # on PATH, so `path` above does not reach them.  Without `nft` it cannot
        # install the tunnel ruleset, leaving the client's VA_INSTALL command
        # unanswered.  Bind them into this unit's own mount namespace so the
        # host's `/usr` stays untouched.
        BindReadOnlyPaths = [
          "${pkgs.nftables}/bin/nft:/usr/sbin/nft"
          "${pkgs.systemd}/bin/systemctl:/usr/bin/systemctl"
        ];
        # tmpfiles ordering against this unit is not guaranteed, so clear a
        # stale socket here too. The leading `-` tolerates an absent path.
        ExecStartPre = "-${pkgs.coreutils}/bin/rm -f /opt/Citrix/NSGClient/.socketpath";
        ExecStart = "${optTree}/NSGClient/service/nsgverctl";
        Restart = "always";
        KillMode = "process";
      };
    };

    # The tunnel interface (`Citrix_VA`) must be left alone by NetworkManager,
    # and the client needs its dedicated routing-table id registered.
    networking.networkmanager.enable = lib.mkDefault true;
    environment.etc."NetworkManager/conf.d/citrix_va.conf".source =
      "${optTree}/NSGClient/citrix_va.conf";
    environment.etc."iproute2/rt_tables.d/rt_csa.conf".source = "${optTree}/NSGClient/rt_csa.conf";

    # Materialise the hardcoded /opt/Citrix tree.
    systemd.tmpfiles.rules = staticTreeRules ++ runtimeStateRules;
  };
}
