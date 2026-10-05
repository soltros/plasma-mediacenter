{
  description = "Plasma Media Center - a 10-foot media UI for KDE Plasma 6";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    in {
      overlays.default = import ./nix/overlay.nix;

      packages = forAllSystems (system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ self.overlays.default ];
          };
        in {
          default = pkgs.plasma-mediacenter;
          plasma-mediacenter = pkgs.plasma-mediacenter;
        });

      checks = forAllSystems (system: {
        package = self.packages.${system}.plasma-mediacenter;
      });
    };
}
