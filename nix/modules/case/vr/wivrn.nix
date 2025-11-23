{
  flake.modules.nixos.vr = {
    services.wivrn = {
      enable = false;
      openFirewall = true;
    };
  };
}
