# Mainstream diff:

## [swift-llvm](https://github.com/SwiftJava/swift-llvm):

~~* [Original SwiftError Fix](https://github.com/SwiftJava/swift-llvm/commit/d4fbcce890fea0c8c239373e5b1fea95b1214f21), [SwiftError Second Iteration](https://github.com/SwiftJava/swift-llvm/commit/209b491035bf8199514c752c19daeffcfc932e7b), [SwiftError Third Iteration](https://github.com/SwiftJava/swift-llvm/commit/b90f33daf1a74f0e11c6152acd801febf2a5fd5e)  Fix for issue with ARM- calling convention. **Already fixed in Swift 4.1**~~

## [swift](https://github.com/readdle/swift)

* [Android specific patches](https://github.com/readdle/swift/commit/1b6b59f8afe222dfd51d923894d40b8f70bc2073), [Android 7](https://github.com/readdle/swift/commit/1057eaaa4229591270d8edf242412a92e0ec9fe5), [Never fail on dlopen](https://github.com/readdle/swift/commit/7ade7c9336496214754cc041d77e587ae8e96a7b) John's fixes for protocol conformances loading in swift runtime **Review needed**

* [Error recovery hook](https://github.com/readdle/swift/commit/3e626a7a3e50d63fddd167a1365f94ffeb02744c) Actually, we don't use this fix - maybe skip it **Skip it**

* [Disable @objc and dynamic for linux. At parsing stage](https://github.com/readdle/swift/commit/7f5df1a30f33fca090e4b0ff814af043ecf5f43d) Option to disable @objc and dynamic **Require Swift Evolution Process**

* ~~[[ClangImporter] Handle ns_error_domain on nameless enums with typedefs](https://github.com/readdle/swift/commit/7f21126de1b8bbf00720596964dea484660a6358) Backport of ClangImporter related fix from 4.1 to propper import C/Objective-C enums to swift **Already merged in Swift 4.1**~~

## [swift-corelibs-foundation](https://github.com/readdle/swift-corelibs-foundation)

* [Changes required for Android port](https://github.com/readdle/swift-corelibs-foundation/commit/3fd25e7c24767ef6f831145b8e44fa90fdb80d31) Original fixes from John **Review needed**

* [For Testing on Android to work](https://github.com/readdle/swift-corelibs-foundation/commit/aa66627a5995b07993894563f8ac43ae0e7ab364) Fix for tests **Skip it**

* [[SR-6420] Ensure that the pthread_key is initialised once](https://github.com/readdle/swift-corelibs-foundation/commit/2448bc731436649fd6e21c2ddacbd1a207c31037) Try to fix it in proper way and push to Apple again @see: [Try#1](https://github.com/apple/swift-corelibs-foundation/pull/1325), [Try#2](https://github.com/apple/swift-corelibs-foundation/pull/1340) **Review needed**

* ~~[Fix IndexSet/NSIndexSet range merging](https://github.com/readdle/swift-corelibs-foundation/commit/1480021b7f536d0927e6aed64f240f55c1bf6144) **Already merged in Swift 4.2**~~

* ~~[Fix parsing long numbers from json](https://github.com/readdle/swift-corelibs-foundation/commit/a2685e4315f1a69c8ce2af259576ec0cf2f10d12) Allow to parse long long and unsigned long long even on 32bit platforms. Fixes overflow crash when casting big double to Int. **Skip it**~~

* ~~[Fix deadlocks in OperationQueue with dequeueIfReady](https://github.com/readdle/swift-corelibs-foundation/commit/41a5f321d3cd684a29a6c8c82ac9ee68676f89fa) **Already fixed in Swift 5.3**~~

* ~~[Fix URLRequest copying](https://github.com/readdle/swift-corelibs-foundation/commit/5519a405bfe4b9d97ba14bef0ace1e13cb41e182) **Already merged in Swift 4.2**~~

* ~~[Fix IndexSet.contains(integersIn indexSet:)](https://github.com/apple/swift-corelibs-foundation/pull/1524) **Already merged in Swift 4.1**~~

* ~~[Add @discardableResult to NSArray.write* methods](https://github.com/readdle/swift-corelibs-foundation/commit/08a695f2213d55f25343df110c65132287ece554), [Add @discardableResult to Scanner](https://github.com/readdle/swift-corelibs-foundation/commit/18f39bc695141b914c09578cd35b50727a799f9f), [Marked UserDefaults.synchronize() as @discardableResult](https://github.com/readdle/swift-corelibs-foundation/commit/70ede439d3f52b7bc86e7a7a3a0fd757d27d604a) **Already merged in Swift 5**~~

* ~~[URLSessionTask implement InputStream](https://github.com/apple/swift-corelibs-foundation/pull/1629) **Already merged in Swift 5.1**~~

* [URLSessionTask implement setCredentials](https://github.com/readdle/swift-corelibs-foundation/commit/578aa76882ac2da62ae932a9a581bd4f4bff68db) **TODO: Create PR**

* [URLSessionTask implement setTrustAllCertificates](https://github.com/readdle/swift-corelibs-foundation/commit/84c9fdba69e939788f52cd70c120452b56eb7bbe) **TODO: Create PR**

* ~~[URLSession implement invalidateAndCancel](https://github.com/readdle/swift-corelibs-foundation/commit/d924e48f3f2bbe031a4e35806b361d4c930001b3) **Already fixed in Swift 5.3**~~

* ~~[fix NSError isEqual](https://github.com/readdle/swift-corelibs-foundation/commit/e99b9698e3f618e7981185dfe1db578658636312) **Already fixed in Swift 5.3**~~

* ~~[Rewrite OperationQueue](https://github.com/readdle/swift-corelibs-foundation/commit/05286234e8e4cb1c050ea7fb68abe1a9e37fd8a3) **Already fixed in Swift 5.3**~~


## [swift-corelibs-libdispatch](https://github.com/SwiftJava/swift-corelibs-libdispatch)

* ~~[Separate main queue for Android](https://github.com/SwiftJava/swift-corelibs-libdispatch/commit/39ff9947faf111b9af24af2fb5968551900ec5ba), [High priority for main queue](https://github.com/SwiftJava/swift-corelibs-libdispatch/commit/81bb34b9e513f89d3c54c9fb58981b2b7631d7f9) Avoid main queue **Skip it**~~

* ~~[Reorder includes in dispatch.h for Android](https://github.com/SwiftJava/swift-corelibs-libdispatch/commit/a011e1ea46d0e891104edaf8af3407e28e406a92), [android-sysmacros](https://github.com/SwiftJava/swift-corelibs-libdispatch/commit/6a9d59764334df5e376aa7fd2610b0d09c76cacd) Fixes very strange compilation crash on Android. Occurs when <sys/sysmacros.h> included before <sys/types.h> **Fixed with new NDK**~~

* [Fix thread pool size for non-Darwin platforms](https://github.com/readdle/swift-corelibs-libdispatch/commit/10510654ebc87b4d16ebe175e554e3ac839cc310) **TODO: Create PR**


