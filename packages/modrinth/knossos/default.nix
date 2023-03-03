{ lib, fetchFromGitHub, buildNpmPackage, ... }:

buildNpmPackage {
  name = "knossos";
  verison = "2.2";

  src = fetchFromGitHub {
    owner = "modrinth";
    repo = "knossos";
    rev = "v2.2";
    sha256 = "sha256-nJDte8rpYq3Ge844qtAOvLp6NcFsl51jFgaZGR97/YI";
  };

  #npmDepsHash = "sha256-RdRQMrYoOaf2rjhvVpZw0skcekKL8rzG3oFlf/1D1cY";
}
