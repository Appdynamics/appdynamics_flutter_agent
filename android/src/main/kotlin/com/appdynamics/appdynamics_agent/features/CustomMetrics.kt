/*
 * Copyright (c) 2022. AppDynamics LLC and its affiliates.
 * All rights reserved.
 *
 */

package com.appdynamics.appdynamics_agent.features

import androidx.annotation.NonNull
import com.appdynamics.appdynamics_agent.AppDynamicsAgentPlugin
import com.appdynamics.eumagent.runtime.Instrumentation
import io.flutter.plugin.common.MethodChannel

fun AppDynamicsAgentPlugin.reportMetric(
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

    val value = properties["value"].toString().toLong()
    Instrumentation.reportMetric(name, value)
    result.success(null)
}
