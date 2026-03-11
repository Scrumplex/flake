{
  flake.modules.nixos.gaming = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      dolphin-emu
      ryubing
    ];
  };
}
