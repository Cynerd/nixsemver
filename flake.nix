{
  description = "Nix Semantic Versioning library";

  inputs.flake-tests.url = "github:antifuchs/nix-flake-tests";

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    flake-tests,
  }: let
    fullLib = nixpkgs.lib.extend self.overlays.lib;
  in
    {
      lib = self.overlays.lib fullLib nixpkgs.lib;
      overlays.lib = final: prev:
        import ./version.nix final prev
        // {
          changelog = import ./changelog.nix final prev;
        };
    }
    // flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      checks = (import ./tests) (v:
        flake-tests.lib.check {
          inherit pkgs;
          tests = v;
        })
      fullLib;
      formatter = pkgs.alejandra;
    });
}
