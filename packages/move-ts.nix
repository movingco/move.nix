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
  version = "6928b8a44e5df6d15fca1159ea59c9689a3b9e7c";

  src = fetchFromGitHub {
    owner = "movingco";
    repo = "move-ts";
    # rev = "v${version}";
    rev = version;
    sha256 = "sha256-uh3mgbEZIoZgzWwtvC/Twsak7FNNCwq16r2SWr/2oBI=";
  };

  inherit buildFeatures;

  cargoSha256 = "sha256-GwySAkccTAcVC7XoGxtD8yYXwfLQVGFQ1w1bRkTQDTU=";
  verifyCargoDeps = true;

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = lib.optionals stdenv.isDarwin
    (with darwin.apple_sdk.frameworks;
    ([ IOKit Security CoreFoundation AppKit ]
      ++ (lib.optionals stdenv.isAarch64 [ System ])));
  strictDeps = true;
}
