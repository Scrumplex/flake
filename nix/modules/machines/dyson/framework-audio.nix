{
  flake.modules.nixos."machine-dyson" = {
    hardware.framework.laptop13.audioEnhancement = {
      enable = true;
      rawDeviceName = "alsa_output.pci-0000_00_1f.3.analog-stereo";
    };
  };
}
