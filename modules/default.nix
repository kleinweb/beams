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
      ddev = ./ddev/module.nix;
      kleinweb-dev__hosts-entries = ./kleinweb/dev/hosts-entries/module.nix;
    };

    home = {
      default = {
        imports = [
          ./kleinweb/dev/module.nix
          ./kleinweb/dev/ssh/aliases.nix
          ./kleinweb/dev/tools/module.nix
        ];

        kleinweb.dev.tools.enable = true;
      };
      kleinweb-dev__ssh-aliases = ./kleinweb/dev/ssh/aliases.nix;
      kleinweb-dev__tools = ./kleinweb/dev/tools/module.nix;
    };
  };
}
