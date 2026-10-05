# Architecture

## Core rule

Plasma Media Center should **compose existing KDE Plasma and KDE Frameworks capabilities before implementing new ones**.

The project is not intended to become a parallel desktop shell or a replacement widget toolkit. Its own code should primarily provide:

- 10-foot layout and presentation
- remote/controller focus policy
- media-center-specific composition
- configuration
- glue between existing Plasma facilities
- provider adapters where no reusable Plasma interface exists

## Preferred building blocks

Use existing platform components wherever possible:

- **Plasma Components 3** for buttons, labels, menus, controls, and Plasma-native styling
- **Kirigami** for icons, typography, sizing, cards, pages, and adaptive layout primitives
- **KRunner / application launcher infrastructure** for discovering and launching applications
- **MPRIS / Plasma media-controller infrastructure** for now-playing state and transport controls
- **Plasma system tray/status infrastructure** for volume, network, Bluetooth, battery, notifications, and similar status surfaces
- **KDE icon themes** via icon names, allowing Breeze, Papirus, and other user-selected themes to work automatically
- existing Plasma data/models/services instead of duplicating their state

## When custom components are acceptable

Small wrapper components are acceptable when they only combine existing controls into a media-center-specific presentation.

Examples:

- a large TV-style launcher card composed from `PC3.Button`, `Kirigami.Icon`, and `PC3.Label`
- a horizontal media row that consumes an existing model
- a focus-navigation helper for D-pad/remote movement

Avoid reimplementing:

- generic buttons
- generic card chrome
- icon loading
- application discovery
- media transport controls
- volume/network/Bluetooth controls
- notifications
- power/session actions

unless the KDE-provided facility cannot satisfy a required TV interaction.

## Icon policy

1. Prefer a standard icon-theme name.
2. Respect the user's active icon theme automatically.
3. Permit a custom PNG/SVG as an explicit override.
4. Never make Papirus, Breeze, or another specific icon theme a hard dependency solely for artwork.

## Long-term direction

The media-center home should become a composition layer that can host or surface existing Plasma functionality in a TV-friendly layout. New functionality should be introduced only where Plasma does not already expose a suitable framework, model, or plasmoid.
