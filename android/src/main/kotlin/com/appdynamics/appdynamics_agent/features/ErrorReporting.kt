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
import org.json.JSONObject
import java.util.*
import kotlin.collections.HashMap

fun AppDynamicsAgentPlugin.reportError(
    @NonNull result: MethodChannel.Result,
    arguments: Any?
) {
    val properties = arguments as HashMap<*, *>

    val hybridExceptionData = properties["hed"] as? String ?: run {
        result.error(
            "500",
            "reportError() failed.",
            "Please send hybridExceptionData as string."
        )
        return
    }

    val severityLevel = properties["sev"] as? Int ?: run {
        result.error(
            "500",
            "reportError() failed.",
            "Please provide a valid error severity level."
        )
        return
    }

    Instrumentation.reportRawError(hybridExceptionData, severityLevel)
    result.success(null)
}

fun AppDynamicsAgentPlugin.createCrashReport(
    @NonNull result: MethodChannel.Result,
    arguments: Any?
) {
    val properties = arguments as HashMap<*, *>

    val hed = properties["hed"] as? String ?: run {
        result.error(
            "500",
            "reportError() failed.",
            "Please send hybridExceptionData as string."
        )
        return
    }

    Instrumentation.createRawCrashReport(hed)
    result.success(null)
}

fun AppDynamicsAgentPlugin.createNativeCrashReport(
    @NonNull result: MethodChannel.Result,
    arguments: Any?
) {
    val properties = arguments as HashMap<*, *>

    val crashData = properties["crashData"] as? String ?: run {
        result.error(
            "500",
            "reportError() failed.",
            "Please send hybridExceptionData as string."
        )
        return
    }

    Instrumentation.createCrashReport(crashData, "androidCrashReport")
    result.success(null)
}

