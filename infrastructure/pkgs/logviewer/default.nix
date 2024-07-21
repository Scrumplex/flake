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
    rev = "f7d15d26b5ee2be1bc1c888b81d4f1b9c7d32d05";
    hash = "sha256-1lfB04ffuy8pqECtQGomPZE+KrBDYrWNLnaGqUbJhcM=";
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
