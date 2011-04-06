#!/bin/sh

install_name_tool -change \
	"@executable_path/../Frameworks/Growl.framework/Versions/A/Growl" \
	"@loader_path/../Frameworks/Growl.framework/Versions/A/Growl"  \
	${TARGET_BUILD_DIR}/${FULL_PRODUCT_NAME}/Contents/MacOS/${PRODUCT_NAME}
