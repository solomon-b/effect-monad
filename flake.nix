{
  description = "Development environment for effect-monad";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        ghc = pkgs.haskell.compiler.ghc9103;
      in
      {
        devShells.default = pkgs.mkShell {
          packages = [
            ghc
            pkgs.cabal-install
            pkgs.stack
            pkgs.haskell-language-server
          ];
        };
      });
}
