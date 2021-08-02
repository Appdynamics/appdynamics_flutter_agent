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
import java.util.*

fun AppDynamicsMobileSdkPlugin.setUserDataLong(
    @NonNull result: MethodChannel.Result,
    arguments: Any?
) {
    val properties = arguments as HashMap<*, *>

    val key = properties["key"] as? String ?: run {
        result.error(
            "500",
            "Agent setUserDataLong() failed.",
            "Please provide a valid string for `key`."
        )
        return
    }

    val value = properties["value"].toString().toLong() ?: run {
        result.error(
            "500",
            "Agent setUserDataLong() failed.",
            "Please provide a valid long for `value`."
        )
        return
    }

    Instrumentation.setUserDataLong(key, value);
    result.success(null)
}


fun AppDynamicsMobileSdkPlugin.removeUserDataLong(
    @NonNull result: MethodChannel.Result,
    arguments: Any?
) {
    val key = arguments as? String ?: run {
        result.error(
            "500",
            "Agent removeUserDataLong() failed.",
            "Please provide a valid string for `key`."
        )
        return
    }

    Instrumentation.setUserDataLong(key, null);
    result.success(null)
}