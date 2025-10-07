// SPDX-FileCopyrightText: 2024-2025 Temple University <kleinweb@temple.edu>
// SPDX-FileCopyrightText: 2023-2025 Evo Mark Ltd.
// SPDX-License-Identifier: GPL-3.0-or-later OR MIT

import type { InputOptions, ExternalOption } from 'rollup'
import { wordpressMatch, external } from './outputOptions.ts'

export function options(options: InputOptions): InputOptions {
  if (Array.isArray(options.external) === false) {
    // If string, RegExp or function
    options.external = [options.external].filter(Boolean) as ExternalOption
  }

  if (Array.isArray(options.external)) {
    options.external = options.external.concat(Object.keys(external))
    options.external.push(wordpressMatch)
  }

  return options
}
