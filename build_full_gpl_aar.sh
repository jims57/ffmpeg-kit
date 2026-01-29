#!/bin/bash

# ============================================================================
# Build FFmpeg-Kit unified AAR with both vid.stab and lame support
# 作者: Jimmy Gan
# 日期: 2025-01-29
# ============================================================================
#
# 功能: 构建统一的FFmpeg-Kit AAR，同时支持:
#   1. libvidstab - 用于视频稳定 (WQVideoStabilizer)
#   2. libmp3lame - 用于音频转换 (WQStyleFilter)
#   3. x264 - 用于H.264视频编码
#
# 使用方法:
# ./build_full_gpl_aar.sh
# ============================================================================

set -e

echo "========================================="
echo "Building FFmpeg-Kit unified AAR"
echo "with vid.stab + lame support"
echo "========================================="

# Set Android SDK and NDK paths
export ANDROID_SDK_ROOT="$HOME/Library/Android/sdk"
export ANDROID_NDK_ROOT="$HOME/Library/Android/sdk/ndk/25.2.9519653"

# Add NDK toolchain to PATH
export PATH="$ANDROID_NDK_ROOT/toolchains/llvm/prebuilt/darwin-x86_64/bin:$PATH"

echo "ANDROID_SDK_ROOT: $ANDROID_SDK_ROOT"
echo "ANDROID_NDK_ROOT: $ANDROID_NDK_ROOT"
echo "NDK toolchain added to PATH"

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
echo "Building with vid.stab + lame support..."
echo "Building arm64-v8a and armeabi-v7a architectures..."
echo "This may take 45-60 minutes..."
echo ""

# Build with both vidstab and lame libraries
# - libvidstab: 用于视频稳定
# - lame: 用于MP3编码
# - x264: 用于H.264视频编码
# Note: Using non-LTS build for better NDK compatibility
# Only building arm64-v8a to save time
# Use --speed to disable --enable-small, which enables all encoders/decoders
# This is needed for watermark (mjpeg encoder, png decoder, overlay filter)
./android.sh \
    --speed \
    --enable-gpl \
    --enable-libvidstab \
    --enable-lame \
    --enable-x264 \
    --disable-arm-v7a \
    --disable-arm-v7a-neon \
    --disable-x86 \
    --disable-x86-64

echo ""
echo "========================================="
echo "Build complete!"
echo "========================================="
echo "AAR location: prebuilt/bundle-android-aar-lts/ffmpeg-kit/"
ls -lh prebuilt/bundle-android-aar-lts/ffmpeg-kit/*.aar 2>/dev/null || echo "AAR not found in expected location, checking alternative..."
ls -lh bundle-android-aar-lts/*.aar 2>/dev/null || true
