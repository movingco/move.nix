{ lib
, cargo-hakari
, rustPlatform
, fetchFromGitHub
, libclang
, clang
, pkg-config
, rustc
, cargo
, rocksdb
, rustfmt
, postgresql
, openssl
, stdenv
, darwin
, libiconv
}:

rustPlatform.buildRustPackage rec {
  pname = "aptos";
  # https://github.com/movingco/aptos-core/tree/devnet-for-nix
  version = "a669724b5b3df1c2d2b1a6b25c31f4cad5177229";

  src = fetchFromGitHub {
    owner = "movingco";
    repo = "aptos-core";
    rev = version;
    sha256 = "sha256-i2czGZSZHMi0Ejqeh9X6n8ydpkikgRyOOGNHMEKbtmE=";
  };

  cargoSha256 = "sha256-bvUEaUsw+lO0leaCAztWknsJneJIHikeT7x2r78olOo=";
  verifyCargoDeps = true;

  PKG_CONFIG_PATH = "${openssl.dev}/lib/pkgconfig";
  RUST_SRC_PATH = "${rustPlatform.rustLibSrc}";

  # skip tests because they're really slow
  doCheck = false;

  # see https://github.com/NixOS/nixpkgs/issues/52447#issuecomment-852079285
  LIBCLANG_PATH = "${libclang.lib}/lib";
  BINDGEN_EXTRA_CLANG_ARGS =
    "-isystem ${libclang.lib}/lib/clang/${lib.getVersion clang}/include";

  # Used by build.rs in the rocksdb-sys crate. If we don't set these, it would
  # try to build RocksDB from source.
  ROCKSDB_INCLUDE_DIR = "${rocksdb}/include";
  ROCKSDB_LIB_DIR = "${rocksdb}/lib";

  nativeBuildInputs = [
    pkg-config
    rustc
    cargo
    clang

    rustfmt
    rocksdb
  ];

  # see: https://github.com/aptos-labs/aptos-core/blob/36dfc6499dd576d7d2ba883b66161510ff5cbe6b/.circleci/config.yml#L241
  buildInputs = [
    libclang
    postgresql # libpq
    openssl # libssl

    cargo-hakari # for workspace hack
  ] ++ (
    lib.optional stdenv.isDarwin ([ libiconv ]
      ++ (with darwin.apple_sdk.frameworks; [ DiskArbitration Foundation ]))
  );
  strictDeps = true;

  meta = with lib; {
    description = "A layer 1 for everyone!";
    homepage = "https://aptoslabs.com";
    license = licenses.asl20;
  };
}
