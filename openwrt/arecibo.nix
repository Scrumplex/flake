{profiles}:
profiles.identifyProfile "ubnt_unifiac-lr"
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
