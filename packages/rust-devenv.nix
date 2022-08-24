{ pkgs }:
with pkgs;
mkShell {
  name = "rust-devenv";
  buildInputs = [
    rustup
    pkg-config
    openssl
    cargo-readme
    cargo-outdated

  ] ++ (
    lib.optional stdenv.isDarwin ([ libiconv ]
      ++ (with darwin.apple_sdk.frameworks; [ DiskArbitration Foundation ]))
  );

  packages = [
    cargo-expand
  ];
}
