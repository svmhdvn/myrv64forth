#!/bin/sh
# David Smith 2022 david.a.c.v.smith@gmail.com
#
# This file has been adapted from David Smith's SmithForth
# (https://dacvs.neocities.org/SF/)

set -eu

I="$1"
O="$2"

compile() {
    cut -d'#' -f1 | xxd -p -r
}

bytes() { # little-endian base sixteen
    wc -c | xargs printf '%08X' | sed 's/\(..\)\(..\)\(..\)\(..\)/\4 \3 \2 \1/'
}

replace() {
    sed "/${1}.*build.sh/ s/^\S\S \S\S \S\S \S\S/${2}/"
}

compile < SForth.dmp > "${O}0"
cat "${O}0" system.fs "${I}" > "${O}"
n="$(bytes < "${O}")"

replace p_filesz "$n" < SForth.dmp | compile > "${O}0"
cat "${O}0" system.fs "${I}" > "${O}"
rm -f "${O}0"
chmod +x "${O}"
