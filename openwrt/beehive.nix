{profiles}:
profiles.identifyProfile "bananapi_bpi-r4"
// {
  packages = [
    "-libustream-mbedtls"
    "-wpad-basic-mbedtls"
    "atlas-sw-probe"
    "dawn"
    "luci"
    "luci-app-dawn"
    "luci-app-sqm"
    "luci-app-upnp"
    "luci-proto-wireguard"
    "luci-ssl-openssl"
    "luci-ssl-openssl"
    "openssh-client-utils" # RIPE Atlas Probe needs OpenSSH keygen
    "qrencode"
    "tcpdump"
    "wpad-openssl"
  ];
}
