#!/bin/bash
# Cross-compilation script for libfreenect for Nitrogen Logic controllers
# Copyright (C)2012, 2018 Mike Bourgeous
#
# Requires CodeSourcery G++ Lite 4.x for ARM in the home directory
#
# TODO: document build paths, rationale, and interaction with other Nitrogen
# Logic repos

BASEDIR="$(readlink -m "$(dirname "$0")")"
NCPUS=$(grep -i 'processor.*:' /proc/cpuinfo | wc -l)

CROSS_BASE=${HOME}/devel/crosscompile

# TODO: Use nlutils cross-compilation toolchains, once the following errors are figured out:
# /crosscompile/debian-squeeze-root-armel-build/lib/libpthread.so.0: undefined reference to `h_errno@GLIBC_PRIVATE'
# /crosscompile/debian-squeeze-root-armel-build/lib/libpthread.so.0: undefined reference to `__libc_dl_error_tsd@GLIBC_PRIVATE'
# /crosscompile/debian-squeeze-root-armel-build/lib/libpthread.so.0: undefined reference to `__default_sa_restorer_v2@GLIBC_PRIVATE'
# /crosscompile/debian-squeeze-root-armel-build/lib/libpthread.so.0: undefined reference to `__default_rt_sa_restorer_v2@GLIBC_PRIVATE'
#
# Seems related to using system ARM GCC 7 to compile; solution might be to use
# nlutils cross-root scripts

case "$1" in
	neon)
	TOOLCHAIN=${BASEDIR}/cross_toolchain/cmake-toolchain-arm-linux-neon.cmake
	PREFIX=${CROSS_BASE}/cross-root-arm-neon-depth/usr/local
	LIBS_PREFIX=${CROSS_BASE}/cross-libs-arm-neon/usr/local
	DEBIAN_ROOT=${CROSS_BASE}/debian-squeeze-root-armel-build
	ARCH=armv7l
	;;

	nofp)
	TOOLCHAIN=${BASEDIR}/cross_toolchain/cmake-toolchain-arm-linux-nofp.cmake
	PREFIX=${CROSS_BASE}/cross-root-arm-nofp-depth/usr/local
	LIBS_PREFIX=${CROSS_BASE}/cross-libs-arm-nofp/usr/local
	DEBIAN_ROOT=${CROSS_BASE}/debian-squeeze-root-armel-build
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
	-D LIBUSB_1_INCLUDE_DIR=${DEBIAN_ROOT}/usr/include/libusb-1.0 \
	-D LIBUSB_1_LIBRARY=${DEBIAN_ROOT}/lib/libusb-1.0.so.0 \
	-D BUILD_EXAMPLES=off \
	"$@" \
	..

make -j $NCPUS $MAKEFLAGS
make -j $NCPUS $MAKEFLAGS install
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
	-D LIBUSB_1_INCLUDE_DIR=${DEBIAN_ROOT}/usr/include/libusb-1.0 \
	-D LIBUSB_1_LIBRARY=${DEBIAN_ROOT}/lib/libusb-1.0.so.0 \
	-D BUILD_EXAMPLES=off \
	"$@" \
	..

make -j $NCPUS $MAKEFLAGS
make -j $NCPUS $MAKEFLAGS install
