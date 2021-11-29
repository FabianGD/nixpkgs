{ lib, stdenv
, python
, buildPythonPackage
, fetchFromGitHub
, pytest
}:

buildPythonPackage rec {
  pname = "pyobjc";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "ronaldoussoren";
    repo = pname;
    rev = version;
    sha256 = "HZeN/kpisPRrVwg1xGGUjxspztZKRbacGY5gpa537c00";
  };

  preInstall = ''
    cd pyobjc-framework-Cocoa
  '';

  # doCheck = !stdenv.isDarwin;
  # checkPhase = "HOME=$TMPDIR pytest";
  checkInputs = [ pytest ];

  meta = with lib; {
    description = "The Python <-> Objective-C Bridge with bindings for macOS frameworks";
    homepage = "https://github.com/ronaldoussoren/pyobjc";
    license = licenses.bsd3;
  };
}
