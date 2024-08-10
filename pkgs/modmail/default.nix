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
    rev = "f01a5dab41c024cba0226185ad3eee704ffaec59";
    hash = "sha256-7shUWde1glPWRHx++D4j1edAAbDzqggnYmp1mGvzeMw=";
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
