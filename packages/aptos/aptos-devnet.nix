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
      version = "509f09e7868a12d031bd7caef62185aa4deebbf0";

      src = fetchFromGitHub {
        owner = "aptos-labs";
        repo = "aptos-core";
        rev = version;
        sha256 = "sha256-McJONUmMtTqNFscSirzSrG6x+YJwHawuUvLiz3xkteQ=";
      };

      inherit cargoSha256 buildAndTestSubdir cargoBuildFlags;
    };
in
{
  cli = buildAptosDevnet {
    pname = "aptos-cli";
    cargoSha256 = "sha256-o73Zph1nJ4qSyY4aTyfleAUKSHsyxUV6X2ye0YuPoe8=";
    buildAndTestSubdir = "crates/aptos";
    cargoBuildFlags = [ "--package" "aptos" ];
  };

  full = buildAptosDevnet {
    pname = "aptos";
    cargoSha256 = "sha256-isW5fmENLwRvis44/awcOJRw45dW5R3eUhzRz9Oox8k=";
  };
}
