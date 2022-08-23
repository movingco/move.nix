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
  version = "547c7f79d1c46dccfcb1024005d2a796be2480ec";

  src = fetchFromGitHub {
    owner = "move-language";
    repo = "move";
    rev = version;
    sha256 = "sha256-JRIUalkTt7bBow0LYWv5VwvVMt4msK5eBcaGLYlcaWw=";
  };

  inherit buildFeatures;

  cargoSha256 = "sha256-c+qrSxj4ltY1gtcLqt+TH0nfHLmS5XXfZ/R9BefwYX0=";
  verifyCargoDeps = true;

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ openssl zlib ] ++ lib.optionals stdenv.isDarwin
    (with darwin.apple_sdk.frameworks;
    ([ IOKit Security CoreFoundation AppKit ]
      ++ (lib.optionals stdenv.isAarch64 [ System ])));
  strictDeps = true;

  meta = with lib; {
    description =
      "CLI frontend for the Move compiler and VM";
    homepage = "https://diem.com";

    license = licenses.asl20;
  };
}
