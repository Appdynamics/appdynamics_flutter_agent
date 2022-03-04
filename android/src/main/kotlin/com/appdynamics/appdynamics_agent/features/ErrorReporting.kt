/*
 * Copyright (c) 2021. AppDynamics LLC and its affiliates.
 * All rights reserved.
 *
 */

package com.appdynamics.appdynamics_agent.features

import androidx.annotation.NonNull
import com.appdynamics.appdynamics_agent.AppDynamicsAgentPlugin
import com.appdynamics.eumagent.runtime.Instrumentation
import io.flutter.plugin.common.MethodChannel

fun AppDynamicsAgentPlugin.reportError(
    @NonNull result: MethodChannel.Result,
    arguments: Any?
) {
    val properties = arguments as HashMap<*, *>

    val message = properties["message"] as? String ?: run {
        result.error(
            "500",
            "reportError() failed.",
            "Please provide a valid message string."
        )
        return
    }

    val severityLevel = properties["severity"] as? Int ?: run {
        result.error(
            "500",
            "reportError() failed.",
            "Please provide a valid error severity level."
        )
        return
    }

    Instrumentation.reportError(Throwable(message), severityLevel)
    result.success(null)
}

fun AppDynamicsAgentPlugin.createCrashReport(
    @NonNull result: MethodChannel.Result,
    arguments: Any?
) {
    val properties = arguments as HashMap<*, *>

    val crashDump = properties["crashDump"] as String
    val type = "clrCrashReport"

    Instrumentation.createCrashReport(crashDump, type)

    result.success(null)
}

