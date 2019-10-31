[ ![Download](https://api.bintray.com/packages/readdle/swift-android-toolchain/swift-android-toolchain/images/download.svg) ](https://bintray.com/readdle/swift-android-toolchain/swift-android-toolchain/_latestVersion)

# Swift Android toolchain build scripts
Automated scripts to build Swift Android cross compilation toolchain for macOS

Based on:
 - https://github.com/SwiftJava/swifty-robot-environment
 - https://github.com/zayass/swift-android-vagrant

# Installation
Prebuilt toolchain can be located [here](https://bintray.com/readdle/swift-android-toolchain/swift-android-toolchain)

### Prepare environment

1. Install JDK 8 if needed. Call javac from terminal and macOS will guide you.
2. [**IMPORTANT**] Install Swift 5.0.3 toolchain for Xcode https://swift.org/builds/swift-5.0.3-release/xcode/swift-5.0.3-RELEASE/swift-5.0.3-RELEASE-osx.pkg
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
NDK=17c
wget https://dl.google.com/android/repository/android-ndk-r$NDK-darwin-x86_64.zip
unzip android-ndk-r$NDK-darwin-x86_64.zip
rm -rf android-ndk-r$NDK-darwin-x86_64.zip
unset NDK
 
# instal swift android toolchain
SWIFT_ANDROID=$(curl -fsSL https://api.bintray.com/packages/readdle/swift-android-toolchain/swift-android-toolchain/versions/_latest | python -c 'import json,sys;print(json.load(sys.stdin))["name"]')
wget https://dl.bintray.com/readdle/swift-android-toolchain/swift-android-$SWIFT_ANDROID.zip
unzip swift-android-$SWIFT_ANDROID.zip
rm -rf swift-android-$SWIFT_ANDROID.zip

swift-android-$SWIFT_ANDROID/bin/swift-android tools --update
ln -sfn swift-android-$SWIFT_ANDROID swift-android-current
unset SWIFT_ANDROID
```

6. Setup environment variables by putting this to .profile 

```
export JAVA_HOME=$(/usr/libexec/java_home --version 1.8)
export TOOLCHAINS=org.swift.50320190830a

NDK=17c
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

---

# Build Toolchain
### System Requirements

Building stdlib require Linux and building macOS compiler requires macOS
So building scripts uses vagrant to automate eentire process on macOS host

#### Vagrant
Install [virtualbox](https://www.virtualbox.org/wiki/Downloads)  
Install [vagrant](https://www.vagrantup.com/)  
Install vagrant plugins

    vagrant plugin install vagrant-disksize
    vagrant plugin install vagrant-scp

#### macOS build tools
Install cmake and ninja

    brew install cmake ninja pkg-config
    
#### Android NDK
Install Android NDK 17c from [android-ndk-r17c-darwin-x86_64.zip](https://dl.google.com/android/repository/android-ndk-r17c-darwin-x86_64.zip) and define ANDROID_NDK_HOME env variable

    cd $somewhere
    wget https://dl.google.com/android/repository/android-ndk-r17c-darwin-x86_64.zip
    unzip android-ndk-r17c-darwin-x86_64.zip
    rm android-ndk-r17c-darwin-x86_64.zip
    export ANDROID_NDK_HOME=$PWD/android-ndk-r17c

### Building

Run `build/build.sh` from project root. 
Resulting toolchain will be generated in `out/swift-android-$VERSION.zip`

To clean building directory run `build/clean.sh` in project root

It usually take around 2 hours on top MacBook Pro
