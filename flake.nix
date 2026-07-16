{
  description = "effect-monad: effect systems via graded and parameterised monads";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    type-level-sets = {
      url = "github:dorchard/type-level-sets/546eea7502e63fdfdc505853eb72c45c0aa451b6";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, flake-utils, type-level-sets }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        ghc = pkgs.haskell.compiler.ghc9103;
        hpkgs = pkgs.haskell.packages.ghc9103.override {
          overrides = hself: hsuper: {
            type-level-sets = hself.callCabal2nix "type-level-sets" type-level-sets { };
          };
        };
        effect-monad = hpkgs.callCabal2nix "effect-monad" ./. { };
      in
      {
        packages.default = effect-monad;

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
