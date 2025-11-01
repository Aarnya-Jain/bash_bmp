#!/bin/bash

# emits a gradient bmp file to stdout

. ./lib/bmp.sh || exit

debug() {
  echo '[debug]' "$@" >&2
}

make_bmp() {
  local width=$1
  local height=$2

  bmp_header "$width" "$height"

    local padding=$REPLY

    ## Colors data goes here

    local r g b x y
    b=0

    for ((y = 0; y < height; y++)); do
      for ((x = 0; x < width; x++)); do
          ((r = x * 255 / width))
          ((g = y * 255 / width))
          rgb "$r" "$g" "$b"
      done
      debug "handled row $((y+1)) / $height"
      bmp_pad "$padding"
    done

}

main() {
  local width=400
  local height=400
  local output=out.bmp

  local OPTIND OPTARG opt
  while getopts 'w:h:o:' opt; do
    case "$opt" in
      w) width=$OPTARG;;
      h) height=$OPTARG;;
      o) output=$OPTARG;;
    esac
  done

  make_bmp "$width" "$height" > "$output" || exit
  echo "generated image of "$width"x"$height" : "$output" "
}

main "$@"




