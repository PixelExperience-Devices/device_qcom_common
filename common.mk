# Copyright 2022 Paranoid Android
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

QCOM_COMMON_PATH := device/qcom/common
BOARD_USES_QCOM_HARDWARE := true
TARGET_FWK_SUPPORTS_FULL_VALUEADDS := true

# Enable support for APEX updates
$(call inherit-product, $(SRC_TARGET_DIR)/product/updatable_apex.mk)

ifeq ($(TARGET_BOARD_PLATFORM),)
$(error "TARGET_BOARD_PLATFORM is not defined yet, please define in your device makefile so it's accessible to QCOM common.")
endif

# List of QCOM targets.
MSMSTEPPE := sm6150
TRINKET := trinket

QCOM_BOARD_PLATFORMS += \
    $(MSMSTEPPE) \
    $(TRINKET) \
    atoll \
    bengal \
    crow \
    holi \
    kona \
    kalama \
    lahaina \
    lito \
    monaco \
    msm8937 \
    msm8953 \
    msm8996 \
    msm8998 \
    msmnile \
    parrot \
    sdm660 \
    sdm710 \
    sdm845 \
    taro

ifneq (,$(filter 3.18 4.4 4.9 4.14 4.19, $(TARGET_KERNEL_VERSION)))
# List of targets that use video hardware.
MSM_VIDC_TARGET_LIST := \
    $(MSMSTEPPE) \
    $(TRINKET) \
    atoll \
    bengal \
    kona \
    lito \
    msm8937 \
    msm8953 \
    msm8996 \
    msm8998 \
    msmnile \
    sdm660 \
    sdm710 \
    sdm845
endif

ifneq (,$(filter 3.18 4.4 4.9 4.14 4.19, $(TARGET_KERNEL_VERSION)))
# List of targets that use master side content protection.
MASTER_SIDE_CP_TARGET_LIST := \
    $(MSMSTEPPE) \
    $(TRINKET) \
    atoll \
    bengal \
    kona \
    lito \
    msm8996 \
    msm8998 \
    msmnile \
    sdm660 \
    sdm710 \
    sdm845
endif

# Include QCOM board utilities.
ifeq ($(TARGET_FWK_SUPPORTS_FULL_VALUEADDS),true)
include vendor/qcom/opensource/core-utils/build/utils.mk
endif

# Kernel Families
5_15_FAMILY := \
    crow \
    kalama \
    monaco

5_10_FAMILY := \
    parrot \
    taro

5_4_FAMILY := \
    holi \
    lahaina

4_19_FAMILY := \
    bengal \
    kona \
    lito

4_14_FAMILY := \
    $(MSMSTEPPE) \
    $(TRINKET) \
    atoll \
    msmnile

4_9_FAMILY := \
    msm8953 \
    qcs605 \
    sdm710 \
    sdm845

4_4_FAMILY := \
    msm8998 \
    sdm660

3_18_FAMILY := \
    msm8937 \
    msm8996

# Override Hals
TARGET_HALS_PATH ?= hardware/qcom-caf/$(TARGET_HALS_VARIANT)

