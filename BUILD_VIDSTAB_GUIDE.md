# Building FFmpeg-Kit with vid.stab Support

## Overview

This guide explains how to build a custom FFmpeg-Kit AAR with vid.stab support for Android video stabilization.

---

## Why Build Custom FFmpeg-Kit?

The pre-built `ffmpeg-kit-full-6.0-2.LTS.aar` from Maven/GitLab **does not include vid.stab** filter support. 

From the error logs:
```
[AVFilterGraph @ 0xb4000076d955b0e0] No such filter: 'vidstabdetect'
```

The FFmpeg configuration showed:
```
--enable-libfontconfig --enable-libfreetype ... (many libraries)
```

But **missing**: `--enable-libvidstab`

---

## Solution: Build from Source

Build FFmpeg-Kit from source with `--enable-libvidstab` flag.

---

## Prerequisites

### 1. Install Required Packages (macOS)

```bash
brew install autoconf automake libtool pkg-config curl git doxygen nasm cmake gcc gperf texinfo yasm bison wget meson ninja
```

### 2. Verify Android SDK/NDK

```bash
# Check paths
echo $ANDROID_SDK_ROOT
# Should show: /Users/mac/Library/Android/sdk

echo $ANDROID_NDK_ROOT  
# Should show: /Users/mac/Library/Android/sdk/ndk/25.2.9519653

# If not set:
export ANDROID_SDK_ROOT="$HOME/Library/Android/sdk"
export ANDROID_NDK_ROOT="$HOME/Library/Android/sdk/ndk/25.2.9519653"
```

---

## Build Instructions

### Option 1: Quick Build (arm64-v8a only) - **RECOMMENDED**

**Time**: ~30-45 minutes  
**Size**: ~15-20MB AAR

```bash
cd /Users/mac/Documents/GitHub/ffmpeg-kit
./build_full_gpl_aar.sh
```

This builds:
- ✅ arm64-v8a architecture only (most modern devices)
- ✅ vid.stab support
- ✅ x264 encoder (for output encoding)
- ✅ LTS version (supports API 16+)

**Output**: `bundle-android-aar-lts/ffmpeg-kit-min-gpl-6.0-2.LTS.aar`

### Option 2: Full Build (All Architectures)

**Time**: ~2-3 hours  
**Size**: ~60-80MB AAR

```bash
cd /Users/mac/Documents/GitHub/ffmpeg-kit

export ANDROID_SDK_ROOT="$HOME/Library/Android/sdk"
export ANDROID_NDK_ROOT="$HOME/Library/Android/sdk/ndk/25.2.9519653"

./android.sh \
    --lts \
    --enable-gpl \
    --enable-libvidstab \
    --enable-x264
```

This builds all architectures:
- arm64-v8a
- armeabi-v7a
- armeabi-v7a-neon
- x86
- x86_64

**Output**: `bundle-android-aar-lts/ffmpeg-kit-min-gpl-6.0-2.LTS.aar`

---

## After Build Completes

### 1. Verify vid.stab is Included

```bash
# Extract AAR
cd bundle-android-aar-lts
unzip -q ffmpeg-kit-min-gpl-6.0-2.LTS.aar -d extracted

# Check libraries
ls -lh extracted/jni/arm64-v8a/

# You should see:
# - libavfilter.so (contains vidstab filter)
# - libvidstab.so (vid.stab library)
```

### 2. Copy to Your Project

```bash
# Copy the new AAR
cp bundle-android-aar-lts/ffmpeg-kit-min-gpl-6.0-2.LTS.aar \
   /Users/mac/Documents/GitHub/video-stabilization-by-opencv/my-info/build_aar_for_android/third-party-aar/

# Rename for clarity
cd /Users/mac/Documents/GitHub/video-stabilization-by-opencv/my-info/build_aar_for_android/third-party-aar/
mv ffmpeg-kit-min-gpl-6.0-2.LTS.aar ffmpeg-kit-vidstab-6.0-2.LTS.aar
```

### 3. Rebuild Your VideoStabilizer AAR

```bash
cd /Users/mac/Documents/GitHub/video-stabilization-by-opencv/my-info/build_aar_for_android

# Update extract script to use new AAR
# Edit extract_ffmpeg_libs.sh and change:
# FFMPEG_KIT_AAR="$SCRIPT_DIR/third-party-aar/ffmpeg-kit-vidstab-6.0-2.LTS.aar"

# Extract and build
./extract_ffmpeg_libs.sh
./build_simple_aar.sh
```

### 4. Rebuild Android App

