#!/bin/bash

CONFIGURATION="Release"
WORKSPACE="WorldpayCSE.xcworkspace"
SCHEME="WorldpayCSE"
LIBIPHONESIMULATORPATH="build/Build/Products/${CONFIGURATION}-iphonesimulator/WorldpayCSE.framework/WorldpayCSE"
LIBDIPHONEOSPATH="build/Build/Products/${CONFIGURATION}-iphoneos/WorldpayCSE.framework/WorldpayCSE"
FRAMEWORKIPHONEOSPATH="build/Build/Products/${CONFIGURATION}-iphoneos/WorldpayCSE.framework"

RELEASE_VERSION="$1"

if [ X"" == X"$1" ]; then
	RELEASE_VERSION="1.0.0"
fi

rm -fr build 
agvtool new-marketing-version  "${RELEASE_VERSION}"

xcodebuild -configuration "${CONFIGURATION}" -sdk "iphoneos" -workspace "${WORKSPACE}" -scheme "${SCHEME}" CODE_SIGN_IDENTITY="" OTHER_CFLAGS="-fembed-bitcode" CODE_SIGNING_REQUIRED=NO -derivedDataPath build build
xcodebuild -configuration "${CONFIGURATION}" -sdk "iphonesimulator" -workspace "${WORKSPACE}" -scheme "${SCHEME}" CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO -derivedDataPath build build

lipo -create "${LIBIPHONESIMULATORPATH}" "${LIBDIPHONEOSPATH}" -output "${LIBDIPHONEOSPATH}.all"

mv "${LIBDIPHONEOSPATH}.all" "${LIBDIPHONEOSPATH}"
rm -fr "${SCHEME}.framework"
mv "${FRAMEWORKIPHONEOSPATH}" .

zip -1 -r "${SCHEME}.framework.zip" "${SCHEME}.framework"