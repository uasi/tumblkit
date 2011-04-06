#!/bin/sh

REV_ID=`git --git-dir="$SRCROOT/.git" rev-parse --short HEAD`
VOL_NAME="$PRODUCT_NAME-$REV_ID"
NAME="$VOL_NAME.dmg"
SRC_DIR="$SRCROOT/DMGSources"
TMP_DIR="$DERIVED_FILE_DIR/$VOL_NAME"
DST_DIR="$CONFIGURATION_BUILD_DIR"

PRODUCT="$CONFIGURATION_BUILD_DIR/$WRAPPER_NAME"
PRODUCT_VER=`/usr/libexec/PlistBuddy -c 'print :CFBundleShortVersionString' "$PRODUCT/Contents/Info.plist"`

RELEASE_VOL_NAME="$PRODUCT_NAME-$PRODUCT_VER"
RELEASE_DMG_NAME="$RELEASE_VOL_NAME.dmg"

echo "This is `basename $0`"

if [ -e "$DMG_DST_DIR/$DMG_NAME" ]; then
	echo "Disk image exists"
	exit
fi

echo "Preparing disk image source"

rm -rf "$DMG_TMP_DIR"
mkdir -p "$DMG_TMP_DIR"
if [ -d "$DMG_SRC_DIR" ]; then
	cp -a "$DMG_SRC_DIR/" "$DMG_TMP_DIR"
fi
cp -a "$PRODUCT" "$DMG_TMP_DIR"

echo "Creating disk image"

hdiutil create \
	-ov \
	-srcfolder "$DMG_TMP_DIR" \
	-fs HFS+ \
	-volname "$VOL_NAME" \
	"$DMG_DST_DIR/$DMG_NAME"

echo "Checking if tagged as a release version"

TAG=`git --git-dir="$SRCROOT/.git" describe --tags --exact-match 2> /dev/null`
if [ $? -ne 0 ]; then
	echo "Not tagged"
	exit
fi

IS_RELEASE_TAG=`perl -e 'print $ARGV[0] =~ /^v\d+(\.\d+)+$/ ? 1 : 0' $TAG`
if [ $IS_RELEASE_TAG -eq 0 ]; then
	echo "Not a release version"
	exit
fi

if [ "v$PRODUCT_VER" != "$TAG" ]; then
	echo "Error: version mismatch; tagged as $TAG but version is $PRODUCT_VER" > /dev/stderr
	exit 1
fi

echo "Creating release disk image"

hdiutil create \
	-ov \
	-srcfolder "$DMG_TMP_DIR" \
	-fs HFS+ \
	-volname "$RELEASE_VOL_NAME" \
	"$DMG_DST_DIR/$RELEASE_DMG_NAME"
