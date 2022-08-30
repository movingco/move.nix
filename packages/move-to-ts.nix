{ fetchFromGitHub
, lib
, rustPlatform
, pkgconfig
, stdenv
, darwin
, openssl
, buildFeatures ? [ ]
}:

with rustPlatform;

buildRustPackage rec {
  pname = "move-to-ts";
  version = "ea20385af33f98207217747c015dbf31b63b0d8e";

  src = fetchFromGitHub {
    owner = "hippospace";
    repo = "move-to-ts";
    # rev = "v${version}";
    rev = version;
    sha256 = "sha256-ICKUlrs7dLNJTgBtt8ffaqZI+zpwxrRoch9FZatyQ/U=";
  };

  inherit buildFeatures;

  cargoSha256 = "sha256-5pcM/1Uhtys+9svBWBKXJ7dFgF4qo+/nlUutSqqFF7Y=";
  verifyCargoDeps = true;

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin
    (with darwin.apple_sdk.frameworks;
    ([ IOKit Security CoreFoundation AppKit ]
      ++ (lib.optionals stdenv.isAarch64 [ System ])));
  strictDeps = true;
}
