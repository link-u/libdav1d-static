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

cd "${SCRIPTS_DIR}/generated"
mkdir -p iphone simulator

lipo -create -output iphone/libdav1d.a -arch armv7 armv7-iphoneos.a -arch armv7s armv7s-iphoneos.a -arch arm64 arm64-iphoneos.a
lipo -create -output simulator/libdav1d.a -arch arm64 arm64-iphone-simulator.a -arch x86_64 x86_64-iphone-simulator.a -arch i386 i386-iphone-simulator.a

## ライブラリをビルド
cd "${SCRIPTS_DIR}"
rm -rf artifacts
mkdir -p artifacts
xcodebuild -create-xcframework -library generated/iphone/libdav1d.a -headers "headers" -library generated/simulator/libdav1d.a -headers "headers" -output artifacts/libdav1d.xcframework

## zip で固める
cd artifacts
zip libdav1d.xcframework.zip -r libdav1d.xcframework

## sha256sum を作る
sha256sum libdav1d.xcframework.zip > libdav1d.xcframework.zip.sha256sum
