{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    imv
    loupe
  ];

  hm.xdg.mimeApps.defaultApplications."image/*" = ["org.gnome.Loupe.desktop" "imv.desktop"];
}
