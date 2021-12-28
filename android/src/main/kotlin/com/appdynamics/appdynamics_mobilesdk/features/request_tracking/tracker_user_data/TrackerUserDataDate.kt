/*
 * Copyright (c) 2021. AppDynamics LLC and its affiliates.
 * All rights reserved.
 *
 */

package com.appdynamics.appdynamics_mobilesdk.features.request_tracking.tracker_user_data

import androidx.annotation.NonNull
import com.appdynamics.appdynamics_mobilesdk.AppDynamicsMobileSdkPlugin
import io.flutter.plugin.common.MethodChannel
import java.text.SimpleDateFormat
import java.util.*

@Suppress("SpellCheckingInspection")
fun AppDynamicsMobileSdkPlugin.setRequestTrackerUserDataDate(
    @NonNull result: MethodChannel.Result,
    arguments: Any?
) {
    val properties = arguments as HashMap<*, *>
    val id = properties["id"] as String

    val tracker = requestTrackers[id] ?: run {
        result.error(
            "500",
            "Agent setRequestTrackerUserDataDate() failed.",
            "Request tracker was not initialized or already reported."
        )
        return
    }

    val key = properties["key"] as? String ?: run {
        result.error(
            "500",
            "Agent setRequestTrackerUserDataDate() failed.",
            "Please provide a valid string for `key`."
        )
        return
    }

    val value = properties["value"] as? String ?: run {
        result.error(
            "500",
            "Agent setRequestTrackerUserDataDate() failed.",
            "Please provide a valid DateTime for `value`."
        )
        return
    }

    val date = SimpleDateFormat(
        dateFormat,
        Locale.US
    ).parse(value) ?: run {
        result.error(
            "500",
            "Agent setRequestTrackerUserDataDate() failed.",
            "Please provide a valid DateTime for `value`."
        )
        return
    }

    tracker.withUserDataDate(key, date)
    result.success(null)
}
