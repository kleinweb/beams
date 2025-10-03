# SPDX-FileCopyrightText: 2025 Temple University <kleinweb@temple.edu>
# SPDX-License-Identifier: GPL-3.0-or-later

{
  perSystem =
    {
      config,
      inputs',
      pkgs,
      ...
    }:
    let
      commonPkgs = [
        pkgs.fd
        pkgs.gnused
        pkgs.jq
        inputs'.nixpkgs-trunk.legacyPackages.just
        pkgs.moreutils # provides `sponge`
        pkgs.reuse
        pkgs.ripgrep
        pkgs.turbo
        pkgs.nodejs
      ];

      checksPkgs = config.pre-commit.settings.enabledPackages ++ [
        pkgs.biome
        pkgs.dotenv-linter
      ];

      formatterPkgs = config.pre-commit.settings.hooks.treefmt.settings.formatters ++ [
        pkgs.treefmt
      ];

      ciPkgs = commonPkgs ++ checksPkgs;
      devPkgs =
        commonPkgs
        ++ checksPkgs
        ++ formatterPkgs
        ++ [
          pkgs.cocogitto
          pkgs.json2ts
        ];

    in
    {
      devShells.default = pkgs.mkShellNoCC {
        shellHook = ''
          : "''${PRJ_BIN_HOME:=''${PRJ_PATH:-''${PRJ_ROOT}/.bin}}"

          export PRJ_BIN_HOME

          ${config.pre-commit.installationScript}
        '';
        nativeBuildInputs = devPkgs;
      };
      devShells.ci = pkgs.mkShellNoCC { nativeBuildInputs = ciPkgs; };
    };
}
