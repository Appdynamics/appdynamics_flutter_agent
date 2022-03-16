/*
 * Copyright (c) 2022. AppDynamics LLC and its affiliates.
 * All rights reserved.
 *
 */

package com.appdynamics.appdynamics_agent.features

import android.os.Handler
import android.os.Looper
import androidx.annotation.NonNull
import com.appdynamics.appdynamics_agent.AppDynamicsAgentPlugin
import io.flutter.plugin.common.MethodChannel

fun AppDynamicsAgentPlugin.sleep(@NonNull result: MethodChannel.Result, arguments: Any?) {
    val properties = arguments as HashMap<*, *>
    val seconds = properties["seconds"] as Number
    Thread.sleep(seconds.toLong() * 1000)
    result.success(null)
}

fun AppDynamicsAgentPlugin.crash(@NonNull result: MethodChannel.Result, arguments: Any?) {
    Handler(Looper.getMainLooper()).postDelayed(Runnable {
        throw java.lang.RuntimeException("AppDynamics native crash");
    }, 50)
    result.success(null);
}