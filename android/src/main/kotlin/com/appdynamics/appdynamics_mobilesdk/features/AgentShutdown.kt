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

fun AppDynamicsMobileSdkPlugin.shutdownAgent(
    @NonNull result: MethodChannel.Result,
    arguments: Any?
) {
    Instrumentation.shutdownAgent();
    result.success(null)
}

fun AppDynamicsMobileSdkPlugin.restartAgent(
    @NonNull result: MethodChannel.Result,
    arguments: Any?
) {
    Instrumentation.restartAgent();
    result.success(null)
}
