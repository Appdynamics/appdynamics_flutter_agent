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

@Suppress("SpellCheckingInspection")
fun AppDynamicsAgentPlugin.setUserDataDate(
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

    val value = properties["value"] as? Long ?: run {
        result.error(
            "500",
            "Agent setUserDataDate() failed.",
            "Please provide a valid DateTime for `value`."
        )
        return
    }

    Instrumentation.setUserDataDate(key, Date(value))
    result.success(null)
}


fun AppDynamicsAgentPlugin.removeUserDataDate(
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