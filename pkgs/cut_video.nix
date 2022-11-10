{ lib,
  pkgs,
}:

pkgs.writeShellScriptBin "cut_video" ''
  INPUT="$1"
  START="$2"
  DURATION="$3"

  OUTPUT="''${INPUT%.*}.cut.''${INPUT##*.}"

  ${pkgs.ffmpeg}/bin/ffmpeg -i "$INPUT" -ss "$START" -t "$DURATION" -c copy -movflags use_metadata_tags -map_metadata 0 "$OUTPUT"
''
