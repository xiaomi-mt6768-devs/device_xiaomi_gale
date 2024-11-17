/*
 * Copyright (C) 2021 The LineageOS Project
 *
 * SPDX-License-Identifier: Apache-2.0
 */
#include <libinit_variant.h>
#include <libinit_utils.h>

#include "vendor_init.h"

static const variant_info_t c3un_info = {
    .hwc_value = "",
    .sku_value = "c3un",

    .brand = "Redmi",
    .device = "gust",
    .mod_device = "gust_global",
    .marketname = "Redmi 13C",
    .model = "23108RN04Y",
    .build_fingerprint = "Redmi/gust_global/gust:13/SP1A.210812.016/V816.0.5.0.UGPMIXM:user/release-keys"
};

static const variant_info_t c3ua_info = {
    .hwc_value = "",
    .sku_value = "c3ua",

    .brand = "Redmi",
    .device = "gale",
    .mod_device = "gale_global",
    .marketname = "Redmi 13C",
    .model = "23106RN0DA",
    .build_fingerprint = "Redmi/gale_global/gale:13/SP1A.210812.016/V816.0.5.0.UGPMIXM:user/release-keys"
};

static const variant_info_t c3ul_info = {
    .hwc_value = "",
    .sku_value = "c3ul",

    .brand = "Redmi",
    .device = "gale",
    .mod_device = "gale_global",
    .marketname = "Redmi 13C",
    .model = "23100RN82L",
    .build_fingerprint = "Redmi/gale_global/gale:13/SP1A.210812.016/V816.0.5.0.UGPMIXM:user/release-keys"
};

static const variant_info_t c3uin_info = {
    .hwc_value = "",
    .sku_value = "c3uin",

    .brand = "Redmi",
    .device = "gale",
    .mod_device = "gale_global",
    .marketname = "Redmi 13C",
    .model = "2311DRN14I",
    .build_fingerprint = "Redmi/gale_global/gale:13/SP1A.210812.016/V816.0.5.0.UGPMIXM:user/release-keys"
};

static const variant_info_t c3upg_info = {
    .hwc_value = "",
    .sku_value = "c3upg",

    .brand = "Poco",
    .device = "gust",
    .mod_device = "gust_p_global",
    .marketname = "POCO C65",
    .model = "2310FPCA4G",
    .build_fingerprint = "POCO/gust_p_global/gust:13/SP1A.210812.016/V816.0.5.0.UGPMIXM:user/release-keys"
};

static const variant_info_t c3upin_info = {
    .hwc_value = "",
    .sku_value = "c3upin",

    .brand = "Poco",
    .device = "gale",
    .mod_device = "gale_p_global",
    .marketname = "POCO C65",
    .model = "2310FPCA4I",
    .build_fingerprint = "POCO/gale_p_global/gale:13/SP1A.210812.016/V816.0.5.0.UGPMIXM:user/release-keys"
};

static const std::vector<variant_info_t> variants = {
    c3un_info,
    c3ua_info,
    c3ul_info,
    c3upin_info,
    c3uin_info,
    c3upg_info,
};

void vendor_load_properties() {
        search_variant(variants);
}
