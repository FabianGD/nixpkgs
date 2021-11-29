{ lib, stdenv
, python
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, Foundation
, libffi
}:

buildPythonPackage rec {
  pname = "pyobjc";
  version = "7.3";

  src = fetchFromGitHub {
    owner = "ronaldoussoren";
    repo = pname;
    rev = "v${version}";
    sha256 = "Y8Su1qNpc9aOnlrklc379JGHsozf3+nJlcwM4s5ZV28=";
  };

  buildInputs = [  ];

  buildInputs = [ Foundation libffi ];

  hardeningDisable = ["strictoverflow"];

  preBuild = ''
    cd pyobjc-core
  '';

  # doCheck = !stdenv.isDarwin;
  # checkPhase = "HOME=$TMPDIR pytest";
  checkInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "The Python <-> Objective-C Bridge with bindings for macOS frameworks";
    homepage = "https://github.com/ronaldoussoren/pyobjc";
    license = licenses.bsd3;
  };
}
