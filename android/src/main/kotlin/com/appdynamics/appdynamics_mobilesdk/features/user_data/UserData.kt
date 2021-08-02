/*
 * Copyright (c) 2021. AppDynamics LLC and its affiliates.
 * All rights reserved.
 *
 */

package com.appdynamics.appdynamics_mobilesdk.features

import androidx.annotation.NonNull
import com.appdynamics.appdynamics_mobilesdk.AppDynamicsMobileSdkPlugin
import com.appdynamics.eumagent.runtime.Instrumentation
import io.flutter.plugin.common.MethodChannel
import java.text.SimpleDateFormat
import java.util.*

fun AppDynamicsMobileSdkPlugin.setUserData(
    @NonNull result: MethodChannel.Result,
    arguments: Any?
) {
    val properties = arguments as HashMap<*, *>

    val key = properties["key"] as? String ?: run {
        result.error(
            "500",
            "Agent setUserData() failed.",
            "Please provide a valid string for `key`."
        )
        return
    }

    val value = properties["value"] as? String ?: run {
        result.error(
            "500",
            "Agent setUserData() failed.",
            "Please provide a valid string for `value`."
        )
        return
    }

    Instrumentation.setUserData(key, value);
    result.success(null)
}


fun AppDynamicsMobileSdkPlugin.removeUserData(
    @NonNull result: MethodChannel.Result,
    arguments: Any?
) {
    val key = arguments as? String ?: run {
        result.error(
            "500",
            "Agent removeUserData() failed.",
            "Please provide a valid string for `key`."
        )
        return
    }

    Instrumentation.setUserData(key, null);
    result.success(null)
}