{
  flake.modules.nixos."ext-monitoring" = {
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

    config = lib.mkIf (cfg != []) {
      environment.etc."alloy/discovery.alloy".text = ''
        discovery.file "default" {
          files = ["/etc/alloy/discovery.json"]
        }

        prometheus.scrape "default" {
          targets    = discovery.file.default.targets
          scrape_interval = "15s"

          forward_to = [prometheus.relabel.default.receiver]
        }

        prometheus.relabel "default" {
          rule {
            target_label = "node"
            replacement = sys.env("HOSTNAME")
          }
          forward_to = [prometheus.remote_write.default.receiver]
        }
      '';
      environment.etc."alloy/discovery.json".source = jsonFormat.generate "alloy-discovery.json" cfg;
    };
  };
}
