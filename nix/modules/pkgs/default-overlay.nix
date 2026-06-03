{
  config,
  lib,
  ...
}: {
  flake.overlays.default = lib.composeManyExtensions (builtins.attrValues (removeAttrs config.flake.overlays ["default"]));
}
