{ callPackage, fetchFromGitHub, cargo-hakari }:

let
  buildAptos = callPackage ./aptos.nix {
    inherit cargo-hakari;
  };
in
buildAptos rec {
  # https://github.com/movingco/aptos-core/tree/devnet-for-nix
  version = "a0ba71f4f02d403ce3222bc9a87aa3f2df95f49b";

  src = fetchFromGitHub {
    owner = "movingco";
    repo = "aptos-core";
    rev = version;
    sha256 = "sha256-1gj5jZ59cjeJocUaloJ1aH2c6iQAKPi3hzRaLruakJk=";
  };

  cargoSha256 = "sha256-awAZECBHFfKNVwvPON0moglSy6MGT/tSH1cF8K4vwgI=";
}