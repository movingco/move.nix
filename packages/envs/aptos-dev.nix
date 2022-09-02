# Useful for working in the Aptos/Sui repos.
{ env-rust
, rocksdb
, postgresql
, mkShell
, move-cli-address32
, rust
, libclang
, clang
, lib
, cmake
, protobuf
}:
mkShell {
  name = "env-aptos-dev";
  RUST_SRC_PATH = "${rust.packages.stable.rustPlatform.rustLibSrc}";

  # see https://github.com/NixOS/nixpkgs/issues/52447#issuecomment-852079285
  LIBCLANG_PATH = "${libclang.lib}/lib";
  BINDGEN_EXTRA_CLANG_ARGS =
    "-isystem ${libclang.lib}/lib/clang/${lib.getVersion clang}/include";

  # Used by build.rs in the rocksdb-sys crate. If we don't set these, it would
  # try to build RocksDB from source.
  ROCKSDB_INCLUDE_DIR = "${rocksdb}/include";
  ROCKSDB_LIB_DIR = "${rocksdb}/lib";

  buildInputs = env-rust.buildInputs ++ [
    libclang
    clang
    rocksdb

    move-cli-address32 # move-analyzer

    # Aptos only
    postgresql # libpq

    # Sui only
    cmake
    protobuf
  ];
}
