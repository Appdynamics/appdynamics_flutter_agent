package com.appdynamics.appdynamics_mobilesdk

import androidx.annotation.NonNull
import com.appdynamics.eumagent.runtime.AgentConfiguration
import com.appdynamics.eumagent.runtime.HttpRequestTracker
import com.appdynamics.eumagent.runtime.Instrumentation
import com.appdynamics.eumagent.runtime.ServerCorrelationHeaders
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import kotlin.reflect.KFunction2

open class AppDynamicsMobileSdkPlugin : FlutterPlugin, MethodCallHandler {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private lateinit var context: android.content.Context
    internal var customRequestTracker: HttpRequestTracker? = null

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        context = flutterPluginBinding.applicationContext
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "appdynamics_mobilesdk")
        channel.setMethodCallHandler(this)
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        val methods: Map<String, KFunction2<Result, Any?, Unit>> = mapOf(
            "start" to ::start,

            // Manual request tracking
            "getRequestTrackerWithUrl" to ::getRequestTrackerWithUrl,
            "setRequestTrackerErrorInfo" to ::setRequestTrackerErrorInfo,
            "setRequestTrackerStatusCode" to ::setRequestTrackerStatusCode,
            "setRequestTrackerResponseHeaders" to ::setRequestTrackerResponseHeaders,
            "setRequestTrackerRequestHeaders" to ::setRequestTrackerRequestHeaders,
            "getServerCorrelationHeaders" to ::getServerCorrelationHeaders,
            "requestTrackerReport" to ::requestTrackerReport
        )

        methods[call.method]?.let { method ->
            method(result, call.arguments)
        } ?: run {
            result.notImplemented()
        }
    }

    // region Agent methods

    private fun start(@NonNull result: Result, arguments: Any?) {
        try {
            val properties = arguments as HashMap<*, *>
            val agentVersion = properties["version"] as String
            val agentName = properties["type"] as String
            val appKey = properties["appKey"] as? String
            val loggingLevel = properties["loggingLevel"] as? Int
            val collectorURL = properties["collectorURL"] as? String

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

            if (collectorURL != null) {
                builder.withCollectorURL(collectorURL)
            }

            builder.withApplicationName("com.appdynamics.FlutterEveryfeatureAndroid")
            Instrumentation.startFromHybrid(builder.build(), agentName, agentVersion)

            result.success(null)
        } catch (e: RuntimeException) {
            result.error("500", e.message, "Agent start() failed.")
        }
    }


    // endregion
}
