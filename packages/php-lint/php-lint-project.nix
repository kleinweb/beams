{
  fd,
  php-lint,
  writeShellApplication,
}:
writeShellApplication {
  name = "php-lint-project";
  runtimeInputs = [
    fd
    php-lint
  ];
  text = ''
    fd --type file --extension php --hidden --exec-batch \
      php-lint --show-deprecated
  '';
}
