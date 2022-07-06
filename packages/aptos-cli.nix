{ pkgs, cargo-hakari }:

with pkgs;
rustPlatform.buildRustPackage rec {
  pname = "aptos";
  # devnet
  version = "devnet-for-nix";

  src = fetchFromGitHub {
    owner = "movingco";
    repo = "aptos-core";
    rev = version;
    sha256 = "sha256-i2czGZSZHMi0Ejqeh9X6n8ydpkikgRyOOGNHMEKbtmE=";
  };

  cargoSha256 = "sha256-s2fTCDH/uE10QSZRrCq9iq5LaGypTZHxp49AT7dJwlw=";
  verifyCargoDeps = true;

  # Sets `-j 1`, which is required to avoid a deadlock when building the crate.
  # The `move-package` crate has some sort of lock which breaks the build if this
  # flag is not set.
  # NIX_BUILD_CORES = 1;
  cargoBuildFlags = [ "--bin=aptos" ];

  RUST_BACKTRACE = "full";
  PKG_CONFIG_PATH = "${openssl.dev}/lib/pkgconfig";
  RUST_SRC_PATH = "${rust.packages.stable.rustPlatform.rustLibSrc}";

  # see https://github.com/NixOS/nixpkgs/issues/52447#issuecomment-852079285
  LIBCLANG_PATH = "${libclang.lib}/lib";
  BINDGEN_EXTRA_CLANG_ARGS =
    "-isystem ${libclang.lib}/lib/clang/${lib.getVersion clang}/include";

  doCheck = false;

  nativeBuildInputs = with pkgs; [
    pkg-config
    rustc
    cargo
    clang

    rustfmt
  ];

  # see: https://github.com/aptos-labs/aptos-core/blob/36dfc6499dd576d7d2ba883b66161510ff5cbe6b/.circleci/config.yml#L241
  buildInputs = with pkgs; [
    libclang
    rocksdb
    postgresql # libpq
    openssl # libssl

    cargo-hakari # for workspace hack
  ] ++ (
    lib.optional stdenv.isDarwin ([ libiconv ]
      ++ (with darwin.apple_sdk.frameworks; [ DiskArbitration Foundation ]))
  );
  strictDeps = true;
}
