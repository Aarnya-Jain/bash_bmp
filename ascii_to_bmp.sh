#!/bin/bash

# emits a ascii to bmp file to stdout

. ./lib/bmp.sh || exit

debug() {
  echo '[debug]' "$@" >&2
}

make_bmp() {

  local SPRITE
  mapfile -t SPRITE
  local width=${#SPRITE[0]}
  local height=${#SPRITE[@]}

  bmp_header "$width" "$height"

    local padding=$REPLY

    ## Colors data goes here

    local r g b x y

    for ((y = 0; y < height; y++)); do
      for ((x = 0; x < width; x++)); do

          local c=${SPRITE[height - y - 1]} # to get the inverted line coz we doin that from the start
          c=${c:x:1}

          case "$c" in
          ' ')    r=0; g=0; b=0;;       # space (black)
          '\t')  r=0; g=0; b=0;;       # tab (black)
          '/')    r=255; g=0; b=0;;     # red
          '_')    r=0; g=0; b=255;;     # blue
          '\')   r=255; g=0; b=0;;     # red
          '|' )   r=0; g=0; b=255;;     # blue
          '^' )   r=0; g=255; b=0;;     # green
          $'\r')  r=0; g=0; b=0;;       # ignore CR az black
          *)
            printf '[debug] unknown char %q at x=%d y=%d (treating as black)\n' "$c" "$x" "$y" >&2
            r=0; g=0; b=0;;
        esac

          rgb "$r" "$g" "$b"
      done
      debug "handled row $((y+1)) / $height"
      bmp_pad "$padding"
    done

}


main() {
  local output=out.bmp

  local OPTIND OPTARG opt
  while getopts 'o:' opt; do
    case "$opt" in
      o) output=$OPTARG;;
    esac
  done

  make_bmp > "$output" || exit
  echo "generated image : "$output" "
}

main "$@"




