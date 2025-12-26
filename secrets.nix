let
  scrumplex = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJV9lYhi0kcwAAjPTMl6sycwCGkjrI0bvTIwpPuXkW2W scrumplex@andromeda"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG4jTPHOnfxvBOcVmExcU+j2u9Lsf1OoVG/ols2Met9/ scrumplex@dyson"
  ];

  andromeda = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEwSXiI0/VUx0B9auVaCB6tDU8AP7QLbgOFQaH8khRnA"
  ];
  dyson = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOLPh2twOIyrawZAQC76U9gUVETyPWBOSWJ4k9hdA8mP"
  ];

  universe = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPWva83JbLRs2E6oqAP71CARJpdGRLWEUxM524vhfxXr"];
  cosmos = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFP1mSnn2jJw4nsRtGdikPlN6Cie+kOo5a1bYctjjapg"];
  sonic = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFlUqH1I3MG76kXF9cpDO6geUbhRF8h2LkSW0gO1cm+k scrumplex@dyson"];
  centauri = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIY8VwneXuBfB88eQqz48LFkfCgIghlBNzbeqyL99EcP"];
  eclipse = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEgfjN4xqCCsl+XzvSFFIR4WQ18r4+G7kGcMLkTe4be6"];
in {
  "nix/modules/class/desktop/music/listenbrainz-token.age".publicKeys = andromeda ++ dyson ++ scrumplex;
  "nix/modules/class/desktop/music/beets-secrets.yaml.age".publicKeys = andromeda ++ dyson ++ scrumplex;

  "nixosConfigurations/cosmos/hetzner-api-token.env.age".publicKeys = scrumplex ++ cosmos;
  "nixosConfigurations/cosmos/home-assistant/secrets.yaml.age".publicKeys = scrumplex ++ cosmos;
  "nixosConfigurations/eclipse/hetzner-api-token.env.age".publicKeys = scrumplex ++ eclipse;
  "nixosConfigurations/universe/matrix/draupnir-access-token.age".publicKeys = scrumplex ++ universe;

  "secrets/andromeda/borgbase-repokey.age".publicKeys = andromeda ++ scrumplex;
  "secrets/andromeda/cache-key.age".publicKeys = andromeda ++ scrumplex;
  "secrets/andromeda/id_borgbase.age".publicKeys = andromeda ++ scrumplex;
  "secrets/andromeda/wg.age".publicKeys = andromeda ++ scrumplex;

  "secrets/dyson/borgbase-repokey.age".publicKeys = dyson ++ scrumplex;
  "secrets/dyson/id_borgbase.age".publicKeys = dyson ++ scrumplex;
  "secrets/dyson/wg.age".publicKeys = dyson ++ scrumplex;

  "secrets/universe/id_borgbase.age".publicKeys = scrumplex ++ universe;
  "secrets/universe/borgbase_repokey.age".publicKeys = scrumplex ++ universe;
  "secrets/universe/channel-notifier.env.age".publicKeys = scrumplex ++ universe;
  "secrets/universe/grafana-smtp-password.age".publicKeys = scrumplex ++ universe;
  "secrets/universe/murmur.env.age".publicKeys = scrumplex ++ universe;
  "secrets/universe/renovate.env.age".publicKeys = scrumplex ++ universe;
  "secrets/universe/scrumplex-x.htaccess.age".publicKeys = scrumplex ++ universe;
  "secrets/universe/searx.env.age".publicKeys = scrumplex ++ universe;
  "secrets/universe/stalwart.env.age".publicKeys = scrumplex ++ universe;
  "secrets/universe/synapse.signing.key.age".publicKeys = scrumplex ++ universe;
  "secrets/universe/synapse-secrets.yaml.age".publicKeys = scrumplex ++ universe;
  "secrets/universe/scrumplex-hs_ed25519_secret_key.age".publicKeys = scrumplex ++ universe;
  "secrets/universe/wireguard.key.age".publicKeys = scrumplex ++ universe;

  "secrets/centauri/wifi-password.age".publicKeys = scrumplex ++ centauri;

  "secrets/cosmos/id_borgbase.age".publicKeys = scrumplex ++ cosmos;
  "secrets/cosmos/wireguard.key.age".publicKeys = scrumplex ++ cosmos;
  "secrets/cosmos/wpa_supplicant.conf.age".publicKeys = scrumplex ++ cosmos;

  "secrets/eclipse/frigate.env.age".publicKeys = scrumplex ++ eclipse;
  "secrets/eclipse/home-assistant-secrets.yaml.age".publicKeys = scrumplex ++ eclipse;
  "secrets/eclipse/id_borgbase.age".publicKeys = scrumplex ++ eclipse;
  "secrets/eclipse/miniflux.env.age".publicKeys = scrumplex ++ eclipse;
  "secrets/eclipse/paperless-password.age".publicKeys = scrumplex ++ eclipse;
  "secrets/eclipse/slskd-creds.env.age".publicKeys = scrumplex ++ eclipse;
  "secrets/eclipse/syncthing-key.pem.age".publicKeys = scrumplex ++ eclipse;
  "secrets/eclipse/syncthing-cert.pem.age".publicKeys = scrumplex ++ eclipse;
  "secrets/eclipse/tandoor-recipes.env.age".publicKeys = scrumplex ++ eclipse;
  "secrets/eclipse/transmission-creds.json.age".publicKeys = scrumplex ++ eclipse;
  "secrets/eclipse/vaultwarden.env.age".publicKeys = scrumplex ++ eclipse;
  "secrets/eclipse/wireguard.key.age".publicKeys = scrumplex ++ eclipse;
  "secrets/eclipse/yt-dlp-targets.age".publicKeys = scrumplex ++ eclipse;

  "secrets/common/Beehive.psk.age".publicKeys = cosmos ++ sonic ++ scrumplex;
  "secrets/common/mqtt-password.age".publicKeys = scrumplex ++ universe ++ cosmos ++ eclipse;
  "secrets/common/bob-the-builder.key.age".publicKeys = scrumplex ++ andromeda ++ dyson;
  "secrets/common/screenshot-bash.age".publicKeys = andromeda ++ dyson ++ scrumplex;
}
