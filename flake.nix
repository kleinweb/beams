# SPDX-FileCopyrightText: 2024-2025 Temple University <kleinweb@temple.edu>
# SPDX-License-Identifier: GPL-3.0-or-later
{
  description = "Beams";
  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";
    pre-commit-hooks.inputs.nixpkgs.follows = "nixpkgs";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    inputs@{ nixpkgs, flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-darwin"
        "aarch64-linux"
      ];

      imports = [
        inputs.pre-commit-hooks.flakeModule

        ./.config/devshells
        ./.config/git-hooks

        ./modules
        ./packages
      ];

      perSystem =
        { system, pkgs, ... }:
        {
          _module.args = {
            pkgs = import nixpkgs {
              inherit system;
              config.allowUnfree = true;
            };
          };
          formatter = pkgs.nixfmt-rfc-style;
        };
    };
}
