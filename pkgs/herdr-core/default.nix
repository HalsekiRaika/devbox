# herdr-core (hc): the persistent terminal runtime the Herdr desktop app attaches to over SSH.
#
# `src` is the official release tarball (flake input `herdr-core`, flake = false).
# The Linux build is statically linked, so it runs as-is without patchelf.
# A source build fetches libghostty-vt's Zig dependencies during the build,
# which doesn't fit the Nix sandbox, so this uses the release binary.
{
  lib,
  stdenvNoCC,
  src,
  version,
}:

stdenvNoCC.mkDerivation {
  pname = "herdr-core";
  inherit version src;

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    install -Dm755 $src/herdr-core $out/bin/herdr-core
    ln -s herdr-core $out/bin/hc
    install -Dm644 $src/LICENSE $out/share/licenses/herdr-core/LICENSE
    runHook postInstall
  '';

  meta = {
    description = "Terminals and coding agents that keep running after you leave";
    homepage = "https://github.com/herdrdev/herdr-core";
    license = lib.licenses.asl20;
    platforms = [ "x86_64-linux" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    mainProgram = "hc";
  };
}
