# SPDX-FileCopyrightText: 2022-2025 Temple University <kleinweb@temple.edu>
# SPDX-License-Identifier: GPL-3.0-or-later

###: <https://just.systems/man/en/>

import '.config/vars.just'

mod release '.config/release'
mod reuse '.config/reuse'

# Display a list of available tasks as the default command
default:
    @just --choose

[doc("Check for any lint or formatting issues on project files")]
[group("qa")]
check:
    dotenv-linter check
    nix flake check

[doc("Write *all* formatter+fixer changes to project files")]
[group("qa")]
fix:
    treefmt
    composer fix

[doc("Write _safe_ formatter changes to project files")]
[group("qa")]
fmt:
    treefmt
