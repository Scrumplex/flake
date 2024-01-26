{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    loupe
  ];

  hm.xdg.mimeApps.defaultApplications."image/*" = ["org.gnome.Loupe.desktop" "imv.desktop"];
}
