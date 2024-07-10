{
  lib,
  stdenv,
  meson,
#  ninja,
  fetchFromGitHub,
  vulkan-headers,
  libX11,
}:

stdenv.mkDerivation {
  pname = "VK_hdr_layer";
  version = "0-unstable-";

  src = fetchFromGitHub {
    owner = "Zamundaaa";
    repo = "VK_hdr_layer";
    rev = "e47dc6da924cd361b0082f5c27fe5e923377bb54";
    fetchSubmodules = true;
    hash = "sha256-wuZdUWMKEM/UCeuZSiNyup2vzo6+KIH9Rpaoc4FARJE=";
  };

  nativeBuildInputs = [
    meson
 #   ninja
  ];

  buildInputs = [ vulkan-headers libX11 ];

  strictDeps = true;

  meta = {
    description = "Hacks to make HDR work in games on KDE";
    homepage = "https://github.com/Zamundaaa/VK_hdr_layer";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jopejoe1 ];
    platforms = lib.platforms.linux;
  };
}
