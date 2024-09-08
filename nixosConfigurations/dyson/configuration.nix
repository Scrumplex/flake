{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./boot.nix
    ./borg.nix
    ./desktop/sway.nix
    ./desktop/swayidle.nix
    ./keyd.nix
    ./networkmanager.nix
    ./swapfile.nix
    ./wireguard.nix

    inputs.nixos-hardware.nixosModules.framework-12th-gen-intel
  ];

  hardware.enableRedistributableFirmware = true;
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_zen;

  profile.nix.enableMyCache = true;

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
