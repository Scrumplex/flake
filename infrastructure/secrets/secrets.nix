let
  scrumplex = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJV9lYhi0kcwAAjPTMl6sycwCGkjrI0bvTIwpPuXkW2W scrumplex@andromeda"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHsd6Edr19iTS5QFnCEvMQh0rUZM1mjksaZHlihweLdU scrumplex@dyson"
  ];

  universe = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPWva83JbLRs2E6oqAP71CARJpdGRLWEUxM524vhfxXr";
  spacehub = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOPLNX2+TkwkR92aSmNw8faKt4DO58EJkJrBk//MEHrf";
  duckhub = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINo54AduiP0MDvRS35SeEV0Wi1Nlszo3enR/xVJtGQaX";
  cosmos = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFP1mSnn2jJw4nsRtGdikPlN6Cie+kOo5a1bYctjjapg";
  eclipse = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEgfjN4xqCCsl+XzvSFFIR4WQ18r4+G7kGcMLkTe4be6";
in {
  "common/nullmailer-remotes.age".publicKeys = scrumplex ++ [universe spacehub duckhub cosmos eclipse];

  "universe/id_borgbase.age".publicKeys = scrumplex ++ [universe];
  "universe/borgbase_repokey.age".publicKeys = scrumplex ++ [universe];
  "universe/murmur.env.age".publicKeys = scrumplex ++ [spacehub universe];
  "universe/hetzner.key.age".publicKeys = scrumplex ++ [spacehub universe];
  "universe/hedgedoc-service.env.age".publicKeys = scrumplex ++ [spacehub universe];
  "universe/nextcloud-service.env.age".publicKeys = scrumplex ++ [spacehub universe];
  "universe/refraction-service.env.age".publicKeys = scrumplex ++ [spacehub universe];
  "universe/renovate.env.age".publicKeys = scrumplex ++ [spacehub universe];
  "universe/scrumplex-x-service.env.age".publicKeys = scrumplex ++ [spacehub universe];
  "universe/synapse.signing.key.age".publicKeys = scrumplex ++ [universe];
  "universe/synapse-secrets.yaml.age".publicKeys = scrumplex ++ [universe];
  "universe/tor-service.env.age".publicKeys = scrumplex ++ [spacehub universe];
  "universe/wireguard.key.age".publicKeys = scrumplex ++ [spacehub universe];

  "cosmos/id_borgbase.age".publicKeys = scrumplex ++ [cosmos];
  "cosmos/wireguard.key.age".publicKeys = scrumplex ++ [cosmos];
  "cosmos/hetzner.key.age".publicKeys = scrumplex ++ [cosmos];
  "cosmos/root-password.age".publicKeys = scrumplex ++ [cosmos];

  "eclipse/ca_intermediate.key.age".publicKeys = scrumplex ++ [eclipse];
  "eclipse/ca_intermediate.pass.age".publicKeys = scrumplex ++ [eclipse];
  "eclipse/frigate.env.age".publicKeys = scrumplex ++ [eclipse];
  "eclipse/frigate-users.age".publicKeys = scrumplex ++ [eclipse];
  "eclipse/hetzner-ddns.env.age".publicKeys = scrumplex ++ [eclipse];
  "eclipse/hetzner.key.age".publicKeys = scrumplex ++ [eclipse];
  "eclipse/id_borgbase.age".publicKeys = scrumplex ++ [eclipse];
  "eclipse/miniflux.env.age".publicKeys = scrumplex ++ [eclipse];
  "eclipse/paperless-password.age".publicKeys = scrumplex ++ [eclipse];
  "eclipse/quassel-cert.pem.age".publicKeys = scrumplex ++ [eclipse];
  "eclipse/syncthing-key.pem.age".publicKeys = scrumplex ++ [eclipse];
  "eclipse/syncthing-cert.pem.age".publicKeys = scrumplex ++ [eclipse];
  "eclipse/transmission-creds.json.age".publicKeys = scrumplex ++ [eclipse];
  "eclipse/typhon-admin.age".publicKeys = scrumplex ++ [eclipse];
  "eclipse/vaultwarden.env.age".publicKeys = scrumplex ++ [eclipse];
}
