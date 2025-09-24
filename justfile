default: switch

rebuild goal *args:
    #!/usr/bin/env bash
    set -o pipefail # fail if the build fails instead of blindly returning 0 as nom succeeds
    sudo darwin-rebuild --impure --flake . --verbose {{goal}} {{args}}

build: (rebuild "build")
boot: (rebuild "boot")
test: (rebuild "test")
switch: (rebuild "switch")

update:
    nix flake update --commit-lock-file

lock name ref:
    nix flake lock --override-input {{name}} {{ref}}
