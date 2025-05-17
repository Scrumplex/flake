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
  "andromeda/borgbase-repokey.age".publicKeys = andromeda ++ scrumplex;
  "andromeda/cache-key.age".publicKeys = andromeda ++ scrumplex;
  "andromeda/id_borgbase.age".publicKeys = andromeda ++ scrumplex;
  "andromeda/wg.age".publicKeys = andromeda ++ scrumplex;

  "dyson/borgbase-repokey.age".publicKeys = dyson ++ scrumplex;
  "dyson/id_borgbase.age".publicKeys = dyson ++ scrumplex;
  "dyson/wg.age".publicKeys = dyson ++ scrumplex;

  "universe/id_borgbase.age".publicKeys = scrumplex ++ universe;
  "universe/borgbase_repokey.age".publicKeys = scrumplex ++ universe;
  "universe/channel-notifier.env.age".publicKeys = scrumplex ++ universe;
  "universe/grafana-smtp-password.age".publicKeys = scrumplex ++ universe;
  "universe/murmur.env.age".publicKeys = scrumplex ++ universe;
  "universe/renovate.env.age".publicKeys = scrumplex ++ universe;
  "universe/scrumplex-x.htaccess.age".publicKeys = scrumplex ++ universe;
  "universe/searx.env.age".publicKeys = scrumplex ++ universe;
  "universe/stalwart.env.age".publicKeys = scrumplex ++ universe;
  "universe/synapse.signing.key.age".publicKeys = scrumplex ++ universe;
  "universe/synapse-secrets.yaml.age".publicKeys = scrumplex ++ universe;
  "universe/scrumplex-hs_ed25519_secret_key.age".publicKeys = scrumplex ++ universe;
  "universe/wireguard.key.age".publicKeys = scrumplex ++ universe;

  "centauri/wifi-password.age".publicKeys = scrumplex ++ centauri;

  "cosmos/hetzner-ddns.env.age".publicKeys = scrumplex ++ cosmos;
  "cosmos/hetzner-traefik.env.age".publicKeys = scrumplex ++ cosmos;
  "cosmos/id_borgbase.age".publicKeys = scrumplex ++ cosmos;
  "cosmos/wireguard.key.age".publicKeys = scrumplex ++ cosmos;

  "eclipse/ca_intermediate.key.age".publicKeys = scrumplex ++ eclipse;
  "eclipse/ca_intermediate.pass.age".publicKeys = scrumplex ++ eclipse;
  "eclipse/codeberg-oauth-secret.age".publicKeys = scrumplex ++ eclipse;
  "eclipse/codeberg-webhook-secret.age".publicKeys = scrumplex ++ eclipse;
  "eclipse/codeberg-token.age".publicKeys = scrumplex ++ eclipse;
  "eclipse/frigate.env.age".publicKeys = scrumplex ++ eclipse;
  "eclipse/hetzner-ddns.env.age".publicKeys = scrumplex ++ eclipse;
  "eclipse/hetzner-traefik.env.age".publicKeys = scrumplex ++ eclipse;
  "eclipse/id_borgbase.age".publicKeys = scrumplex ++ eclipse;
  "eclipse/miniflux.env.age".publicKeys = scrumplex ++ eclipse;
  "eclipse/paperless-password.age".publicKeys = scrumplex ++ eclipse;
  "eclipse/quassel-cert.pem.age".publicKeys = scrumplex ++ eclipse;
  "eclipse/slskd-creds.env.age".publicKeys = scrumplex ++ eclipse;
  "eclipse/syncthing-key.pem.age".publicKeys = scrumplex ++ eclipse;
  "eclipse/syncthing-cert.pem.age".publicKeys = scrumplex ++ eclipse;
  "eclipse/transmission-creds.json.age".publicKeys = scrumplex ++ eclipse;
  "eclipse/vaultwarden.env.age".publicKeys = scrumplex ++ eclipse;
  "eclipse/wireguard.key.age".publicKeys = scrumplex ++ eclipse;
  "eclipse/wg-backdoor.key.age".publicKeys = scrumplex ++ eclipse;
  "eclipse/yt-dlp-targets.age".publicKeys = scrumplex ++ eclipse;

  "common/Beehive.psk.age".publicKeys = cosmos ++ sonic ++ scrumplex;
  "common/beets-secrets.yaml.age".publicKeys = andromeda ++ dyson ++ scrumplex;
  "common/listenbrainz-token.age".publicKeys = andromeda ++ dyson ++ scrumplex;
  "common/mqtt-password.age".publicKeys = scrumplex ++ universe ++ cosmos ++ eclipse;
  "common/bob-the-builder.key.age".publicKeys = scrumplex ++ andromeda ++ dyson;
  "common/nullmailer-remotes.age".publicKeys = scrumplex ++ universe ++ cosmos ++ eclipse;
  "common/screenshot-bash.age".publicKeys = andromeda ++ dyson ++ scrumplex;
}
