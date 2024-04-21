{ lib,
  pkgs,
}:

pkgs.writeShellScriptBin "cut_video" ''
  INPUT="$1"
  START="$2"
  DURATION="$3"

  OUTPUT="''${INPUT%.*}.cut.''${INPUT##*.}"

  ${pkgs.ffmpeg}/bin/ffmpeg \
    -i "$INPUT" \
    -ss "$START" \
    -t "$DURATION" \
    -movflags use_metadata_tags \
    -c copy \
    -map_metadata 0 \
    -map_metadata:s:v 0:s:v \
    -map_metadata:s:a 0:s:a \
    "$OUTPUT"
''
