{
  description = "Flake for prisma package versions missing in nixpkgs";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = inputs@{ flake-parts, ... }:
    let
      prismaVersion = "5.7.0";
      engineHash = "sha256-gZEz0UtgNwumsZbweAyx3TOVHJshpBigc9pzWN7Gb/A=`";
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin" ];
      perSystem = { config, self', inputs', pkgs, system, ... }: {
        packages."prisma-engines_${builtins.replaceStrings ["."] ["_"] prismaVersion}" = pkgs.callPackage ./prisma-engines.nix { inherit prismaVersion engineHash; };
      };
    };
}
