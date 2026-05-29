# SPDX-FileCopyrightText: (C) 2025 Temple University <kleinweb@temple.edu>
# SPDX-License-Identifier: GPL-3.0-or-later

{ withSystem, ... }:
{
  flake.modules = {
    generic = {
      kleinweb-dev = ./kleinweb/dev/module.nix;
    };

    nixos = {
      default = {
        imports = [
          ./ddev/module.nix
          ./kleinweb/dev/module.nix
          ./kleinweb/dev/hosts-entries/module.nix
        ];

        programs.ddev.enable = true;
        kleinweb.dev.enable = true;
        kleinweb.dev.hostsEntries.enable = true;
      };

      citrix-secure-access =
        { pkgs, ... }:
        {
          imports = [ ./citrix-secure-access/nixos-module.nix ];
          services.citrix-secure-access.package = withSystem pkgs.stdenv.hostPlatform.system (
            { config, ... }: config.packages.citrix-secure-access
          );
        };

      ddev = ./ddev/module.nix;

      kleinweb-dev__hosts-entries = ./kleinweb/dev/hosts-entries/module.nix;
    };

    homeManager = {
      default = {
        imports = [
          ./kleinweb/dev/module.nix
          ./kleinweb/dev/ssh/aliases.nix
        ];
      };
      kleinweb-dev__ssh-aliases = ./kleinweb/dev/ssh/aliases.nix;
    };
  };
}
