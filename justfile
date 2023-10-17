new-role ROLE:
  jinja2 ./roles/_template.nix.j2 -o ./roles/{{ROLE}}.nix -D name={{ROLE}}
  nvim ./roles/{{ROLE}}.nix
