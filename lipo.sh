#!/bin/sh

#  build.sh
#  libdav1d
#
#  Created by murakami on 2021/05/14.
#  

cd generated
lipo -create -output libdav1d-iphone.a -arch armv7 armv7-iphoneos.a -arch armv7s armv7s-iphoneos.a -arch arm64 arm64-iphoneos.a
lipo -create -output libdav1d-simulator.a -arch arm64 arm64-iphone-simulator.a -arch x86_64 x86_64-iphone-simulator.a
cd ../
xcodebuild -create-xcframework -library generated/libdav1d-iphone.a -headers "headers" -library generated/libdav1d-simulator.a -headers "headers" -output libdav1d.xcframework
