{config, ...}: {
  xdg.configFile."pam-gnupg".text = ''
    ${config.programs.gpg.homedir}
    2622167BDE636A248CE883080EE77D752284FDF4
    EA9F43D0C2AEA7D44EDE68FAAAD1776402F99A4E
  '';
}
