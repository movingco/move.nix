{ callPackage, fetchFromGitHub }:

let
  buildAptos = callPackage ./aptos.nix { };
  buildAptosDevnet =
    { pname
    , cargoSha256
    , buildAndTestSubdir ? null
    , cargoBuildFlags ? [ ]
    }:
    buildAptos rec {
      inherit pname;
      # https://github.com/aptos-labs/aptos-core/tree/devnet
      version = "6b41e0e01cd8bf57c0497c69af4f5ea083aa16c3";

      src = fetchFromGitHub {
        owner = "aptos-labs";
        repo = "aptos-core";
        rev = version;
        sha256 = "sha256-h1WQNHIWobe+Sn1X4TMmj2vpUkrJYL9ZVlBPcdiaW1s=";
      };

      inherit cargoSha256 buildAndTestSubdir cargoBuildFlags;
    };
in
{
  cli = buildAptosDevnet {
    pname = "aptos-cli";
    cargoSha256 = "sha256-l/Y5q0bpUMu1Wf9TUPea5lm4CSQYEnBNpKfeC8v6DKU=";
    buildAndTestSubdir = "crates/aptos";
    cargoBuildFlags = [ "--package" "aptos" ];
  };

  full = buildAptosDevnet {
    pname = "aptos";
    cargoSha256 = "sha256-zd/e6s3IvwU84FIfuCGCGiZQQT1mi+PYrnLfJFMnnF4=";
  };
}
