#!/bin/bash

# Build FFmpeg-Kit with libmp3lame support for MP3 encoding
# 作者: Jimmy Gan
# 日期: 2025-12-16

set -e

echo "========================================="
echo "Building FFmpeg-Kit with libmp3lame support"
echo "========================================="

# Set Android SDK and NDK paths
export ANDROID_SDK_ROOT="$HOME/Library/Android/sdk"
export ANDROID_NDK_ROOT="$HOME/Library/Android/sdk/ndk/25.2.9519653"

echo "ANDROID_SDK_ROOT: $ANDROID_SDK_ROOT"
echo "ANDROID_NDK_ROOT: $ANDROID_NDK_ROOT"

# Verify paths exist
if [ ! -d "$ANDROID_SDK_ROOT" ]; then
    echo "ERROR: Android SDK not found at $ANDROID_SDK_ROOT"
    exit 1
fi

if [ ! -d "$ANDROID_NDK_ROOT" ]; then
    echo "ERROR: Android NDK not found at $ANDROID_NDK_ROOT"
    exit 1
fi

echo ""
echo "Building with libmp3lame (LAME MP3 encoder) support..."
echo "Building arm64-v8a and armeabi-v7a architectures..."
echo "This may take 30-60 minutes..."
echo ""

# Build with lame support
# --enable-lame adds libmp3lame for MP3 encoding
./android.sh \
    --enable-lame \
    --disable-x86 \
    --disable-x86-64

echo ""
echo "========================================="
echo "Build complete!"
echo "========================================="
echo "AAR location: prebuilt/bundle-android-aar/"
ls -lh prebuilt/bundle-android-aar/ffmpeg-kit/*.aar 2>/dev/null || echo "AAR not found in expected location"
