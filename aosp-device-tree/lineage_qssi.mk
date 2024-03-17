#
# Copyright (C) 2024 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# Inherit some common Lineage stuff.
$(call inherit-product, vendor/lineage/config/common_full_phone.mk)

# Inherit from qssi device
$(call inherit-product, device/dji/qssi/device.mk)

PRODUCT_DEVICE := qssi
PRODUCT_NAME := lineage_qssi
PRODUCT_BRAND := qti
PRODUCT_MODEL := qssi system image for arm64
PRODUCT_MANUFACTURER := dji

PRODUCT_GMS_CLIENTID_BASE := android-dji

PRODUCT_BUILD_PROP_OVERRIDES += \
    PRIVATE_BUILD_DESC="qssi-user 11 V00.01.04.98 10498 test-keys"

BUILD_FINGERPRINT := qti/qssi/qssi:11/V00.01.04.98/10498:user/test-keys
