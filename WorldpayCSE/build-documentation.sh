#!/bin/bash

BUILT_PRODUCTS_DIR="$(pwd)/build"
PROJECT_DIR="$(pwd)"
APPLEDOCPATH="${BUILT_PRODUCTS_DIR}/appledoc"
DOCSPATH="${PROJECT_DIR}/documentation"
HEADERSPATH="${BUILT_PRODUCTS_DIR}/Headers/"

rm -fr "${APPLEDOCPATH}" "${DOCSPATH}" "${PROJECT_DIR}/documentation.zip" "${HEADERSPATH}"
mkdir -p "${DOCSPATH}" "${HEADERSPATH}"

# copy header files to create docs
cp "${PROJECT_DIR}/WorldpayCSE/WorldpayCSE.h" \
"${PROJECT_DIR}/WorldpayCSE/WPConstants.h" \
"${PROJECT_DIR}/WorldpayCSE/WPErrorCodes.h" \
"${PROJECT_DIR}/WorldpayCSE/crypto/WPPublicKey.h" \
"${PROJECT_DIR}/WorldpayCSE/model/WPCardData.h" \
"${HEADERSPATH}"

# build appledoc
git clone git://github.com/tomaz/appledoc.git "${APPLEDOCPATH}"
cd "${APPLEDOCPATH}" && mkdir -p bin/templates
sh install-appledoc.sh -b "${APPLEDOCPATH}/bin" -t "${APPLEDOCPATH}/bin/templates"


# generate documentation
"${APPLEDOCPATH}/bin/appledoc" \
--project-name "Worldpay Client Side Encryption (CSE) SDK" \
--project-company "Worldpay" \
--company-id "com.worldpay" \
--output "${DOCSPATH}" \
--logformat xcode \
--keep-undocumented-objects \
--keep-undocumented-members \
--keep-intermediate-files \
--no-repeat-first-par \
--no-warn-invalid-crossref \
--merge-categories \
--exit-threshold 2 \
--docset-platform-family iphoneos \
"${HEADERSPATH}"

cd "${BUILT_PRODUCTS_DIR}"
zip -1 -r "${PROJECT_DIR}/documentation.zip" "${DOCSPATH}"
