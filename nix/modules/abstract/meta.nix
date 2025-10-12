{lib, ...}: {
  options.flake.meta = {
    username = lib.mkOption {
      default = "scrumplex";
    };
  };
}
