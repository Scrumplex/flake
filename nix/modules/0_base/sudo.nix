{
  flake.modules.nixos.base = {
    security.sudo = {
      extraRules = [
        {
          groups = ["wheel"];
          commands = [
            {
              command = "/run/current-system/sw/bin/nixos-rebuild";
              options = ["NOPASSWD"];
            }
            {
              command = "/run/current-system/sw/bin/networkctl";
              options = ["NOPASSWD"];
            }
            {
              command = "/run/current-system/sw/bin/systemctl";
              options = ["NOPASSWD"];
            }
          ];
        }
      ];
      extraConfig = ''
        Defaults lecture = always
        Defaults lecture_file = ${./sudo_lecture.txt}
        Defaults pwfeedback
        Defaults passwd_timeout=0
      '';
    };
  };
}
