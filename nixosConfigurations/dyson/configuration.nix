{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./boot.nix
    ./desktop/sway.nix
    ./desktop/swayidle.nix
    ./networkmanager.nix
    ./swapfile.nix
    ./wireguard.nix

    inputs.nixos-hardware.nixosModules.framework-12th-gen-intel
  ];

  hardware.enableRedistributableFirmware = true;
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_zen;

  powerManagement.cpuFreqGovernor = "powersave";
  services.fwupd.enable = true;

  boot.binfmt.emulatedSystems = ["aarch64-linux"];

  services.logind = {
    powerKey = "suspend-then-hibernate";
    lidSwitch = "suspend-then-hibernate";
    lidSwitchExternalPower = "suspend";
    extraConfig = ''
      PowerKeyIgnoreInhibited=yes
      LidSwitchIgnoreInhibited=no
    '';
  };

  systemd.sleep.extraConfig = ''
    HibernateDelaySec=10m
  '';

  system.stateVersion = "23.11";
}
