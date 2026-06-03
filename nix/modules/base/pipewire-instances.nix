{lib, ...}: {
  flake.modules.homeManager."base" = {
    config,
    pkgs,
    ...
  }: let
    inherit
      (lib)
      isStorePath
      literalExpression
      makeSearchPath
      mapAttrs'
      mkIf
      mkOption
      nameValuePair
      types
      ;

    cfg = config.services.pipewire;

    instanceOpts = types.submodule {
      options = {
        config = mkOption {
          type = with types; either path str;
          default = null;
          example = literalExpression "./compressor.conf";
          description = ''
            Configuration file for the PipeWire instance. See <citerefentry>
            <refentrytitle>pipewire.conf</refentrytitle><manvolnum>5</manvolnum>
            </citerefentry>
          '';
        };
        extraPackages = mkOption {
          type = with types; listOf package;
          default = [];
          example = literalExpression "[ pkgs.calf ]";
          description = "Extra packages available to this PipeWire instance.";
        };
      };
    };

    mkPipeWireInstance = name: instance: let
      fullName = "pipewire-instance-${name}";
      pwConfig =
        if builtins.isPath instance.config || isStorePath instance.config
        then instance.config
        else pkgs.writeText "${fullName}.conf" instance.config;
    in
      nameValuePair fullName {
        Unit = {
          Description = "PipeWire instance ${name}";
          After = "pipewire.service";
          BindsTo = "pipewire.service";
        };
        Service = {
          Environment = let
            # pipewire-filter-chain allows loading LADSPA and LV2 filters, add them to the search path here
            extraPackages = instance.extraPackages ++ [pkgs.pipewire];
            bins = makeSearchPath "bin" extraPackages;
            libs = makeSearchPath "lib" extraPackages;
            ladspaLibs = makeSearchPath "lib/ladspa" extraPackages;
            lv2Libs = makeSearchPath "lib/lv2" extraPackages;
          in [
            "PATH=${bins}"
            "LD_LIBRARY_PATH=${libs}"
            "LADSPA_PATH=${ladspaLibs}"
            "LV2_PATH=${lv2Libs}"
          ];
          ExecStart = ''
            ${lib.getExe' pkgs.pipewire "pipewire"} -c ${pwConfig}
          '';
        };
        Install.WantedBy = ["pipewire.service"];
      };
  in {
    options.services.pipewire.instances = mkOption {
      type = types.attrsOf instanceOpts;
      default = {};
      example = literalExpression ''
        {
          compressor = {
            config = ./compressor.conf;
            extraPackages = [ pkgs.calf ];
          };
        }
      '';
      description = "Definition of PipeWire instances";
    };

    config = mkIf (cfg.enable && cfg.instances != []) {
      systemd.user.services = mapAttrs' mkPipeWireInstance cfg.instances;
    };
  };
}
