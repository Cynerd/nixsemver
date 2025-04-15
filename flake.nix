{
  description = "Nix Semantic Versioning library";

  inputs.flake-tests.url = "github:antifuchs/nix-flake-tests";

  outputs = {
    self,
    nixpkgs,
    flake-tests,
  }: let
    inherit (nixpkgs.lib) genAttrs systems composeManyExtensions;

    withPkgs = func:
      genAttrs systems.flakeExposed (system:
        func nixpkgs.legacyPackages.${system});
    fullLib = nixpkgs.lib.extend self.overlays.lib;
  in {
    overlays.lib = composeManyExtensions [
      (import ./version.nix)
      (import ./changelog.nix)
    ];
    lib = self.overlays.lib fullLib nixpkgs.lib;

    checks = withPkgs (pkgs:
      import ./tests (v:
        flake-tests.lib.check {
          inherit pkgs;
          tests = v;
        })
      fullLib);

    formatter = withPkgs (pkgs: pkgs.alejandra);
  };
}
