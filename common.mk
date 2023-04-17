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
TARGET_FWK_SUPPORTS_FULL_VALUEADDS := true

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
    bengal_515 \
    crow \
    holi \
    kona \
    kona_515 \
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

# List of targets that use video hardware.
MSM_VIDC_TARGET_LIST := \
    $(MSMSTEPPE) \
    $(TRINKET) \
    atoll \
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

# Include QCOM board utilities.
ifeq ($(TARGET_FWK_SUPPORTS_FULL_VALUEADDS),true)
include vendor/qcom/opensource/core-utils/build/utils.mk
endif

# Kernel Families
5_15_FAMILY := \
    bengal_515 \
    crow \
    kona_515 \
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
else ifeq ($(TARGET_USE_SM8250_HALS),true) # lito kona
TARGET_KERNEL_VERSION ?= 4.19
TARGET_HALS_VARIANT ?= sm8250-common
OVERRIDE_QCOM_HARDWARE_VARIANT := sm8250-common
else ifeq ($(TARGET_USE_BENGAL_HALS),true) # sm6115 sm6225
TARGET_KERNEL_VERSION ?= 4.19
TARGET_HALS_VARIANT ?= bengal
OVERRIDE_QCOM_HARDWARE_VARIANT := bengal
else ifeq ($(TARGET_USE_LAHAINA_HALS),true) # lahaina: sm8350
TARGET_KERNEL_VERSION ?= 5.4
TARGET_HALS_VARIANT ?= lahaina
OVERRIDE_QCOM_HARDWARE_VARIANT := lahaina
else ifeq ($(TARGET_USE_HOLI_HALS),true) # holi: sm6375
TARGET_KERNEL_VERSION ?= 5.4
TARGET_HALS_VARIANT ?= holi
OVERRIDE_QCOM_HARDWARE_VARIANT := holi
else ifeq ($(TARGET_USE_SM8450_HALS),true) # taro parrot
TARGET_KERNEL_VERSION ?= 5.10
TARGET_HALS_VARIANT ?= sm8450-common
OVERRIDE_QCOM_HARDWARE_VARIANT := sm8450-common
else ifeq ($(TARGET_USE_SM8550_HALS),true) # kalama crow
TARGET_KERNEL_VERSION ?= 5.15
TARGET_HALS_VARIANT ?= sm8550-common
OVERRIDE_QCOM_HARDWARE_VARIANT := sm8550-common
else ifeq ($(TARGET_USE_BENGAL-515_HALS),true) # bengal-515: SM6225-AD - khaje divar
TARGET_KERNEL_VERSION ?= 5.15
TARGET_HALS_VARIANT ?= bengal-5.15
OVERRIDE_QCOM_HARDWARE_VARIANT := bengal-5.15
else ifeq ($(TARGET_USE_KONA-515_HALS),true) # kona-5.15: QCS8250 QRB5165 QCS7230 QRB3165 
TARGET_KERNEL_VERSION ?= 5.15
TARGET_HALS_VARIANT ?= kona-5.15
OVERRIDE_QCOM_HARDWARE_VARIANT := kona-5.15
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

# Components
include $(QCOM_COMMON_PATH)/components.mk

# Filesystem
TARGET_FS_CONFIG_GEN += $(QCOM_COMMON_PATH)/config.fs

# Power
ifneq ($(TARGET_PROVIDES_POWERHAL),true)
$(call inherit-product-if-exists, vendor/qcom/opensource/power/power-vendor-product.mk)
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

# Neural Network
PRODUCT_PACKAGES += \
    libprotobuf-cpp-full-rtti

# Pre-optimization
PRODUCT_DEXPREOPT_SPEED_APPS += \
    SystemUIGoogle

# Charger
PRODUCT_SYSTEM_EXT_PROPERTIES += \
    ro.charger.enable_suspend=1

# Compile SystemUI on device with `speed`.
PRODUCT_PROPERTY_OVERRIDES += \
    dalvik.vm.systemuicompilerfilter=speed

# QTI framework detect
PRODUCT_PACKAGES += \
    libvndfwk_detect_jni.qti \
    libqti_vndfwk_detect \
    libvndfwk_detect_jni.qti.vendor \
    libqti_vndfwk_detect.vendor \
    libqti_vndfwk_detect_system \
    libqti_vndfwk_detect_vendor \
    libvndfwk_detect_jni.qti_system \
    libvndfwk_detect_jni.qti.vendor \

# QSSI properties
PRODUCT_SYSTEM_EXT_PROPERTIES += \
    arm64.memtag.process.system_server=off \
    dalvik.vm.dex2oat64.enabled=true \
    ro.launcher.blur.appLaunch=0 \

# Disable RescueParty due to high risk of data loss
PRODUCT_PRODUCT_PROPERTIES += \
    persist.sys.disable_rescue=true

# Vendor Service Manager
PRODUCT_PACKAGES += \
    vndservicemanager

# Common android HIDL vendor variant
PRODUCT_PACKAGES += \
    android.hardware.drm@1.4.vendor \
    android.hardware.gatekeeper@1.0.vendor \
    android.hardware.keymaster@4.1.vendor \
    android.hardware.neuralnetworks@1.3.vendor \
    android.hardware.authsecret@1.0.vendor

PRODUCT_PACKAGES += \
    vendor.qti.hardware.camera.device@1.0.vendor

# Exfat FS
PRODUCT_PACKAGES += \
    fsck.exfat \
    mkfs.exfat

# SoC
PRODUCT_VENDOR_PROPERTIES += \
    ro.soc.manufacturer=QTI

endif # QCOM_BOARD_PLATFORMS
