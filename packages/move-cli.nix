{ fetchFromGitHub
, lib
, rustPlatform
, pkgconfig
, openssl
, zlib
, stdenv
, darwin
, buildFeatures ? [ ]
}:

with rustPlatform;

buildRustPackage rec {
  pname = "move";
  version = "c72541e9fe1581316f0328a411c2a2e751e9b35c";

  src = fetchFromGitHub {
    owner = "move-language";
    repo = "move";
    rev = version;
    sha256 = "sha256-jJz092Bf6Y4PqSIrcJMmvAD01886eyjR5sGuoNFVAL8=";
  };

  inherit buildFeatures;

  cargoSha256 = "sha256-NlpkfsRLt4r9bwg6x5PQUOYmQHBW/ThpF/DuEZfQQSU=";
  verifyCargoDeps = true;

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ openssl zlib ] ++ lib.optionals stdenv.isDarwin
    (with darwin.apple_sdk.frameworks;
    ([ IOKit Security CoreFoundation AppKit ]
      ++ (lib.optionals stdenv.isAarch64 [ System ])));
  strictDeps = true;

  doCheck = false;

  meta = with lib; {
    description =
      "CLI frontend for the Move compiler and VM";
    homepage = "https://diem.com";

    license = licenses.asl20;
  };
}
