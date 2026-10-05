# Media-center containment

Plasma Media Center now ships two Plasma packages:

- `info.soltros.plasma-mediacenter` — the reusable home-screen plasmoid
- `info.soltros.plasma-mediacenter.containment` — a desktop containment intended to replace the normal desktop/panel arrangement on a media-center session

The containment follows Plasma's native containment model. Existing applets are real Plasma applets; they are only rearranged for television use.

## Placement policy

- **Plasma Media Center** fills the desktop.
- **System Tray** is hosted in a dedicated top-right surface.
- Other applets added to the containment are placed into a quick-controls area in the lower-right.

This allows network, Bluetooth, audio, notifications, removable devices, and other tray functionality to remain owned by Plasma.

## Initial setup

The repository includes `scripts/plasma-mediacenter-layout.js`, a Plasma Shell script that ensures the Media Center and System Tray applets exist on the selected containment.

The containment is intentionally opt-in while it is being tested. It does not replace a user's existing desktop containment automatically.
