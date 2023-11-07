# Copyright (C) 2022 Paranoid Android
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Include display HAL makefiles.
$(call inherit-product-if-exists, $(TARGET_HALS_PATH)/display/config/display-board.mk)
$(call inherit-product-if-exists, $(TARGET_HALS_PATH)/display/config/display-product.mk)

# Enable Legacy Lights HAL for <5.10 targets
ifneq (,$(filter 3.18 4.4 4.9 4.14 4.19 5.4, $(TARGET_KERNEL_VERSION)))

# Lights HAL
PRODUCT_PACKAGES += \
    android.hardware.lights-service.qti \
    lights.qcom

else # >= 5.10

# Include QTI AIDL Lights HAL for 5.10
-include vendor/qcom/opensource/lights/lights-vendor-product.mk

endif # >= 5.10

# Permissions
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.touchscreen.multitouch.jazzhand.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.touchscreen.multitouch.jazzhand.xml

# Packages
PRODUCT_PACKAGES += \
    android.hardware.graphics.common-V1-ndk_platform.vendor \
    libqdutils \
    libqservice

# Properties for <5.15 targets
# These are already set on 5.15+.
ifneq (,$(filter 3.18 4.4 4.9 4.14 4.19 5.4 5.10, $(TARGET_KERNEL_VERSION)))
PRODUCT_VENDOR_PROPERTIES += \
    debug.sf.auto_latch_unsignaled=0
endif

# Properties for <5.10 targets
# These are already set on 5.10+.
ifneq (,$(filter 3.18 4.4 4.9 4.14 4.19 5.4, $(TARGET_KERNEL_VERSION)))
PRODUCT_VENDOR_PROPERTIES += \
    debug.sf.predict_hwc_composition_strategy=0 \
    debug.sf.treat_170m_as_sRGB=1
endif

# Properties for <5.4 targets
# These are already set on 5.4+
ifneq (,$(filter 3.18 4.4 4.9 4.14 4.19, $(TARGET_KERNEL_VERSION)))
PRODUCT_VENDOR_PROPERTIES += \
    debug.sf.disable_client_composition_cache=1
endif

# Properties for <4.19 targets
# These are already set on 4.19+.
ifneq (,$(filter 3.18 4.4 4.9 4.14, $(TARGET_KERNEL_VERSION)))
PRODUCT_VENDOR_PROPERTIES += \
    debug.sf.latch_unsignaled=1
endif

# Copy feature_enabler rc only for lahaina on 5.4
ifeq ($(call is-board-platform-in-list, lahaina),true)
PRODUCT_COPY_FILES += \
    device/qcom/common/vendor/display/5.4/feature_enabler_client.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/feature_enabler_client.rc
endif

# Disable custom content metadata region on <5.15 targets
ifneq (,$(filter 3.18 4.4 4.9 4.14 4.19 5.4 5.10, $(TARGET_KERNEL_VERSION)))
TARGET_GRALLOC_HANDLE_HAS_NO_CUSTOM_CONTENT_MD_RESERVED_SIZE := true
endif

# Disable UBWC-P on <6.1 targets
ifneq (,$(filter 3.18 4.4 4.9 4.14 4.19 5.4 5.10 5.15, $(TARGET_KERNEL_VERSION)))
TARGET_GRALLOC_HANDLE_HAS_NO_UBWCP := true
endif

# Get non-open-source specific aspects.
$(call inherit-product-if-exists, vendor/qcom/common/vendor/display/$(TARGET_KERNEL_VERSION)/display-vendor.mk)
