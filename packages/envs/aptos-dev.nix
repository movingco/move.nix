# Useful for working in the Aptos repo.
{ env-rust
, rocksdb
, postgresql
, mkShell
, move-cli-address32
, rust
, libclang
, clang
, lib
}:
mkShell {
  name = "env-aptos-dev";
  RUST_SRC_PATH = "${rust.packages.stable.rustPlatform.rustLibSrc}";

  # see https://github.com/NixOS/nixpkgs/issues/52447#issuecomment-852079285
  LIBCLANG_PATH = "${libclang.lib}/lib";
  BINDGEN_EXTRA_CLANG_ARGS =
    "-isystem ${libclang.lib}/lib/clang/${lib.getVersion clang}/include";

  buildInputs = env-rust.buildInputs ++ [
    rocksdb
    postgresql # libpq

    move-cli-address32 # move-analyzer
  ];
}
