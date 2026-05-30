{
  flake.modules.nixos."base" = {
    config,
    lib,
    ...
  }: let
    inherit (lib) literalExpression mkEnableOption mkIf mkOption optional types;

    cfg = config.infra.borg-rsync-net;

    user = "zh6584";
    host = "${user}.rsync.net";

    repo = "ssh://${user}@${host}/./borg/${cfg.subDir}";
  in {
    options.infra.borg-rsync-net = {
      enable = mkEnableOption "regular Borg backup";

      subDir = mkOption {
        type = types.str;
        default = config.networking.hostName;
        defaultText = literalExpression ''
          config.networking.hostName
        '';
      };

      sshKeyFile = mkOption {
        type = types.path;
        example = literalExpression ''
          config.age.secrets."id-borgbase".path
        '';
      };

      repokeyPasswordFile = mkOption {
        type = with types; nullOr path;
        default = null;
        example = literalExpression ''
          config.age.secrets."borgbase-repokey".path
        '';
      };

      extraPaths = mkOption {
        type = with types; listOf path;
        default = [];
      };

      extraExcludes = mkOption {
        type = with types; listOf str;
        default = [];
      };
    };

    config = mkIf cfg.enable {
      assertions = [
        {
          assertion = lib.versionOlder config.services.borgbackup.package.version "1.15";
          message = ''
            Expected Borg version <1.15 for `services.borgbackup.package`. Got ${config.services.borgbackup.package.version}
          '';
        }
      ];
      services.borgbackup.jobs.rsync-net = {
        inherit repo;
        environment.BORG_RSH = "ssh -i ${cfg.sshKeyFile}";
        paths =
          ["/srv" "/var/lib" "/home" "/root"]
          ++ optional config.services.postgresqlBackup.enable config.services.postgresqlBackup.location
          ++ cfg.extraPaths;
        exclude =
          ["/var/lib/containers" "/var/lib/docker" "/var/lib/kubelet"]
          ++ cfg.extraExcludes;
        startAt = lib.mkDefault "05:00"; # run later, maybe the servers are overloaded at 00:00 CE(S)T
        compression = "auto,zstd";
        prune.keep = {
          within = "1d";
          daily = 3;
          weekly = 4;
          monthly = 3;
          yearly = 1;
        };
        encryption = {
          mode =
            if cfg.repokeyPasswordFile != null
            then "repokey-blake2"
            else "keyfile-blake2";
          passphrase = "";
          passCommand = mkIf (cfg.repokeyPasswordFile != null) "cat ${cfg.repokeyPasswordFile}";
        };

        extraArgs = ["-v" "--remote-path=borg14"];
        extraCreateArgs = lib.mkDefault ["--stats"];
      };

      programs.ssh.knownHosts."rsync-net" = {
        hostNames = [host];
        publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJtclizeBy1Uo3D86HpgD3LONGVH0CJ0NT+YfZlldAJd";
      };
    };
  };
}
