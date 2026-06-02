{pkgs, ...}: {
  hm.programs.imv.enable = true;
  environment.systemPackages = with pkgs; [
    loupe
  ];

  hm.xdg.mimeApps.defaultApplications."image/*" = ["org.gnome.Loupe.desktop" "imv.desktop"];
}
