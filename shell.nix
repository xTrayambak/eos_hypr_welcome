with import <nixpkgs> { };

mkShell {
  nativeBuildInputs = [
    gtk4.dev
    libadwaita.dev
    pkg-config
  ];

  LD_LIBRARY_PATH = lib.makeLibraryPath [
    libGL
    xorg.libXext.dev
    xorg.libX11.dev
  ];
}
