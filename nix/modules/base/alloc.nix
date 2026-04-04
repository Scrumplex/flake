{inputs, ...}: {
  flake.modules.nixos."base" = {
    imports = [inputs.alloc.nixosModules.alloc];

    alloc = {
      # Inspired by Kubernetes node port range
      tcpPorts = {
        start = 30000;
        interval = 2767;
      };
      udpPorts = {
        start = 30000;
        interval = 2767;
      };
    };
  };
}
