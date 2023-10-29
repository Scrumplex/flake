{
  config,
  lib,
  ...
}: let
  inherit (builtins) concatStringsSep;
  inherit (lib.attrsets) genAttrs;
  inherit (lib.modules) mkIf;

  cfg = config.roles.gpg;
in {
  config = mkIf (cfg.enable && cfg.keygrips != []) {
    roles.gpg.pamServices = ["login"];
    security.pam.services = genAttrs cfg.pamServices (_: {
      gnupg = {
        enable = true;
        noAutostart = true;
        storeOnly = true;
      };
    });

    hm.xdg.configFile."pam-gnupg".text = ''
      ${config.hm.programs.gpg.homedir}
      ${concatStringsSep "\n" cfg.keygrips}
    '';
  };
}
