{
  config,
  lib,
  ...
}: let
  inherit (builtins) concatStringsSep;
  inherit (lib.attrsets) genAttrs;
  inherit (lib.options) mkOption;
  inherit (lib) types;

  cfg = config.profile.gpg;
in {
  options.profile.gpg.keygrips = mkOption {
    type = with types; listOf str;
    default = [];
    example = [
      "A83C07665C749FA4E8DBADE4502184DC611FF922"
      "313F49A44A9AD9E7AF7F41F767F6C5B826C493A1"
    ];
    description = ''
      List of keygrips to unlock using pam-gnupg.
      Leave empty to disable pam-gnupg.
    '';
  };

  config = {
    profile.gpg.keygrips = [
      "2622167BDE636A248CE883080EE77D752284FDF4"
    ];

    hm = {
      programs.git.signing.signByDefault = true;
      programs.gpg = {
        enable = true;
        homedir = "${config.hm.xdg.dataHome}/gnupg";
      };
      services.gpg-agent = {
        enable = true;
        enableSshSupport = true;
        defaultCacheTtl = 1209600;
        defaultCacheTtlSsh = 1209600;
        maxCacheTtl = 1209600;
        maxCacheTtlSsh = 1209600;
        extraConfig = "allow-preset-passphrase";
      };

      xdg.configFile."pam-gnupg".text = ''
        ${config.hm.programs.gpg.homedir}
        ${concatStringsSep "\n" cfg.keygrips}
      '';
    };

    security.pam.services = genAttrs ["login" "gtklock"] (_: {
      gnupg = {
        enable = true;
        noAutostart = true;
        storeOnly = true;
      };
    });
  };
}
