# SPDX-FileCopyrightText: (C) 2025 Temple University <kleinweb@temple.edu>
# SPDX-License-Identifier: GPL-3.0-or-later

{
  php,
  writeShellApplication,
}:
writeShellApplication {
  name = "php-lint";
  runtimeInputs = [
    php
    php.packages.php-parallel-lint
  ];
  text = ''
    parallel-lint \
      --exclude .git --exclude .cache --exclude .data --exclude .direnv \
      --exclude vendor --exclude node_modules \
      "$@"
  '';
}
