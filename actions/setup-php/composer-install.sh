#!/usr/bin/env bash

# SPDX-FileCopyrightText: (C) 2025 Temple University <kleinweb@temple.edu>
# SPDX-License-Identifier: GPL-3.0-or-later

set -euo pipefail

: "${COMPOSER_INSTALL_DEVELOPMENT:=yes}"
: "${COMPOSER_INSTALL_EXTRA_ARGS:=}"
: "${COMPOSER_INSTALL_OVERRIDE_ARGS:=}"

COMPOSER_ARGS="--no-progress ${COMPOSER_INSTALL_EXTRA_ARGS}"

with_arg () {
  COMPOSER_ARGS="${COMPOSER_ARGS} ${1:-}"
}

if [[ -z "$COMPOSER_INSTALL_OVERRIDE_ARGS" ]]; then
  if [[ "false" == "${COMPOSER_INSTALL_DEVELOPMENT}" ]]; then
    with_arg "--no-dev"
  fi
fi

# shellcheck disable=SC2086
composer install $COMPOSER_ARGS
