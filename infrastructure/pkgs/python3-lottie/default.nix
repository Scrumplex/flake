{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  wheel,
}:
buildPythonPackage rec {
  pname = "lottie";
  version = "0.7.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-oyQvi6NwUfvddQPs0WggOgjkrybxe+LsygimSvHn08E=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  pythonImportsCheck = ["lottie"];

  meta = with lib; {
    description = "A framework to work with lottie files and telegram animated stickers (tgs";
    homepage = "https://pypi.org/project/lottie/";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [Scrumplex];
  };
}
