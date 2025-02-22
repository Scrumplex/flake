{pkgs, ...}: {
  environment.systemPackages = with pkgs; [epsonscan2];
  services.printing = {
    enable = true;
    drivers = with pkgs; [samsung-unified-linux-driver_1_00_37 epson-escpr];
  };
}
