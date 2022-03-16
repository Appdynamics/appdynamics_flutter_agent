/*
 * Copyright (c) 2022. AppDynamics LLC and its affiliates.
 * All rights reserved.
 *
 */

package com.appdynamics.appdynamics_agent.features

import com.appdynamics.eumagent.runtime.CrashReportCallback
import com.appdynamics.eumagent.runtime.CrashReportSummary
import io.flutter.plugin.common.MethodChannel

class CrashCallbackObject(private val channel: MethodChannel) : CrashReportCallback {
    override fun onCrashesReported(summaries: Collection<CrashReportSummary>) {
        val serializableSummaries = summaries.map { summary ->
            mapOf(
                "crashId" to summary.crashId,
                "exceptionName" to summary.exceptionClass,
                "exceptionReason" to summary.exceptionMessage
            )
        }
        channel.invokeMethod("onCrashReported", serializableSummaries)
    }
}