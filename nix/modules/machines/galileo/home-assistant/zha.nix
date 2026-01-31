{
  flake.modules.nixos."machine-galileo" = {
    services.home-assistant.extraComponents = [
      "zha"
    ];

    services.udev.extraRules = ''
      SUBSYSTEM=="tty", ATTRS{idVendor}=="10c4", ATTRS{idProduct}=="ea60", ATTRS{serial}=="2ed25a95ac3aef11a9c02c1455516304", SYMLINK+="ttyUSB-SONOFF-ZigBee"
    '';
  };
}
