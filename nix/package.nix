{ lib, stdenvNoCC }:

stdenvNoCC.mkDerivation {
  pname = "plasma-mediacenter";
  version = "0.1.0";

  src = lib.cleanSource ../.;

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    plasmoidDir="$out/share/plasma/plasmoids/info.soltros.plasma-mediacenter"
    mkdir -p "$plasmoidDir"
    cp -r package/* "$plasmoidDir/"

    runHook postInstall
  '';

  meta = {
    description = "TV-friendly media center home screen for KDE Plasma 6";
    homepage = "https://github.com/soltros/plasma-mediacenter";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };
}
