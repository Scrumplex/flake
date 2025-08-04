{
  config,
  lib,
  ...
}: let
  inherit (lib) literalExpression mkEnableOption mkIf mkOption optional types;

  cfg = config.infra.borgbase;
in {
  options.infra.borgbase = {
    enable = mkEnableOption "Regular Borg backup";

    repo = mkOption {
      type = with types; str;
      description = ''
        Remote borgbase repo.
      '';
    };

    sshKeyFile = mkOption {
      type = with types; path;
      description = ''
        Path to a ssh key file to authenticate against the borgbase repo.
      '';
      example = literalExpression ''
        config.age.secrets."id-borgbase".path
      '';
    };

    repokeyPasswordFile = mkOption {
      type = with types; nullOr path;
      default = null;
      description = ''
        Path to a password file to decrypt a repokey.
      '';
      example = literalExpression ''
        config.age.secrets."borgbase-repokey".path
      '';
    };

    extraPaths = mkOption {
      type = with types; listOf path;
      default = [];
      description = ''
        A list of extra paths that should be backed up.
      '';
    };
  };

  config = mkIf cfg.enable {
    services.borgbackup.jobs.borgbase = {
      inherit (cfg) repo;
      environment.BORG_RSH = "ssh -i ${cfg.sshKeyFile}";
      paths =
        ["/srv" "/var/lib" "/home" "/root"]
        ++ optional config.services.postgresqlBackup.enable config.services.postgresqlBackup.location
        ++ cfg.extraPaths;
      exclude = ["/var/lib/containers" "/var/lib/docker" "/var/lib/kubelet"];
      startAt = "05:00"; # run later, maybe the servers are overloaded at 00:00 CE(S)T
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

      extraArgs = "-v";
      extraCreateArgs = "--stats";
    };

    programs.ssh.knownHosts."borgbase" = {
      hostNames = ["c8wl3xsp.repo.borgbase.com" "gils6l68.repo.borgbase.com" "yekr15ge.repo.borgbase.com"];
      publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMS3185JdDy7ffnr0nLWqVy8FaAQeVh1QYUSiNpW5ESq";
    };
  };
}
