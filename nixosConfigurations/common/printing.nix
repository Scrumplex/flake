{pkgs, ...}: let
  epsonscan2 = pkgs.epsonscan2.override {
    withNonFreePlugins = true;
  };
in {
  environment.systemPackages = [epsonscan2];
  services.printing = {
    enable = true;
    drivers = with pkgs; [samsung-unified-linux-driver_1_00_37 epson-escpr];
  };

  hardware.sane = {
    enable = true;
    extraBackends = [
      epsonscan2
      pkgs.sane-airscan
    ];
    netConf = "10.0.0.149";
  };

  services.avahi = {
    nssmdns4 = true;
    nssmdns6 = true;
  };

  primaryUser.extraGroups = ["scanner" "lp"];
}
