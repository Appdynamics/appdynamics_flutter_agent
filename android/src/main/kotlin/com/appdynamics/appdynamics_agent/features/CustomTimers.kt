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

fun AppDynamicsAgentPlugin.startTimer(
    @NonNull result: MethodChannel.Result,
    arguments: Any?
) {
    val name = arguments as? String ?: run {
        result.error(
            "500",
            "Agent startTimer() failed.",
            "Please provide a valid timer name."
        )
        return
    }

    Instrumentation.startTimer(name)
    result.success(null)
}


fun AppDynamicsAgentPlugin.stopTimer(
    @NonNull result: MethodChannel.Result,
    arguments: Any?
) {
    val name = arguments as? String ?: run {
        result.error(
            "500",
            "Agent stopTimer() failed.",
            "Please provide a valid timer name."
        )
        return
    }

    Instrumentation.stopTimer(name)
    result.success(null)
}