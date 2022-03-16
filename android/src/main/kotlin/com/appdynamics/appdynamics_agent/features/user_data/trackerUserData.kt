/*
 * Copyright (c) 2022. AppDynamics LLC and its affiliates.
 * All rights reserved.
 *
 */

package com.appdynamics.appdynamics_agent.features.user_data

import androidx.annotation.NonNull
import com.appdynamics.appdynamics_agent.AppDynamicsAgentPlugin
import com.appdynamics.eumagent.runtime.Instrumentation
import io.flutter.plugin.common.MethodChannel
import java.util.*

fun AppDynamicsAgentPlugin.setUserData(
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

    Instrumentation.setUserData(key, value)
    result.success(null)
}


fun AppDynamicsAgentPlugin.removeUserData(
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

    Instrumentation.setUserData(key, null)
    result.success(null)
}