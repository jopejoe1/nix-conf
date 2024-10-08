{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  esp8266,
  ncurses,
  flex,
  bison,
  gperf,
}:

stdenv.mkDerivation rec {
  pname = "esp8266-sdk";
  version = "3.4";

  src = fetchFromGitHub {
    owner = "espressif";
    repo = "ESP8266_RTOS_SDK";
    rev = "v${version}";
    hash = "sha256-3+eIiW79dlHFjkLGXq4IV5EC78I7JDtASLkDyCyyh6g=";
  };

  postPatch = ''
    substituteInPlace ./lxdialog/check-lxdialog.sh --replace-fail "main() {}" "int main() { return 0; }"
    #substituteInPlace Makefile --replace "-lncurses" "${ncurses}/lib/libncurses.so"
  '';

  env = {
    LDFLAGS = "-L${ncurses}/lib";
    CPPFLAGS = "-I${ncurses.dev}/include";
    NIX_CFLAGS_COMPILE = "-I${ncurses.dev}/include";
  };

  sourceRoot = "${src.name}/tools/kconfig";

  nativeBuildInputs = [
    flex
    bison
    gperf
  ];

  buildInputs = [
    esp8266
    ncurses
    stdenv.cc.cc.lib
  ];

  meta = {
    description = "ESP8266 RTOS SDK, an SDK for developing applications for the ESP8266 WiFi SoC";
    homepage = "https://github.com/espressif/ESP8266_RTOS_SDK";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jopejoe1 ];
    platforms = lib.platforms.linux;
  };
}
