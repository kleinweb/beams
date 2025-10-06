// SPDX-FileCopyrightText: 2024-2025 Temple University <kleinweb@temple.edu>
// SPDX-FileCopyrightText: 2023-2025 Evo Mark Ltd.
// SPDX-License-Identifier: GPL-3.0-or-later OR MIT

import { generateFileHash, generatePhpAssetFile } from './utils.ts'
import type { OutputAsset, OutputBundle, OutputChunk } from 'rollup'

export function isOutputChunk(
  bundle: OutputAsset | OutputChunk,
): bundle is OutputChunk {
  return Object.hasOwn(bundle, 'code')
}

/**
 * WordPress blocks wont be detected unless an `index.asset.php` file is generated for each one which
 * tells WP information about versioning and dependencies.
 *
 * This function maps the imports from the @wordpress namespace, generates a version hash and then
 * emits the required php file into the build folder
 *
 * @see https://rollupjs.org/plugin-development/#generatebundle
 */
export function generateBundle(
  bundle: OutputBundle,
  dependencies: string[],
): string {
  let hash: string = ''

  const imports = Object.values(bundle).reduce((acc, file) => {
    if (!isOutputChunk(file)) return acc
    hash = generateFileHash(file.code)
    file.imports.forEach((i) => {
      i = i.replace(/^@wordpress\//, 'wp-')
      acc.add(i)
    }, acc)
    return acc
  }, new Set()) as Set<string>

  for (const dependency of dependencies) {
    imports.add(dependency)
  }

  return generatePhpAssetFile(imports, hash)
}
