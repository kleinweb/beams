{ config, lib, ... }:
let
  cfg = config.kleinweb.dev.hostsEntries;
in
{
  options = {
    kleinweb.dev.hostsEntries = {
      enable = lib.mkEnableOption "/etc/hosts entries for local development";
    };
  };

  config = lib.mkIf cfg.enable {
    networking.hosts = {
      "127.0.0.1" = [
        "kleinforms.ddev.site"
        "kleinsites.ddev.site"
        "logancenter.ddev.site"
        "logance.ddev.site"
        "phillyn.ddev.site"
        "telepresence.ddev.site"
        "tutv.ddev.site"
        "whipradio.ddev.site"

        "seesaw.ddev.site"
        "pingpong.seesaw.ddev.site"
        "kleinit.seesaw.ddev.site"

        "templenews.ddev.site"
        "chopboom.templenews.ddev.site"
        "longform.templenews.ddev.site"
        "makingitwork.templenews.ddev.site"
        "owlery.templenews.ddev.site"
        "thecherry.templenews.ddev.site"
      ];
    };
  };
}
