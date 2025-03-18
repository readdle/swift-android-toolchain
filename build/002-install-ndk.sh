#!/bin/bash

cd $HOME

ndk=android-ndk-r26c
ndk_zip=$ndk-linux.zip

wget --progress=bar:force https://dl.google.com/android/repository/$ndk_zip
unzip $ndk_zip
rm $ndk_zip

# Patch: Fix `fts_open` Parameter Annotation in NDK `fts.h`
#
# In the Android NDK 26c the function `fts_open` is incorrectly
# declared to accept `char* _Nonnull const* _Nonnull` for its first parameter.
# However, the array should actually be null-terminated, indicating the pointer
# at the end may be NULL. Therefore, `_Nullable` is more appropriate.
sed -i 's/fts_open(char\* _Nonnull const\* _Nonnull/fts_open(char* _Nullable const* _Nonnull/' $ndk/toolchains/llvm/prebuilt/linux-x86_64/sysroot/usr/include/fts.h

# exports
echo "export ANDROID_NDK=\$HOME/$ndk" >> .build_env
echo "export ANDROID_NDK_HOME=\$ANDROID_NDK" >> .build_env