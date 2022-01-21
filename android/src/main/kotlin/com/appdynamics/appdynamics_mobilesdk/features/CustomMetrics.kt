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

fun AppDynamicsMobileSdkPlugin.reportMetric(
    @NonNull result: MethodChannel.Result,
    arguments: Any?
) {
    val properties = arguments as HashMap<*, *>
    val name = properties["name"] as? String

    if (name == null) {
        result.error(
            "500",
            "Agent reportMetric() failed.",
            "Please provide a valid metric name."
        )
        return
    }

    try {
        val value = properties["value"].toString().toLong()
        Instrumentation.reportMetric(name, value)
        result.success(null)
    } catch (e: Exception) {
        result.error(
            "500",
            "Agent reportMetric() failed.",
            e.message
        )
    }
}
