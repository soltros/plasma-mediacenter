{ lib, stdenvNoCC, qt6 }:

stdenvNoCC.mkDerivation {
  pname = "plasma-mediacenter";
  version = "0.1.0";

  src = lib.cleanSource ../.;

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    plasmoidDir="$out/share/plasma/plasmoids/info.soltros.plasma-mediacenter"
    containmentDir="$out/share/plasma/plasmoids/info.soltros.plasma-mediacenter.containment"

    mkdir -p "$plasmoidDir" "$containmentDir"
    cp -r package/* "$plasmoidDir/"
    cp -r containment/* "$containmentDir/"

    mkdir -p "$out/share/plasma-mediacenter/scripts"
    cp scripts/plasma-mediacenter-layout.js "$out/share/plasma-mediacenter/scripts/"

    mkdir -p "$out/share/applications"
    install -m 0644 assets/info.soltros.supraviolet.desktop "$out/share/applications/info.soltros.supraviolet.desktop"

    mkdir -p "$out/bin"
    install -m 0755 scripts/plasma-mediacenter-setup "$out/bin/plasma-mediacenter-setup"
    substituteInPlace "$out/bin/plasma-mediacenter-setup" \
      --replace-fail "qdbus6" "${qt6.qttools}/bin/qdbus"

    mkdir -p "$out/share/doc/plasma-mediacenter"
    cp ARCHITECTURE.md "$out/share/doc/plasma-mediacenter/"
    cp docs/CONTAINMENT.md "$out/share/doc/plasma-mediacenter/"

    runHook postInstall
  '';

  meta = {
    description = "TV-friendly media center home screen and desktop containment for KDE Plasma 6";
    homepage = "https://github.com/soltros/plasma-mediacenter";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };
}
