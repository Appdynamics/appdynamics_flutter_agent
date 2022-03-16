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

fun AppDynamicsAgentPlugin.shutdownAgent(
    @NonNull result: MethodChannel.Result,
    arguments: Any?
) {
    Instrumentation.shutdownAgent();
    result.success(null)
}

fun AppDynamicsAgentPlugin.restartAgent(
    @NonNull result: MethodChannel.Result,
    arguments: Any?
) {
    Instrumentation.restartAgent();
    result.success(null)
}
