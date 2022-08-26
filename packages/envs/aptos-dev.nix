# Useful for working in the Aptos repo.
{ lib
, cargo-hakari
, openssl
, rust
, libclang
, clang
, rustc
, cargo
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

  PKG_CONFIG_PATH = "${openssl.dev}/lib/pkgconfig";
  RUST_SRC_PATH = "${rust.packages.stable.rustPlatform.rustLibSrc}";

  # see https://github.com/NixOS/nixpkgs/issues/52447#issuecomment-852079285
  LIBCLANG_PATH = "${libclang.lib}/lib";
  BINDGEN_EXTRA_CLANG_ARGS =
    "-isystem ${libclang.lib}/lib/clang/${lib.getVersion clang}/include";

  nativeBuildInputs = [ rustc cargo clang ];

  # see: https://github.com/aptos-labs/aptos-core/blob/36dfc6499dd576d7d2ba883b66161510ff5cbe6b/.circleci/config.yml#L241
  buildInputs = [
    pkg-config
    libclang
    rocksdb
    postgresql # libpq
    openssl # libssl

    cargo-hakari # for workspace hack
    move-cli-address32 # move-analyzer
  ] ++ (
    lib.optional stdenv.isDarwin ([ libiconv ]
      ++ (with darwin.apple_sdk.frameworks; [ DiskArbitration Foundation ]))
  );
}
