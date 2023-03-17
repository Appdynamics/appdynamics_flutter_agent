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

fun AppDynamicsAgentPlugin.changeAppKey(
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

    Instrumentation.changeAppKey(newKey)
    result.success(null)
}
