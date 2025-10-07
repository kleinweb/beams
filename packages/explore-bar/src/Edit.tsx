// SPDX-FileCopyrightText: (C) 2025 Temple University <kleinweb@temple.edu>
// SPDX-License-Identifier: GPL-3.0-or-later

import { useBlockProps } from '@wordpress/block-editor'
import { __ } from '@wordpress/i18n'

import './editor.css'

export default function Edit() {
  return <p {...useBlockProps()}>{__('Explore Klein')}</p>
}
