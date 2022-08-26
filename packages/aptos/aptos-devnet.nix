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
      version = "e1c6a5713301ed72bf3a846ab9536d002ac801d6";

      src = fetchFromGitHub {
        owner = "aptos-labs";
        repo = "aptos-core";
        rev = version;
        sha256 = "sha256-CFWX1LCsXYo+hVvHx7WtF6BhIf3fYs92Uj+ctqiB+G8=";
      };

      inherit cargoSha256 buildAndTestSubdir cargoBuildFlags;
    };
in
{
  cli = buildAptosDevnet {
    pname = "aptos-cli";
    cargoSha256 = "sha256-o73Zph1nJ4qSyY4aTyaleAUKSHsyxUV6X2ye0YuPoe8=";
    buildAndTestSubdir = "crates/aptos";
    cargoBuildFlags = [ "--package" "aptos" ];
  };

  full = buildAptosDevnet {
    pname = "aptos";
    cargoSha256 = "sha256-isW5fmENLwRvis44/awcOJRw45dW5R3eUhzRz9Oox8k=";
  };
}
