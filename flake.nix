{
  description = "Flake for prisma package versions missing in nixpkgs";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = inputs@{ flake-parts, ... }:
    let
      prismaEngineHashes = {
        "5.7.1" = "sha256-EOYbWUgoc/9uUtuocfWDh0elExzL0+wb4PsihgMbsWs=";
        "5.16.2" = "sha256-uJJX5lI0YFXygWLeaOuYxjgyswJcjSujPcqHn1aKn8M=";
      };
      toUnderscored = version: builtins.replaceStrings [ "." ] [ "_" ] version;
      lib = inputs.nixpkgs.lib;
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin" ];
      perSystem = { config, self', inputs', pkgs, system, ... }: {
        packages = builtins.listToAttrs (lib.attrsets.attrValues (builtins.mapAttrs
          (prismaVersion: engineHash:
            {
              name = "prisma-engines-${toUnderscored prismaVersion}";
              value = pkgs.callPackage ./prisma-engines.nix {
                inherit prismaVersion engineHash;
              };
            })
          prismaEngineHashes));
      };
    };
}