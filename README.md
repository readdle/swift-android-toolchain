# Swift Android Toolchain [![Download](https://img.shields.io/github/v/release/readdle/swift-android-toolchain?label=Download)](https://github.com/readdle/swift-android-toolchain/releases/latest)


Automated scripts to build Swift Android cross compilation toolchain for macOS

# Installation
Prebuilt toolchains are located on [Github Releases](https://github.com/readdle/swift-android-toolchain/releases)

### Prepare environment (macOS x86_64 or macOS arm64)

1. Download and install [Swift toolchain 6.0.3](https://download.swift.org/swift-6.0.3-release/xcode/swift-6.0.3-RELEASE/swift-6.0.3-RELEASE-osx.pkg)

2. Install the Android NDK:
* If you have [Android SDK Command-Line Tools](https://developer.android.com/tools#tools-sdk) installed:
```
sdkmanager --install "ndk;26.2.11394342"
```
* otherwise:
```
curl -O https://dl.google.com/android/repository/android-ndk-r26c-darwin.dmg
hdiutil attach android-ndk-r26c-darwin.dmg
cp -r "/Volumes/Android NDK r26c/AndroidNDK11394342.app/Contents/NDK/" ./android-ndk-r26c
hdiutil detach "/Volumes/Android NDK r26c"
```

3. Install the Swift Android Toolchain
```
curl -L -O https://github.com/readdle/swift-android-toolchain/releases/latest/download/swift-android.zip
unzip swift-android.zip
swift-android/bin/swift-android tools --update
```

4. Set Up Environment Variables
```
export ANDROID_NDK_HOME=<PATH_TO_NDK> 
export SWIFT_ANDROID_HOME=<PATH_TO_SWIFT_ANDROID>
 
export PATH=$ANDROID_NDK_HOME:$PATH
export PATH=$SWIFT_ANDROID_HOME/build-tools:$PATH
```

### Build and Test swift modules

Our current swift build system is tiny wrapper over Swift PM. See [Swift Package Manager](https://github.com/apple/swift-package-manager/blob/master/Documentation/Usage.md) docs for more info.

| Command                             | Description                  |
|-------------------------------------|------------------------------|
| swift package clean                 | Clean build folder           |
| swift package update                | Update dependencies          |
| swift android build                 | Build all products           |
| swift android build --build-tests   | Build all products and tests |
| swift android test                  | Connect to Android device and run all tests |
 
`swift android build` wrapper scripts works as `swift build` from Swift Package Manager but is configured for Android. You can pass additional parameters such as `-Xswiftc -DDEBUG` , `-Xswiftc -suppress-warnings` or `--configuration release`

Example of compilation flags:
* Debug
```
swift-build --configuration debug -Xswiftc -DDEBUG
```
* Release
```
swift-build --configuration release
```

`swift android test` wrapper script builds, copies, and runs Swift Package Manager (SPM) tests on a connected Android device.
  
### Build swift modules with Android Studio

This [plugin](https://github.com/readdle/swift-android-gradle) integrates Swift Android Toolchain to Gradle

### Other swift releated projects and articles

1. [Swift for Android: Our Experience and Tools](https://readdle.com/blog/swift-for-android-our-experience-and-tools) 
2. [Anotation Processor for generating JNI code](https://github.com/readdle/swift-java-codegen)
3. [Cross-platform swift weather app](https://github.com/andriydruk/swift-weather-app)
