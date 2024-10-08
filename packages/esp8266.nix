{
  lib,
  stdenv,
  fetchzip,
  autoPatchelfHook,
  gcc,
  git,
  ncurses,
  flex,
  bison,
  gperf,
  python3,
}:

stdenv.mkDerivation rec {
  pname = "esp8266";
  version = "2020r3";

  src = fetchzip {
    url = "https://dl.espressif.com/dl/xtensa-lx106-elf-gcc8_4_0-esp-${version}-linux-amd64.tar.gz";
    hash = "sha256-6to5phSx3E2D/qIbN+Nci9qkCTsGT18veFpcKAC1IfA=";
  };

  installPhase = ''
    mkdir -p $out/
    mv ./* $out/
  '';

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  buildInputs = [
    stdenv.cc.cc.lib
  ];

  autoPatchelfIgnoreMissingDeps = [ "libpython2.7.so.1.0" ];

  meta = {
    description = "Hacks to make HDR work in games on KDE";
    homepage = "https://github.com/Zamundaaa/VK_hdr_layer";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jopejoe1 ];
    platforms = lib.platforms.linux;
  };
}
