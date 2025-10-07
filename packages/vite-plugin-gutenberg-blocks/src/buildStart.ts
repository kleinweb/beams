// SPDX-FileCopyrightText: 2024-2025 Temple University <kleinweb@temple.edu>
// SPDX-FileCopyrightText: 2023-2025 Evo Mark Ltd.
// SPDX-License-Identifier: GPL-3.0-or-later OR MIT

import type { EmittedAsset, PluginContext } from 'rollup'
import type { WordpressBlockJson } from './transform.ts'
import {
  generateFileHash,
  generatePhpAssetFile,
  extractFilenameWithoutExtension,
} from './utils.ts'
import { build as esBuild } from 'esbuild'
import { resolve } from 'node:path'

const normaliseArray = (source: unknown) =>
  Array.isArray(source) ? source : [source]

export async function sideload(
  this: PluginContext,
  // FIXME: use generated type
  blockJson: WordpressBlockJson,
  outputDirectory: string,
): Promise<void> {
  // Load the block.json options for "script" (frontend/backend) and "viewScript" (frontend)
  const viewScript = blockJson?.viewScript ?? []
  const standardScript = blockJson?.script ?? []
  // Normalise into array
  const standardScripts = normaliseArray(standardScript)
  const viewScripts = normaliseArray(viewScript)

  // Combine arrays into array of files
  const concatScripts = viewScripts
    .concat(standardScripts)
    .filter((script) => script.startsWith('file'))
    .map((script) => {
      return script.replace('file:./', '')
    })

  for (const script of concatScripts) {
    const scriptPath = resolve(`${process.env['PWD']}/src/${script}`)
    // Vite won't track this file for watching, so we'll add a manual watcher
    this.addWatchFile('./src/' + script)
    let wpImports: Array<string> = []
    // Build the script as a sideloaded file that isn't injected into the main bundle
    const result = await esBuild({
      entryPoints: [scriptPath],
      outfile: outputDirectory + '/' + script,
      platform: 'browser',
      bundle: true,
      write: false,
      metafile: true,
      plugins: [
        {
          name: 'alias-wordpress',
          setup(build) {
            // Intercept @wordpress/* paths
            build.onResolve({ filter: /^@wordpress\// }, (args) => {
              return {
                path: args.path,
                namespace: 'wordpress-alias',
              }
            })

            // Generate a shim for @wordpress/* imports
            build.onLoad(
              { filter: /.*/, namespace: 'wordpress-alias' },
              (args) => {
                const moduleName = args.path.split('/')[1]
                wpImports.push('wp-' + moduleName)
                return {
                  contents: `
                const wpModule = window.wp.${moduleName};
                for (const key in wpModule) {
                  if (Object.prototype.hasOwnProperty.call(wpModule, key)) {
                    exports[key] = wpModule[key];
                  }
                }
              `,
                  loader: 'js',
                }
              },
            )
          },
        },
      ],
    })

    const bundledDependencies = Object.keys(result.metafile.inputs).filter(
      (dep) => {
        if (dep === 'src/' + script) return false
        if (/:/.test(dep)) return false
        else return true
      },
    )

    bundledDependencies.forEach((dep) => {
      this.addWatchFile('./' + dep)
    })

    result.outputFiles.forEach((file) => {
      const hash = generateFileHash(file.text)
      const filename = extractFilenameWithoutExtension(script)

      this.emitFile({
        type: 'asset',
        fileName: filename + '.asset.php',
        source: generatePhpAssetFile(wpImports, hash),
      } satisfies EmittedAsset)
      this.emitFile({
        type: 'asset',
        fileName: script,
        source: file.contents,
      } satisfies EmittedAsset)
    })
  }
}
