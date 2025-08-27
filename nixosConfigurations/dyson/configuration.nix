{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ./boot.nix
    ./borg.nix
    ./desktop/niri.nix
    ./disks.nix
    ./keyd.nix
    ./networkmanager.nix
    ./swapfile.nix
    ./wireguard.nix

    inputs.nixos-facter-modules.nixosModules.facter
    inputs.nixos-hardware.nixosModules.framework-12th-gen-intel
    inputs.srvos.nixosModules.desktop
  ];

  facter.reportPath = ./facter.json;
  hardware.enableRedistributableFirmware = true;
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_zen;

  security.pam.services.login.fprintAuth = false;
  security.pam.services.sudo.fprintAuth = false;

  services.power-profiles-daemon.enable = true;
  services.fwupd.enable = true;

  networking.useNetworkd = true;

  boot.binfmt.emulatedSystems = ["aarch64-linux"];

  services.logind.settings.Login = {
    HandlePowerKey = "suspend-then-hibernate";
    HandleLidSwitch = "suspend-then-hibernate";
    HandleLidSwitchExternalPower = "suspend-then-hibernate";
    PowerKeyIgnoreInhibited = true;
    LidSwitchIgnoreInhibited = true;
  };

  systemd.sleep.extraConfig = ''
    HibernateDelaySec=10m
  '';

  system.stateVersion = "23.11";
}
