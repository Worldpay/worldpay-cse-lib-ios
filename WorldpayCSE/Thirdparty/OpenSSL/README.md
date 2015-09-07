# OpenSSL for iOS


Complete solution to OpenSSL on iOS. Package comes with the openssl.framework, and includes scripts to build newer version if necessary.

The *openssl.framework* is a fake framework. It is actually fat static library disguised as a dynamic library.

Current version contains binaries built with SDK iOS 8.1 (target 7.0).

## Architectures

The built framework was created with the following iOS architectures: armv7, armv7s, arm64 + simulator (i386, x86_64)

## Recompiling openssl.framework

To recompile openssl.framework from source it is needed to execute in the local folder two scripts: *build-libssl.sh* and *./create-framework.sh*.

### 1) Compile static libraries

````
./build-libssl.sh
```` 

This will build *libssl.a* and *libcrypto.a* fat binaries containing slices for the listed architectures. 

To add or remove architectures it is needed to edit *build-libssl.sh* and change the **ARCHS** value:

````
ARCHS="i386 x86_64 armv7 armv7s arm64"
````

By default it is building OpenSSL 1.0.2d, to change this it is needed to edit **VERSION** from *build-libssl.sh*:

````
VERSION="1.0.2d"
````

### 2) Create the framework

````
./create-framework.sh
```` 

This command will merge *libssl.a* and *libcrypto.a* into *openssl* static library, and create the *openssl.framework* in the current folder. 

Before running this script please execute the first one.

To change the framework version edit *FRAMEWORK_VERSION* from the script:

````
FRAMEWORK_VERSION="1.0.2d"
````

## Enable App Thinning

With Xcode 7 there is a new feature named App Thinning. To support this new feature in apps linking against this library it is needed to recompile it with bitcode flag enabled:

````
-fembed-bitcode
````

To enable bitcode, appned  ````-fembed-bitcode```` the *CC* variable value from ````./build-libssl.sh````

````
export CC="${BUILD_TOOLS}/usr/bin/gcc -arch ${ARCH} -fembed-bitcode"
````

Save the changes and recompile the OpenSSL framework by following the steps from the &Build

**Authors**

[OpenSSL](http://openssl.org)