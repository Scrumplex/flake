{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.srvos.darwinModules.server
    ../common/openssh.nix
    ../common/remote-build-provider.nix
  ];

  system.stateVersion = 5;

  programs.zsh.enable = true;
  programs.zsh.enableCompletion = false;
  programs.bash.enable = true;
  programs.bash.completion.enable = true;

  services.nix-daemon.enable = true;

  nix = {
    package = pkgs.nix;
    settings = {
      "extra-experimental-features" = [
        "nix-command"
        "flakes"
      ];
      max-jobs = 4;
      cores = 2;
    };

    gc = {
      automatic = true;
      user = "";
      interval = {
        Minute = 15;
      };
      options = let
        gbFree = 50;
      in "--max-freed $((${toString gbFree} * 1024**3 - 1024 * $(df -P -k /nix/store | tail -n 1 | awk '{ print $4 }')))";
    };
    # If we drop below 20GiB during builds, free 20GiB
    extraOptions = ''
      min-free = ${toString (30 * 1024 * 1024 * 1024)}
      max-free = ${toString (50 * 1024 * 1024 * 1024)}
    '';
  };
}
