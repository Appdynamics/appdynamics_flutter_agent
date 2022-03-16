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

fun AppDynamicsAgentPlugin.takeScreenshot(
    @NonNull result: MethodChannel.Result,
    arguments: Any?
) {
    Instrumentation.takeScreenshot()
    result.success(null)
}

fun AppDynamicsAgentPlugin.blockScreenshots(
    @NonNull result: MethodChannel.Result,
    arguments: Any?
) {
    Instrumentation.blockScreenshots()
    result.success(null)
}

fun AppDynamicsAgentPlugin.unblockScreenshots(
    @NonNull result: MethodChannel.Result,
    arguments: Any?
) {
    Instrumentation.unblockScreenshots()
    result.success(null)
}

fun AppDynamicsAgentPlugin.screenshotsBlocked(
    @NonNull result: MethodChannel.Result,
    arguments: Any?
) {
    val status = Instrumentation.screenshotsBlocked()
    result.success(status)
}