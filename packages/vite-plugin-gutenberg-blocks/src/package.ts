/*!*
 * SPDX-FileCopyrightText: 2025  Temple University <kleinweb@temple.edu>
 * SPDX-FileCopyrightText: 2016-2025  The WordPress Contributors
 * SPDX-License-Identifier: GPL-3.0-or-later AND MPL-2.0
 */

import { existsSync } from 'node:fs'
import { dirname, resolve } from 'node:path'
import { readPackageUpSync } from 'read-package-up'

export function packageJsonFile(): string {
  const path = readPackageUpSync()?.path
  if (!path) {
    throw new Error('Could not locate a package.json file')
  }
  return path
}

export const packageRoot = (): string => dirname(packageJsonFile())

export const hasPackageFile = (file: string): boolean =>
  existsSync(resolve(packageRoot(), file))
