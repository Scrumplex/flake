default: switch

rebuild:
    nixos-rebuild --flake . --verbose --print-build-logs --show-trace build

switch: rebuild
    sudo nixos-rebuild --flake . switch

lock name ref:
    nix flake lock --update-input {{name}} --override-input {{name}} {{ref}}
