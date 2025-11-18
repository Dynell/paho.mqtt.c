#
# CMake Toolchain file for crosscompiling on ARM.
#
# This can be used when running cmake in the following way:
#  cd build/
#  cmake .. -DCMAKE_TOOLCHAIN_FILE=../cross-arm-linux-gnueabihf.cmake
#
#/opt/exorintos/1.5.3/sysroots/cortexa8hf-vfp-neon-poky-linux-gnueabi/lib/
#/opt/exorintos/1.5.3/sysroots/i686-pokysdk-linux/usr/bin/arm-poky-linux-gnueabi
set(CROSS_PATH /opt/exorintos-3.x.x/3.x.x/sysroots)
set(SDKTARGETSYSROOT ${CROSS_PATH}/cortexa9t2hf-neon-poky-linux-gnueabi)
set(CMAKE_FIND_ROOT_PATH  ${SDKTARGETSYSROOT})
# Target operating system name.
set(CMAKE_SYSTEM_NAME Linux)

# Name of C compiler.
set(CMAKE_C_COMPILER "${CROSS_PATH}/x86_64-pokysdk-linux/usr/bin/arm-poky-linux-gnueabi/arm-poky-linux-gnueabi-gcc")
set(CMAKE_CXX_COMPILER "${CROSS_PATH}/x86_64-pokysdk-linux/usr/bin/arm-poky-linux-gnueabi/arm-poky-linux-gnueabi-g++")
set(CMAKE_C_FLAGS "-mcpu=cortex-a9 -mfloat-abi=hard --sysroot=${SDKTARGETSYSROOT}")
set(CMAKE_CXX_FLAGS "-mcpu=cortex-a9 -mfloat-abi=hard --sysroot=${SDKTARGETSYSROOT}")
#
# Different build system distros set release optimization level to different
# things according to their local policy, eg, Fedora is -O2 and Ubuntu is -O3
# here.  Actually the build system's local policy is completely unrelated to
# our desire for cross-build release optimization policy for code built to run
# on a completely different target than the build system itself.
#
# Since this goes last on the compiler commandline we have to override it to a
# sane value for cross-build here.  Notice some gcc versions enable broken
# optimizations with -O3.
#
if (CMAKE_BUILD_TYPE MATCHES RELEASE OR CMAKE_BUILD_TYPE MATCHES Release OR CMAKE_BUILD_TYPE MATCHES release)
	set(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} -O2")
	set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -O2")
endif()

# Where to look for the target environment. (More paths can be added here)
set(CMAKE_PREFIX_PATH "${CROSS_PATH}/cortexa9t2hf-neon-poky-linux-gnueabi/")
set(CMAKE_LIBRARY_PATH "${CROSS_PATH}/cortexa9t2hf-neon-poky-linux-gnueabi/lib/")

# Adjust the default behavior of the FIND_XXX() commands:
# search programs in the host environment only.
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)

# Search headers and libraries in the target environment only.
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)

#build:
# cmake . -DCMAKE_TOOLCHAIN_FILE=./cross-arm-linux-gnueabihf.cmake -DPAHO_BUILD_STATIC=TRUE -DPAHO_BUILD_SHARED=FALSE --fresh --debug-trycompile
# make