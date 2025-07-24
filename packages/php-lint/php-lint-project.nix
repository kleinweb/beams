# SPDX-FileCopyrightText: (C) 2025 Temple University <kleinweb@temple.edu>
# SPDX-License-Identifier: GPL-3.0-or-later

{
  fd,
  php-lint,
  writeShellApplication,
}:
writeShellApplication {
  name = "php-lint-project";
  runtimeInputs = [
    fd
    php-lint
  ];
  text = ''
    fd --type file --extension php --hidden --exec-batch \
      php-lint --show-deprecated
  '';
}
