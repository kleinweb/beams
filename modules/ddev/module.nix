# SPDX-FileCopyrightText: (C) 2025 Temple University <kleinweb@temple.edu>
# SPDX-License-Identifier: GPL-3.0-or-later

{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.programs.ddev;
in
{
  options = {
    programs.ddev = {
      enable = lib.mkEnableOption "ddev";
      package = lib.mkPackageOption pkgs "ddev" { };
    };
  };

  config = lib.mkIf cfg.enable {
    # Any other user who needs to be able to run Docker containers will need to be
    # added to this group.  However, note that this essentially gives container
    # `root` users access to the host system via the socket.
    users.groups.docker.members = config.users.groups.wheel.members;

    # FIXME: do not expose to world!
    networking.firewall.allowedTCPPorts = [
      9003 # xdebug
    ];

    virtualisation.docker.enable = true;

    environment.systemPackages = [
      cfg.package

      pkgs.docker-buildx
      pkgs.docker-compose
      pkgs.mkcert

      # <https://ddev.readthedocs.io/en/stable/users/install/docker-installation/#testing-and-troubleshooting-your-docker-installation>
      (pkgs.writeShellScriptBin "ddev-verify-installation" ''
        docker run --rm -t -p 80:80 -p 443:443 -v "//$PWD:/tmp/projdir" \
          busybox sh -c "echo ---- Project Directory \
        && ls /tmp/projdir"
      '')
    ];
  };
}
