{pkgs, ...}: {
  virtualisation.oci-containers.externalImages.imagesFile = ../../values.yaml;

  environment.systemPackages = with pkgs; [kitty.terminfo htop nload tcpdump];

  networking.useNetworkd = true;

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
}
