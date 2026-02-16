{
  flake.modules.nixos.ext-crashdump = {
    boot.crashDump = {
      enable = true;
      automatic = true;
    };
  };
}
