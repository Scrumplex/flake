{config, ...}: {
  xdg.configFile."pam-gnupg".text = ''
    ${config.programs.gpg.homedir}
    2622167BDE636A248CE883080EE77D752284FDF4
    BF9C6D61344A624956EB93594834D4D2AF5BD8C1
  '';
}
