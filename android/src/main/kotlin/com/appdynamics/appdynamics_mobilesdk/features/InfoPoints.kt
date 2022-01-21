/*
 * Copyright (c) 2021. AppDynamics LLC and its affiliates.
 * All rights reserved.
 *
 */

package com.appdynamics.appdynamics_mobilesdk.features

import androidx.annotation.NonNull
import com.appdynamics.appdynamics_mobilesdk.AppDynamicsMobileSdkPlugin
import com.appdynamics.eumagent.runtime.Instrumentation
import io.flutter.plugin.common.MethodChannel
import org.json.JSONObject

fun AppDynamicsMobileSdkPlugin.beginCall(
    @NonNull result: MethodChannel.Result,
    arguments: Any?
) {
    val properties = arguments as HashMap<*, *>
    val callId = properties["callId"] as String
    val className = properties["className"] as? String
    val methodName = properties["methodName"] as? String
    val methodArgs = (properties["methodArgs"] as? ArrayList<*>) ?: emptyList<Any>()

    if (className == null) {
        result.error(
            "500",
            "Agent trackCall() failed.",
            "Please provide a valid class name."
        )
        return
    }

    if (methodName == null) {
        result.error(
            "500",
            "Agent trackCall() failed.",
            "Please provide a valid method name."
        )
        return
    }

    val tracker =
        Instrumentation.beginCall(false, className, methodName, *methodArgs.toTypedArray())
    callTrackers[callId] = tracker

    result.success(null)
}


fun AppDynamicsMobileSdkPlugin.endCallWithSuccess(
    @NonNull result: MethodChannel.Result,
    arguments: Any?
) {
    val properties = arguments as HashMap<*, *>
    val callId = properties["callId"] as String
    val value = properties["result"]

    val tracker = callTrackers[callId]
    tracker!!.reportCallEndedWithReturnValue(value);
    callTrackers.remove(callId)

    result.success(null)
}

fun AppDynamicsMobileSdkPlugin.endCallWithError(
    @NonNull result: MethodChannel.Result,
    arguments: Any?
) {
    val properties = arguments as HashMap<*, *>
    val callId = properties["callId"] as String
    val error = properties["error"] as HashMap<*, *>

    val dict = mutableMapOf<String, Any>("is_error" to true)
    val message = error["message"] as? String
    val stackTrace = error["stackTrace"] as? String


    if (message != null) {
        dict["message"] = message
    }

    if (stackTrace != null) {
        dict["stackTrace"] = stackTrace
    }

    val tracker = callTrackers[callId]
    tracker!!.reportCallEndedWithReturnValue(JSONObject(dict.toMap()).toString())
    callTrackers.remove(callId)

    result.success(null)
}