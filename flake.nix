{
  description = "Flake for prisma package versions missing in nixpkgs";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = inputs@{ flake-parts, ... }:
    let
      prismaVersion = "5.16.2";
      engineHash = "sha256-EOYbWUgoc/9uUtuocfWDh0elExzL0+wb4PsihgMbsWs=";
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin" ];
      perSystem = { config, self', inputs', pkgs, system, ... }: {
        packages."prisma-engines" = pkgs.callPackage ./prisma-engines.nix { inherit prismaVersion engineHash; };
      };
    };
}
