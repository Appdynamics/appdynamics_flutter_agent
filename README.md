[![Pub Version](https://img.shields.io/pub/v/appdynamics_agent)](https://pub.dev/packages/appdynamics_agent)

# AppDynamics Flutter Plugin

Extension of the AppDynamics SDK that allows you to instrument Flutter apps and receive analytics.

This plugin wraps the native SDKs and requires a valid AppDynamics mobile license.

## Features

The Flutter agent incorporates the following features:

* Network request tracking via
  the [TrackedHTTPClient](https://pub.dev/documentation/appdynamics_agent/latest/appdynamics_agent/TrackedHttpClient-class.html)
  and [RequestTracker](https://pub.dev/documentation/appdynamics_agent/latest/appdynamics_agent/RequestTracker-class.html)
  classes.
* Automatic crash reporting
  and [CrashReportCallback](https://pub.dev/documentation/appdynamics_agent/latest/appdynamics_agent/CrashReportCallback.html)
  for extra crash report configuration.
* Screen tracking
  via [NavigationObserver](https://pub.dev/documentation/appdynamics_agent/latest/appdynamics_agent/NavigationObserver-class.html)
  and [WidgetTracker](https://pub.dev/documentation/appdynamics_agent/latest/appdynamics_agent/WidgetTracker-class.html).
* Automatic detection and reporting of the app-is-not-responding cases (ANR).
* [SessionFrame](https://pub.dev/documentation/appdynamics_agent/latest/appdynamics_agent/SessionFrame-class.html)
  mechanism to track custom user flows in the app.
* [Errors](https://pub.dev/documentation/appdynamics_agent/latest/appdynamics_agent/Instrumentation/errorHandler.html)
  and [custom metrics](https://pub.dev/documentation/appdynamics_agent/latest/appdynamics_agent/Instrumentation/reportMetric.html)
  reporting.
* Automatic capture of screenshots and user touch-points (iOS only).
* Custom user data on network requests, crash reports, or sessions.
* Report [breadcrumbs](https://pub.dev/documentation/appdynamics_agent/latest/appdynamics_agent/Instrumentation/leaveBreadcrumb.html)
to track UI widgets or custom user interactions.
* [Timers](https://pub.dev/documentation/appdynamics_agent/latest/appdynamics_agent/Instrumentation/startTimer.html)
  to track events that span across multiple methods.
* Mark method execution
  as [info points](https://pub.dev/documentation/appdynamics_agent/latest/appdynamics_agent/Instrumentation/trackCall.html).
* Split app instrumentation
  into [multiple sessions](https://pub.dev/documentation/appdynamics_agent/latest/appdynamics_agent/Instrumentation/startNextSession.html).
* Automatically report device metrics (memory, storage, battery) and connection transition events.

# Getting started

## Installation

You can install the Flutter plugin via `flutter` — more info on
the [Installation tab](https://pub.dev/packages/appdynamics_agent/install).

```
$ flutter pub add appdynamics_agent
```

## Extra configuration for Android apps:

1. Add the following changes to `android/build.gradle`:

```groovy
dependencies {
    classpath "com.appdynamics:appdynamics-gradle-plugin:22.2.2"
    // ... other dependencies
}
```

2. Apply the `adeum` plugin to the bottom of the `android/app/build.gradle` file:

```groovy
dependencies {
    // ... project dependencies
}

// Bottom of file
apply plugin: 'adeum'
```

3. Add the following permissions to your `AndroidManifest.xml` (usually in `android/src/main/`):

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.example.myawesomepackage">

    <!-- add these two permissions -->
    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />

    <!-- other permissions -->

    <application>
        <!-- other settings -->
    </application>
</manifest>
```

## Start instrumentation

> **_NOTE:_** Replace `<EUM_APP_KEY>` with your app key.

```dart
import 'package:appdynamics_agent/appdynamics_agent.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final config = AgentConfiguration(
      appKey: "<EUM_APP_KEY>",
      loggingLevel: LoggingLevel.verbose, // optional, for better debugging.
      collectorURL: "<COLLECTOR_URL>", // optional, mostly on-premises. 
      screenshotURL: "<SCREENSHOT_URL>" // optional, mostly on-premises.
  );
  await Instrumentation.start(config);

  runApp(const MyApp());
}
 ```

# Docs

You can access [pub.dev docs](https://pub.dev/documentation/appdynamics_agent/latest/) or check
the [official docs](https://docs.appdynamics.com/22.3/en/end-user-monitoring/mobile-real-user-monitoring/instrument-flutter-applications/customize-the-flutter-instrumentation)
for extra customization of the agent.
