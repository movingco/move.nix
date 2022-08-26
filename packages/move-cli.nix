{ fetchFromGitHub
, lib
, rustPlatform
, pkgconfig
, openssl
, zlib
, stdenv
, darwin
, buildFeatures ? [ ]
, git
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

  cargoSha256 = "sha256-/bsfncv9v2neN7RFiyQU6yltDp1Q7O0n04pYb1zeBzA=";
  verifyCargoDeps = true;

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ openssl zlib git ] ++ lib.optionals stdenv.isDarwin
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
