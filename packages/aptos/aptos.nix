{ lib
, llvmPackages_12
, rustPlatform
, fetchFromGitHub
, pkg-config
, rustc
, cargo
, rocksdb_6_23
, rustfmt
, postgresql
, openssl
, stdenv
, darwin
, libiconv
}:

{ pname ? "aptos", src, version, cargoSha256, buildAndTestSubdir ? null }:

let
  rocksdb = rocksdb_6_23;
in
with {
  inherit (llvmPackages_12) llvm clang libclang;
};
rustPlatform.buildRustPackage rec {
  inherit pname buildAndTestSubdir src version cargoSha256;
  verifyCargoDeps = true;

  PKG_CONFIG_PATH = "${openssl.dev}/lib/pkgconfig";
  RUST_SRC_PATH = "${rustPlatform.rustLibSrc}";

  # skip tests because they're really slow
  doCheck = false;

  # Needed to get openssl-sys to use pkg-config.
  OPENSSL_NO_VENDOR = 1;
  OPENSSL_LIB_DIR = "${lib.getLib openssl}/lib";
  OPENSSL_DIR = "${lib.getDev openssl}";

  # ensure we are using LLVM to compile
  LLVM_CONFIG_PATH = "${llvm}/bin/llvm-config";

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
    llvm
  ];

  # see: https://github.com/aptos-labs/aptos-core/blob/36dfc6499dd576d7d2ba883b66161510ff5cbe6b/.circleci/config.yml#L241
  buildInputs = [
    rocksdb
    postgresql # libpq
    openssl # libssl
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
