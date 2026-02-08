# Swift SDK for Android [![Download](https://img.shields.io/github/v/release/readdle/swift-android-toolchain?label=Download)](https://github.com/readdle/swift-android-toolchain/releases/latest)

Fork of the official Swift SDK for Android that includes Readdle's patches. This SDK can be used on any platform that supports the official Swift toolchain installed via [swiftly](https://www.swift.org/install/).

## Installation

Prebuilt SDKs are located on [GitHub Releases](https://github.com/readdle/swift-android-toolchain/releases).

1. Install Swift toolchain 6.2.1 with [swiftly](https://www.swift.org/install/)

```
swiftly install 6.2.1
```

2. Install Android NDK 27d

```
$ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager --install "ndk;27.3.13750724"
```

3. Install Readdle Swift Android SDK

```
swift sdk install https://github.com/readdle/swift-android-toolchain/releases/download/6.2-r1/readdle-swift-6.2.1-RELEASE_android.artifactbundle.tar.gz --checksum 2057ecd9cf71fcd9beaded08d370f4815f867983c073f2d0010796aefdf8c2f1
export ANDROID_NDK_HOME=$ANDROID_HOME/ndk/27.3.13750724
~/Library/org.swift.swiftpm/swift-sdks/readdle-swift-6.2.1-RELEASE_android.artifactbundle/swift-android/scripts/setup-android-sdk.sh
```

## Build and test Swift packages on Android

[Swift Android Build Tools](https://github.com/readdle/swift-android-buildtools) provide the `swift-android` command that wraps Swift Package Manager for cross-compiling and testing on Android devices.

### Install Build Tools

```
git clone https://github.com/readdle/swift-android-buildtools.git
export PATH="$PATH:/path/to/swift-android-buildtools"
```

### Build

`swift-android build` is a wrapper over `swift build` configured for Android. You can pass any Swift PM flags directly.

```
swift-android build
```

* Build with tests
```
swift-android build --build-tests
```
* Debug
```
swift-android build -Xswiftc -DDEBUG
```
* Release
```
swift-android build -c release
```
* Target a specific architecture
```
SWIFT_ANDROID_ARCH=x86_64 swift-android build
```

### Test on device

`swift-android test` builds, deploys, and runs XCTest suites on a connected Android device via ADB.

```
swift-android test
```

* Run a specific test case
```
swift-android test -Xtest MyModuleTests.SomeTestClass/testSpecificCase
```
* Run on exact device
```
swift-android test --device DEVICE_SERIAL
```
* Build and push without running
```
swift-android test --deploy
```
* Just re-run tests on device
```
swift-android test --fast
```

See [Swift Android Build Tools documentation](https://github.com/readdle/swift-android-buildtools) for the full reference.

## Build Android application in Android Studio

[Swift Android Gradle plugin](https://github.com/readdle/swift-android-gradle) integrates Swift builds into your Android Studio project. It uses swiftly and the Swift Android SDK under the hood.

### Setup

1. Add to your root `build.gradle`:

```groovy
buildscript {
    repositories {
        mavenCentral()
    }
    dependencies {
        classpath 'com.readdle.android.swift:gradle:6.2'
    }
}
```

2. Apply the plugin in your project `build.gradle`:

```groovy
apply plugin: 'com.readdle.android.swift'
```

Place your Swift package inside `app/src/main/swift` and build with `./gradlew assembleDebug`.

| Gradle                      | SwiftPM                             |
|-----------------------------|-------------------------------------|
| ./gradlew swiftClean        | swift package clean                 |
| ./gradlew swiftBuildDebug   | swift build                         |
| ./gradlew swiftBuildRelease | swift build --configuration release |

See [Swift Android Gradle plugin documentation](https://github.com/readdle/swift-android-gradle) for the full configuration reference.

## Build Readdle SDK from source

The SDK can be built using Docker or locally on Ubuntu 24.04.

### Docker build
```
./build-docker tag:swift-6.2.1-RELEASE ./output-dir
```

### Local build (Ubuntu 24.04)
```
./build-local tag:swift-6.2.1-RELEASE ./output-dir
```

Both scripts accept a Swift version specifier and a working directory for the build output.

## Related projects and articles

1. [Swift for Android: Our Experience and Tools](https://readdle.com/blog/swift-for-android-our-experience-and-tools) 
2. [Annotation Processor for generating JNI code](https://github.com/readdle/swift-java-codegen)
3. [Cross-platform swift weather app](https://github.com/andriydruk/swift-weather-app)
