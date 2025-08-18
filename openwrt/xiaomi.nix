{profiles}:
profiles.identifyProfile "xiaomi_mi-router-ax3000t-ubootmod"
// {
  packages = [
    "-dnsmasq"
    "-wpad-basic-mbedtls"
    "wpad-openssl"
    "luci"
    "bridger" # See https://openwrt.org/inbox/toh/xiaomi/ax3000t#wireless_ethernet_dispatch_wed
  ];
}
