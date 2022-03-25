{ stdenv
, lib
, fetchurl
, autoPatchelfHook
, zlib
, glibc
}:

stdenv.mkDerivation rec {
  name = "soteria-${version}";

  version = "develop";

  src = fetchTarball {
    url = "https://github.com/saber-hq/soteria-mirror/raw/aafe9490cfc40f5f7225eddccc68dfc0ba8d34d5/soteria-linux-develop.tar.gz";
    sha256 = "sha256:15y2646j8ywxqym51h1nk7473874lpisnwj8qfgsv5bjbancdlqn";
  };

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  buildInputs = [
    zlib
    stdenv.cc.cc.lib
    glibc
  ];

  installPhase = ''
    cp -R $src/ $out
  '';

  meta = with lib; {
    homepage = "https://soteria.dev";
    description = "Auditing tools for Solana programs.";
    platforms = platforms.linux;
  };
}
