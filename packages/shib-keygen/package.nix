# SPDX-FileCopyrightText: (C) 2025 Temple University <kleinweb@temple.edu>
# SPDX-License-Identifier: GPL-3.0-or-later

{
  lib,
  openssl,
  writeShellApplication,
}:
(writeShellApplication {
  name = "shib-keygen";
  text = builtins.readFile ./shib-keygen.sh;
  runtimeInputs = [
    openssl
  ];
  meta = {
    description = "Generate an x509 certificate for a SAML service provider";
    downloadPage = "https://git.shibboleth.net/view/?p=cpp-sp.git;a=blob;f=configs/keygen.sh;h=b5378fd36f74c2c13f9c8328e79a393960fe0f60;hb=181a9eb535994a012a7852f9e333379e07434ed3";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ montchr ];
    mainProgram = "shib-keygen";
    website = "https://shibboleth.atlassian.net/wiki/spaces/CONCEPT/pages/948470554/SAMLKeysAndCertificates";
  };
})
