#!/bin/sh

PRODUCT_NAME="openssl"
FRAMEWORK_VERSION="1.0.2d"
FRAMEWORK_PATH="${PRODUCT_NAME}.framework"

rm -fr "${FRAMEWORK_PATH}"

# Create the paths
mkdir -p "${FRAMEWORK_PATH}/Headers"

# Copy the public headers into the framework
cp -a "include/${PRODUCT_NAME}/" "${FRAMEWORK_PATH}/Headers"

# Create the library
libtool -no_warning_for_no_symbols -static -o "${FRAMEWORK_PATH}/${PRODUCT_NAME}" lib/libcrypto.a lib/libssl.a

chmod +x "${FRAMEWORK_PATH}/${PRODUCT_NAME}"

# Create the plist
cat > "${FRAMEWORK_PATH}/Info.plist" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>BuildMachineOSBuild</key>
	<string>13F34</string>
	<key>CFBundleDevelopmentRegion</key>
	<string>en</string>
	<key>CFBundleExecutable</key>
	<string>${PRODUCT_NAME}</string>
	<key>CFBundleIdentifier</key>
	<string>${PRODUCT_NAME}.sdk</string>
	<key>CFBundleInfoDictionaryVersion</key>
	<string>6.0</string>
	<key>CFBundleName</key>
	<string>${PRODUCT_NAME}</string>
	<key>CFBundlePackageType</key>
	<string>FMWK</string>
	<key>CFBundleShortVersionString</key>
	<string>${FRAMEWORK_VERSION}</string>
	<key>CFBundleSignature</key>
	<string>????</string>
	<key>CFBundleSupportedPlatforms</key>
	<array>
		<string>iPhoneOS</string>
	</array>
	<key>CFBundleVersion</key>
	<string>20</string>
	<key>DTCompiler</key>
	<string>com.apple.compilers.llvm.clang.1_0</string>
	<key>DTPlatformBuild</key>
	<string>12B411</string>
	<key>DTPlatformName</key>
	<string>iphoneos</string>
	<key>DTPlatformVersion</key>
	<string>8.1</string>
	<key>DTSDKBuild</key>
	<string>12B411</string>
	<key>DTSDKName</key>
	<string>iphoneos8.1</string>
	<key>DTXcode</key>
	<string>0611</string>
	<key>DTXcodeBuild</key>
	<string>6A2008a</string>
	<key>MinimumOSVersion</key>
	<string>7.0</string>
	<key>NSHumanReadableCopyright</key>
	<string>Copyright © 2015 OpenSSL. All rights reserved.</string>
	<key>UIDeviceFamily</key>
	<array>
		<integer>1</integer>
		<integer>2</integer>
	</array>
</dict>
</plist>
EOF

rm -fr lib include




