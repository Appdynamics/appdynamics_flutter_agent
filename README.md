# AppDynamics Flutter Plugin

Extension of the AppDynamics SDK that allows you to instrument Flutter apps and receive analytics.

This plugin wraps the native SDKs and requires a valid AppDynamics mobile license.

## Features

The Flutter agent incorporates the following features:
  * Network request tracking via the [TrackedHTTPClient]() and [RequestTracker]() classes.
  * Automatic crash reporting and [CrashReportCallback]() for extra crash report configuration.
  * Screen tracking via [NavigationObserver]() and [WidgetTracker]().
  * Automatic detection and reporting of the app-is-not-responding cases (ANR).
  * [SessionFrame]() mechanism to track custom user flows in the app.
  * [Errors]() and [custom metrics]() reporting.
  * Automatic capture of screenshots and user touch-points. (iOS only)
  * Custom user data on network requests, crash reports, or sessions.
  * Report [breadcrumbs]() to track UI widgets or custom user interactions.
  * [Timers]() to track events that span across multiple methods.
  * Mark method execution as [info points]().
  * Split app instrumentation into [multiple sessions]().
  * Automatically report device metrics (memory, storage, battery) and connection transition events.

# Getting started

## Installation
You can install the Flutter plugin via `flutter` — more info on the [Installation tab]().

```
$ flutter pub add appdynamics_agent
```

## Extra configuration for Android apps:

1. Add the following changes to `android/build.gradle`:

```kotlin
dependencies {
    classpath "com.appdynamics:appdynamics-gradle-plugin:22.2.2"
    // ... other dependencies
}
```

2. Apply the `adeum` plugin to the bottom of the `android/app/build.gradle` file:

```kotlin
dependencies {
    // ... project dependencies
}

// Bottom of file
apply plugin: 'adeum'
```

3. Add the following permissions to your AndroidManifest.xml (usually in android/src/main/):
   
```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
package="com.example.myawesomepackage">
    
    <!-- add these two permissions -->
    <uses-permission android:name="android.permission.INTERNET" /> 
    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
    <application>
    <!-- other settings -->
```

## Start instrumentation

> **_NOTE:_** Replace `<EUM_LICENSE_KEY>` with your app key.

```dart
import 'package:appdynamics_agent/appdynamics_agent.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final config = AgentConfiguration(
      appKey: "<EUM_LICENSE_KEY>",
      loggingLevel: LoggingLevel.verbose // optional, for better debugging.
  );
  await Instrumentation.start(config);
     
  runApp(const MyApp());
}
 ```

# Docs
You can access [pub.dev docs]() or check the [official docs]() for extra customization of the agent.
