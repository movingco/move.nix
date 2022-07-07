{ callPackage, fetchFromGitHub, cargo-hakari }:

let
  buildAptos = callPackage ./aptos.nix {
    inherit cargo-hakari;
  };
in
buildAptos rec {
  pname = "aptos-cli";
  # https://github.com/movingco/aptos-core/tree/devnet-for-nix
  version = "a669724b5b3df1c2d2b1a6b25c31f4cad5177229";

  src = fetchFromGitHub {
    owner = "movingco";
    repo = "aptos-core";
    rev = version;
    sha256 = "sha256-i2czGZSZHMi0Ejqeh9X6n8ydpkikgRyOOGNHMEKbtmE=";
  };

  cargoSha256 = "sha256-paR5KXvUVbQQeI0l92Qiav8RX6ok1IzWvcm/qWEkLVI=";

  buildAndTestSubdir = "crates/aptos";
}
