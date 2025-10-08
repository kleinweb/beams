// SPDX-FileCopyrightText: 2024-2025 Temple University <kleinweb@temple.edu>
// SPDX-FileCopyrightText: 2023-2025 Evo Mark Ltd.
// SPDX-License-Identifier: GPL-3.0-or-later OR MIT

import { readFileSync } from 'node:fs'
import { basename, join, normalize, resolve } from 'node:path'
import type { BlockJson } from '@kleinweb/gutenberg-types'
import react from '@vitejs/plugin-react'
import type { OutputBundle } from 'rollup'
import type { ResolvedConfig, Plugin as VitePlugin } from 'vite'
import { viteStaticCopy } from 'vite-plugin-static-copy'

import { sideload } from './buildStart.ts'
import { generateBundle } from './generateBundle.ts'
import { options } from './options.ts'
import { outputOptions } from './outputOptions.ts'
import { packageRoot } from './package.ts'
import { transform } from './transform.ts'

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
  const packageDir = packageRoot()
  const srcDir = join(packageDir, 'src')
  const blockName = basename(packageDir)
  const blockJson: BlockJson = JSON.parse(
    readFileSync(`${srcDir}/block.json`, 'utf-8'),
  )

  const {
    watch = watchFiles,
    outDir = `${packageDir}/dist`,
    dependencies = [],
  } = pluginConfig

  const outputDirectory = normalize(outDir)
  let resolvedConfig: ResolvedConfig

  return [
    {
      name: NAME,
      config: () => ({
        build: {
          lib: {
            entry: join(srcDir, 'index.ts'),
            name: 'index',
            formats: ['iife'],
            fileName: () => 'index.js',
          },
          outDir: join(outputDirectory, blockName),
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
        await sideload.call(this, blockJson, outputDirectory)
      },
      transform(code, id) {
        transform.call(this, code, id, blockJson, resolvedConfig)
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
          src: resolve(srcDir, 'block.json'),
          dest: '.',
        },
        {
          // FIXME: throws an error when silent is false and no php
          // files exist
          src: resolve(srcDir, '*.php'),
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
