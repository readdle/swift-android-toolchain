# Swift Android toolchain build scripts
Automated scripts to build Swift Android cross compilation toolchain for macOS

Based on:
 - https://github.com/SwiftJava/swifty-robot-environment
 - https://github.com/zayass/swift-android-vagrant

## System Requirements

Building stdlib require Linux and building macOS compiler requires macOS
So building scripts uses vagrant to automate eentire process on macOS host

#### Vagrant
Install [virtualbox](https://www.virtualbox.org/wiki/Downloads)  
Install [vagrant](https://www.vagrantup.com/)  
Install `vagrant-disksize` vagrant plugin

    vagrant plugin install vagrant-disksize

#### macOS build tools
Install cmake and ninja

    brew install cmake ninja
    
#### Android NDK
Install Android NDK 15c from [android-ndk-r15c-darwin-x86_64.zip](https://dl.google.com/android/repository/android-ndk-r15c-darwin-x86_64.zip) and define ANDROID_NDK_HOME env variable

    cd $somewhere
    wget https://dl.google.com/android/repository/android-ndk-r15c-darwin-x86_64.zip
    unzip https://dl.google.com/android/repository/android-ndk-r15c-darwin-x86_64.zip
    rm android-ndk-r15c-darwin-x86_64.zip
    export ANDROID_NDK_HOME=`pwd`/android-ndk-r15c

## Building

Run `build/build.sh` from project root. 
Resulting toolchain will be generated in `out/swift-android-$VERSION.zip`

To clean building directory run `build/clean.sh` in project root

It usually take around 2 hours on top MacBook Pro
