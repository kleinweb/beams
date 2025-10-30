# SPDX-FileCopyrightText: 2024-2025 Temple University <kleinweb@temple.edu>
# SPDX-License-Identifier: GPL-3.0-or-later
{
  description = "Beams";
  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-darwin"
        "aarch64-linux"
      ];

      imports = [
        inputs.flake-parts.flakeModules.modules
        inputs.flake-parts.flakeModules.partitions

        ./modules
        ./packages
      ];

      perSystem =
        { pkgs, ... }:
        {
          formatter = pkgs.nixfmt-rfc-style;
        };

      partitions.dev = {
        extraInputsFlake = ./.config;
        module =
          { inputs, ... }:
          {
            imports = [
              inputs.pre-commit-hooks.flakeModule
              ./.config/devshells
              ./.config/git-hooks
            ];
          };
      };

      partitionedAttrs = {
        checks = "dev";
        devShells = "dev";
      };
    };
}
