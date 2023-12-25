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
## 生成されるディレクトリ名 (8bit用)
GENERATED_DIR="${SCRIPTS_DIR}/generated/8bit"
ARTIFACTS_DIR="${SCRIPTS_DIR}/artifacts/8bit"

cd "${GENERATED_DIR}"
mkdir -p iphone simulator

lipo -create -output iphone/libdav1d.a \
    -arch armv7 armv7-iphoneos.a \
    -arch armv7s armv7s-iphoneos.a \
    -arch arm64 arm64-iphoneos.a
lipo -create -output simulator/libdav1d.a \
    -arch arm64 arm64-iphone-simulator.a \
    -arch x86_64 x86_64-iphone-simulator.a \
    -arch i386 i386-iphone-simulator.a

## ライブラリをビルド
cd "${SCRIPTS_DIR}"
rm -rf "${ARTIFACTS_DIR}"
mkdir -p "${ARTIFACTS_DIR}"
xcodebuild -create-xcframework \
    -library "${GENERATED_DIR}/iphone/libdav1d.a" -headers "${GENERATED_DIR}/headers" \
    -library "${GENERATED_DIR}/simulator/libdav1d.a" -headers "${GENERATED_DIR}/headers" \
    -output "${ARTIFACTS_DIR}/libdav1d.xcframework"

## 新しい8bit版に差し替える
rm -rf "${SCRIPTS_DIR}/8bit"
cp -r "${ARTIFACTS_DIR}" "8bit"

## zip で固める
cd "${ARTIFACTS_DIR}"
zip libdav1d.xcframework.zip -r libdav1d.xcframework

## checksum を出力する
swift package compute-checksum libdav1d.xcframework.zip  > libdav1d.xcframework.zip.checksum
