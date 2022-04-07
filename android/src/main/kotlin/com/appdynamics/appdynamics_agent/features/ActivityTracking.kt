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
import java.text.SimpleDateFormat
import java.util.*

fun AppDynamicsAgentPlugin.trackPageStart(
    @NonNull result: MethodChannel.Result,
    arguments: Any?
) {
    val properties = arguments as HashMap<*, *>
    val pageName = properties["widgetName"] as? String
    val uuid = UUID.randomUUID()

    val startDate = properties["startDate"] as String
    val start = SimpleDateFormat(
        dateFormat,
        Locale.US
    ).parse(startDate)!!.time

    Instrumentation.trackPageStart(pageName, uuid, start)
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

    val startDate = properties["startDate"] as String
    val start = SimpleDateFormat(
        dateFormat,
        Locale.US
    ).parse(startDate)!!.time

    val endDate = properties["endDate"] as String
    val end = SimpleDateFormat(
        dateFormat,
        Locale.US
    ).parse(endDate)!!.time

    Instrumentation.trackPageEnd(pageName, uuid, start, end)
    result.success(null)
}
