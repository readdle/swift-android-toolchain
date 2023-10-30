# Swift Android Toolchain [![Download](https://img.shields.io/github/v/release/readdle/swift-android-toolchain?label=Download)](https://github.com/readdle/swift-android-toolchain/releases/latest)


Automated scripts to build Swift Android cross compilation toolchain for macOS

# Installation
Prebuilt toolchains are located on [Github Releases](https://github.com/readdle/swift-android-toolchain/releases)

### Prepare environment (macOS x86_64 or macOS arm64)

1. [**IMPORTANT**] Swift Android Toolchain uses the macOS Swift toolchain. That's why it will work ONLY with the proper version of the host toolchain. There are 2 options on how to switch the default toolchain to a proper version:
* Install [XCode 14.2](https://xcodereleases.com/) and make it [default in Command Line](https://developer.apple.com/library/archive/technotes/tn2339/_index.html#//apple_ref/doc/uid/DTS40014588-CH1-HOW_DO_I_SELECT_THE_DEFAULT_VERSION_OF_XCODE_TO_USE_FOR_MY_COMMAND_LINE_TOOLS_)
* Or install [Swift toolchain 5.7.3](https://download.swift.org/swift-5.7.3-release/xcode/swift-5.7.3-RELEASE/swift-5.7.3-RELEASE-osx.pkg) in you current XCode and add `export TOOLCHAINS=swift` to enviroment
2. Install NDK and Swift Android Toolchain. 
* If you have [Android SDK Command-Line Tools](https://developer.android.com/tools#tools-sdk) installed:
```
sdkmanager --install "ndk;25.2.9519653"
```
* otherwise:
```
curl -O https://dl.google.com/android/repository/android-ndk-r25c-darwin.dmg
hdiutil attach android-ndk-r25c-darwin.dmg
cp -r "/Volumes/Android NDK r25c/AndroidNDK9519653.app/Contents/NDK/" ./android-ndk-r25c
hdiutil detach "/Volumes/Android NDK r25c"
```
3. Install Swift Android Toolchain
```
curl -L -O https://github.com/readdle/swift-android-toolchain/releases/latest/download/swift-android.zip
unzip swift-android.zip
swift-android/bin/swift-android tools --update
```

4. Setup environment variables by adding: 

```
export ANDROID_NDK_HOME=<PATH_TO_NDK> 
export SWIFT_ANDROID_HOME=<PATH_TO_SWIFT_ANDROID>
 
export PATH=$ANDROID_NDK_HOME:$PATH
export PATH=$SWIFT_ANDROID_HOME/bin:$SWIFT_ANDROID_HOME/build-tools/current:$PATH
```

### Build and Test swift modules

Our current swift build system is tiny wrapper over Swift PM. See [Swift PM](https://github.com/apple/swift-package-manager/blob/master/Documentation/Usage.md) docs for more info.

| Command                      | Description                  |
|------------------------------|------------------------------|
| swift package clean          | Clean build folder           |
| swift package update         | Update dependencies          |
| swift-build                  | Build all products           |
| swift-build  --build-tests   | Build all products and tests |
| swift-test                   | Connect to Android device and run all tests |
 
swift-build wrapper scripts works as swift build from swift package manager but configured for android.
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

### Other swift releated projects and articles

1. [Swift for Android: Our Experience and Tools](https://readdle.com/blog/swift-for-android-our-experience-and-tools) 
2. [Anotation Processor for generating JNI code](https://github.com/readdle/swift-java-codegen)
3. [Cross-platform swift weather app](https://github.com/andriydruk/swift-weather-app)
