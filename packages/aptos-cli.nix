{ pkgs, cargo-hakari }:

with pkgs;
rustPlatform.buildRustPackage rec {
  pname = "aptos";
  version = "0.1.4";

  src = fetchCrate {
    pname = "aptos";
    inherit version;
    sha256 = "sha256-1pjdYp2AOVyhkNwcK2E4j8NAYAbnTjNwVlgs/BXoItY=";
  };

  cargoSha256 = "sha256-mBQInRm6T4A/d9jcz8khjb7rvstUqKcIVQLL8+vNIhY=";
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
