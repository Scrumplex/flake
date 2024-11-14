default: switch

deploy name: (rebuildD name "switch")

rebuildD name goal:
    nix run -vL .#deploy-{{name}} -- {{goal}}

rebuild goal *args:
    #!/usr/bin/env bash
    set -o pipefail # fail if the build fails instead of blindly returning 0 as nom succeeds
    sudo nixos-rebuild --flake . --verbose --log-format internal-json {{goal}} {{args}} |& nom --json

build: (rebuild "build")
boot: (rebuild "boot")
test: (rebuild "test")
switch: (rebuild "switch")


deploy-all: (deploy "universe") (deploy "eclipse") (deploy "cosmos")

update:
    nix flake update --commit-lock-file

lock name ref:
    nix flake lock --override-input {{name}} {{ref}}
