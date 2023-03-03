{ lib, fetchFromGitHub, buildNpmPackage, ... }:

buildNpmPackage {
  name = "knossos";
  verison = "2.2";

  src = fetchFromGitHub {
    owner = "modrinth";
    repo = "knossos";
    rev = "v2.2";
    sha256 = "sha256-p6rHMio9oOmT2qyPq+TPzd7id+X1fck9Wa3vLHWp0Kg=";
  };

  #npmDepsHash = "sha256-RdRQMrYoOaf2rjhvVpZw0skcekKL8rzG3oFlf/1D1cY";
}
