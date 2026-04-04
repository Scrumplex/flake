{
  flake.modules.nixos.base = {
    config,
    lib,
    pkgs,
    ...
  }: let
    cfg = config.services.alloy.scrape;
    jsonFormat = pkgs.formats.json {};
    scrapeModule = lib.types.submodule {
      freeformType = jsonFormat.type;
      options = {
        targets = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [];
        };
        labels = lib.mkOption {
          type = lib.types.attrsOf lib.types.str;
          default = {};
        };
      };
    };
  in {
    options.services.alloy.scrape = lib.mkOption {
      type = lib.types.listOf scrapeModule;
      default = [];
    };

    config = lib.mkIf (config.services.alloy.enable && cfg != []) {
      environment.etc."alloy/discovery.alloy".text = ''
        discovery.file "default" {
          files = ["/etc/alloy/discovery.json"]
        }

        prometheus.scrape "default" {
          targets    = discovery.file.default.targets

          forward_to = [prometheus.relabel.default.receiver]
        }
      '';
      environment.etc."alloy/discovery.json".source = jsonFormat.generate "alloy-discovery.json" cfg;
    };
  };
}
