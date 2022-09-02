{ lib
, llvmPackages_12
, protobuf
, rustPlatform
, fetchFromGitHub
, pkg-config
, rustc
, cargo
, rocksdb
, rustfmt
, openssl
, stdenv
, DiskArbitration
, Foundation
, libiconv
, cmake
, symlinkJoin
, wrapWithProver
}:

let
  cargoHashes = {
    sui = "sha256-ojCy0Dtmvul+NiJGHKPs92pSm7fOxtwu2SpQwjl2+FI=";
    sui-gateway = "sha256-oQabtMi7FpVCJJYeTLebL4d4fQjO6qf9Hhgj1vltR90=";
    sui-node = "sha256-WSlMAyoZsIypfdgwDnv2vgqj04m4EgrrqK752GDuwuc=";
    sui-tools = "sha256-jtSOkhHghhnIrrInpGi8n9rWjOB73fjHEBs3lpWbr20=";
  };

  buildSui =
    { pname
    , cargoSha256
    , cargoBuildFlags ? [ ]
    }:
    rustPlatform.buildRustPackage rec {
      inherit pname cargoBuildFlags cargoSha256;
      version = "unstable-2022-09-02";

      src = fetchFromGitHub {
        owner = "movingco";
        repo = "sui";
        # https://github.com/movingco/sui/tree/sui-cargo-vendor
        rev = "27508937e1e84f0292f3075ee8c2f40a6e18ecbc";
        sha256 = "sha256-4LZVgmnWoSaYVdxZ0qWg5Wos9XFhJ8+yBC1/z1bapAg=";
      };

      PKG_CONFIG_PATH = "${lib.getDev openssl}/lib/pkgconfig";
      RUST_SRC_PATH = rustPlatform.rustLibSrc;

      # Needed by the Sui build scripts.
      GIT_REVISION = version;

      # Needed to get openssl-sys to use pkg-config.
      OPENSSL_NO_VENDOR = 1;
      OPENSSL_LIB_DIR = "${lib.getLib openssl}/lib";
      OPENSSL_DIR = "${lib.getDev openssl}";

      # ensure we are using LLVM to compile
      LLVM_CONFIG_PATH = "${llvmPackages_12.llvm}/bin/llvm-config";

      # see https://github.com/NixOS/nixpkgs/issues/52447#issuecomment-852079285
      LIBCLANG_PATH = "${llvmPackages_12.libclang.lib}/lib";
      BINDGEN_EXTRA_CLANG_ARGS = with llvmPackages_12;
        "-isystem ${libclang.lib}/lib/clang/${lib.getVersion clang}/include";

      # Used by build.rs in the rocksdb-sys crate. If we don't set these, it would
      # try to build RocksDB from source.
      ROCKSDB_INCLUDE_DIR = "${rocksdb}/include";
      ROCKSDB_LIB_DIR = "${rocksdb}/lib";

      nativeBuildInputs = [
        pkg-config
        rustc
        cargo
        cmake

        rustfmt
        protobuf

        llvmPackages_12.llvm
        llvmPackages_12.clang
      ];

      buildInputs = [
        rocksdb
        openssl # libssl
      ] ++ (
        lib.optional stdenv.isDarwin [
          libiconv
          DiskArbitration
          Foundation
        ]
      );

      meta = with lib; {
        description = "Sui is a boundless platform to build rich and dynamic on-chain assets from gaming to finance";
        homepage = "https://sui.io";
        license = licenses.asl20;
        maintainers = [ maintainers.macalinao ];
      };
    };
in
rec {
  sui-no-prover = buildSui {
    pname = "sui";
    cargoSha256 = cargoHashes.sui;
    cargoBuildFlags = [
      "--package"
      "sui"
    ];
  };

  sui = wrapWithProver {
    package = sui-no-prover;
    bin = "sui";
  };

  sui-gateway = buildSui {
    pname = "sui-gateway";
    cargoSha256 = cargoHashes.sui-gateway;
    cargoBuildFlags = [
      "--package"
      "sui-gateway"
    ];
  };

  sui-node = buildSui {
    pname = "sui-node";
    cargoSha256 = cargoHashes.sui-node;
    cargoBuildFlags = [
      "--package"
      "sui-node"
    ];
  };

  # This should exclude any crate that already has a dedicated derivation, i.e.
  # one defined above.
  #
  # See: https://github.com/MystenLabs/sui/blob/3b41203/Cargo.toml#L4
  sui-tools = buildSui {
    pname = "sui-tools";
    cargoSha256 = cargoHashes.sui-tools;
    cargoBuildFlags = [
      "--workspace"
      "--exclude"
      "sui"
      "--exclude"
      "sui-gateway"
      "--exclude"
      "sui-node"
    ];
  };

  sui-full = symlinkJoin {
    name = "sui-full";
    paths = [
      sui
      sui-gateway
      sui-node
      sui-tools
    ];
  };
}

