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

  npmDepsHash = "sha256-4ha6qgehExf/OoUGu622vpBTN80/83r3IWbPbBOSCMQ=";
}
