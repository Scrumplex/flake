{pkgs, ...}: {
  fonts = {
    packages = with pkgs; [
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

  services.gvfs.enable = true;
}
