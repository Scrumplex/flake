{
  writeShellApplication,
  coreutils,
  kitty,
  run-or-raise,
}:
writeShellApplication {
  name = "termapp";

  runtimeInputs = [coreutils kitty run-or-raise];

  text = ''
    if [ $# -eq 0 ]; then
      exit 1
    fi

    appid="popup_$(basename "$1")"

    exec run-or-raise "$appid" kitty "--class=$appid" "$@"
  '';
}
