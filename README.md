# Plasma Media Center

A Plasma 6 media-center interface designed for a 10-foot UI, remote/controller navigation, and easy NixOS installation.

## Current prototype

The first prototype provides:

- A Plasma 6 plasmoid package
- TV-friendly home screen
- Large focusable media cards
- Explicit keyboard / D-pad focus navigation
- Browse and quick-launch sections
- Now-playing placeholder ready for MPRIS integration
- First-class Nix package
- Reusable Nix overlay
- Flake package outputs
- GitHub Actions Nix build checks

Plasmoid ID:

```
info.soltros.plasma-mediacenter
```

## Add it to another Nix flake

Add the input:

```nix
inputs.plasma-mediacenter.url = "github:soltros/plasma-mediacenter";
```

Then add its overlay when constructing `pkgs`:

```nix
pkgs = import nixpkgs {
  inherit system;
  overlays = [
    plasma-mediacenter.overlays.default
  ];
};
```

The package is then available as:

```nix
pkgs.plasma-mediacenter
```

For NixOS:

```nix
environment.systemPackages = [
  pkgs.plasma-mediacenter
];
```

A complete minimal example:

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    plasma-mediacenter.url = "github:soltros/plasma-mediacenter";
  };

  outputs = { nixpkgs, plasma-mediacenter, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          plasma-mediacenter.overlays.default
        ];
      };
    in {
      nixosConfigurations.media-center = nixpkgs.lib.nixosSystem {
        inherit system;

        modules = [
          {
            nixpkgs.pkgs = pkgs;

            environment.systemPackages = [
              pkgs.plasma-mediacenter
            ];
          }
        ];
      };
    };
}
```

The flake also exposes the package directly:

```nix
plasma-mediacenter.packages.x86_64-linux.default
plasma-mediacenter.packages.x86_64-linux.plasma-mediacenter
```

## Manual test

After installation, add **Plasma Media Center** through Plasma's widget picker.

For development, Plasma's standalone widget runner can also be used:

```bash
plasmawindowed info.soltros.plasma-mediacenter
```

## Roadmap

The immediate next steps are:

1. Real application launching
2. MPRIS now-playing integration
3. Configurable home rows and applications
4. Jellyfin provider
5. Supraviolet provider
6. Game/controller input polishing
7. Media Mode / Desktop Mode switching
8. Dedicated media-center containment/session behavior

## License

MIT
