/*
 * Copyright (c) 2021. AppDynamics LLC and its affiliates.
 * All rights reserved.
 *
 */

package com.appdynamics.appdynamics_mobilesdk

import androidx.annotation.NonNull
import com.appdynamics.eumagent.runtime.Instrumentation
import com.appdynamics.eumagent.runtime.ServerCorrelationHeaders
import io.flutter.plugin.common.MethodChannel
import java.net.URL

fun AppDynamicsMobileSdkPlugin.getRequestTrackerWithUrl(
    @NonNull result: MethodChannel.Result,
    arguments: Any?
) {
    val urlString = arguments as? String

    if (urlString == null) {
        result.error(
            "500",
            "Agent getRequestTrackerWithUrl() failed.",
            "Please provide a valid URL."
        )
        return
    }

    val url = URL(urlString)
    customRequestTracker = Instrumentation.beginHttpRequest(url)
    result.success(null)
}

fun AppDynamicsMobileSdkPlugin.setRequestTrackerErrorInfo(
    @NonNull result: MethodChannel.Result,
    arguments: Any?
) {
    val tracker = customRequestTracker ?: run {
        result.error(
            "500",
            "Agent setRequestTrackerErrorInfo() failed.",
            "Request tracker was not initialized."
        )
        return
    }

    val error = arguments as? HashMap<String, String>
    val message = error?.get("message")

    if (message == null) {
        result.error(
            "500",
            "Agent setRequestTrackerErrorInfo() failed.",
            "Error 'message' is not a valid String."
        )
        return
    }

    tracker.withError(message)
    result.success(null)
}

fun AppDynamicsMobileSdkPlugin.setRequestTrackerStatusCode(
    @NonNull result: MethodChannel.Result,
    arguments: Any?
) {
    val tracker = customRequestTracker ?: run {
        result.error(
            "500",
            "Agent setRequestTrackerStatusCode() failed.",
            "Request tracker was not initialized."
        )
        return
    }

    val statusCode = arguments as? Int
    if (statusCode == null) {
        result.error(
            "500",
            "Agent setRequestTrackerStatusCode() failed.",
            "Status code must be an integer."
        )
        return
    }

    tracker.withResponseCode(statusCode)
    result.success(null)
}

fun AppDynamicsMobileSdkPlugin.setRequestTrackerResponseHeaders(
    @NonNull result: MethodChannel.Result,
    arguments: Any?
) {
    val tracker = customRequestTracker ?: run {
        result.error(
            "500",
            "Agent setRequestTrackerResponseHeaders() failed.",
            "Request tracker was not initialized."
        )
        return
    }

    val headers = arguments as? Map<String, String> ?: run {
        result.error(
            "500",
            "Agent setRequestTrackerResponseHeaders() failed.",
            "Headers are not of type Map<String, String>."
        )
        return
    }
    val listHeaders: Map<String, List<String>> = headers.entries.associate { it.key to listOf(it.value) }

    tracker.withResponseHeaderFields(listHeaders)
    result.success(null)
}

fun AppDynamicsMobileSdkPlugin.setRequestTrackerRequestHeaders(
    @NonNull result: MethodChannel.Result,
    arguments: Any?
) {
    val tracker = customRequestTracker ?: run {
        result.error(
            "500",
            "Agent setRequestTrackerRequestHeaders() failed.",
            "Request tracker was not initialized."
        )
        return
    }

    val headers = arguments as? Map<String, String> ?: run {
        result.error(
            "500",
            "Agent setRequestTrackerRequestHeaders() failed.",
            "Headers are not of type Map<String, String>."
        )
        return
    }
    val listHeaders: Map<String, List<String>> = headers.entries.associate { it.key to listOf(it.value) }

    tracker.withRequestHeaderFields(listHeaders)
    result.success(null)
}

fun AppDynamicsMobileSdkPlugin.requestTrackerReport(
    @NonNull result: MethodChannel.Result,
    arguments: Any?
) {
    val tracker = customRequestTracker ?: run {
        result.error(
            "500",
            "Agent requestTrackerReport() failed.",
            "Request tracker was not initialized."
        )
        return
    }

    tracker.reportDone()
    result.success(null)
}


fun AppDynamicsMobileSdkPlugin.getServerCorrelationHeaders(
    @NonNull result: MethodChannel.Result,
    arguments: Any?
) {
    val listHeaders = ServerCorrelationHeaders.generate()
    val headers: Map<String, String> = listHeaders.entries.associate { it.key to it.value[0] }
    result.success(headers)
}