{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  six,
  wheel,
}:
buildPythonPackage rec {
  pname = "natural";
  version = "0.2.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-GMg2YtLTP9fm7uTjsNc2bhzoYiVmTjEnoqrwoyM/ffI=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    six
  ];

  pythonImportsCheck = ["natural"];

  meta = with lib; {
    description = "Convert data to their natural (human-readable) format";
    homepage = "https://pypi.org/project/natural/";
    license = licenses.mit;
    maintainers = with maintainers; [Scrumplex];
  };
}
