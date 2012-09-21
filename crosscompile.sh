#!/bin/bash

NCPUS=$(grep -i 'processor.*:' /proc/cpuinfo | wc -l)

case "$1" in
	neon)
	TOOLCHAIN=${HOME}/devel/crosscompile/cmake-toolchain-arm-linux-neon.cmake
	PREFIX=${HOME}/devel/crosscompile/cross-root-arm-neon-depth/usr/local
	LIBS_PREFIX=${HOME}/devel/crosscompile/cross-libs-arm-neon/usr/local
	ARCH=armv7l
	;;

	nofp)
	TOOLCHAIN=${HOME}/devel/crosscompile/cmake-toolchain-arm-linux-nofp.cmake
	PREFIX=${HOME}/devel/crosscompile/cross-root-arm-nofp-depth/usr/local
	LIBS_PREFIX=${HOME}/devel/crosscompile/cross-libs-arm-nofp/usr/local
	ARCH=armv5tel
	;;

	*)
	echo "Not gonna work.  You gotta say \"neon\" or \"nofp\"."
	exit
	;;
esac

shift
[ -z "$@" ] || echo "Extra cmake args: " "$@"

printf "\n\n====== Compiling/installing library to crossroot ======\n\n"
# Install libs for device image
rm -rf build-$ARCH
mkdir build-$ARCH
cd build-$ARCH

cmake \
	-D CMAKE_TOOLCHAIN_FILE=${TOOLCHAIN} \
	-D CMAKE_INSTALL_PREFIX=${PREFIX} \
	-D CMAKE_BUILD_TYPE=Release \
	-D LIBUSB_1_INCLUDE_DIR=/home/nitrogen/devel/crosscompile/cross-libs-arm-nofp/usr/include/ \
	-D LIBUSB_1_LIBRARY=/home/nitrogen/devel/crosscompile/cross-libs-arm-nofp/usr/lib/libusb-1.0.so \
	-D BUILD_EXAMPLES=off \
	"$@" \
	..

make -j $NCPUS
make -j $NCPUS install
rm -rf ${PREFIX}/include/*libfreenect*

cd ..

printf "\n\n====== Compiling/installing library+headers to crosslibs ======\n\n"
# Install libs and headers for local compilation
rm -rf build-$ARCH-libs
mkdir build-$ARCH-libs
cd build-$ARCH-libs

cmake \
	-D CMAKE_TOOLCHAIN_FILE=${TOOLCHAIN} \
	-D CMAKE_INSTALL_PREFIX=${LIBS_PREFIX} \
	-D CMAKE_BUILD_TYPE=Release \
	-D LIBUSB_1_INCLUDE_DIR=/home/nitrogen/devel/crosscompile/cross-libs-arm-nofp/usr/include/ \
	-D LIBUSB_1_LIBRARY=/home/nitrogen/devel/crosscompile/cross-libs-arm-nofp/usr/lib/libusb-1.0.so \
	-D BUILD_EXAMPLES=off \
	"$@" \
	..

make -j $NCPUS
make -j $NCPUS install
