# CMake toolchain file for Sheeva and related ARMv5 processors with no FPU
# TODO: Use system cross-compilation GCC instead of Sourcery
# TODO: Use nlutils CMake toolchain files
# (C)2011 Mike Bourgeous

# See http://www.cmake.org/Wiki/CMake_Cross_Compiling
set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR armv5tel)
set(CMAKE_C_COMPILER arm-none-linux-gnueabi-gcc)
set(CMAKE_CXX_COMPILER arm-none-linux-gnueabi-g++)
set(CMAKE_FIND_ROOT_PATH $ENV{HOME}/CodeSourcery/Sourcery_G++_Lite/arm-none-linux-gnueabi/libc $ENV{HOME}/CodeSourcery/Sourcery_G++_Lite/arm-none-linux-gnueabi $ENV{HOME}/devel/crosscompile/cross-libs-arm-nofp $ENV{HOME}/devel/crosscompile/cross-root-arm-nofp)

set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)

set(CMAKE_C_FLAGS "-march=armv5te -mtune=xscale -fsingle-precision-constant -I$ENV{HOME}/devel/crosscompile/cross-libs-arm-nofp/usr/include -I$ENV{HOME}/devel/crosscompile/cross-libs-arm-nofp/usr/include/libusb-1.0 -I$ENV{HOME}/devel/crosscompile/cross-libs-arm-nofp/usr/local/include -I$ENV{HOME}/devel/crosscompile/cross-root-arm-nofp/usr/include -I$ENV{HOME}/devel/crosscompile/cross-root-arm-nofp/usr/local/include" CACHE STRING "C compiler flags" FORCE)

add_definitions(-DNL_EMBEDDED)
set(NL_EMBEDDED true)

# TODO: Create CMake find scripts instead of using hard-coded include and library paths
set(CMAKE_SHARED_LINKER_FLAGS "-Wl,-rpath $ENV{HOME}/devel/crosscompile/cross-libs-arm-nofp/usr/lib -Wl,-rpath $ENV{HOME}/devel/crosscompile/cross-root-arm-nofp/usr/local/lib -L$ENV{HOME}/devel/crosscompile/cross-libs-arm-nofp/usr/lib -L$ENV{HOME}/devel/crosscompile/cross-root-arm-nofp/usr/local/lib" CACHE STRING "Linker flags" FORCE)
set(CMAKE_MODULE_LINKER_FLAGS "-Wl,-rpath $ENV{HOME}/devel/crosscompile/cross-libs-arm-nofp/usr/lib -Wl,-rpath $ENV{HOME}/devel/crosscompile/cross-root-arm-nofp/usr/local/lib -L$ENV{HOME}/devel/crosscompile/cross-libs-arm-nofp/usr/lib -L$ENV{HOME}/devel/crosscompile/cross-root-arm-nofp/usr/local/lib" CACHE STRING "Linker flags" FORCE)
set(CMAKE_EXE_LINKER_FLAGS "-Wl,-rpath $ENV{HOME}/devel/crosscompile/cross-libs-arm-nofp/usr/lib -Wl,-rpath $ENV{HOME}/devel/crosscompile/cross-root-arm-nofp/usr/local/lib -L$ENV{HOME}/devel/crosscompile/cross-libs-arm-nofp/usr/lib -L$ENV{HOME}/devel/crosscompile/cross-root-arm-nofp/usr/local/lib" CACHE STRING "Linker flags" FORCE)

