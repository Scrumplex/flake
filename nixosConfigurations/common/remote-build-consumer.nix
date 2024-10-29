{config, ...}: {
  age.secrets."bob-the-builder.key".file = ../../secrets/common/bob-the-builder.key.age;

  nix = {
    buildMachines = [
      {
        hostName = "cosmos.lan";
        sshUser = "bob-the-builder";
        sshKey = config.age.secrets."bob-the-builder.key".path;
        system = "aarch64-linux";
        protocol = "ssh-ng";
        maxJobs = 2;
        speedFactor = 2; # much faster than our arm64 emulation!
        supportedFeatures = ["nixos-test" "benchmark" "big-parallel" "kvm" "gccarch-armv8-a"];
      }
      {
        hostName = "eclipse.lan";
        sshUser = "bob-the-builder";
        sshKey = config.age.secrets."bob-the-builder.key".path;
        system = "x86_64-linux";
        protocol = "ssh-ng";
        maxJobs = 4;
        speedFactor = 1;
        supportedFeatures = ["nixos-test" "benchmark" "big-parallel" "kvm"];
      }
    ];
    distributedBuilds = true;
    settings.builders-use-substitutes = true;
  };
}
