// SPDX-FileCopyrightText: (C) 2025 Temple University <kleinweb@temple.edu>
// SPDX-License-Identifier: GPL-3.0-or-later

import { registerBlockType } from '@wordpress/blocks'
import metadata from './block.json'
import Edit from './Edit'
import Save from './Save'

import './style.css'

registerBlockType(metadata, {
  edit: Edit,
  save: Save,
})
