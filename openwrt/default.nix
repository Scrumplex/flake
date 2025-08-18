{inputs, ...}: {
  perSystem = {pkgs, ...}: let
    profiles = inputs.openwrt-imagebuilder.lib.profiles {inherit pkgs;};
  in {
    packages = {
      openwrt-arecibo = inputs.openwrt-imagebuilder.lib.build (import ./arecibo.nix {inherit profiles;});
      openwrt-brite = inputs.openwrt-imagebuilder.lib.build (import ./brite.nix {inherit profiles;});
      openwrt-honeyjar = inputs.openwrt-imagebuilder.lib.build (import ./honeyjar.nix {inherit profiles;});
      openwrt-xiaomi = inputs.openwrt-imagebuilder.lib.build (import ./xiaomi.nix {inherit profiles;});
    };
  };
}
