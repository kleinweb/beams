// SPDX-FileCopyrightText: (C) 2025 Temple University <kleinweb@temple.edu>
// SPDX-License-Identifier: GPL-3.0-or-later

import { createViteBlock } from '@kleinweb/vite-plugin-gutenberg-blocks'
import { defineConfig } from 'vite'

export default defineConfig({
  plugins: [createViteBlock()],
})
