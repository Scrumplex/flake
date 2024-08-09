{
  lib,
  buildPythonApplication,
  fetchFromGitHub,
  poetry-core,
  pythonRelaxDepsHook,
  aiodns,
  aiohttp,
  aiosignal,
  async-timeout,
  attrs,
  brotli,
  cairocffi,
  cairosvg,
  certifi,
  cffi,
  charset-normalizer,
  colorama,
  cssselect2,
  defusedxml,
  discordpy,
  dnspython,
  emoji,
  frozenlist,
  idna,
  isodate,
  lottie,
  motor,
  multidict,
  natural,
  orjson,
  packaging,
  parsedatetime,
  pillow,
  pycares,
  pycparser,
  pymongo,
  python-dateutil,
  python-dotenv,
  requests,
  six,
  tinycss2,
  urllib3,
  uvloop,
  webencodings,
  yarl,
}:
buildPythonApplication rec {
  pname = "modmail";
  version = "4.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Scrumplex";
    repo = "Modmail";
    rev = "8a8c1c53eb25b5ef8603274335ac94a0bf1ffd1e";
    hash = "sha256-TY95aXcL3v/gvPBSW7UZx3acXFxjpRuwoBqqGDEHJxI=";
  };

  nativeBuildInputs = [
    poetry-core
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = [
    aiodns
    aiohttp
    aiosignal
    async-timeout
    attrs
    brotli
    cairocffi
    cairosvg
    certifi
    cffi
    charset-normalizer
    colorama
    cssselect2
    defusedxml
    discordpy
    dnspython
    emoji
    frozenlist
    idna
    isodate
    lottie
    motor
    multidict
    natural
    orjson
    packaging
    parsedatetime
    pillow
    pycares
    pycparser
    pymongo
    python-dateutil
    python-dotenv
    requests
    six
    tinycss2
    urllib3
    uvloop
    webencodings
    yarl
  ];

  pythonRelaxDeps = [
    "packaging"
    "defusedxml"
  ];

  pythonImportsCheck = ["modmail"];

  meta = with lib; {
    description = "A Discord bot that functions as a shared inbox between staff and members, similar to Reddit's Modmail";
    homepage = "https://github.com/modmail-dev/Modmail";
    changelog = "https://github.com/modmail-dev/Modmail/blob/${src.rev}/CHANGELOG.md";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [Scrumplex];
    mainProgram = "modmail";
  };
}
