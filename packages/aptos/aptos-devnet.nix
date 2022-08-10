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
      # https://github.com/movingco/aptos-core/tree/devnet-nix-2022-08-10
      version = "06ea700432e9a14a7c96acaa5619615108eab36e";

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
    cargoSha256 = "sha256-xDyeUjVIPZV0dN3YV57UMV/99yG/XNN5q/jcMTw1qx0=";
    buildAndTestSubdir = "crates/aptos";
    cargoBuildFlags = [ "--package" "aptos" ];
  };

  full = buildAptosDevnet {
    pname = "aptos";
    cargoSha256 = "sha256-1xjx55CcW88wFdevgnJf4y1wnspu9O3ihrOGRWihNl8=";
  };
}
