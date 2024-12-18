{
  buildPythonApplication,
  prometheus-api-client,
  setuptools,
}:
buildPythonApplication {
  pname = "channel-notifier";
  version = "1";
  pyproject = true;

  src = ./.;

  build-system = [
    setuptools
  ];

  dependencies = [
    prometheus-api-client
  ];

  pythonImportsCheck = ["channel_notifier"];

  meta.mainProgram = "channel-notifier";
}
