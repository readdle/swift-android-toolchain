#!/bin/bash

cd $HOME

ndk=android-ndk-r27c
ndk_zip=$ndk-linux.zip

wget --progress=bar:force https://dl.google.com/android/repository/$ndk_zip
unzip $ndk_zip
rm $ndk_zip

# exports
echo "export ANDROID_NDK=\$HOME/$ndk" >> .build_env
echo "export ANDROID_NDK_HOME=\$ANDROID_NDK" >> .build_env