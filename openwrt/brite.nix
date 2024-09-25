{profiles}:
profiles.identifyProfile "tplink_eap235-wall-v1"
// {
  packages = [
    "-dnsmasq"
    "-wpad-basic-mbedtls"
    "wpad-openssl"
    "dawn"
    "luci"
    "luci-app-dawn"
  ];
}
