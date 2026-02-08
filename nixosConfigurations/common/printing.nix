{pkgs, ...}: let
  epsonscan2 = pkgs.epsonscan2.override {
    withNonFreePlugins = true;
  };
in {
  nixpkgs.allowedUnfreePackageNames = ["epsonscan2"];

  environment.systemPackages = [epsonscan2];

  services.printing = {
    enable = true;
    drivers = with pkgs; [epson-escpr];
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
