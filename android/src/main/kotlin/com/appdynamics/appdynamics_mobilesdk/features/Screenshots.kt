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

fun AppDynamicsMobileSdkPlugin.takeScreenshot(
    @NonNull result: MethodChannel.Result,
    arguments: Any?
) {
    Instrumentation.takeScreenshot()
    result.success(null)
}

fun AppDynamicsMobileSdkPlugin.blockScreenshots(
    @NonNull result: MethodChannel.Result,
    arguments: Any?
) {
    Instrumentation.blockScreenshots()
    result.success(null)
}

fun AppDynamicsMobileSdkPlugin.unblockScreenshots(
    @NonNull result: MethodChannel.Result,
    arguments: Any?
) {
    Instrumentation.unblockScreenshots()
    result.success(null)
}

fun AppDynamicsMobileSdkPlugin.screenshotsBlocked(
    @NonNull result: MethodChannel.Result,
    arguments: Any?
) {
    val status = Instrumentation.screenshotsBlocked()
    result.success(status)
}