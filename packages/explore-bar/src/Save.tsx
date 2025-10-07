// SPDX-FileCopyrightText: (C) 2025 Temple University <kleinweb@temple.edu>
// SPDX-License-Identifier: GPL-3.0-or-later

import { useBlockProps } from '@wordpress/block-editor'
import { __ } from '@wordpress/i18n'

export default function Save() {
  return <p {...useBlockProps.save()}>{__('Explore Klein College')}</p>
}
