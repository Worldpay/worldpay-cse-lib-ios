# OpenSSL for iOS


Complete solution to OpenSSL on iOS. Package comes with the openssl.framework, and includes scripts to build newer version if necessary.

The *openssl.framework* is a fake framework. It is actually fat static library disguised as a dynamic library.

Current version contains binaries built with SDK iOS 8.1 (target 7.0).

## Architectures

The built framework was created with the following iOS architectures: armv7, armv7s, arm64 + simulator (i386, x86_64)

## Recompiling openssl.framework

To recompile openssl.framework from source it is needed to execute in the local folder: *./create-framework.sh*.

### Compile the framework

````
./create-framework.sh
```` 

This command will compile and merge *libssl.a* and *libcrypto.a* into *openssl* static library, and create the *openssl.framework* in the current folder. 

To change the framework version edit *FRAMEWORK_VERSION* from the script:

````
FRAMEWORK_VERSION="1.0.2d"
````

**Authors**

[OpenSSL](http://openssl.org)