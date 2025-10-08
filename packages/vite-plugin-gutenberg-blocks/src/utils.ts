// SPDX-FileCopyrightText: 2024-2025 Temple University <kleinweb@temple.edu>
// SPDX-FileCopyrightText: 2023-2025 Evo Mark Ltd.
// SPDX-License-Identifier: GPL-3.0-or-later OR MIT

import crypto from 'node:crypto'
import { join, parse } from 'node:path'

export const generateFileHash = (contents: string): string =>
  crypto.createHash('md5').update(contents).digest('hex')

export const generatePhpAssetFile = (
  dependencies: Set<string> | string[] = [],
  hash = '',
) => {
  return `<?php return ["dependencies" => ${JSON.stringify(Array.from(dependencies))}, "version" => "${hash}"];`
}

export const extractFilenameWithoutExtension = (path: string): string => {
  const parsed = parse(path)
  return join(parsed.dir, parsed.name)
}
