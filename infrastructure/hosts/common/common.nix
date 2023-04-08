{pkgs, ...}: {
  virtualisation.docker = {
    enable = true;
    autoPrune = {
      enable = true;
      flags = ["--all"];
    };
  };

  services.openssh = {
    enable = true;
    ports = [22701];
    passwordAuthentication = false;
  };

  users = {
    mutableUsers = false;
    users.root = {
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJV9lYhi0kcwAAjPTMl6sycwCGkjrI0bvTIwpPuXkW2W scrumplex@andromeda"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHsd6Edr19iTS5QFnCEvMQh0rUZM1mjksaZHlihweLdU scrumplex@dyson"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDOXynAF50OShHHCcIGuHO133PWo/pjpaYgyOQDTS5Tj termux@void"
      ];
    };
  };

  environment.systemPackages = with pkgs; [kitty.terminfo htop nload];

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
