set(CMAKE_TOOLCHAIN_FILE "$ENV{ANDROID_NDK}/build/cmake/android.toolchain.cmake" CACHE STRING "")

include($ENV{ANDROID_NDK}/build/cmake/flags.cmake)

set(CMAKE_Swift_SDK "$ENV{HOME}/swift-toolchain" CACHE STRING "")
set(CMAKE_Swift_COMPILER "$ENV{HOME}/swift-toolchain/usr/bin/swiftc" CACHE STRING "")
        
set(CMAKE_BUILD_TYPE "RelWithDebInfo" CACHE STRING "")
set(CMAKE_VERBOSE_MAKEFILE ON)
set(CMAKE_INSTALL_PREFIX "$ENV{HOME}/swift-toolchain/usr" CACHE STRING "")

set(ANDROID_NATIVE_API_LEVEL "24" CACHE STRING "")
set(CMAKE_Swift_FLAGS 
        "-tools-directory $ENV{ANDROID_NDK}/toolchains/llvm/prebuilt/linux-x86_64/bin \
         -sdk $ENV{ANDROID_NDK}/toolchains/llvm/prebuilt/linux-x86_64/sysroot \
         -resource-dir $ENV{ANDROID_NDK}/toolchains/llvm/prebuilt/linux-x86_64/sysroot/usr/lib/swift \
         -Xlinker --build-id=sha1" 
    CACHE STRING "")