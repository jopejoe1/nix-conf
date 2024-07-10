{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  kdePackages,
}:

stdenv.mkDerivation {
  pname = "wallpaper-engine-kde-plugin";
  version = "0-unstable-";

  src = fetchFromGitHub {
    owner = "catsout";
    repo = "wallpaper-engine-kde-plugin";
    rev = "34f7f01acba3bc8f94d478032cf86aef06b02d26";
    hash = "sha256-kuXDLlE//HuM8fJOGjZtsIBDIudR19mhwrBtwhDhN+k=";
  };

  nativeBuildInputs = [
    cmake
    kdePackages.extra-cmake-modules
    kdePackages.wrapQtAppsHook
  ];

  buildInputs = [ kdePackages.qtbase ];

  cmakeFlags = [
    "-DECM_DIR=${kdePackages.extra-cmake-modules}/share/ECM/cmake"
    "-DQT_MAJOR_VERSION=6"
  ];

  strictDeps = true;

  meta = {
    description = "Kde wallpaper plugin integrating wallpaper engine";
    homepage = "https://github.com/catsout/wallpaper-engine-kde-plugin";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ jopejoe1 ];
    platforms = lib.platforms.linux;
  };
}
