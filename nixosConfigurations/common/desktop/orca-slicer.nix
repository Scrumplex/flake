{pkgs, ...}: {
  nixpkgs.config.permittedInsecurePackages = [
    "libsoup-2.74.3"
  ];

  environment.systemPackages = [
    pkgs.orca-slicer
  ];
}
