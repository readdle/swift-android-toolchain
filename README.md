# Swift Android Toolchain [![Download](https://img.shields.io/github/v/release/readdle/swift-android-toolchain?label=Download)](https://github.com/readdle/swift-android-toolchain/releases/latest) [![CI](https://img.shields.io/github/workflow/status/readdle/swift-android-toolchain/Build%20Android%20Toolchain%205.4?label=Swift%205.4)](https://github.com/readdle/swift-android-toolchain/releases/latest)


Automated scripts to build Swift Android cross compilation toolchain for macOS

# Installation
Prebuilt toolchains are located on [Github Releases](https://github.com/readdle/swift-android-toolchain/releases)

### Prepare environment

1. Install JDK 8 if needed. Call javac from terminal and macOS will guide you.
2. [**IMPORTANT**] Install Swift 5.4.2 toolchain for Xcode https://swift.org/builds/swift-5.4.2-release/xcode/swift-5.4.2-RELEASE/swift-5.4.2-RELEASE-osx.pkg
3. Install Android Studio 3.5 or higher (optional)
4. Install [brew](https://brew.sh/) if needed
5. Install tools, NDK and Swift Android Toolchain

```
# install system tools
brew install coreutils cmake wget
 
cd ~
mkdir android
cd android
 
# install ndk
NDK=21e
wget https://dl.google.com/android/repository/android-ndk-r$NDK-darwin-x86_64.zip
unzip android-ndk-r$NDK-darwin-x86_64.zip
rm -rf android-ndk-r$NDK-darwin-x86_64.zip
unset NDK
 
# instal swift android toolchain
SWIFT_ANDROID=$(curl --silent "https://api.github.com/repos/readdle/swift-android-toolchain/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
wget https://github.com/readdle/swift-android-toolchain/releases/latest/download/swift-android-$SWIFT_ANDROID.zip
unzip swift-android-$SWIFT_ANDROID.zip
rm -rf swift-android-$SWIFT_ANDROID.zip

swift-android-$SWIFT_ANDROID/bin/swift-android tools --update
ln -sfn swift-android-$SWIFT_ANDROID swift-android-current
unset SWIFT_ANDROID
```

6. Setup environment variables by putting this to .profile 

```
export JAVA_HOME=$(/usr/libexec/java_home --version 1.8)
export TOOLCHAINS=org.swift.540202104261a

NDK=21e
export ANDROID_NDK_HOME=$HOME/android/android-ndk-r$NDK
# Stranger things
export NDK_ROOT=$ANDROID_NDK_HOME
export ANDROID_NDK=$ANDROID_NDK_HOME
export ANDROID_NDK_ROOT=$ANDROID_NDK_HOME

# Uncomment if you install Android Studio
# export ANDROID_HOME=$HOME/Library/Android/sdk

export SWIFT_ANDROID_HOME=$HOME/android/swift-android-current
 
export PATH=$ANDROID_NDK_HOME:$PATH
export PATH=$SWIFT_ANDROID_HOME/bin:$SWIFT_ANDROID_HOME/build-tools/current:$PATH
 
unset NDK
unset SWIFT_ANDROID
```

7. Include .profile to your .bashrc or .zshrc if needed by adding this line

```
source $HOME/.profile
```

### Build and Test swift modules

Our current swift build system is tiny wrapper over Swift PM. See [Swift PM](https://github.com/apple/swift-package-manager/blob/master/Documentation/Usage.md) docs for more info.

| Command                      | Description                  |
|------------------------------|------------------------------|
| swift package clean          | Clean build folder           |
| swift package update         | Update dependencies          |
| swift-build                  | Build all products           |
| swift-build  --build-tests   | Build all products and tests |
 
swift-build wrapper scripts works as swift build from swift package manager but configuresd for android.
So you can add any extra params like -Xswiftc -DDEBUG , -Xswiftc -suppress-warnings or --configuration release

Example of compilation flags:

Debug
```
swift-build --configuration debug \
    -Xswiftc -DDEBUG \
    -Xswiftc -Xfrontend -Xswiftc -experimental-disable-objc-attr
```

Release
```
swift-build --configuration release \
    -Xswiftc -Xfrontend -Xswiftc -experimental-disable-objc-attr \
    -Xswiftc -Xllvm -Xswiftc -sil-disable-pass=array-specialize
```
  
### Build swift modules with Android Studio

This [plugin](https://github.com/readdle/swift-android-gradle) integrates Swift Android Toolchain to Gradle

### Other swift releated projects

1. [Anotation Processor for generating JNI code](https://github.com/readdle/swift-java-codegen)
2. [Sample todo app](https://github.com/readdle/swift-android-architecture)
3. [Cross-platform swift weather app](https://github.com/andriydruk/swift-weather-app)
