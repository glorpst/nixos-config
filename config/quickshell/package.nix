{ lib
, symlinkJoin
, makeWrapper
, quickshell
, kdePackages
, configPath ? /.
}:

let
  # Create the full-featured derivation
  fullQuickshell = quickshell.override {
    enableExtras = true;
  };

  qmlPath = lib.makeSearchPath "lib/qt-6/qml" [
    kdePackages.qtbase
    kdePackages.qtdeclarative
    kdePackages.qt5compat
    kdePackages.qtquickcontrols2
  ];

in symlinkJoin {
  pname = "retroism";
  inherit (fullQuickshell) version;

  paths = [ fullQuickshell ];
  nativeBuildInputs = [ makeWrapper ];

  postBuild = ''
    makeWrapper ${fullQuickshell}/bin/quickshell $out/bin/retroism \
      --set QML2_IMPORT_PATH "${qmlPath}" \
      --add-flags '-p ${configPath}'
  '';

  meta.mainProgram = "retroism";
}
