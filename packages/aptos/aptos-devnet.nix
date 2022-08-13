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
      version = "3910637893b6aed4af73b19a2c429ef717e1ee26";

      src = fetchFromGitHub {
        owner = "aptos-labs";
        repo = "aptos-core";
        rev = version;
        sha256 = "sha256-YbrbQPduhVQJdw2N57AKGW+uS1ZLmqJXzzS9e8ZCAc8=";
      };

      inherit cargoSha256 buildAndTestSubdir cargoBuildFlags;
    };
in
{
  cli = buildAptosDevnet {
    pname = "aptos-cli";
    cargoSha256 = "sha256-UW/qdLYYKE5xHnf7Yo4dUsCTFQjlQT5XVjWypkTUZ+g=";
    buildAndTestSubdir = "crates/aptos";
    cargoBuildFlags = [ "--package" "aptos" ];
  };

  full = buildAptosDevnet {
    pname = "aptos";
    cargoSha256 = "sha256-k3cjbql8QheK8MRYIvUlnuLsYvkVwNuz/sbSgFUvH1o=";
  };
}
