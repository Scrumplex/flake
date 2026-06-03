{
  writeShellApplication,
  niri,
  jq,
}:
writeShellApplication {
  name = "run-or-raise";

  runtimeInputs = [niri jq];

  text = ''
    [ $# -lt 2 ] && exit 1

    class="$1"

    id=$(niri msg --json windows | jq --raw-output --arg appId "$class" '.[] | select(.app_id == $appId) | .id')

    if [ -n "$id" ]; then
      exec niri msg action focus-window --id "$id"
    else
      exec "''${@:2}"
    fi
  '';
}
