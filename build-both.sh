#!/bin/bash

#  build.sh
#  libdav1d
#
#  Created by murakami on 2021/05/14.
#

set -eu
set -o pipefail

## スクリプトの保存されているディレクトリに移動する
SCRIPTS_DIR="$(cd $(dirname "${0}") && pwd)/"
cd "${SCRIPTS_DIR}"

cp build/crossfiles/*.meson dav1d/package/crossfiles/
cd dav1d

files=$(find ../build/crossfiles/ -name \*iphoneos\* -or -name \*simulator\* | sed "s!^.*/!!")
echo $files

## generated ディレクトリを作る
mkdir -p "${SCRIPTS_DIR}/generated"

for f in $files; do
  mkdir -p "build-${f}"
  echo --cross-file=package/crossfiles/${f}
  meson "build-${f}" "--cross-file=package/crossfiles/${f}" "--cross-file=package/crossfiles/constants.meson" --default-library=static
  cd "build-${f}"
  meson configure "-Dbitdepths=['8','16']" -Denable_asm=true -Denable_avx512=true -Db_bitcode=true
  ninja -v
  cp src/libdav1d.a "../../generated/${f%.meson}.a"
  cd ../
done

## dav1d サブモジュールの changed ファイルをリセットする
cd "${SCRIPTS_DIR}/dav1d"
git checkout -- .
git clean -f
