# SPDX-FileCopyrightText: 2022-2025 Temple University <kleinweb@temple.edu>
# SPDX-License-Identifier: GPL-3.0-or-later

###: <https://just.systems/man/en/>

import '.config/vars.just'

mod aws '.config/aws'
mod release '.config/release'
mod reuse '.config/reuse'

# Display a list of available tasks as the default command
default:
    @just --choose

push: check
    git checkout main
    git push origin main
    git push codeberg main

[doc("Check for any lint or formatting issues on project files")]
[group("qa")]
check: (reuse::check)
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

clean:
    fd -t d -I dist packages -X rm -rf {}
