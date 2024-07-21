{
  lib,
  buildPythonApplication,
  fetchFromGitHub,
  poetry-core,
  pythonRelaxDepsHook,
  aiofiles,
  dnspython,
  httptools,
  jinja2,
  markupsafe,
  motor,
  multidict,
  natural,
  pymongo,
  python-dateutil,
  python-dotenv,
  sanic,
  sanic-routing,
  six,
  ujson,
  uvloop,
  websockets,
  setuptools,
}:
buildPythonApplication rec {
  pname = "logviewer";
  version = "1.1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Scrumplex";
    repo = "logviewer";
    rev = "2c9c80c323f4481fb2d0c78bc043b7933a955be8";
    hash = "sha256-FUoQFUXXtQljT3bKOZTmnW8CeXqqPD1v4WzUc/x1vNM=";
  };

  nativeBuildInputs = [
    poetry-core
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = [
    aiofiles
    dnspython
    httptools
    jinja2
    markupsafe
    motor
    multidict
    natural
    pymongo
    python-dateutil
    python-dotenv
    sanic
    sanic-routing
    setuptools
    six
    ujson
    uvloop
    websockets
  ];

  pythonRelaxDeps = [
    "aiofiles"
    "httptools"
    "jinja2"
    "markupsafe"
    "motor"
    "multidict"
    "python-dateutil"
    "python-dotenv" # ==0.18.0 not satisfied by version 1.0.1
    "sanic" #==22.6.2 not satisfied by version 23.12.0
    "sanic-routing" #==22.3.0 not satisfied by version 23.12.0
    "ujson" # not satisfied by version 5.10.0
    "uvloop" # not satisfied by version 0.19.0
    "websockets" # ==10.3 not satisfied by version 12.0"
  ];

  pythonImportsCheck = ["logviewer"];

  meta = {
    description = "External website that allows moderators and administrators to view past Modmail threads. It provides a convenient way for moderators to track previous conversations and helps them to maintain a record of user interactions";
    homepage = "https://github.com/modmail-dev/logviewer";
    changelog = "https://github.com/modmail-dev/logviewer/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [Scrumplex];
    mainProgram = "logviewer";
  };
}
