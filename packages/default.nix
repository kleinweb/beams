{ lib, ... }:
{
  perSystem =
    { config, pkgs, ... }:
    {
      apps = {
        php-lint-project = {
          type = "app";
          program = lib.getExe config.packages.php-lint-project;
        };
      };
      packages = {
        # TODO: Remove when available upstream: https://github.com/NixOS/nixpkgs/pull/344503
        ddev = pkgs.callPackage ./ddev/package.nix { };
        php-lint = pkgs.callPackage ./php-lint/package.nix { };
        php-lint-project = pkgs.callPackage ./php-lint/php-lint-project.nix {
          inherit (config.packages) php-lint;
        };
        php-stubs-generator = pkgs.callPackage ./php-stubs-generator/package.nix { };
        shib-keygen = pkgs.callPackage ./shib-keygen/package.nix { };
      };
    };
}
