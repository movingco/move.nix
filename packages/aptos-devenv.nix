{ pkgs, cargo-hakari }:
with pkgs;
mkShell {
  name = "aptos-devenv";

  # see: https://github.com/aptos-labs/aptos-core/blob/36dfc6499dd576d7d2ba883b66161510ff5cbe6b/.circleci/config.yml#L241
  buildInputs = with pkgs; [
    pkg-config
    postgresql # libpq
    openssl # libssl

    rustup

    cargo-hakari # for workspace hack
  ] ++ (
    lib.optional stdenv.isDarwin ([ libiconv ]
      ++ (with darwin.apple_sdk.frameworks; [ DiskArbitration Foundation ]))
  );
}
