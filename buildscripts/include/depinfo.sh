#!/bin/bash -e

## Dependency versions

v_sdk=11076708_latest
v_ndk=27.1.12297006
v_sdk_build_tools=35.0.0

v_lua=5.2.4
v_libass=0.17.3
v_harfbuzz=12.3.2
v_fribidi=1.0.16
v_freetype=2.14.1
v_mbedtls=3.6.5
v_libplacebo=7.360.0
v_dav1d=1.4.3
v_libxml2=2.12.9
v_ffmpeg=7.1
v_mpv=0.41.0
v_libogg=1.3.5
v_libvorbis=1.3.7
v_libvpx=1.14


## Dependency tree
# I would've used a dict but putting arrays in a dict is not a thing

dep_mbedtls=()
dep_dav1d=()
dep_libvorbis=(libogg)
if [ -n "$ENCODERS_GPL" ]; then
	dep_ffmpeg=(mbedtls dav1d libxml2 libvorbis libvpx libx264)
else
	dep_ffmpeg=(mbedtls dav1d libxml2)
fi
dep_freetype2=()
dep_fribidi=()
dep_harfbuzz=()
dep_libass=(freetype fribidi harfbuzz)
dep_lua=()
dep_shaderc=()
dep_libplacebo=()
if [ -n "$ENCODERS_GPL" ]; then
	dep_mpv=(ffmpeg libass libplacebo fftools_ffi lua libplacebo)
else
	dep_mpv=(ffmpeg libass libplacebo lua libplacebo)
fi
