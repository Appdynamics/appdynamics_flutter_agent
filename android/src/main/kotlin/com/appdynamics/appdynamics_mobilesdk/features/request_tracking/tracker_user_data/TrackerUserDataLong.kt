/*
 * Copyright (c) 2021. AppDynamics LLC and its affiliates.
 * All rights reserved.
 *
 */

package com.appdynamics.appdynamics_mobilesdk.features.request_tracking.tracker_user_data

import androidx.annotation.NonNull
import com.appdynamics.appdynamics_mobilesdk.AppDynamicsMobileSdkPlugin
import io.flutter.plugin.common.MethodChannel
import java.lang.Exception
import java.util.*

fun AppDynamicsMobileSdkPlugin.setRequestTrackerUserDataLong(
    @NonNull result: MethodChannel.Result,
    arguments: Any?
) {
    val properties = arguments as HashMap<*, *>
    val id = properties["id"] as String

    val tracker = requestTrackers[id] ?: run {
        result.error(
            "500",
            "Agent setRequestTrackerUserDataLong() failed.",
            "Request tracker was not initialized or already reported."
        )
        return
    }

    val key = properties["key"] as? String ?: run {
        result.error(
            "500",
            "Agent setRequestTrackerUserDataLong() failed.",
            "Please provide a valid string for `key`."
        )
        return
    }

    try {
        val value = properties["value"].toString().toLong()
        tracker.withUserDataLong(key, value)
        result.success(null)
    } catch (e: Exception) {
        result.error(
            "500",
            "Agent setRequestTrackerUserDataLong() failed.",
            e.message
        )
    }
}
