# Useful for working in the Aptos repo.
{ lib
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

  # see: https://github.com/aptos-labs/aptos-core/blob/36dfc6499dd576d7d2ba883b66161510ff5cbe6b/.circleci/config.yml#L241
  buildInputs = [
    pkg-config
    rocksdb
    postgresql # libpq
    openssl # libssl

    rustup
    rust-analyzer

    cargo-hakari # for workspace hack
    move-cli-address32 # move-analyzer
  ] ++ (
    lib.optional stdenv.isDarwin ([ libiconv ]
      ++ (with darwin.apple_sdk.frameworks; [ DiskArbitration Foundation ]))
  );
}
