#!/bin/sh

#  build.sh
#  libdav1d
#
#  Created by murakami on 2021/05/14.
#  

cd generated
mkdir iphone
mkdir simulator

lipo -create -output iphone/libdav1d.a -arch armv7 armv7-iphoneos.a -arch armv7s armv7s-iphoneos.a -arch arm64 arm64-iphoneos.a
lipo -create -output simulator/libdav1d.a -arch arm64 arm64-iphone-simulator.a -arch x86_64 x86_64-iphone-simulator.a
cd ../
xcodebuild -create-xcframework -library generated/iphone/libdav1d.a -headers "headers" -library generated/simulator/libdav1d.a -headers "headers" -output libdav1d.xcframework
