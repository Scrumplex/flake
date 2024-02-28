{
  inputs,
  lib,
  self,
  ...
}: let
  libT = inputs.typhon-ci.lib;
in {
  flake.typhonProject = libT.gitea.mkProject {
    title = "scrumplex.net Infrastructure";
    instance = "codeberg.org";
    owner = "Scrumplex";
    repo = "infrastructure";
    typhonUrl = "https://typhon.sefa.cloud";
    secrets = ./secrets.age;
  };
  flake.typhonJobs = {
    x86_64-linux =
      lib.genAttrs
      ["eclipse" "universe"]
      (m: self.nixosConfigurations.${m}.config.system.build.toplevel);
  };
}
