default: switch

deploy name: (rebuildD name "switch")

rebuildD name goal:
    nix run -vL .#deploy-{{name}} -- {{goal}}

rebuild goal:
    sudo nixos-rebuild --flake . --verbose --print-build-logs --show-trace {{goal}}

build: (rebuild "build")
boot: (rebuild "boot")
test: (rebuild "test")
switch: (rebuild "switch")


deploy-all: (deploy "universe") (deploy "eclipse") (deploy "cosmos")

update:
    nix flake update --commit-lock-file

lock name ref:
    nix flake lock --override-input {{name}} {{ref}}
