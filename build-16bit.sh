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
cd "${SCRIPTS_DIR}/dav1d"

## meson ファイル一覧を取得する
MESON_FILES=$(for MESON in $(find ../build/crossfiles/ -name \*iphoneos\* -or -name \*simulator\*); do basename $MESON; done;)
echo $MESON_FILES


## 生成されるディレクトリ名 (16bit用)
GENERATED_DIR="${SCRIPTS_DIR}/generated/16bit"

## generated ディレクトリを作りなおす
rm -rf "${GENERATED_DIR}"
mkdir -p "${GENERATED_DIR}"

## ビルドする
for MESON in $MESON_FILES; do
  cd "${SCRIPTS_DIR}/dav1d"
  ## ビルドディレクトリを作りなおす
  rm -rf "build-${MESON}"
  mkdir -p "build-${MESON}"

  ## ビルドする
  echo --cross-file=package/crossfiles/${MESON}
  meson setup --wipe "build-${MESON}" \
      --cross-file="package/crossfiles/${MESON}" \
      --cross-file="package/crossfiles/constants.meson" \
      --default-library=static
  cd "${SCRIPTS_DIR}/dav1d/build-${MESON}"
  meson configure -Dbitdepths=16 -Denable_asm=true -Denable_avx512=true -Db_bitcode=true
  ninja -v
  cp src/libdav1d.a "${GENERATED_DIR}/${MESON%.meson}.a"
done

## ヘッダファイルをコピーする
mkdir -p "${GENERATED_DIR}/headers/dav1d"
cp "${SCRIPTS_DIR}/dav1d/include/dav1d/"*.h "${GENERATED_DIR}/headers/dav1d/"

## meson で生成された version.h もコピーする
#  ※ version.h に関してはどのビルドでも同じなので、最初のビルドで生成されたものをコピーする
FIRST_MESON="$(echo "${MESON_FILES}" | head -n 1)"
cp "${SCRIPTS_DIR}/dav1d/build-${FIRST_MESON}/include/dav1d/version.h" "${GENERATED_DIR}/headers/dav1d/"

## dav1d サブモジュールの changed ファイルをリセットする
cd "${SCRIPTS_DIR}/dav1d"
git checkout -- .
git clean -f
