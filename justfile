new-role ROLE:
  mkdir -p ./roles/{{ROLE}}
  jinja2 ./roles/_template.nix.j2 -o ./roles/{{ROLE}}/default.nix -D name={{ROLE}}
  nvim ./roles/{{ROLE}}/default.nix
