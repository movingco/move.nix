{ pkgs }:

with pkgs;
rustPlatform.buildRustPackage rec {
  pname = "aptos-cli";
  version = "49f08c7419b442461e47164848305fe74e846607";

  src = fetchFromGitHub {
    owner = "aptos-labs";
    repo = "aptos-core";
    rev = version;
    sha256 = "sha256-eNn488nw/l/1NCickCXzDzvahFOv58mB8iREpNlCweg=";
  };

  cargoSha256 = lib.fakeHash;

  cargoBuildFlags = [ "--bin=aptos" ];

  nativeBuildInputs = [ openssl libclang ];

  LIBCLANG_PATH = "${libclang.lib}/lib";
}
