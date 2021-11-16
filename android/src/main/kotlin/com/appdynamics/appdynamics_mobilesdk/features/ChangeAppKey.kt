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

fun AppDynamicsMobileSdkPlugin.changeAppKey(
    @NonNull result: MethodChannel.Result,
    arguments: Any?
) {
    val properties = arguments as HashMap<*, *>

    val newKey = properties["newKey"] as? String

    if (newKey == null) {
        result.error(
            "500",
            "Agent changeAppKey() failed.",
            "Please provide a new valid key."
        )
        return
    }

    try {
        Instrumentation.changeAppKey(newKey)
        result.success(null)
    } catch (e: Exception) {
        result.error("500", "Agent changeAppKey() failed.", e.message)
    }
}
