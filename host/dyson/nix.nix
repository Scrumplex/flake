{lib, ...}: let
  mkAfterAfter = lib.mkOrder 2000;
in {
  nixpkgs.config.allowUnfree = true;
  nix.settings = {
    substituters = mkAfterAfter [
      "http://10.10.10.10:5000" # TODO: make this a bit smarter
    ];
    trusted-public-keys = [
      "10.10.10.10:g/hJVSroB+h/rPTMv76QmKuMOiZzJhvSWtlAgZ/DnBY="
    ];
  };
}
