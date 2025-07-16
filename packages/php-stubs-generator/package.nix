{
  lib,
  php,
  fetchFromGitHub,
}:

php.buildComposerProject (finalAttrs: {
  pname = "php-stubs-generator";
  version = "0.8.5";

  src = fetchFromGitHub {
    owner = "php-stubs";
    repo = "generator";
    rev = "v${finalAttrs.version}";
    hash = "sha256-eKvAeM3B3u5EeeOpuHpuW79VTreq4YQiP4mXYb7NMTQ=";
  };

  vendorHash = "sha256-531ncqpfv1ertcgWeVf7zJfv2HDiKeKpMzOBLbRikOU=";

  composerLock = ./composer.lock;

  meta = with lib; {
    description = "Generate stubs from any PHP code for IDE completion and static analysis";
    homepage = "https://github.com/php-stubs/generator";
    changelog = "https://github.com/php-stubs/generator/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ montchr ];
    mainProgram = "generate-stubs";
    platforms = platforms.all;
  };
})
