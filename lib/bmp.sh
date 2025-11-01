#!/bin/bash

u_32le() {
  local n=$1 out

  # convert number into 4 octets
  # ex: input = 0x12345678
  # octet1: 0x12
  # octet2: 0x34
  # octet3: 0x56
  # octet4: 0x78

  local octet1=$(( (n >> 24) & 0xFF ))
  local octet2=$(( (n >> 16) & 0xFF ))
  local octet3=$(( (n >> 8) & 0xFF ))
  local octet4=$(( (n >> 0) & 0xFF ))

  printf -v out '\\x%02x\\x%02x\\x%02x\\x%02x' $octet4 $octet3 $octet2 $octet1
  printf '%b' "$out"

}

u_16le() {
  local n=$1 out

  # convert number into 2 octets
  # ex: input = 0x1234
  # octet1: 0x12
  # octet2: 0x34

  local octet1=$(( (n >> 8) & 0xFF ))
  local octet2=$(( (n >> 0) & 0xFF ))

  printf -v out '\\x%02x\\x%02x' $octet2 $octet1
  printf '%b' "$out"

}

# for 24 bits one - colors
rgb() {
  local r=$1
  local g=$2
  local b=$3
  local out

  printf -v out '\\x%02x\\x%02x\\x%02x' $b $g $r
  printf '%b' "$out"

}

bmp_header() {
  local width=$1
  local height=$2

  local bit_per_px=24
  local bytes_per_px=$((bit_per_px / 8))

  local row_size=$((width * bytes_per_px))
  # align to a four byte boundary ( means that the row size should be a multiple of four , we have to pad it elsewise )
  local padding=0
  # so
  while((row_size % 4)); do
    ((padding++))
    ((row_size++))
  done

  local px_data_size=$((row_size * height))
  local px_data_offset=$((14 + 40))

  # size of entire file
  local file_size=$((px_data_offset + px_data_size))

  # to create a bitmap file ------------------------------------------------------------------->>>>>>

  # Header ( 14 bytes )
  ## Signature
  printf 'BM'

  ## file size
  # can't quite do echo "$file_size" , needto convert to little endian form"
  u_32le "$file_size"

  ## Reserved (=0)
  u_32le 0

  ## DataOffset
  u_32le "$px_data_offset"

  # Info header ( 14 bytes )
  ## Size
  u_32le 40

  ## Width
  u_32le "$width"

  ## Height
  u_32le "$height"

  ## Planes (=1)
  u_16le 1 # it was 2 bytes so

  ## BitCount
  u_16le "$bit_per_px"

  ## Compression
  u_32le 0

  ## ImageSize
  u_32le 0

  ## XPixelsPerM
  u_32le 0

  ## YPixelsPerM
  u_32le 0

  ## Colors Used
  u_32le 0

  ## Colors Imp
  u_32le 0

  REPLY=$padding # sort of a global variable to have padding

}

bmp_pad() {
  local padding=$1
  for ((i = 0; i < padding; i++)); do
    printf '\0'
  done
}