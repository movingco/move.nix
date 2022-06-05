{ fetchCrate, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-hakari";
  version = "0.9.4";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-5ouZqTAzi+2ELYPbaLVOgwWGrABIEz5dYOiop+mFR9o=";
  };

  cargoHash = "sha256-zxoNNox22AU+vAdQGxclqMffp8K9rXFr1hIf9d7NMfg=";
}
