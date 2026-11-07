{
  lib,
  stdenvNoCC,
  requireFile,
  unzip,
}:

let
  archiveName = "PragmataPro-fialk8-6rjkhe.zip";
in
stdenvNoCC.mkDerivation {
  pname = "pragmatapro";
  version = "0.903";

  src = (requireFile {
    name = archiveName;
    hash = "sha256-dwQA6dTz1A/oiTr5rh94T2/60kH8QYkSjE08RhX7dyc=";
    message = ''
      Download your purchased PragmataPro archive from
      https://fsd.it/shop/fonts/pragmatapro/
      Keep it outside the dotfiles repository, then import it with:

        nix-store --add-fixed sha256 /path/to/${archiveName}

      The archive must match the filename and hash pinned in the configuration.
    '';
  }).overrideAttrs {
    allowSubstitutes = false;
  };

  nativeBuildInputs = [ unzip ];
  # Releases may include multiple top-level directories, including __MACOSX.
  sourceRoot = ".";
  dontConfigure = true;
  dontBuild = true;
  preferLocalBuild = true;
  allowSubstitutes = false;

  installPhase = ''
    runHook preInstall

    # Install TrueType faces only, avoiding duplicate OpenType versions and
    # macOS resource-fork files. Preserve paths to avoid filename collisions.
    mkdir -p "$out/share/fonts/truetype"
    find . -type f -iname '*.ttf' \
      ! -path '*/__MACOSX/*' ! -name '._*' -print0 |
      while IFS= read -r -d "" font; do
        install -Dm644 "$font" "$out/share/fonts/truetype/''${font#./}"
      done

    if ! find "$out/share/fonts/truetype" -type f -iname '*.ttf' -print -quit | grep -q .; then
      echo "No TrueType fonts found in the PragmataPro archive" >&2
      exit 1
    fi

    runHook postInstall
  '';

  meta = {
    description = "PragmataPro programming font (requires a purchased archive)";
    homepage = "https://fsd.it/shop/fonts/pragmatapro/";
    license = lib.licenses.unfree;
    platforms = lib.platforms.all;
  };
}
