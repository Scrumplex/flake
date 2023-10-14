new-role ROLE:
  jinja2 ./home/roles/_template.nix.j2 -o ./home/roles/{{ROLE}}.nix -D name={{ROLE}}
  nvim ./home/roles/{{ROLE}}.nix
