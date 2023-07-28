{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "fontawesomefree";
  version = "6.4.0";
  format = "wheel";

  # they only provide a wheel
  src = fetchPypi {
    inherit pname version format;
    dist = "py3";
    python = "py3";
    hash = "sha256-4S7a1xts9pk/x8aupjZ+Ex8vJHtkNfrKmbEjKbrNKyc=";
  };

  pythonImportsCheck = [
    "fontawesomefree"
  ];

  meta = with lib; {
    homepage = "https://github.com/FortAwesome/Font-Awesome";
    description = "Icon library and toolkit";
    license = with licenses; [ ofl cc-by-40 ];
    maintainers = with maintainers; [ netali ];
  };
}