ifeq ($(TARGET_USE_MSM8996_HALS),true) # msm8937 msm8996
TARGET_KERNEL_VERSION ?= 3.18
TARGET_HALS_VARIANT ?= msm8996-common
OVERRIDE_QCOM_HARDWARE_VARIANT := msm8996-common
else ifeq ($(TARGET_USE_MSMS8998_HALS),true) # MSM8998 SDM660-4.4
TARGET_KERNEL_VERSION ?= 4.4
TARGET_HALS_VARIANT ?= msm8998-common
OVERRIDE_QCOM_HARDWARE_VARIANT := msm8998-common
else ifeq ($(TARGET_USE_SDM845_HALS),true) # MSM8953 SDM710 SDM845
TARGET_KERNEL_VERSION ?= 4.9
TARGET_HALS_VARIANT ?= sdm845-common
OVERRIDE_QCOM_HARDWARE_VARIANT := sdm845-common
else ifeq ($(TARGET_USE_SM8150_HALS),true) # atoll msmsteppe msmnille trinket
TARGET_KERNEL_VERSION ?= 4.14
TARGET_HALS_VARIANT ?= sm8150-common
OVERRIDE_QCOM_HARDWARE_VARIANT := sm8150-common
else ifeq ($(TARGET_USE_SDM660_4_1_9_HALS),true) # SDM660-4.19
TARGET_KERNEL_VERSION ?= 4.19
TARGET_HALS_VARIANT ?= sdm660
OVERRIDE_QCOM_HARDWARE_VARIANT := sdm660
else ifeq ($(TARGET_USE_SM8250_HALS),true) # lito kona
TARGET_KERNEL_VERSION ?= 4.19
TARGET_HALS_VARIANT ?= sm8250-common
OVERRIDE_QCOM_HARDWARE_VARIANT := sm8250-common
else ifeq ($(TARGET_USE_BENGAL_HALS),true) # sm6115 sm6225
TARGET_KERNEL_VERSION ?= 4.19
TARGET_HALS_VARIANT ?= bengal
OVERRIDE_QCOM_HARDWARE_VARIANT := bengal
else ifeq ($(TARGET_USE_SM8350_HALS),true) # lahaina/holi: sm8350/sm6375
TARGET_KERNEL_VERSION ?= 5.4
TARGET_HALS_VARIANT ?= sm8350-common
OVERRIDE_QCOM_HARDWARE_VARIANT := sm8350-common
else ifeq ($(TARGET_USE_SM8450_HALS),true) # taro parrot
TARGET_KERNEL_VERSION ?= 5.10
TARGET_HALS_VARIANT ?= sm8450-common
OVERRIDE_QCOM_HARDWARE_VARIANT := sm8450-common
else ifeq ($(TARGET_USE_SM8550_HALS),true) # kalama crow
TARGET_KERNEL_VERSION ?= 5.15
TARGET_HALS_VARIANT ?= sm8550-common
OVERRIDE_QCOM_HARDWARE_VARIANT := sm8550-common
else ifeq ($(TARGET_USE_SM6225_HALS),true) # bengal-515: SM6225-AD - khaje divar
TARGET_KERNEL_VERSION ?= 5.15
TARGET_HALS_VARIANT ?= sm6225
OVERRIDE_QCOM_HARDWARE_VARIANT := sm6225
endif

ifeq ($(call is-board-platform-in-list,$(QCOM_BOARD_PLATFORMS)),true)
ifeq ($(TARGET_FWK_SUPPORTS_FULL_VALUEADDS),true)
# Compatibility matrix
DEVICE_MATRIX_FILE += \
    device/qcom/vendor-common/compatibility_matrix.xml

DEVICE_FRAMEWORK_COMPATIBILITY_MATRIX_FILE += \
    vendor/qcom/opensource/core-utils/vendor_framework_compatibility_matrix.xml \
    vendor/aosp/config/device_framework_matrix.xml

PRODUCT_VENDOR_PROPERTIES += ro.vendor.qti.va_aosp.support=1
PRODUCT_ODM_PROPERTIES += ro.vendor.qti.va_odm.support=1
endif

# Opt out of 16K alignment changes
PRODUCT_MAX_PAGE_SIZE_SUPPORTED ?= 4096

# Components
include $(QCOM_COMMON_PATH)/components.mk

# Filesystem
TARGET_FS_CONFIG_GEN += $(QCOM_COMMON_PATH)/config.fs

# Partition source order for Product/Build properties pickup.
PRODUCT_SYSTEM_PROPERTIES += \
    ro.product.property_source_order=odm,vendor,product,system_ext,system

# Power
ifneq ($(TARGET_PROVIDES_POWERHAL),true)
$(call inherit-product-if-exists, vendor/qcom/opensource/power/power-vendor-product.mk)

PRODUCT_PACKAGES += \
    android.hardware.power-service-qti
endif

# Public Libraries
PRODUCT_COPY_FILES += \
    device/qcom/qssi/public.libraries.product-qti.txt:$(TARGET_COPY_OUT_PRODUCT)/etc/public.libraries-qti.txt \
    device/qcom/qssi/public.libraries.system_ext-qti.txt:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/public.libraries-qti.txt

# SECCOMP Extensions
PRODUCT_COPY_FILES += \
    $(QCOM_COMMON_PATH)/vendor/seccomp/codec2.software.ext.policy:$(TARGET_COPY_OUT_VENDOR)/etc/seccomp_policy/codec2.software.ext.policy \
    $(QCOM_COMMON_PATH)/vendor/seccomp/codec2.vendor.ext.policy:$(TARGET_COPY_OUT_VENDOR)/etc/seccomp_policy/codec2.vendor.ext.policy \
    $(QCOM_COMMON_PATH)/vendor/seccomp/mediacodec-seccomp.policy:$(TARGET_COPY_OUT_VENDOR)/etc/seccomp_policy/mediacodec.policy \
    $(QCOM_COMMON_PATH)/vendor/seccomp/mediaextractor-seccomp.policy:$(TARGET_COPY_OUT_VENDOR)/etc/seccomp_policy/mediaextractor.policy

