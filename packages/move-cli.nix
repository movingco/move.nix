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
  version = "f20499851934cd51f81b390954a292ca1bd419b8";

  src = fetchFromGitHub {
    owner = "move-language";
    repo = "move";
    rev = version;
    sha256 = "sha256-JutgCA1CtUNpgyy5Ny7DZh9+5f54eA2RyVul0XdedfI=";
  };

  inherit buildFeatures;

  cargoSha256 = "sha256-FanHIuctJfvLadRqVvgdHSibdJNXBGD6D2vBWN0tYx8=";
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
