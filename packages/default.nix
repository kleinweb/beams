{
  imports = [ ./php-lint.nix ];

  perSystem =
    { pkgs, ... }:
    {
      packages = {
        # TODO: Remove when available upstream: https://github.com/NixOS/nixpkgs/pull/344503
        ddev = pkgs.callPackage ./ddev.nix { };

        php-stubs-generator = pkgs.callPackage ./php-stubs-generator/package.nix { };
      };
    };
}
