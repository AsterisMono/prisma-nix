{
  description = "Flake for prisma package versions missing in nixpkgs";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    pnpm2nix.url = "github:nzbr/pnpm2nix-nzbr";
  };

  outputs = inputs@{ flake-parts, ... }:
    let
      prismaVersion = "5.7.0";
      engineHash = "sha256-gZEz0UtgNwumsZbweAyx3TOVHJshpBigc9pzWN7Gb/A=`";
      nodeLibHash = "sha256-hp9XNIYtlb1Oh0q6bjh/p7Mrq+CwF2JGdevTrgoFHko=";
      dashedPrismaVersion = builtins.replaceStrings ["."] ["_"] prismaVersion;
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin" ];
      perSystem = { config, self', inputs', pkgs, system, ... }: {
        packages."prisma-engines_${dashedPrismaVersion}" = pkgs.callPackage ./prisma-engines.nix { inherit prismaVersion engineHash; };
        packages."prisma_${dashedPrismaVersion}" = pkgs.callPackage ./prisma.nix { inherit prismaVersion nodeLibHash; inherit (inputs.pnpm2nix.packages.${system}) mkPnpmPackage; };
      };
    };
}
