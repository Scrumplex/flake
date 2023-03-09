{
  lib,
  buildFishPlugin,
  fetchFromGitHub,
}:
buildFishPlugin rec {
  pname = "bobthefisher";
  version = "unstable-2022-06-27";

  src = fetchFromGitHub {
    owner = "Scrumplex";
    repo = pname;
    rev = "fb35870208f697e57946ed044345c94306899466";
    sha256 = "sha256-SubqgQooQq+gOC/UE3i96Sst/Q29kGwsQ6IMZVePFw8=";
  };

  meta = with lib; {
    description = "A Powerline-style, Git-aware fish theme optimized for awesome";
    homepage = "https://github.com/Scrumplex/bobthefisher";
    license = licenses.mit;
    maintainers = with maintainers; [Scrumplex];
  };
}
