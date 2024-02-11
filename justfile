default: switch

rebuild goal:
    sudo nixos-rebuild --flake . --verbose --print-build-logs --show-trace {{goal}}

build: (rebuild "build")
boot: (rebuild "boot")
test: (rebuild "test")
switch: (rebuild "switch")

update:
    nix flake update --commit-lock-file

lock name ref:
    nix flake lock --update-input {{name}} --override-input {{name}} {{ref}}
