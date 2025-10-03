# ddev

## Setup

### Security

You will need to generate a certificate _for local use only_ with
`mkcert`.

If you are running NixOS or Nix-Darwin, you will need to add the
generated certificate to your system’s certificates:

```nix
security.pki.certificates = [
  # mkcert for local development
  (builtins.readFile ./path/to/rootCA.crt)
];
```

Like any X.509 keypair, the certificate is intended to be public. The
private key must never leave your system.
