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

fun AppDynamicsMobileSdkPlugin.setUserDataBoolean(
    @NonNull result: MethodChannel.Result,
    arguments: Any?
) {
    val properties = arguments as HashMap<*, *>

    val key = properties["key"] as? String ?: run {
        result.error(
            "500",
            "Agent setUserDataBoolean() failed.",
            "Please provide a valid string for `key`."
        )
        return
    }

    val value = properties["value"] as? Boolean ?: run {
        result.error(
            "500",
            "Agent setUserDataBoolean() failed.",
            "Please provide a valid boolean for `value`."
        )
        return
    }

    Instrumentation.setUserDataBoolean(key, value);
    result.success(null)
}


fun AppDynamicsMobileSdkPlugin.removeUserDataBoolean(
    @NonNull result: MethodChannel.Result,
    arguments: Any?
) {
    val key = arguments as? String ?: run {
        result.error(
            "500",
            "Agent removeUserDataBoolean() failed.",
            "Please provide a valid string for `key`."
        )
        return
    }

    Instrumentation.setUserDataBoolean(key, null);
    result.success(null)
}