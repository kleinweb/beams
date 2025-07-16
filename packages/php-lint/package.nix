{
  php,
  writeShellApplication,
}:
writeShellApplication {
  name = "php-lint";
  runtimeInputs = [
    php
    php.packages.php-parallel-lint
  ];
  text = ''
    parallel-lint \
      --exclude .git --exclude .cache --exclude .data --exclude .direnv \
      --exclude vendor --exclude node_modules \
      "$@"
  '';
}
