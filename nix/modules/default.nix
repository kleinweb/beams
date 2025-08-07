{
  flake.modules = {
    generic = {
      kleinweb-dev = ./kleinweb/dev/module.nix;
    };

    nixos = {
      ddev = ./ddev/module.nix;
      kleinweb-dev__hosts-entries = ./kleinweb/dev/hosts-entries/module.nix;
    };

    home = {
      kleinweb-dev__ssh-aliases = ./kleinweb/dev/ssh/aliases.nix;
      kleinweb-dev__tools = ./kleinweb/dev/tools/module.nix;
    };
  };
}
