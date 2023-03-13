/*
 * Copyright (c) 2022. AppDynamics LLC and its affiliates.
 * All rights reserved.
 *
 */

package com.appdynamics.appdynamics_agent.features

import androidx.annotation.NonNull
import com.appdynamics.appdynamics_agent.AppDynamicsAgentPlugin
import com.appdynamics.eumagent.runtime.AgentConfiguration
import com.appdynamics.eumagent.runtime.Instrumentation
import io.flutter.plugin.common.MethodChannel

fun AppDynamicsAgentPlugin.start(@NonNull result: MethodChannel.Result, arguments: Any?) {
    val properties = arguments as HashMap<*, *>
    val agentVersion = properties["version"] as String
    val agentName = properties["type"] as String
    val appKey = properties["appKey"] as? String
    val loggingLevel = properties["loggingLevel"] as? Int
    val collectorURL = properties["collectorURL"] as? String
    val screenshotURL = properties["screenshotURL"] as? String
    val screenshotsEnabled = properties["screenshotsEnabled"] as? Boolean
    val crashReportingEnabled = properties["crashReportingEnabled"] as? Boolean
    val applicationName = properties["applicationName"] as? String

    if (appKey == null) {
        result.error("500", "Please provide an appKey.", "Agent start() failed.")
        return
    }

    val builder: AgentConfiguration.Builder =
        AgentConfiguration.builder()
            .withAppKey(appKey)

    if (loggingLevel != null) {
        val levels = listOf(
            Instrumentation.LOGGING_LEVEL_NONE,
            Instrumentation.LOGGING_LEVEL_INFO,
            Instrumentation.LOGGING_LEVEL_VERBOSE,
        )
        builder.withLoggingLevel(levels[loggingLevel])
    }

    if (collectorURL != null) {
        builder.withCollectorURL(collectorURL)
    }

    if (screenshotURL != null) {
        builder.withScreenshotURL(screenshotURL)
    }

    if (screenshotsEnabled != null) {
        builder.withScreenshotsEnabled(screenshotsEnabled)
    }

    if (crashReportingEnabled != null) {
        builder.withCrashReportingEnabled(crashReportingEnabled)
    }

    if (applicationName != null) {
        builder.withApplicationName(applicationName)
    }

    if (crashReportCallback == null) {
        crashReportCallback = CrashCallbackObject(channel)
        builder.withCrashCallback(crashReportCallback)
    }

    builder
        .withAutoInstrument(false)
        .withContext(context)
        .withJSAgentInjectionEnabled(false)
        .withJSAgentAjaxEnabled(false)
    Instrumentation.startFromHybrid(builder.build(), agentName, agentVersion)

    result.success(null)
}
