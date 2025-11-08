{pkgs, ...}: {
  fonts = {
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      fira
      monocraft
      fira-code
      roboto
    ];

    enableDefaultPackages = true;

    fontDir = {
      enable = true;
      decompressFonts = true;
    };

    fontconfig = {
      cache32Bit = true;
      defaultFonts = {
        sansSerif = ["Fira Sans"];
        monospace = ["Fira Code"];
      };
    };

    symbols = {
      enable = true;
      fonts = [
        "Fira Code"
        "Fira Code,Fira Code Light"
        "Fira Code,Fira Code Medium"
        "Fira Code,Fira Code Retina"
        "Fira Code,Fira Code SemiBold"
        "Monocraft"
      ];
    };
  };

  # Stop apps from generating fontconfig caches and breaking reproducibility
  hm.systemd.user.tmpfiles.rules = [
    "R %C/fontconfig - - - - -"
  ];
}
