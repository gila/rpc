{
  description = "Shared gRPC bits for mayastor";

  inputs = {
    flake-utils = {
      url = "github:numtide/flake-utils";
    };
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    };
    naersk = {
      url = "github:nmattia/naersk";
    };

  };

  outputs = { self, flake-utils, nixpkgs, naersk, ... }:
    # helper to create a "for each arch"
    flake-utils.lib.eachDefaultSystem (system:
      let
        cargoToml = (builtins.fromTOML (builtins.readFile ./Cargo.toml));
        pkgs = import nixpkgs { inherit system; overlays = [ ]; };
        naersk-lib = naersk.lib."${system}";

        common = rec {
          LIBCLANG_PATH = "${pkgs.llvmPackages.libclang.lib}/lib";
          PROTOC = "${pkgs.protobuf}/bin/protoc";
          PROTOC_INCLUDE = "${pkgs.protobuf}/include";

          buildInputs = with pkgs; [
            openssl
            pkg-config
            protobuf
          ];
        };
      in
      rec
      {
        devShell = pkgs.mkShell (common // {
          nativeBuildInputs = with pkgs; [ rustc cargo openssl pkg-config protobuf ];
        });

      });
}
