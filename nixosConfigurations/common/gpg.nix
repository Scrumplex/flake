{
  config,
  lib,
  ...
}: {
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    settings = {
      default-cache-ttl = 1209600;
      default-cache-ttl-ssh = 1209600;
      max-cache-ttl = 1209600;
      max-cache-ttl-ssh = 1209600;
    };
  };

  hm = {
    programs.git.signing.signByDefault = true;
    programs.gpg = {
      enable = true;
      inherit (config.programs.gnupg) package;
      homedir = "${config.hm.xdg.dataHome}/gnupg";
    };
  };
}
