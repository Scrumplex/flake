{
  flake.modules.nixos.base = {pkgs, ...}: {
    programs.mtr.enable = true;
    programs.bandwhich.enable = true;

    programs.bat.enable = true;

    environment.systemPackages = with pkgs; [
      htop
      ranger
      git

      jq

      just

      dig
      lsof
      nload
      tcpdump
      tree

      fd
      file
      libqalculate
      parallel
      ripgrep

      pciutils
      psmisc
      usbutils

      p7zip
      unzip
      zip

      vimv-rs
    ];

    environment.etc."htoprc".text = ''
      .tree_view_always_by_pid=1
      delay=10
      fields=0 48 17 18 38 39 40 2 46 47 49 1
      left_meter_modes=1 1 1
      left_meters=LeftCPUs2 Memory Swap
      right_meter_modes=1 2 2 2
      right_meters=RightCPUs2 Tasks LoadAverage Uptime
      tree_view=1
    '';

    environment.etc."ranger/rc.conf".text = ''
      set preview_images_method kitty
    '';
  };
}
