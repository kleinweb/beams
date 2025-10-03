# SPDX-FileCopyrightText: (C) 2024-2025 Temple University <kleinweb@temple.edu>
# SPDX-License-Identifier: GPL-3.0-or-later

[no-cd]
[confirm: "Publish releases?"]
[doc: "Publish available releases"]
publish:
    npm run release

[no-cd]
new-change:
    npx @changesets/cli
