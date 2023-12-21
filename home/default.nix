{config, ...}: {
  hm.imports = [./common ./${config.networking.hostName}];
}
