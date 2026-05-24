{
  flake.modules.homeManager.desktop.programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    settings = {
      "*" = {
        controlMaster = "auto";
        controlPath = "~/.ssh/sockets/master-%r@%n:%p";
        controlPersist = "10m";
      };

      "galileo.sefa.cloud" = {
        user = "root";
      };

      "eclipse.sefa.cloud" = {
        user = "root";
      };

      "scrumplex.net" = {
        user = "root";
      };
    };
  };
}
