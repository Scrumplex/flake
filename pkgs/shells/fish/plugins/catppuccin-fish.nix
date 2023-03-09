{
  lib,
  buildFishPlugin,
  fetchFromGitHub,
}:
buildFishPlugin rec {
  pname = "catppuccin-fish";
  version = "unstable-2022-12-29";

  src = fetchFromGitHub {
    owner = "catppuccin";
    repo = "fish";
    rev = "b90966686068b5ebc9f80e5b90fdf8c02ee7a0ba";
    sha256 = "sha256-wQlYQyqklU/79K2OXRZXg5LvuIugK7vhHgpahpLFaOw=";
  };

  meta = with lib; {
    description = "Soothing pastel theme for the Fish Shell";
    homepage = "https://github.com/catppuccin/fish";
    license = licenses.mit;
    maintainers = with maintainers; [Scrumplex];
  };
}
