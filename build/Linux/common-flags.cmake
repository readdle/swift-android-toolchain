set(CMAKE_TOOLCHAIN_FILE "$ENV{ANDROID_NDK}/build/cmake/android.toolchain.cmake" CACHE STRING "")

set(CMAKE_Swift_SDK "$ENV{DST_ROOT}/swift-nightly-install" CACHE STRING "")
set(CMAKE_Swift_COMPILER "$ENV{DST_ROOT}/swift-nightly-install/usr/bin/swiftc" CACHE STRING "")
        
set(CMAKE_BUILD_TYPE "RelWithDebInfo" CACHE STRING "")
set(CMAKE_INSTALL_PREFIX "$ENV{DST_ROOT}/swift-nightly-install/usr" CACHE STRING "")

set(ANDROID_NATIVE_API_LEVEL "24" CACHE STRING "")
set(CMAKE_Swift_FLAGS 
        "-tools-directory $ENV{ANDROID_NDK}/toolchains/llvm/prebuilt/linux-x86_64/bin \
         -sdk $ENV{ANDROID_NDK}/toolchains/llvm/prebuilt/linux-x86_64/sysroot \
         -resource-dir ${CMAKE_Swift_SDK}/usr/lib/swift" 
    CACHE STRING "")