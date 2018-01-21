# Swift Android toolchain build scripts
Automated scripts to build Swift Android cross compilation toolchain for macOS

Based on:
 - https://github.com/SwiftJava/swifty-robot-environment
 - https://github.com/zayass/swift-android-vagrant

# Instalation
Prebuilt toolchain can be located [here](https://bintray.com/readdle/swift-android-toolchain/swift-android-toolchain)

## System Requirements
Swift Android toolchain depends on Xcode 9 and Android NDK 15c  
Environment variables shoud be named **exactly** `ANDROID_NDK_HOME` and `SWIFT_ANDROID_HOME`

## Download Android NDK 15c

    wget https://dl.google.com/android/repository/android-ndk-r15c-darwin-x86_64.zip
    unzip android-ndk-r15c-darwin-x86_64.zip
    rm android-ndk-r15c-darwin-x86_64.zip
    
    export ANDROID_NDK_HOME=$PWD/android-ndk-r15c
    # Replace with ~/.zshrc with ~/.bashrc for bash
    echo "export ANDROID_NDK_HOME=$ANDROID_NDK_HOME" >> ~/.zshrc

## Download toolchain

    wget https://dl.bintray.com/readdle/swift-android-toolchain/swift-android-4.0b.zip
    unzip swift-android-4.0b.zip
    rm swift-android-4.0b.zip
    
    export SWIFT_ANDROID_HOME=$PWD/swift-android-4.0b
    # Replace with ~/.zshrc with ~/.bashrc for bash
    echo "export SWIFT_ANDROID_HOME=$SWIFT_ANDROID_HOME" >> ~/.zshrc
    
## Setup build tools (optional)
To build and test swift projects from command line dowload command line tools  
It is not required if you dont use comand line to build swift directly

    export PATH=$SWIFT_ANDROID_HOME/bin:$SWIFT_ANDROID_HOME/build-tools/current:$PATH
    # Replace with ~/.zshrc with ~/.bashrc for bash
    echo 'export PATH=$SWIFT_ANDROID_HOME/bin:$SWIFT_ANDROID_HOME/build-tools/current:$PATH' >> ~/.zshrc
    
    swift-android tools --update

# Build 
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
    unzip android-ndk-r15c-darwin-x86_64.zip
    rm android-ndk-r15c-darwin-x86_64.zip
    export ANDROID_NDK_HOME=$PWD/android-ndk-r15c

## Building

Run `build/build.sh` from project root. 
Resulting toolchain will be generated in `out/swift-android-$VERSION.zip`

To clean building directory run `build/clean.sh` in project root

It usually take around 2 hours on top MacBook Pro
