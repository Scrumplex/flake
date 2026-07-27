{pkgs, ...}: {
  environment.systemPackages = with pkgs; [kitty.terminfo htop nload tcpdump];

  networking.useNetworkd = true;
}
