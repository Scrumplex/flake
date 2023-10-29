{
  config,
  lib,
  ...
}: let
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.modules) mkAliasOptionModule mkIf;
  inherit (lib) types;

  cfg = config.roles.gpg;
in {
  options.roles.gpg = {
    enable = mkEnableOption "gpg role";

    keygrips = mkOption {
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

    pamServices = mkOption {
      type = with types; listOf str;
      default = [];
      example = [
        "gtklock"
      ];
      description = ''
        List of pam services to add pam-gnupg to.
      '';
    };
  };

  imports = [
    (mkAliasOptionModule ["roles" "gpg" "pinentryFlavor"] ["hm" "services" "gpg-agent" "pinentryFlavor"])
  ];

  config = mkIf cfg.enable {
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
    };
  };
}
