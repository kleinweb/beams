// SPDX-FileCopyrightText: (C) 2025 Temple University <kleinweb@temple.edu>
// SPDX-License-Identifier: GPL-3.0-or-later

import { defineConfig } from 'tsdown'

export default defineConfig({
  entry: ['./src/index.ts'],
  dts: {
    sourcemap: true,
  },
  exports: true,
})
