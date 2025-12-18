#!/usr/bin/env bash
set -e

# ===== resolve paths =====
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

echo "SCRIPT_DIR=$SCRIPT_DIR"
echo "ROOT_DIR=$ROOT_DIR"

# --------------------------------------------------
# clean
# --------------------------------------------------
rm -rf deps prefix

# --------------------------------------------------
# build mpv
# --------------------------------------------------
./download.sh
./patch.sh

rm -f scripts/ffmpeg.sh
cp flavors/full.sh scripts/ffmpeg.sh

./build.sh

# --------------------------------------------------
# build media-kit helper
# --------------------------------------------------
pushd deps/media-kit-android-helper

chmod +x gradlew
./gradlew assembleRelease

unzip -o app/build/outputs/apk/release/app-release.apk -d app/build/outputs/apk/release

cp app/build/outputs/apk/release/lib/arm64-v8a/libmediakitandroidhelper.so      "$SCRIPT_DIR/prefix/arm64-v8a/usr/local/lib"
cp app/build/outputs/apk/release/lib/armeabi-v7a/libmediakitandroidhelper.so    "$SCRIPT_DIR/prefix/armeabi-v7a/usr/local/lib"
cp app/build/outputs/apk/release/lib/x86/libmediakitandroidhelper.so            "$SCRIPT_DIR/prefix/x86/usr/local/lib"
cp app/build/outputs/apk/release/lib/x86_64/libmediakitandroidhelper.so         "$SCRIPT_DIR/prefix/x86_64/usr/local/lib"

popd

# --------------------------------------------------
# package jars (FLAT)
# --------------------------------------------------
pushd "$SCRIPT_DIR/prefix/arm64-v8a/usr/local/lib"
zip -r "$ROOT_DIR/full-arm64-v8a.jar" *.so
popd

pushd "$SCRIPT_DIR/prefix/armeabi-v7a/usr/local/lib"
zip -r "$ROOT_DIR/full-armeabi-v7a.jar" *.so
popd

pushd "$SCRIPT_DIR/prefix/x86/usr/local/lib"
zip -r "$ROOT_DIR/full-x86.jar" *.so
popd

pushd "$SCRIPT_DIR/prefix/x86_64/usr/local/lib"
zip -r "$ROOT_DIR/full-x86_64.jar" *.so
popd

# --------------------------------------------------
# verify
# --------------------------------------------------
echo "===== Generated jars ====="
ls -lh "$ROOT_DIR"/full-*.jar

echo "===== MD5 ====="
md5sum "$ROOT_DIR"/full-*.jar
