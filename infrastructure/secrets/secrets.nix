let
  scrumplex = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJV9lYhi0kcwAAjPTMl6sycwCGkjrI0bvTIwpPuXkW2W scrumplex@andromeda"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHsd6Edr19iTS5QFnCEvMQh0rUZM1mjksaZHlihweLdU scrumplex@dyson"
  ];

  spacehub = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOPLNX2+TkwkR92aSmNw8faKt4DO58EJkJrBk//MEHrf";
  duckhub = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINo54AduiP0MDvRS35SeEV0Wi1Nlszo3enR/xVJtGQaX";
  cosmos = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFP1mSnn2jJw4nsRtGdikPlN6Cie+kOo5a1bYctjjapg";
  eclipse = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEgfjN4xqCCsl+XzvSFFIR4WQ18r4+G7kGcMLkTe4be6";
in {
  "spacehub/id_borgbase.age".publicKeys = scrumplex ++ [spacehub];
  "spacehub/murmur.env.age".publicKeys = scrumplex ++ [spacehub];
  "spacehub/wireguard.key.age".publicKeys = scrumplex ++ [spacehub];
  "spacehub/hetzner.key.age".publicKeys = scrumplex ++ [spacehub];
  "spacehub/hedgedoc-service.env.age".publicKeys = scrumplex ++ [spacehub];
  "spacehub/nextcloud-service.env.age".publicKeys = scrumplex ++ [spacehub];
  "spacehub/refraction-service.env.age".publicKeys = scrumplex ++ [spacehub];
  "spacehub/scrumplex-x-service.env.age".publicKeys = scrumplex ++ [spacehub];
  "spacehub/tor-service.env.age".publicKeys = scrumplex ++ [spacehub];

  "duckhub/id_borgbase.age".publicKeys = scrumplex ++ [duckhub];
  "duckhub/wireguard.key.age".publicKeys = scrumplex ++ [duckhub];
  "duckhub/hetzner.key.age".publicKeys = scrumplex ++ [duckhub];

  "cosmos/id_borgbase.age".publicKeys = scrumplex ++ [cosmos];
  "cosmos/wireguard.key.age".publicKeys = scrumplex ++ [cosmos];
  "cosmos/hetzner.key.age".publicKeys = scrumplex ++ [cosmos];

  "eclipse/ca_intermediate.key.age".publicKeys = scrumplex ++ [eclipse];
  "eclipse/ca_intermediate.pass.age".publicKeys = scrumplex ++ [eclipse];
  "eclipse/hetzner-ddns.env.age".publicKeys = scrumplex ++ [eclipse];
  "eclipse/id_borgbase.age".publicKeys = scrumplex ++ [eclipse];
  "eclipse/paperless-password.age".publicKeys = scrumplex ++ [eclipse];
  "eclipse/syncthing-key.pem.age".publicKeys = scrumplex ++ [eclipse];
  "eclipse/syncthing-cert.pem.age".publicKeys = scrumplex ++ [eclipse];
  "eclipse/transmission-creds.json.age".publicKeys = scrumplex ++ [eclipse];
  "eclipse/vaultwarden.env.age".publicKeys = scrumplex ++ [eclipse];
}
