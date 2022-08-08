{ fetchCrate, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-hakari";
  version = "0.9.14";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-C4UBvxGZDpGfYokTzHQNkUkZqBNuKbE4pzOJ04sTDoY=";
  };

  cargoHash = "sha256-eQrRBmlP206MKDlXxcJ64jD6/6mv3V/sv9TsybIx+8Q=";
}
