# SPDX-FileCopyrightText: (C) 2025 Temple University <kleinweb@temple.edu>
# SPDX-License-Identifier: GPL-3.0-or-later

{ config, lib, ... }:
let
  cfg = config.kleinweb.dev;
in
{
  options = {
    kleinweb.dev = {
      enable = lib.mkEnableOption "Whether to enable Kleinweb local development features.";
    };
  };

  config = lib.mkIf cfg.enable {

  };
}
