{
  lib,
  pkgs,
  ...
}: {
  virtualisation.docker = {
    enable = lib.mkDefault true;
    liveRestore = false;
    autoPrune = {
      enable = true;
      flags = ["--all"];
    };
  };

  virtualisation.oci-containers.externalImages.imagesFile = ../../values.yaml;

  services.openssh = {
    enable = true;
    ports = [22701];
    settings.PasswordAuthentication = false;
  };

  users = {
    mutableUsers = false;
    users.root = {
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJV9lYhi0kcwAAjPTMl6sycwCGkjrI0bvTIwpPuXkW2W scrumplex@andromeda"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG4jTPHOnfxvBOcVmExcU+j2u9Lsf1OoVG/ols2Met9/ scrumplex@dyson"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJiQEIN+AnXuJFNqw04h/LSGF1bu8cS5PjzgIpn5QTX1 termux@void"
      ];
    };
  };

  environment.systemPackages = with pkgs; [kitty.terminfo htop nload tcpdump];

  programs.neovim = {
    enable = true;
    configure.customRC = ''
      set encoding=UTF-8

      set mouse=a
      set number

      set expandtab
      set autoindent

      set hlsearch
      set ignorecase
      set smartcase
      set clipboard=unnamed
      set nospell

      syntax enable
      filetype plugin on
    '';
  };

  nixpkgs.config.allowUnfree = true;
}
