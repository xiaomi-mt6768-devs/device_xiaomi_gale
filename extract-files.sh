#!/bin/bash
#
# SPDX-FileCopyrightText: 2016 The CyanogenMod Project
# SPDX-FileCopyrightText: 2017-2024 The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

set -e

DEVICE=gale
VENDOR=xiaomi

# Load extract_utils and do some sanity checks
MY_DIR="${BASH_SOURCE%/*}"
if [[ ! -d "${MY_DIR}" ]]; then MY_DIR="${PWD}"; fi

ANDROID_ROOT="${MY_DIR}/../../.."

export TARGET_ENABLE_CHECKELF=true

export PATCHELF_VERSION=0_17_2

# If XML files don't have comments before the XML header, use this flag
# Can still be used with broken XML files by using blob_fixup
export TARGET_DISABLE_XML_FIXING=true

HELPER="${ANDROID_ROOT}/tools/extract-utils/extract_utils.sh"
if [ ! -f "${HELPER}" ]; then
    echo "Unable to find helper script at ${HELPER}"
    exit 1
fi
source "${HELPER}"

# Default to sanitizing the vendor folder before extraction
CLEAN_VENDOR=true

ONLY_FIRMWARE=
KANG=
SECTION=

while [ "${#}" -gt 0 ]; do
    case "${1}" in
        --only-firmware)
            ONLY_FIRMWARE=true
            ;;
        -n | --no-cleanup)
            CLEAN_VENDOR=false
            ;;
        -k | --kang)
            KANG="--kang"
            ;;
        -s | --section)
            SECTION="${2}"
            shift
            CLEAN_VENDOR=false
            ;;
        *)
            SRC="${1}"
            ;;
    esac
    shift
done

if [ -z "${SRC}" ]; then
    SRC="adb"
fi

function blob_fixup {
    case "$1" in
        system_ext/lib64/libsink.so)
            "${PATCHELF}" --add-needed "libshim_sink.so" "$2"
            [ "$2" = "" ] && return 0
            ;;
        system_ext/priv-app/ImsService/ImsService.apk)
            apktool_patch "${2}" "${MY_DIR}/blob-patches/ImsService.patch" -r
            [ "$2" = "" ] && return 0
            ;;
        vendor/bin/mnld|\
        vendor/lib*/libaalservice.so|\
        vendor/lib64/libcam.utils.sensorprovider.so)
            [ "$2" = "" ] && return 0
            "$PATCHELF" --add-needed "libshim_sensors.so" "$2"
            ;;
        vendor/lib*/libmtkcam_stdutils.so)
            [ "$2" = "" ] && return 0
            "${PATCHELF}" --replace-needed "libutils.so" "libutils-v32.so" "$2"
            ;;
        vendor/lib/vendor.mediatek.hardware.bluetooth.audio-V1-ndk.so)
            [ "$2" = "" ] && return 0
            "${PATCHELF}" --replace-needed "android.hardware.audio.common-V1-ndk.so" "android.hardware.audio.common-V2-ndk.so" "${2}"
            ;;
        vendor/bin/hw/android.hardware.graphics.allocator-V2-service-mediatek|\
        vendor/lib*/egl/libGLES_mali.so|\
        vendor/lib*/hw/android.hardware.graphics.allocator-V2-mediatek.so|\
        vendor/lib64/libaimemc.so|\
        vendor/lib64/libcodec2_fsr.so|\
        vendor/lib64/vendor.mediatek.hardware.camera.isphal-V1-ndk.so|\
        vendor/lib*/vendor.mediatek.hardware.pq_aidl-V*.so)
            [ "$2" = "" ] && return 0
            "${PATCHELF}" --replace-needed "android.hardware.graphics.common-V4-ndk.so" "android.hardware.graphics.common-V5-ndk.so" "${2}"
            ;;
        vendor/lib64/libmtkcam_hal_aidl_common.so)
            [ "$2" = "" ] && return 0
            "${PATCHELF}" --replace-needed "android.hardware.camera.common-V2-ndk.so" "android.hardware.camera.common-V1-ndk.so" "${2}"
            ;;
        vendor/lib64/libmtkcam_grallocutils.so)
            [ "$2" = "" ] && return 0
            "${PATCHELF}" --replace-needed "android.hardware.graphics.allocator-V1-ndk.so" "android.hardware.graphics.allocator-V2-ndk.so" "${2}"
            "${PATCHELF}" --replace-needed "android.hardware.graphics.common-V4-ndk.so" "android.hardware.graphics.common-V5-ndk.so" "${2}"
            ;;
        system_ext/lib64/libsource.so)
            [ "$2" = "" ] && return 0
            grep -q "libui_shim.so" "${2}" || "${PATCHELF}" --add-needed "libui_shim.so" "${2}"
            ;;
        vendor/lib64/libmtkcam_stdutils.so|\
        vendor/lib64/hw/android.hardware.camera.provider@2.6-impl-mediatek.so)
            [ "$2" = "" ] && return 0
            "${PATCHELF}" --replace-needed "libutils.so" "libutils-v32.so" "${2}"
            ;;
        vendor/lib64/libmnl.so)
            "${PATCHELF}" --add-needed "libcutils.so" "${2}"
            ;;
        vendor/lib*/libteei_daemon_vfs.so|\
        vendor/lib64/libSQLiteModule_VER_ALL.so|\
        vendor/lib64/lib3a.flash.so|\
        vendor/lib64/libaaa_ltm.so)
            "${PATCHELF}" --add-needed "liblog.so" "${2}"
            ;;
        *)
            return 1
            ;;
    esac

    return 0
}

function blob_fixup_dry() {
    blob_fixup "${1}" ""
}

# Initialize the helper
setup_vendor "${DEVICE}" "${VENDOR}" "${ANDROID_ROOT}" false "${CLEAN_VENDOR}"

if [ -z "${ONLY_FIRMWARE}" ]; then
    extract "${MY_DIR}/proprietary-files.txt" "${SRC}" "${KANG}" --section "${SECTION}"
fi

"${MY_DIR}/setup-makefiles.sh"
