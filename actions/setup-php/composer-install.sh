#!/usr/bin/env bash

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

composer install "$COMPOSER_ARGS"
