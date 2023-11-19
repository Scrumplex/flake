{config, ...}: {
  swapDevices = [
    {
      device = "/swapfile";
      size = 16384;
    }
  ];

  boot.kernelParams = ["resume_offset=122849280"];
  boot.resumeDevice = config.fileSystems."/".device;
}
