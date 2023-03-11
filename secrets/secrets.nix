let
  scrumplex = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJV9lYhi0kcwAAjPTMl6sycwCGkjrI0bvTIwpPuXkW2W scrumplex@andromeda"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHsd6Edr19iTS5QFnCEvMQh0rUZM1mjksaZHlihweLdU scrumplex@dyson"
  ];

  andromeda = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEwSXiI0/VUx0B9auVaCB6tDU8AP7QLbgOFQaH8khRnA"
  ];
  dyson = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOLPh2twOIyrawZAQC76U9gUVETyPWBOSWJ4k9hdA8mP"
  ];
in {
  "andromeda/cache-key.age".publicKeys = andromeda ++ scrumplex;
  "andromeda/wg.age".publicKeys = andromeda ++ scrumplex;

  "dyson/wg.age".publicKeys = dyson ++ scrumplex;

  "common/beets-secrets.yaml".publicKeys = andromeda ++ dyson ++ scrumplex;
  "common/listenbrainz-token".publicKeys = andromeda ++ dyson ++ scrumplex;
}
