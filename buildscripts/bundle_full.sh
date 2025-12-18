# --------------------------------------------------

if [ ! -f "deps" ]; then
  sudo rm -r deps
fi
if [ ! -f "prefix" ]; then
  sudo rm -r prefix
fi

./download.sh
./patch.sh

# --------------------------------------------------

if [ ! -f "scripts/ffmpeg" ]; then
  rm scripts/ffmpeg.sh
fi
cp flavors/full.sh scripts/ffmpeg.sh

# --------------------------------------------------

./build.sh

# --------------------------------------------------

cd deps/media-kit-android-helper

sudo chmod +x gradlew
./gradlew assembleRelease

unzip -o app/build/outputs/apk/release/app-release.apk -d app/build/outputs/apk/release

cp app/build/outputs/apk/release/lib/arm64-v8a/libmediakitandroidhelper.so      ../../prefix/arm64-v8a/usr/local/lib
cp app/build/outputs/apk/release/lib/armeabi-v7a/libmediakitandroidhelper.so    ../../prefix/armeabi-v7a/usr/local/lib
cp app/build/outputs/apk/release/lib/x86/libmediakitandroidhelper.so            ../../prefix/x86/usr/local/lib
cp app/build/outputs/apk/release/lib/x86_64/libmediakitandroidhelper.so         ../../prefix/x86_64/usr/local/lib

cd ../..

pushd prefix/arm64-v8a/usr/local/lib
zip -r ../../../../../full-arm64-v8a.jar *.so
popd

pushd prefix/armeabi-v7a/usr/local/lib
zip -r ../../../../../full-armeabi-v7a.jar *.so
popd

pushd prefix/x86/usr/local/lib
zip -r ../../../../../full-x86.jar *.so
popd

pushd prefix/x86_64/usr/local/lib
zip -r ../../../../../full-x86_64.jar *.so
popd

echo "===== Generated jars ====="
ls -lh full-*.jar

echo "===== MD5 ====="
md5sum full-*.jar
