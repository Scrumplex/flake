{ config, pkgs, ... }:

{
  virtualisation.docker = {
    enable = true;
    autoPrune = {
      enable = true;
      flags = [
        "--all"
      ];
    };
  };

  services.openssh = {
    enable = true;
    ports = [ 22701 ];
    listenAddresses = [
      {
        addr = "[::]";
      }
    ];
    passwordAuthentication = false;
  };

  users = {
    mutableUsers = false;
    users.root = {
      openssh.authorizedKeys.keys = [
        "ecdsa-sha2-nistp521 AAAAE2VjZHNhLXNoYTItbmlzdHA1MjEAAAAIbmlzdHA1MjEAAACFBAFVss7naM39Guka0iDWXfsHniST+5pitCCAbDv9S2Z69lrATg9W8dP6R5kug81nQZ+cfITVpZqyt34PVvQLUWoWKgD5MYOXy3f5DjwWvrsIWRETGmYI5bOwW825j8CjDfcnvWa2xKyTZeOLU7+rQR5f+G5owXVGTfeHKdEOofI/4I68Cg== scrumplex@andromeda"  #andromeda
      ];
    };
  };

  environment.systemPackages = with pkgs; [
    kitty.terminfo
    htop
    nload
  ];

  programs.neovim = {
    enable = true;
    configure.customRC =
      ''
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

  nix = {
    autoOptimiseStore = true;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
    # Free up to 1GiB whenever there is less than 100MiB left.
    extraOptions = ''
      min-free = ${toString (100 * 1024 * 1024)}
      max-free = ${toString (1024 * 1024 * 1024)}
    '';
  };

  nixpkgs.config = {
    allowUnfree = true;
  };

}
