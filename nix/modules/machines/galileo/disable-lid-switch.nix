{
  flake.modules.nixos."machine-galileo" = {
    services.logind.settings.Login.HandeLidSwitch = "ignore";
  };
}
