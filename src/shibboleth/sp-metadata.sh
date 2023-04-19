#!/usr/bin/env nix-shell
#! nix-shell -i bash -p gum mustache-go

FQDN=$(gum input --placeholder 'Site FQDN?')

echo "siteFqdn: $FQDN" \
| mustache ./sp-metadata.xml.mustache \
> "sp-metadata.$FQDN.xml.txt"
