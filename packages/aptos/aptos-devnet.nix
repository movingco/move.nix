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
      # https://github.com/movingco/aptos-core/tree/devnet-nix-2022-08-08
      version = "a78c14adf6661723469c430b50df40380d6d66bd";

      src = fetchFromGitHub {
        owner = "movingco";
        repo = "aptos-core";
        rev = version;
        sha256 = "sha256-bYnlzry9wH6wAdBFEdqfUgrP6CzyhV71v/lP1ETexIU=";
      };

      inherit cargoSha256 buildAndTestSubdir cargoBuildFlags;
    };
in
{
  cli = buildAptosDevnet {
    pname = "aptos-cli";
    cargoSha256 = "sha256-jnMrtl2Nl4fvAdF7BffW3fspOsgQptNi7K08u0VT+/8=";
    buildAndTestSubdir = "crates/aptos";
    cargoBuildFlags = [ "--package" "aptos" ];
  };

  full = buildAptosDevnet {
    pname = "aptos";
    cargoSha256 = "sha256-1xjx55CcW88wFdevgnJF4y1wnspu9O3ihrOGRWihNl8=";
  };
}
