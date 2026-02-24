# SPDX-FileCopyrightText: 2024-2025 Temple University <kleinweb@temple.edu>
#
# SPDX-License-Identifier: GPL-3.0-or-later

{
  perSystem =
    { config, pkgs, ... }:
    {
      pre-commit.settings = {
        hooks = {
          check-xml.enable = true;
          composer-lint = {
            enable = true;
            entry = "composer lint --";
            types = [
              "file"
              "php"
            ];
          };
          markdownlint.enable = true;
          markdownlint.excludes = [
            # Auto-generated
            ".changeset/"
            "CHANGELOG.md"
          ];
          reuse = {
            enable = true;
          };
          treefmt = {
            enable = true;
            settings.formatters = [
              config.formatter
              pkgs.biome
              pkgs.dos2unix
              pkgs.prettier
              pkgs.taplo
            ];
          };
          yamllint.enable = true;
        };
        default_stages = [
          "pre-commit"
          "pre-push"
        ];

        excludes = [ ];
      };
    };
}
