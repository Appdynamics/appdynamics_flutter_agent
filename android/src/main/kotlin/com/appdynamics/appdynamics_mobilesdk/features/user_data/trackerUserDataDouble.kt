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
import java.util.*

fun AppDynamicsMobileSdkPlugin.setUserDataDouble(
    @NonNull result: MethodChannel.Result,
    arguments: Any?
) {
    val properties = arguments as HashMap<*, *>

    val key = properties["key"] as? String ?: run {
        result.error(
            "500",
            "Agent setUserDataDouble() failed.",
            "Please provide a valid string for `key`."
        )
        return
    }

    val value = properties["value"] as? Double ?: run {
        result.error(
            "500",
            "Agent setUserDataDouble() failed.",
            "Please provide a valid double for `value`."
        )
        return
    }

    Instrumentation.setUserDataDouble(key, value)
    result.success(null)
}


fun AppDynamicsMobileSdkPlugin.removeUserDataDouble(
    @NonNull result: MethodChannel.Result,
    arguments: Any?
) {
    val key = arguments as? String ?: run {
        result.error(
            "500",
            "Agent removeUserDataDouble() failed.",
            "Please provide a valid string for `key`."
        )
        return
    }

    Instrumentation.setUserDataDouble(key, null)
    result.success(null)
}