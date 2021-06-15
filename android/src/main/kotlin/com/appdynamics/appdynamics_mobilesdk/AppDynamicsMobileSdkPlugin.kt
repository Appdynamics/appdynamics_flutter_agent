package com.appdynamics.appdynamics_mobilesdk

import androidx.annotation.NonNull
import com.appdynamics.eumagent.runtime.AgentConfiguration
import com.appdynamics.eumagent.runtime.Instrumentation
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result


class AppDynamicsMobileSdkPlugin : FlutterPlugin, MethodCallHandler {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private lateinit var context: android.content.Context

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        context = flutterPluginBinding.applicationContext;
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "appdynamics_mobilesdk")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "start" -> start(result, call.arguments)
            else -> result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    // region Agent methods

    private fun start(@NonNull result: Result, arguments: Any) {
        try {
            val properties = arguments as HashMap<String, Any>
            val agentVersion = properties["version"] as String
            val agentName = properties["type"] as String
            val appKey = properties["appKey"] as? String
            val loggingLevel = properties["loggingLevel"] as? Int

            if (appKey == null) {
                result.error("500", "Please provide an appKey.", "Agent start() failed.")
                return
            }

            val builder: AgentConfiguration.Builder =
                    AgentConfiguration.builder()
                            .withAppKey(appKey)
                            .withContext(context)

            if (loggingLevel != null) {
                builder.withLoggingLevel(loggingLevel)
            }
            Instrumentation.startFromHybrid(builder.build(), agentName, agentVersion)

            result.success(null)
        } catch (e: RuntimeException) {
            result.error("500", e.message, "Agent start() failed.")
        }
    }
    // endregion
}
