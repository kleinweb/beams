# SPDX-FileCopyrightText: (C) 2025 Temple University <kleinweb@temple.edu>
# SPDX-License-Identifier: GPL-3.0-or-later

{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.kleinweb.dev.tools;
in
{
  options = {
    kleinweb.dev.tools = {
      enable = lib.mkEnableOption "Whether to enable baseline development tools used by Kleinweb developers.";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      awscli2
      dig
      curl
      fd
      jq
      phpactor
      rclone
      ripgrep
      trurl
      wp-cli
    ];
  };
}
