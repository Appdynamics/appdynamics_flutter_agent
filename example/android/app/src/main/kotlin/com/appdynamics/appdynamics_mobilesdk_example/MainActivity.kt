package com.appdynamics.appdynamics_mobilesdk_example

import io.flutter.embedding.android.FlutterActivity
import androidx.annotation.NonNull
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.appdynamics.flutter.example"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "sleep" -> sleep(result, call.arguments)
                else -> result.notImplemented()
            }
        }
    }

    // region Custom methods

    private fun sleep(@NonNull result: MethodChannel.Result, arguments: Any) {
        val seconds = arguments as Number
        Thread.sleep(seconds.toLong() * 1000)
        result.success(null)
    }

}
