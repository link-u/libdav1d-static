#!/bin/sh

#  build.sh
#  libdav1d
#
#  Created by murakami on 2021/05/14.
#  

mkdir generated
cp build/crossfiles/*.meson dav1d/package/crossfiles/
cd dav1d

find ../build/crossfiles/ -name \*iphoneos\* -or -name \*simulator\*
files=`find ../build/crossfiles/ -name \*iphoneos\* -or -name \*simulator\* | sed "s!^.*/!!"`
echo $files

for f in $files; do
  mkdir "build-${f}"
  echo --cross-file=package/crossfiles/${f}
  meson "build-${f}" "--cross-file=package/crossfiles/${f}" "--cross-file=package/crossfiles/constants.meson" --default-library=static
  cd "build-${f}"
  meson configure -Dbitdepths=8 -Denable_asm=true -Denable_avx512=true -Db_bitcode=true
  ninja -v
  cp src/libdav1d.a "../../generated/${f%.meson}.a"
  cd ../
done
