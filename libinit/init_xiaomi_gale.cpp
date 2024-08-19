/*
 * Copyright (C) 2021 The LineageOS Project
 *
 * SPDX-License-Identifier: Apache-2.0
 */
#include <libinit_variant.h>
#include <libinit_utils.h>
#include <unistd.h>

#include "vendor_init.h"

static const variant_info_t gust_info = {
    .hwc_value = "",
    .sku_value = "gust",

    .brand = "Redmi",
    .device = "gust",
    .marketname = "Redmi 13C",
    .model = "23108RN04Y",
    .build_fingerprint = "Redmi/gale_global/gale:13/SP1A.210812.016/V816.0.2.0.UGPMIXM:user/release-keys"
};

static const variant_info_t gale_info = {
    .hwc_value = "",
    .sku_value = "gale",

    .brand = "Redmi",
    .device = "gale",
    .marketname = "Redmi 13C",
    .model = "23106RN0DA",
    .build_fingerprint = "Redmi/gale_global/gale:13/SP1A.210812.016/V816.0.2.0.UGPMIXM:user/release-keys"
};

static const variant_info_t gale_la_info = {
    .hwc_value = "",
    .sku_value = "gale_la",

    .brand = "Redmi",
    .device = "gale",
    .marketname = "Redmi 13C",
    .model = "23100RN82L",
    .build_fingerprint = "Redmi/gale_global/gale:13/SP1A.210812.016/V816.0.2.0.UGPMIXM:user/release-keys"
};

static const variant_info_t gale_in_info = {
    .hwc_value = "",
    .sku_value = "gale_in",

    .brand = "Redmi",
    .device = "gale",
    .marketname = "Redmi 13C",
    .model = "2311DRN14I",
    .build_fingerprint = "Redmi/gale_global/gale:13/SP1A.210812.016/V816.0.2.0.UGPMIXM:user/release-keys"
};

static const variant_info_t gust_p_info = {
    .hwc_value = "",
    .sku_value = "gust_p",

    .brand = "Poco",
    .device = "gust",
    .marketname = "POCO C65",
    .model = "2310FPCA4G",
    .build_fingerprint = "POCO/gale_p_global/gale:13/SP1A.210812.016/V816.0.2.0.UGPMIXM:user/release-keys"
};

static const variant_info_t gale_p_info = {
    .hwc_value = "",
    .sku_value = "gale_p",

    .brand = "Poco",
    .device = "gale",
    .marketname = "POCO C65",
    .model = "2310FPCA4I",
    .build_fingerprint = "POCO/gale_p_global/gale:13/SP1A.210812.016/V816.0.2.0.UGPMIXM:user/release-keys"
};

static const std::vector<variant_info_t> variants = {
    gust_info,
    gale_info,
    gale_la_info,
    gale_in_info,
    gale_p_info,
    gust_p_info,
};

void vendor_load_properties() {
    if (access("/system/bin/recovery", F_OK) != 0) {
        search_variant(variants);
    }
}
