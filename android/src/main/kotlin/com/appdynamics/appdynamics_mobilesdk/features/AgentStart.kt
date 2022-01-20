/*
 * Copyright (c) 2021. AppDynamics LLC and its affiliates.
 * All rights reserved.
 *
 */

package com.appdynamics.appdynamics_mobilesdk.features

import androidx.annotation.NonNull
import com.appdynamics.appdynamics_mobilesdk.AppDynamicsMobileSdkPlugin
import com.appdynamics.eumagent.runtime.AgentConfiguration
import com.appdynamics.eumagent.runtime.Instrumentation
import io.flutter.plugin.common.MethodChannel

fun AppDynamicsMobileSdkPlugin.start(@NonNull result: MethodChannel.Result, arguments: Any?) {
    try {
        val properties = arguments as HashMap<*, *>
        val agentVersion = properties["version"] as String
        val agentName = properties["type"] as String
        val appKey = properties["appKey"] as? String
        val loggingLevel = properties["loggingLevel"] as? Int
        val collectorURL = properties["collectorURL"] as? String
        val screenshotURL = properties["screenshotURL"] as? String
        val screenshotsEnabled = properties["screenshotsEnabled"] as? Boolean
        val crashReportingEnabled = properties["crashReportingEnabled"] as? Boolean

        if (appKey == null) {
            result.error("500", "Please provide an appKey.", "Agent start() failed.")
            return
        }

        val builder: AgentConfiguration.Builder =
            AgentConfiguration.builder()
                .withAppKey(appKey)

        if (loggingLevel != null) {
            builder.withLoggingLevel(loggingLevel)
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

        if (crashReportCallback == null) {
            crashReportCallback = CrashCallbackObject(channel)
            builder.withCrashCallback(crashReportCallback)
        }

        builder.withAutoInstrument(false)
        builder.withApplicationName("com.appdynamics.FlutterEveryfeatureAndroid")
            .withContext(context)
        Instrumentation.startFromHybrid(builder.build(), agentName, agentVersion)

        result.success(null)
    } catch (e: RuntimeException) {
        result.error("500", e.message, "Agent start() failed.")
    }
}
