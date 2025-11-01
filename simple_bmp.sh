#!/bin/bash

# emits a simple bmp file to stdout

. ./lib/bmp.sh || exit

main() {
  local width=2
  local height=2

  bmp_header "$width" "$height"

  local padding=$REPLY

  ## Colors data goes here

  ### bottom row
  rgb 0 0 0
  rgb 255 255 255
  bmp_pad "$padding"

  ### top row
  rgb 255 0 0
  rgb 0 255 255
  bmp_pad "$padding"

}

main "$@"




