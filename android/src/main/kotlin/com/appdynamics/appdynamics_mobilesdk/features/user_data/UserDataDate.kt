/*
 * Copyright (c) 2021. AppDynamics LLC and its affiliates.
 * All rights reserved.
 *
 */

package com.appdynamics.appdynamics_mobilesdk.features.user_data

import androidx.annotation.NonNull
import com.appdynamics.appdynamics_mobilesdk.AppDynamicsMobileSdkPlugin
import com.appdynamics.eumagent.runtime.Instrumentation
import io.flutter.plugin.common.MethodChannel
import java.text.SimpleDateFormat
import java.util.*

@Suppress("SpellCheckingInspection")
fun AppDynamicsMobileSdkPlugin.setUserDataDate(
    @NonNull result: MethodChannel.Result,
    arguments: Any?
) {
    val properties = arguments as HashMap<*, *>

    val key = properties["key"] as? String ?: run {
        result.error(
            "500",
            "Agent setUserDataDate() failed.",
            "Please provide a valid string for `key`."
        )
        return
    }

    val value = properties["value"] as? String ?: run {
        result.error(
            "500",
            "Agent setUserDataDate() failed.",
            "Please provide a valid DateTime for `value`."
        )
        return
    }

    val date = SimpleDateFormat(
        dateFormat,
        Locale.US
    ).parse(value) ?: run {
        result.error(
            "500",
            "Agent setUserDataDateTime() failed.",
            "Please provide a valid DateTime for `value`."
        )
        return
    }

    Instrumentation.setUserDataDate(key, date)
    result.success(null)
}


fun AppDynamicsMobileSdkPlugin.removeUserDataDate(
    @NonNull result: MethodChannel.Result,
    arguments: Any?
) {
    val key = arguments as? String ?: run {
        result.error(
            "500",
            "Agent removeUserDataDateTime() failed.",
            "Please provide a valid string for `key`."
        )
        return
    }

    Instrumentation.setUserDataDate(key, null)
    result.success(null)
}