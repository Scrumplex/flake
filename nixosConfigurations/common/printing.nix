{pkgs, ...}: {
  environment.systemPackages = with pkgs; [epsonscan2];
  services.printing = {
    enable = true;
    drivers = with pkgs; [samsung-unified-linux-driver_1_00_37 epson-escpr];
  };

  hardware.sane = {
    enable = true;
    extraBackends = [
      pkgs.epsonscan2
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
