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

    val type = "clrCrashReport"
    val crashDump = properties["crashDump"] as String

    val toJson = JSONObject(crashDump)
    toJson.put("guid", UUID.randomUUID().toString())
    val backToString = toJson.toString();

    Instrumentation.createCrashReport(backToString, type)
    result.success(null)
}

