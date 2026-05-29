# SPDX-FileCopyrightText: (C) 2025-2026 Temple University <kleinweb@temple.edu>
# SPDX-License-Identifier: GPL-3.0-or-later
{ lib, ... }:
{
  perSystem =
    { config, pkgs, ... }:
    {
      packages = {
        citrix-secure-access = pkgs.callPackage ./citrix-secure-access/package.nix { };
        php-stubs-generator = pkgs.callPackage ./php-stubs-generator/package.nix { };
        shib-keygen = pkgs.callPackage ./shib-keygen/package.nix { };
      };
    };
}
