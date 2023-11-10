{
  config,
  inputs,
  lib,
  ...
}: let
  inherit (builtins) attrValues hasAttr;
  inherit (lib.lists) optional;
  inherit (lib.modules) mkAliasOptionModule;
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib) types;

  inherit (inputs) catppuccin nix-index-database scrumpkgs;

  cfg = config.roles.base;
in {
  options.roles.base = {
    username = mkOption {
      type = with types; str;
      example = "dave";
      description = ''
        Username of the primary user on this system.
      '';
    };

    enableAdmin = mkEnableOption "admin permissions for the primary user" // {default = true;};
  };

  imports = [
    (mkAliasOptionModule ["hm"] ["home-manager" "users" cfg.username])
    (mkAliasOptionModule ["roles" "base" "user"] ["users" "users" cfg.username])
  ];

  config = {
    assertions = [
      {
        assertion = hasAttr "username" cfg;
        message = "base role username has to be set";
      }
    ];

    nix.settings.trusted-users = optional cfg.enableAdmin cfg.username;

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      sharedModules =
        attrValues scrumpkgs.hmModules
        ++ [
          catppuccin.homeManagerModules.catppuccin
          nix-index-database.hmModules.nix-index
        ];
      extraSpecialArgs = {
        inherit inputs;
        lib' = scrumpkgs.lib;
      };
    };

    hm = {
      home.username = cfg.username;

      programs.home-manager.enable = true;
    };
  };
}
