{
  flake.modules.nixos."desktop" = {
    programs.gnupg.agent = {
      enable = true;
      settings = {
        default-cache-ttl = 1209600;
        default-cache-ttl-ssh = 1209600;
        max-cache-ttl = 1209600;
        max-cache-ttl-ssh = 1209600;
      };
    };
  };

  flake.modules.homeManager."desktop" = {
    programs.git.signing.signByDefault = true;
  };
}
