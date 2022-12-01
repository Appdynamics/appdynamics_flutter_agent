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
import java.util.*

fun AppDynamicsAgentPlugin.trackPageStart(
    @NonNull result: MethodChannel.Result,
    arguments: Any?
) {
    val properties = arguments as HashMap<*, *>
    val pageName = properties["widgetName"] as? String
    val startDate = properties["startDate"] as Long
    val uuid = UUID.randomUUID()

    Instrumentation.trackPageStart(pageName, uuid, startDate)
    result.success(uuid.toString())
}

fun AppDynamicsAgentPlugin.trackPageEnd(
    @NonNull result: MethodChannel.Result,
    arguments: Any?
) {
    val properties = arguments as HashMap<*, *>
    val pageName = properties["widgetName"] as? String
    val uuidString = properties["uuidString"] as String
    val uuid = UUID.fromString(uuidString)

    val startDate = properties["startDate"] as Long
    val endDate = properties["endDate"] as Long

    Instrumentation.trackPageEnd(pageName, uuid, startDate, endDate)
    result.success(null)
}
