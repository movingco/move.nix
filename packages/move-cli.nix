{ fetchFromGitHub
, lib
, rustPlatform
, pkgconfig
, openssl
, zlib
, darwinPackages
, buildFeatures ? [ ]
}:

with rustPlatform;

buildRustPackage rec {
  pname = "move";
  version = "84f3819de919bb74249942a478cb01d10c52c1b6";

  src = fetchFromGitHub {
    owner = "move-language";
    repo = "move";
    rev = version;
    sha256 = "sha256-sNqpXD8X3QWFNmk6aeHevRaiyfwe9DDQOAIavKz4s5I=";
  };

  inherit buildFeatures;

  cargoSha256 = "sha256-NkdCujbfqcPiyPlhRx1J+aL3k2M1NeIzXlP+kf2xPT8=";
  verifyCargoDeps = true;

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ openssl zlib ] ++ darwinPackages;
  strictDeps = true;

  doCheck = false;

  meta = with lib; {
    description =
      "CLI frontend for the Move compiler and VM";
    homepage = "https://diem.com";

    license = licenses.asl20;
  };
}
