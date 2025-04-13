{
  config,
  lib,
  ...
}: {
  age.secrets."bob-the-builder.key".file = ../../secrets/common/bob-the-builder.key.age;

  nix = {
    buildMachines = lib.mkMerge [
      (lib.mkIf (config.networking.hostName != "andromeda") [
        {
          hostName = "andromeda.lan";
          sshUser = "bob-the-builder";
          sshKey = config.age.secrets."bob-the-builder.key".path;
          system = "x86_64-linux";
          protocol = "ssh-ng";
          maxJobs = 4;
          speedFactor = 4;
          supportedFeatures = ["nixos-test" "benchmark" "big-parallel" "kvm"];
        }
      ])
      (lib.mkIf (config.networking.hostName != "eclipse") [
        {
          hostName = "eclipse.sefa.cloud";
          sshUser = "bob-the-builder";
          sshKey = config.age.secrets."bob-the-builder.key".path;
          system = "x86_64-linux";
          protocol = "ssh-ng";
          maxJobs = 4;
          speedFactor = 1;
          supportedFeatures = ["nixos-test" "benchmark" "big-parallel" "kvm"];
        }
      ])
      [
        {
          hostName = "mini.scrumplex.net";
          sshUser = "bob-the-builder";
          sshKey = config.age.secrets."bob-the-builder.key".path;
          system = "aarch64-darwin,x86_64-darwin";
          protocol = "ssh-ng";
          maxJobs = 8;
          speedFactor = 1;
          supportedFeatures = ["nixos-test" "benchmark" "big-parallel" "apple-virt"];
        }
      ]
    ];
    distributedBuilds = true;
    settings.builders-use-substitutes = true;
  };
}
