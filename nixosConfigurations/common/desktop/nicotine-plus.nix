{pkgs, ...}: {
  networking.firewall.allowedTCPPorts = [2234];

  environment.systemPackages = with pkgs; [nicotine-plus];
}
