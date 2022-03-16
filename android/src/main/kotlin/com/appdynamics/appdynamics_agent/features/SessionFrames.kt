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

fun AppDynamicsAgentPlugin.startSessionFrame(
    @NonNull result: MethodChannel.Result,
    arguments: Any?
) {
    val properties = arguments as HashMap<*, *>
    val name = properties["name"] as? String
    val id = properties["id"] as? String

    if (name == null) {
        result.error(
            "500",
            "Agent startSessionFrame() failed.",
            "Please provide a valid session name."
        )
        return
    }

    if (id == null) {
        result.error(
            "500",
            "Agent startSessionFrame() failed.",
            "Please provide a valid session ID."
        )
        return
    }

    val sessionFrame = Instrumentation.startSessionFrame(name)
    sessionFrames[id] = sessionFrame

    result.success(null)
}

fun AppDynamicsAgentPlugin.updateSessionFrameName(
    @NonNull result: MethodChannel.Result,
    arguments: Any?
) {
    val properties = arguments as HashMap<*, *>
    val newName = properties["newName"] as? String
    val id = properties["id"] as? String

    if (newName == null) {
        result.error(
            "500",
            "Agent updateSessionFrame() failed.",
            "Please provide a valid session name."
        )
        return
    }

    if (id == null) {
        result.error(
            "500",
            "Agent updateSessionFrame() failed.",
            "Please provide a valid session ID."
        )
        return
    }

    sessionFrames[id]?.updateName(newName)
    result.success(null)
}

fun AppDynamicsAgentPlugin.endSessionFrame(
    @NonNull result: MethodChannel.Result,
    arguments: Any?
) {
    val id = arguments as? String

    if (id == null) {
        result.error(
            "500",
            "Agent endSessionFrame() failed.",
            "Please provide a valid session ID."
        )
        return
    }

    if (sessionFrames.containsKey(id)) {
        sessionFrames[id]?.end()
        sessionFrames.remove(id)
    }
    result.success(null)
}