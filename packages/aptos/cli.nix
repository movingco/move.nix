import ./aptos-devnet.nix {
  pname = "aptos-cli";
  cargoSha256 = "sha256-lzu9MtgPm0+jd9Q60MwBPOcYvo2jAPTPLz6pAglK0KI=";
  buildAndTestSubdir = "crates/aptos";
}