```bash
cd /Users/mac/Documents/GitHub/android_use_cpp
./gradlew :app:assembleDebug
```

### 5. Test on Device

Deploy and test - the `vidstabdetect` filter should now work!

---

## Build Script Details

The `build_full_gpl_aar.sh` script does:

1. **Sets environment variables**
   - ANDROID_SDK_ROOT
   - ANDROID_NDK_ROOT

2. **Calls android.sh with flags**:
   - `--lts` - Build LTS version (API 16+ support)
   - `--enable-gpl` - Enable GPL libraries
   - `--enable-libvidstab` - **Enable vid.stab filter**
   - `--enable-x264` - Enable x264 encoder (for output)
   - `--disable-arm-v7a` - Skip old ARM architecture
   - `--disable-arm-v7a-neon` - Skip NEON variant
   - `--disable-x86` - Skip x86 (emulator only)
   - `--disable-x86-64` - Skip x86_64 (emulator only)

3. **Downloads and compiles**:
   - FFmpeg source code
   - vid.stab library source
   - x264 library source
   - All dependencies

4. **Creates AAR**:
   - Packages all libraries into AAR
   - Located in `bundle-android-aar-lts/`

---

## Troubleshooting

### Build Fails with "command not found"

Install missing packages:
```bash
brew install <package-name>
```

### NDK Version Issues

If you see NDK-related errors, try NDK r22b:
```bash
# Download from: https://developer.android.com/ndk/downloads
# Or use Android Studio SDK Manager
```

### Build Takes Too Long

- Use Option 1 (arm64-v8a only)
- Most modern Android devices use arm64-v8a
- You can add other architectures later if needed

### Out of Disk Space

FFmpeg-Kit build requires ~10-15GB free space for:
- Source code downloads
- Intermediate build files
- Final binaries

Clean up after build:
```bash
# Remove intermediate files (keep AAR)
cd /Users/mac/Documents/GitHub/ffmpeg-kit
rm -rf prebuilt/android-arm64-v8a
```

---

## Expected Output

### Successful Build Log:
```
=========================================
Building FFmpeg-Kit full-gpl AAR
with vid.stab support
=========================================
ANDROID_SDK_ROOT: /Users/mac/Library/Android/sdk
ANDROID_NDK_ROOT: /Users/mac/Library/Android/sdk/ndk/25.2.9519653

Building with vid.stab support...
Building only arm64-v8a architecture to save time (~30-45 minutes)...

[... compilation logs ...]

=========================================
Build complete!
=========================================
AAR location: bundle-android-aar-lts/
-rw-r--r--  1 mac  admin   18M Nov  3 17:30 ffmpeg-kit-min-gpl-6.0-2.LTS.aar
```

### AAR Contents:
```
ffmpeg-kit-min-gpl-6.0-2.LTS.aar
├── AndroidManifest.xml
├── classes.jar (FFmpeg-Kit Java classes)
├── jni/
│   └── arm64-v8a/
│       ├── libavcodec.so
│       ├── libavdevice.so
│       ├── libavfilter.so      ← Contains vidstab filter
│       ├── libavformat.so
│       ├── libavutil.so
│       ├── libswresample.so
│       ├── libswscale.so
│       ├── libffmpegkit.so
│       ├── libffmpegkit_abidetect.so
│       ├── libvidstab.so       ← vid.stab library
│       ├── libx264.so          ← x264 encoder
│       └── libc++_shared.so
└── R.txt
```

---

## Next Steps

After successful build:

1. ✅ Verify vidstab filter is available
2. ✅ Copy AAR to your project
3. ✅ Rebuild VideoStabilizer AAR
4. ✅ Rebuild Android app
5. ✅ Test video stabilization on device

The error `No such filter: 'vidstabdetect'` should be resolved!

---

## License Note

**Important**: Building with `--enable-gpl` and `--enable-libvidstab` means your AAR will be licensed under **GPLv3**.

- vid.stab is GPL licensed
- x264 is GPL licensed
- Your app using this AAR must comply with GPL

If you need a more permissive license, you cannot use vid.stab.

---

## Estimated Build Time

| Configuration | Time | AAR Size |
|--------------|------|----------|
| arm64-v8a only | 30-45 min | ~18MB |
| All architectures | 2-3 hours | ~60MB |

**Recommendation**: Start with arm64-v8a only. Add other architectures later if needed.

---

**Date**: November 3, 2025  
**FFmpeg-Kit Version**: 6.0-2 LTS  
**Target**: Android API 16+