# Permissions
PRODUCT_COPY_FILES += \
    $(QCOM_COMMON_PATH)/permissions/privapp-permissions-hotword.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/privapp-permissions-hotword.xml \
    device/qcom/qssi/privapp-permissions-qti.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/privapp-permissions-qti.xml \
    device/qcom/qssi/privapp-permissions-qti-system-ext.xml:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/permissions/privapp-permissions-qti-system-ext.xml \
    device/qcom/qssi/qti_whitelist.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/sysconfig/qti_whitelist.xml \
    device/qcom/qssi/qti_whitelist_system_ext.xml:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/sysconfig/qti_whitelist_system_ext.xml

# Vendor Service Manager
PRODUCT_PACKAGES += \
    vndservicemanager

# SoC
PRODUCT_VENDOR_PROPERTIES += \
    ro.soc.manufacturer=QTI

# Charger
PRODUCT_SYSTEM_EXT_PROPERTIES += \
    ro.charger.enable_suspend=1

# Compile SystemUI on device with `speed`.
PRODUCT_PROPERTY_OVERRIDES += \
    dalvik.vm.systemuicompilerfilter=speed

# QSSI properties
PRODUCT_SYSTEM_EXT_PROPERTIES += \
    dalvik.vm.dex2oat64.enabled=true \
    debug.sf.frame_rate_multiple_threshold=60 \
    persist.arm64.memtag.system_server=off \
    ro.launcher.blur.appLaunch=0 \
    ro.sf.use_latest_hwc_vsync_period=0

# Disable RescueParty due to high risk of data loss
PRODUCT_PRODUCT_PROPERTIES += \
    persist.sys.disable_rescue=true

# StrictMode
ifneq ($(TARGET_BUILD_VARIANT),eng)
# Disable extra StrictMode features on all non-engineering builds
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    persist.sys.strictmode.disable=true
endif

# curl
PRODUCT_PACKAGES += \
    curl

# Exfat FS
PRODUCT_PACKAGES += \
    fsck.exfat \
    mkfs.exfat

# Include fs tools for dedicated recovery and ramdisk partitions.
PRODUCT_PACKAGES += \
    e2fsck_ramdisk \
    resize2fs_ramdisk \
    tune2fs_ramdisk

PRODUCT_PACKAGES += \
    e2fsck.recovery \
    resize2fs.recovery \
    tune2fs.recovery

# Common android HIDL vendor variant
PRODUCT_PACKAGES += \
    android.frameworks.sensorservice@1.0.vendor \
    android.hardware.drm@1.4.vendor \
    android.hardware.gatekeeper@1.0.vendor \
    android.hardware.keymaster@4.1.vendor \
    android.hardware.neuralnetworks@1.3.vendor \
    android.hardware.authsecret@1.0.vendor \
    vendor.qti.hardware.camera.device@1.0.vendor

# HIDL
PRODUCT_PACKAGES += \
    android.hidl.base@1.0 \
    android.hidl.base@1.0_system \
    android.hidl.base@1.0.vendor \
    android.hidl.manager@1.0 \
    android.hidl.manager@1.0_system \
    android.hidl.manager@1.0.vendor \
    libhidltransport.vendor \
    libhwbinder.vendor

# Protobuf - Workaround for prebuilt Qualcomm HAL
PRODUCT_PACKAGES += \
    libprotobuf-cpp-full-3.9.1-vendorcompat \
    libprotobuf-cpp-lite-3.9.1-vendorcompat

# QTI framework detect
PRODUCT_PACKAGES += \
    libvndfwk_detect_jni.qti \
    libqti_vndfwk_detect \
    libvndfwk_detect_jni.qti.vendor \
    libqti_vndfwk_detect.vendor \
    libqti_vndfwk_detect_system \
    libqti_vndfwk_detect_vendor \
    libvndfwk_detect_jni.qti_system \
    libvndfwk_detect_jni.qti.vendor

# Wlan
PRODUCT_PACKAGES += \
    libwpa_client

PRODUCT_VENDOR_MOVE_ENABLED := true
endif # QCOM_BOARD_PLATFORMS
