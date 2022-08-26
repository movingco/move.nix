# Useful for working in the Aptos repo.
{ lib
, env-rust
, rustup
, cargo-hakari
, openssl
, rust
, rust-analyzer
, pkg-config
, rocksdb
, postgresql
, stdenv
, libiconv
, darwin
, mkShell
, move-cli-address32
}:
mkShell {
  name = "env-aptos-dev";
  RUST_SRC_PATH = "${rust.packages.stable.rustPlatform.rustLibSrc}";

  buildInputs = env-rust.buildInputs ++ [
    rocksdb
    postgresql # libpq
    openssl # libssl

    move-cli-address32 # move-analyzer
  ];
}
