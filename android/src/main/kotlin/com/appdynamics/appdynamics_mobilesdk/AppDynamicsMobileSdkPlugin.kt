package com.appdynamics.appdynamics_mobilesdk

import androidx.annotation.NonNull
import com.appdynamics.appdynamics_mobilesdk.features.*
import com.appdynamics.appdynamics_mobilesdk.features.user_data.*
import com.appdynamics.eumagent.runtime.CallTracker
import com.appdynamics.eumagent.runtime.HttpRequestTracker
import com.appdynamics.eumagent.runtime.SessionFrame
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
    internal lateinit var channel: MethodChannel
    internal lateinit var context: android.content.Context
    internal var customRequestTracker: HttpRequestTracker? = null
    internal var crashReportCallback: CrashCallbackObject? = null
    internal var sessionFrames: MutableMap<String, SessionFrame> = mutableMapOf()
    internal var callTrackers: MutableMap<String, CallTracker> = mutableMapOf()

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
            "requestTrackerReport" to ::requestTrackerReport,

            // Custom timers
            "startTimer" to ::startTimer,
            "stopTimer" to ::stopTimer,

            // Breadcrumbs
            "leaveBreadcrumb" to ::leaveBreadcrumb,

            // Report error
            "reportError" to ::reportError,

            // Report metric
            "reportMetric" to ::reportMetric,

            // User data
            "setUserData" to ::setUserData,
            "setUserDataBoolean" to ::setUserDataBoolean,
            "setUserDataLong" to ::setUserDataLong,
            "setUserDataDouble" to ::setUserDataDouble,
            "setUserDataDate" to ::setUserDataDate,
            "removeUserData" to ::removeUserData,
            "removeUserDataBoolean" to ::removeUserDataBoolean,
            "removeUserDataLong" to ::removeUserDataLong,
            "removeUserDataDouble" to ::removeUserDataDouble,
            "removeUserDataDate" to ::removeUserDataDate,

            // Session frames
            "startSessionFrame" to ::startSessionFrame,
            "updateSessionFrameName" to ::updateSessionFrameName,
            "endSessionFrame" to ::endSessionFrame,

            // Screenshots
            "takeScreenshot" to ::takeScreenshot,
            "blockScreenshots" to ::blockScreenshots,
            "unblockScreenshots" to ::unblockScreenshots,
            "screenshotsBlocked" to ::screenshotsBlocked,

            // Shutdown & restart
            "shutdownAgent" to ::shutdownAgent,
            "restartAgent" to ::restartAgent,

            // Programmatic session control
            "startNextSession" to ::startNextSession,

            // Info points
            "beginCall" to ::beginCall,
            "endCallWithSuccess" to ::endCallWithSuccess,
            "endCallWithError" to ::endCallWithError
            )

        methods[call.method]?.let { method ->
            method(result, call.arguments)
        } ?: run {
            result.notImplemented()
        }
    }
}
