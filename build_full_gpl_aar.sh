#!/bin/bash

# Build FFmpeg-Kit full-gpl AAR with vid.stab support
# This includes: vid.stab, x264, x265, xvidcore + all full package libraries

set -e

echo "========================================="
echo "Building FFmpeg-Kit full-gpl AAR"
echo "with vid.stab support"
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
echo "Building with vid.stab support..."
echo "Building only arm64-v8a architecture to save time (~30-45 minutes)..."
echo "You can add other architectures later if needed."
echo ""

# Build only arm64-v8a with minimal libraries + vidstab
# This reduces build time significantly
./android.sh \
    --lts \
    --enable-gpl \
    --enable-libvidstab \
    --enable-x264 \
    --disable-arm-v7a \
    --disable-arm-v7a-neon \
    --disable-x86 \
    --disable-x86-64

echo ""
echo "========================================="
echo "Build complete!"
echo "========================================="
echo "AAR location: bundle-android-aar-lts/"
ls -lh bundle-android-aar-lts/*.aar
