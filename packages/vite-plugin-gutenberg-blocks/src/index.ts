// SPDX-FileCopyrightText: 2024-2025 Temple University <kleinweb@temple.edu>
// SPDX-FileCopyrightText: 2023-2025 Evo Mark Ltd.
// SPDX-License-Identifier: GPL-3.0-or-later OR MIT

import { readFileSync } from 'node:fs'
import { dirname, join, resolve, sep } from 'node:path'
import react from '@vitejs/plugin-react'
import type { OutputBundle } from 'rollup'
import type { ResolvedConfig, Plugin as VitePlugin } from 'vite'
import { viteStaticCopy } from 'vite-plugin-static-copy'
import { sideload } from './buildStart.ts'
import { generateBundle } from './generateBundle.ts'
import { options } from './options.ts'
import { outputOptions } from './outputOptions.ts'
import type { WordpressBlockJson } from './transform.ts'
import { transform } from './transform.ts'
import type { ResolvedConfig } from 'vite'

export interface PluginConfig {
  watch?: string[]
  outDir?: string
  dependencies?: string[]
}

const NAME = 'vite-plugin-gutenberg-blocks'

const watchFiles = ['./src/template.php', './src/render.php']

export const createViteBlock = (
  pluginConfig: PluginConfig = {},
): VitePlugin[] => {
  const pwd = process.env['PWD'] as string
  const blockName = dirname(pwd)
  const blockFile: WordpressBlockJson = JSON.parse(
    readFileSync(`${pwd}/src/block.json`, 'utf-8'),
  )

  const { watch = watchFiles, outDir = '', dependencies = [] } = pluginConfig
  // TODO: why bother?
  const outputDirectory =
    new RegExp(`${sep}$`).test(outDir) === false && outDir
      ? outDir + sep
      : outDir

  let resolvedConfig: ResolvedConfig

  return [
    {
      name: NAME,
      // config: () => config({ outDir: normalisedOut, blockFile }),
      config: () => ({
        //  outputDirectory,
        build: {
          lib: {
            entry: resolve(pwd, 'src/index.ts'),
            name: 'index',
            formats: ['iife'],
            fileName: () => 'index.js',
          },
          outDir: outputDirectory
            ? join(outputDirectory, blockName)
            : // FIXME: whyyy?
              resolve(pwd, `../../../build/${blockName}`),
          rollupOptions: {},
          target: 'es2022',
          minify: true,
          cssCodeSplit: true, // This option stops the default `styles.css` from being bundled
        },
      }),

      // FIXME: refer to roots implementation of externals
      options,
      outputOptions,

      configResolved(config) {
        resolvedConfig = config
      },

      async buildStart(_options) {
        watch.forEach((file) => {
          this.addWatchFile(file)
        })
        await sideload.call(this, blockFile, outputDirectory)
      },
      transform(code, id) {
        transform.call(this, code, id, blockFile, resolvedConfig)
      },
      generateBundle(_options, bundle: OutputBundle) {
        this.emitFile({
          type: 'asset',
          fileName: 'index.asset.php',
          // TODO: rename this function
          source: generateBundle(bundle, dependencies),
        })
      },
    },
    ...viteStaticCopy({
      silent: true,
      targets: [
        // Since they're not imported into the bundle, we need to copy
        // these files manually.
        {
          src: resolve(pwd, 'src/block.json'),
          dest: '.',
        },
        {
          src: resolve(pwd, 'src/*.php'),
          dest: '.',
        },
      ],
    }),
    ...react({
      jsxRuntime: 'classic',
      jsxImportSource: '@wordpress/element',
    }),
  ]
}
