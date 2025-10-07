# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**beams** is a monorepo for WordPress Gutenberg block development tooling and blocks, maintained by Klein College of Media and Communication at Temple University. The repository uses pnpm workspaces, Turborepo for build orchestration, and provides a Vite plugin for modern Gutenberg block development.

## Package Manager

This project uses **pnpm** (version 10.18.0). All package management commands should use pnpm, not npm or yarn.

## Common Commands

### Development
- `pnpm dev` - Start development mode for all packages (via Turbo)
- `pnpm build` - Build all packages (via Turbo)
- `pnpm lint` - Run linting across all packages (via Turbo)

### Package-Specific Commands
Navigate to individual package directories to run package-specific commands:
- **vite-plugin-gutenberg-blocks**:
  - `pnpm build` - Build via tsdown
  - `pnpm dev` - Watch mode build
  - `pnpm check` - Type check + Biome check
  - `pnpm check:ts` - TypeScript type checking only
  - `pnpm test` - Runs `check` (no separate test suite)

- **explore-bar** (example Gutenberg block):
  - `pnpm dev` - Vite watch mode
  - `pnpm build` - Production build
  - `pnpm check` - Type check + Biome check
  - `pnpm check:ts` - TypeScript type checking only
  - `pnpm fmt` - Format with Biome

### Code Quality
- `just fmt` - Format code with treefmt (runs Biome, nixfmt, prettier, taplo, dos2unix)
- `just check` - Check for lint/format issues (runs REUSE compliance, dotenv-linter, nix flake check)
- `just fix` - Apply all formatter + fixer changes
- `biome check --write` - Format/fix with Biome directly

### Releases
- `pnpm changeset` - Create a changeset for version bumping
- `pnpm release` - Build and publish packages (runs `pnpm build && changeset publish`)

## Architecture

### Monorepo Structure

```
packages/
├── vite-plugin-gutenberg-blocks/  # Core Vite plugin for Gutenberg block development
├── gutenberg-types/                # TypeScript type definitions for WordPress/Gutenberg
├── explore-bar/                    # Example Gutenberg block implementation
├── tsconfig/                       # Shared TypeScript configurations
└── brand-assets/                   # Brand assets package
```

### Key Packages

**@kleinweb/vite-plugin-gutenberg-blocks**
- Vite plugin that enables modern frontend tooling for WordPress Gutenberg blocks
- Handles React JSX transformation with WordPress element compatibility (`jsxImportSource: '@wordpress/element'`)
- Generates WordPress-specific asset manifests (`index.asset.php`)
- Automatically copies `block.json` and PHP templates to build output
- Configures builds as IIFE bundles targeting ES2022
- Source: `packages/vite-plugin-gutenberg-blocks/src/index.ts`
- Main export: `createViteBlock()` function that returns an array of Vite plugins

**@kleinweb/gutenberg-types**
- Provides TypeScript type definitions for WordPress Gutenberg APIs
- Types are sourced from upstream Gutenberg releases (cached in `.cache/` directory)
- Used by blocks and tools to get proper typing for WordPress globals

**Gutenberg Block Development Pattern**
Blocks follow this structure (see `explore-bar` package as reference):
- `src/block.json` - WordPress block metadata
- `src/index.ts` - Entry point that registers the block with WordPress
- `src/Edit.tsx` - Block editor component
- `src/Save.tsx` - Frontend render component
- `vite.config.ts` - Uses `createViteBlock()` plugin
- Build output goes to `dist/` (or configured `outDir`)

### TypeScript Configuration

The `@kleinweb/tsconfig` package provides shared TypeScript configurations:
- `tsconfig.base.json` - Base configuration
- `tsconfig.node.json` - Node.js projects
- `tsconfig.react.json` - React projects
- `tsconfig.vite.json` - Vite projects
- `tsconfig.web.json` - Web projects
- `tsconfig.app.json` - Application projects
- `tsconfig.recommended.json` - Recommended settings

Packages extend these via `"extends": "@kleinweb/tsconfig/..."` in their `tsconfig.json`.

### Build System

- **Turborepo** orchestrates builds across the monorepo (see `turbo.json`)
- Build tasks have dependency ordering via `dependsOn: ["^build"]`
- Outputs: `dist/**` for packages, `public/build/**` for blocks
- **tsdown** is used for building the Vite plugin package
- **Vite** is used for building Gutenberg blocks

### Code Style

- **Biome** for JavaScript/TypeScript/CSS linting and formatting (configured in `biome.json`)
  - Single quotes, semicolons as needed
  - 2-space indentation
  - Sorted attributes and properties enabled
- **treefmt** orchestrates multiple formatters (Biome, prettier, nixfmt, taplo, dos2unix)
- **EditorConfig** for cross-editor consistency
- License headers enforced via REUSE compliance (GPL-3.0-or-later)

### Development Environment

The project uses Nix for reproducible development environments:
- `flake.nix` defines the development shell
- `direnv` with `.envrc` for automatic environment loading
- Node.js version enforced: ^22.0.0 || ^23.0.0 || ^24.0.0 (per vite-plugin-gutenberg-blocks)

## Important Notes

- React JSX in blocks uses classic runtime with `@wordpress/element` as the import source (configured in the Vite plugin)
- Block builds are IIFE format to integrate with WordPress's script loading system
- The plugin automatically externalizes WordPress dependencies (handled via `options` and `outputOptions` hooks)
- Block metadata (`block.json`) and PHP templates are copied to build output, not bundled
- When creating new Gutenberg blocks, follow the `explore-bar` package structure
