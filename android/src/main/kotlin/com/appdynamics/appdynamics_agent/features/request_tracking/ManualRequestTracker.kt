/*
 * Copyright (c) 2022. AppDynamics LLC and its affiliates.
 * All rights reserved.
 *
 */

package com.appdynamics.appdynamics_agent.features.request_tracking

import androidx.annotation.NonNull
import com.appdynamics.appdynamics_agent.AppDynamicsAgentPlugin
import com.appdynamics.eumagent.runtime.Instrumentation
import com.appdynamics.eumagent.runtime.ServerCorrelationHeaders
import io.flutter.plugin.common.MethodChannel
import java.net.MalformedURLException
import java.net.URL

fun AppDynamicsAgentPlugin.getRequestTrackerWithUrl(
    @NonNull result: MethodChannel.Result,
    arguments: Any?
) {
    val properties = arguments as HashMap<*, *>
    val id = properties["id"] as String

    val urlString = properties["url"] as? String ?: run {
        result.error(
            "500",
            "Agent getRequestTrackerWithUrl() failed.",
            "Please insert valid URL string."
        )
        return
    }

    val url = URL(urlString)
    requestTrackers[id] = Instrumentation.beginHttpRequest(url)
    result.success(null)
}

fun AppDynamicsAgentPlugin.setRequestTrackerErrorInfo(
    @NonNull result: MethodChannel.Result,
    arguments: Any?
) {
    val properties = arguments as HashMap<*, *>
    val id = properties["id"] as String

    val error = properties["errorDict"] as? HashMap<String, String> ?: run {
        result.error(
            "500",
            "Agent setRequestTrackerErrorInfo() failed.",
            "Please insert a valid error message."
        )
        return
    }

    val tracker = requestTrackers[id] ?: run {
        result.error(
            "500",
            "Agent setRequestTrackerErrorInfo() failed.",
            "Request tracker was not initialized or already reported."
        )
        return
    }

    tracker.withError(error["message"])
    result.success(null)
}

fun AppDynamicsAgentPlugin.setRequestTrackerStatusCode(
    @NonNull result: MethodChannel.Result,
    arguments: Any?
) {
    val properties = arguments as HashMap<*, *>
    val id = properties["id"] as String

    val tracker = requestTrackers[id] ?: run {
        result.error(
            "500",
            "Agent setRequestTrackerStatusCode() failed.",
            "Request tracker was not initialized or already reported."
        )
        return
    }

    val statusCode = properties["statusCode"] as? Int ?: run {
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

fun AppDynamicsAgentPlugin.setRequestTrackerResponseHeaders(
    @NonNull result: MethodChannel.Result,
    arguments: Any?
) {
    val properties = arguments as HashMap<*, *>
    val id = properties["id"] as String

    val tracker = requestTrackers[id] ?: run {
        result.error(
            "500",
            "Agent setRequestTrackerResponseHeaders() failed.",
            "Request tracker was not initialized or already reported."
        )
        return
    }

    val headers = properties["headers"] as? Map<String, List<String>> ?: run {
        result.error(
            "500",
            "Agent setRequestTrackerResponseHeaders() failed.",
            "Headers are not of type Map<String, String>."
        )
        return
    }

    tracker.withResponseHeaderFields(headers)
    result.success(null)
}

fun AppDynamicsAgentPlugin.setRequestTrackerRequestHeaders(
    @NonNull result: MethodChannel.Result,
    arguments: Any?
) {
    val properties = arguments as HashMap<*, *>
    val id = properties["id"] as String

    val tracker = requestTrackers[id] ?: run {
        result.error(
            "500",
            "Agent setRequestTrackerRequestHeaders() failed.",
            "Request tracker was not initialized or already reported."
        )
        return
    }

    val headers = properties["headers"] as? Map<String, List<String>> ?: run {
        result.error(
            "500",
            "Agent setRequestTrackerRequestHeaders() failed.",
            "Headers are not of type Map<String, String>."
        )
        return
    }

    tracker.withRequestHeaderFields(headers)
    result.success(null)
}

fun AppDynamicsAgentPlugin.requestTrackerReport(
    @NonNull result: MethodChannel.Result,
    arguments: Any?
) {
    val properties = arguments as HashMap<*, *>
    val id = properties["id"] as String

    val tracker = requestTrackers[id] ?: run {
        result.error(
            "500",
            "Agent requestTrackerReport() failed.",
            "Request tracker was not initialized or already reported."
        )
        return
    }

    tracker.reportDone()
    result.success(null)
}

fun AppDynamicsAgentPlugin.getServerCorrelationHeaders(
    @NonNull result: MethodChannel.Result,
    arguments: Any?
) {
    val headers = ServerCorrelationHeaders.generate()
    result.success(headers)
}