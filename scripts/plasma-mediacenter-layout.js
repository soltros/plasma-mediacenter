// Plasma Shell scripting helper for Plasma Media Center.
//
// Run this only after switching the desktop containment to:
//   info.soltros.plasma-mediacenter.containment
//
// It makes sure the containment has the two core applets that compose the
// panel-less media-center experience.

const desktops = desktopsForActivity(currentActivity());

for (let i = 0; i < desktops.length; ++i) {
    const desktop = desktops[i];

    let hasHome = false;
    let hasTray = false;

    for (const widget of desktop.widgets()) {
        if (widget.type === "info.soltros.plasma-mediacenter") {
            hasHome = true;
        } else if (widget.type === "org.kde.plasma.systemtray") {
            hasTray = true;
        }
    }

    if (!hasHome) {
        desktop.addWidget("info.soltros.plasma-mediacenter");
    }

    if (!hasTray) {
        desktop.addWidget("org.kde.plasma.systemtray");
    }
}
