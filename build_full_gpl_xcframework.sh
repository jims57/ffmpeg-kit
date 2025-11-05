#!/bin/bash

# Build FFmpeg-Kit full-gpl XCFramework with vid.stab support
# This includes: vid.stab, x264, x265, xvidcore + all full package libraries
# Device-only build (no simulator)

set -e

echo "========================================="
echo "Building FFmpeg-Kit full-gpl XCFramework"
echo "with vid.stab support"
echo "========================================="

echo ""
echo "Building with vid.stab support for iOS..."
echo "Building for iOS device only (arm64)..."
echo ""

# Build for iOS device only with GPL libraries + vidstab
# This will create framework for real device only (no simulator)
./ios.sh \
    --lts \
    --enable-gpl \
    --enable-libvidstab \
    --enable-x264 \
    --disable-armv7 \
    --disable-armv7s \
    --disable-i386 \
    --disable-x86-64 \
    --disable-arm64-simulator

echo ""
echo "========================================="
echo "Build complete!"
echo "========================================="
echo "XCFramework location: prebuilt/bundle-ios-xcframework-lts/"
ls -lh prebuilt/bundle-ios-xcframework-lts/*.xcframework 2>/dev/null || echo "XCFramework files:"
find prebuilt/bundle-ios-xcframework-lts -name "*.xcframework" -type d 2>/dev/null || echo "No XCFramework found"
