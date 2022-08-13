{ fetchFromGitHub
, lib
, rustPlatform
, pkgconfig
, stdenv
, darwin
, buildFeatures ? [ ]
}:

with rustPlatform;

buildRustPackage rec {
  pname = "move-ts";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "movingco";
    repo = "move-ts";
    rev = "v${version}";
    sha256 = "sha256-nGWhkm6aWACSx1ojsB/X8XU/IHhRMDCn5IWD1AzJqW4=";
  };

  inherit buildFeatures;

  cargoSha256 = "sha256-jVXl/QDSdSwzYkYIRK2GgFETAeOviyZhi18DZFFiIbo=";
  verifyCargoDeps = true;

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = lib.optionals stdenv.isDarwin
    (with darwin.apple_sdk.frameworks;
    ([ IOKit Security CoreFoundation AppKit ]
      ++ (lib.optionals stdenv.isAarch64 [ System ])));
  strictDeps = true;
}
