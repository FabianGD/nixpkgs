{ stdenv, lib, fetchurl, dpkg, atk, glib, pango, gdk-pixbuf, gnome2, gtk3, cairo
, freetype, fontconfig, dbus, libXi, libXcursor, libXdamage, libXrandr, libxshmfence
, libXcomposite, libXext, libXfixes, libXrender, libX11, libXtst, libXScrnSaver
, libxcb, libdrm, libxkbcommon, mesa, nss, nspr, alsa-lib, cups, expat, udev, libpulseaudio
, at-spi2-core, at-spi2-atk }:

let
  libPath = lib.makeLibraryPath [
    stdenv.cc.cc gtk3 gnome2.GConf atk glib pango gdk-pixbuf cairo freetype fontconfig dbus
    libXi libXcursor libXdamage libXrandr libXcomposite libXext libXfixes libxcb libxshmfence
    libXrender libX11 libXtst libXScrnSaver nss nspr alsa-lib cups expat udev libpulseaudio
    at-spi2-core at-spi2-atk libdrm libxkbcommon mesa
  ];
in
stdenv.mkDerivation rec {
  version = "3.1.0-canary.6";
  pname = "hyper";
  src = fetchurl {
    url = "https://github.com/vercel/hyper/releases/download/v${version}/hyper_${version}_amd64.deb";
    sha256 = "qoxmmU8DOQHN7+XFM4VnLSZNIMCpLqghCZtIMt4f43Y=";
  };
  buildInputs = [ dpkg ];
  unpackPhase = ''
    mkdir pkg
    dpkg-deb -x $src pkg
    sourceRoot=pkg
  '';
  installPhase = ''
    mkdir -p "$out/bin"
    mv opt "$out/"
    ln -s "$out/opt/Hyper/hyper" "$out/bin/hyper"
    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" --set-rpath "${libPath}:$out/opt/Hyper:\$ORIGIN" "$out/opt/Hyper/hyper"
    mv usr/* "$out/"
  '';
  dontPatchELF = true;
  meta = with lib; {
    description = "A terminal built on web technologies";
    homepage    = "https://hyper.is/";
    maintainers = with maintainers; [ puffnfresh ];
    license     = licenses.mit;
    platforms   = [ "x86_64-linux" ];
  };
}
