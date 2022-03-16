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

fun AppDynamicsAgentPlugin.leaveBreadcrumb(
    @NonNull result: MethodChannel.Result,
    arguments: Any?
) {
    val properties = arguments as HashMap<*, *>
    val breadcrumb = properties["breadcrumb"] as? String ?: run {
        result.error(
            "500",
            "leaveBreadcrumb() failed.",
            "Invalid breadcrumb string."
        )
        return
    }

    val mode = properties["mode"] as? Int ?: run {
        result.error(
            "500",
            "leaveBreadcrumb() failed.",
            "Invalid breadcrumb mode."
        )
        return
    }

    Instrumentation.leaveBreadcrumb(breadcrumb, mode)
    result.success(null)
}