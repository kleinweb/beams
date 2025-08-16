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
