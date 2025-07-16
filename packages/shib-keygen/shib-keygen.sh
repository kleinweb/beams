#!/bin/sh

# Copyright 2024-2025  Temple University
# Copyright 2024  The Shibboleth Consortium
# SPDX-License-Identifier: Apache-2.0

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at

#     http://www.apache.org/licenses/LICENSE-2.0

# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# <https://git.shibboleth.net/view/?p=cpp-sp.git;a=blob;f=configs/keygen.sh;h=b5378fd36f74c2c13f9c8328e79a393960fe0f60;hb=181a9eb535994a012a7852f9e333379e07434ed3>
# <https://shibboleth.atlassian.net/wiki/spaces/CONCEPT/pages/948470554/SAMLKeysAndCertificates#SAMLKeysAndCertificates-InspectingtheSAMLCertificate>

usage() {
  echo "Usage:	$0 [-e <entity-id>] [-f] [-n <filename-prefix>] [-o <out-dir>] [-y <years>] <fqdn>" 1>&2
}

while getopts n:o:e:y:hf c
do
  case $c in
    o)         OUT=$OPTARG;;
    f)         FORCE=1;;
    e)         ENTITYID=$OPTARG;;
    y)         YEARS=$OPTARG;;
    n)         PREFIX=$OPTARG;;
    h|\?)      usage
               exit 1;;
  esac
done
shift "$((OPTIND-1))"

FQDN=$1

if [ -z "${FQDN}" ]; then
  echo "Missing required <fqdn> argument."
  usage
  exit 1
fi

: "${OUT:=${PRJ_CONFIG_HOME:-.config}/x509}"
: "${PREFIX:=sp}"
: "${YEARS:=10}"
# TODO: double-check this
: "${DAYS:=$(( YEARS * 365 ))}"

KEY_DEST="${OUT}/keys/${PREFIX}.key"
CERT_DEST="${OUT}/certs/${PREFIX}.crt"
SSLCNF=$OUT/${PREFIX}-cert.cnf
ALTNAME="DNS:${FQDN}${ENTITYID:+,URI:${ENTITYID}}"

if [ -n "$FORCE" ] ; then
  rm "${KEY_DEST}" "${CERT_DEST}"
fi

if [ -s "${KEY_DEST}" ] || [ -s "${CERT_DEST}" ] ; then
  echo "The files ${KEY_DEST} and/or ${CERT_DEST} already exist!"
  echo "Use -f option to force recreation of keypair."
  usage
  exit 2
fi

cat >"$SSLCNF" <<EOF
# OpenSSL configuration file for creating keypair
[req]
prompt=no
default_bits=3072
encrypt_key=no
default_md=sha256
distinguished_name=dn
# PrintableStrings only
string_mask=MASK:0002
x509_extensions=ext
[dn]
CN=${FQDN}
[ext]
subjectAltName=${ALTNAME}
subjectKeyIdentifier=hash
EOF

touch "${KEY_DEST}"
chmod 600 "${KEY_DEST}"

openssl req -config "$SSLCNF" -new -x509 -days "$DAYS" \
        -keyout "${KEY_DEST}" \
        -out "${CERT_DEST}"

rm "$SSLCNF"

# Inspect the certificate
openssl x509 -text -in "$CERT_DEST"
