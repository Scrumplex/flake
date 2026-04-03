{lib, ...}: {
  options.flake.meta = {
    syncthingDevices = lib.mkOption {
      type = with lib.types;
        attrsOf (submodule {
          options.id = lib.mkOption {
            type = str;
          };
        });
    };
  };
  config = {
    # Sadly not NixOS :(
    flake.meta.syncthingDevices = {
      "antares".id = "MOD53BR-TS455TP-KWYY4VD-RQ7JLZM-NSURG2I-GLAFRFQ-K4XIWQ4-7BMPBQK";
      "borealis".id = "HTHVAWB-C5SXLYH-UZA4ZIJ-A75RYY2-WNOFJ5Y-J6Z3FEQ-TUJHI7Z-L7WYQQC";
    };
  };
}
