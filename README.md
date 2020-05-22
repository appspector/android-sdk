# [![AppSpector](images/github-cover.png)](https://appspector.com?utm_source=android_readme)

With AppSpector you can remotely debug your app running in the same room or on another continent.
You can measure app performance, view database content, logs, network requests and many more in realtime.
This is the instrument that you've been looking for. Don't limit yourself only to simple logs.
Debugging doesn't have to be painful!

* [Installation](#installation)
  * [Gradle dependency](#add-appspector-sdk-to-your-project)
  * [Initialize AppSpector](#initialize-appspector-sdk)
  * [Use End-To-End Encryption to protect your data](#use-end-to-end-encryption-to-protect-your-data)
  * [Build and Run](#build-and-run)
* [Configure](#configure)
  * [SDK start/stop](#sdk-startstop)
  * [Custom device name](#custom-device-name)
  * [Support SQLCipher](#support-sqlcipher)
  * [Filtering your data](#filtering-your-data)
    * [Filtering HTTP requests and responses](#filtering-http-requests-and-responses)
    * [Filtering SharedPreferences values and files](#filtering-sharedpreferences-values-and-files)
    * [Filtering Logs](#filtering-logs)
    * [Applying filters](#applying-filters)
  * [Getting session URL](#getting-session-url)
  * [Disable background data collection](#disable-background-data-collection)
  * [Using OkHttp interceptor instead of AppSpector Gradle Plugin](#using-okhttp-interceptor-instead-of-appspector-gradle-plugin)
* [Features](#features)

# Installation

Each app you want to use with AppSpector SDK you have to register on our
service through the web ([https://app.appspector.com](https://app.appspector.com?utm_source=android_readme))
or the [desktop app](https://appspector.com/download/?utm_source=android_readme).
After adding the application navigate to app settings and copy API key.

## Add AppSpector SDK to your project
<!-- integration-manual-start -->
[![GitHub release](https://img.shields.io/github/release/appspector/android-sdk.svg)](https://github.com/appspector/android-sdk/releases)

#### Add AppSpector dependency to buildscript in your project-level build.gradle
```groovy
buildscript {
  repositories {
      jcenter()
      google()
      maven { url "https://maven.appspector.com/artifactory/android-sdk" }
  }
  
  dependencies {
      classpath "com.appspector:android-sdk-plugin:1.+"
  }
}
```

#### Modify your app-level build.gradle
```groovy
apply plugin: 'com.android.application'
// Put AppSpector plugin after Android plugin
apply plugin: 'com.appspector.sdk'

// Add AppSpector maven repository
repositories {
    maven { url "https://maven.appspector.com/artifactory/android-sdk" }
}

dependencies {
    implementation "com.appspector:android-sdk:1.+"
}
```

In case when you don't want to have AppSpector SDK in your release APK use AppSpector NO-OP artifact
```groovy
dependencies {
    debugImplementation "com.appspector:android-sdk:1.+"
    releaseImplementation "com.appspector:android-sdk-noop:1.+"
}
```
<!-- integration-manual-end -->

## Initialize AppSpector SDK
<!-- initialization-manual-start -->
```java
import android.app.Application;

import com.appspector.sdk.AppSpector;

public class AmazingApp extends Application {

   @Override
   public void onCreate() {
      super.onCreate();
      
      // We recommend to start AppSpector from Application#onCreate method
      
      // You can start all monitors
      AppSpector
            .build(this)
            .withDefaultMonitors()            
            .run("API_KEY");
            
      // Or you can select monitors that you want to use
      AppSpector
            .build(this)
            .addPerformanceMonitor()
            .addHttpMonitor()
            // If specific monitor is not added then this kind of data won't be tracked and available on the web
            .addLogMonitor()
            .addScreenshotMonitor()
            .addSQLMonitor()
            .run("API_KEY");
   }

}
```
<!-- initialization-manual-end -->


## Use End-To-End encryption to protect your data

AppSpector SDK collects and stores user data including logs, database content
and network traffic. All of this can contain sensitive data so to protect
your privacy we offer an additional module with E2EE feature. It allows
you to encrypt all data AppSpector sends from or to your device and be sure
only you can decrypt it. Due to security reasons encrypted sessions are only
available in [desktop application](https://appspector.com/download/?utm_source=android_readme).

To use encryption you must select the `Enable End-To-End encryption` option
during the registration of your app using [desktop application](https://appspector.com/download/?utm_source=android_readme)
(previously registered application can't be updated to support encryption).

After that, you need to add the `android-sdk-encryption` module to your
dependencies declaration. So, your app-level `build.gradle` should contain the next lines:

```groovy
apply plugin: 'com.android.application'
// Put AppSpector plugin after Android plugin
apply plugin: 'com.appspector.sdk'

// Add AppSpector maven repository
repositories {
    maven { url "https://maven.appspector.com/artifactory/android-sdk" }
}

dependencies {
    implementation "com.appspector:android-sdk:1.+"
    implementation 'com.appspector:android-sdk-encryption:1.+'
}
```

Finally, enable encryption by putting the `enableEncryption` to SDK
configuration. The client `Public Key` you can find on the application settings screen.

<!-- e2e-start -->
```java
AppSpector
            .build(this)
            .withDefaultMonitors() 
            .enableEncryption("CLIENT_PUBLIC_KEY")
            .run("API_KEY");
```

<!-- e2e-end -->


## Build and Run

Build your project and see everything work! When your app is up and running you can go to [https://app.appspector.com](https://app.appspector.com?utm_source=android_readme) and connect to your application session.


# Configure

## SDK start/stop

After calling the `run` method the SDK starts data collection and
data transferring to the web service. From that point you can see
your session in the AppSpector client.

Since we recommend to keep SDK initialization in the `onCreate()` method
of your [Application](https://developer.android.com/reference/android/app/Application),
the SDK provides methods to help you control AppSpector state by
calling `stop()` and `start()` methods.
**You are able to use these methods only after AppSpector was initialized.**

The `stop()` tells AppSpector to disable all data collection and close current session.

```java
AppSpector.shared().stop();
```

The `start()` starts it again using config you provided at initialization.

```java
AppSpector.shared().start();
```

**As the result new session will be created and all activity between
`stop()` and `start()` calls will not be tracked.**

To check AppSpector state you can use `isStarted()` method.

```java
AppSpector.shared().isStarted();
```

## Custom device name

You can assign a custom name to your device to easily find needed sessions
in the sessions list. To do this you should add the desired name as a value
for `AppSpector.METADATA_KEY_DEVICE_NAME` key to the `metadata` dictionary:

```java
AppSpector
            .build(this)
            .withDefaultMonitors()
            .addMetadata(AppSpector.METADATA_KEY_DEVICE_NAME, "YOUR_DEVICE_NAME")
            .run("YOUR_API_KEY");
```

Also, the SDK allows managing the device name during application lifetime using

the `setMetadataValue` method to change device name

```java
AppSpector.shared().setMetadataValue(AppSpector.METADATA_KEY_DEVICE_NAME, "NEW_DEVICE_NAME");
```

or the `removeMetadataValue` to remove your custom device name

```java
AppSpector.shared().removeMetadataValue(AppSpector.METADATA_KEY_DEVICE_NAME);
```

## Support SQLCipher
For browsing and running SQL queries in the SQLCipher database you need to perform a couple of additional steps.
First of all, add the `sqlcipher-extension` module to your `app/build.gradle` file under the main sdk module. So, it'll look like that:

```groovy
dependencies {
    implementation 'com.appspector:android-sdk:+'
    implementation 'com.appspector:sqlcipher-extension::+'
}
```

After that, create DatabaseConnectionFactory and pass it as an argument of the `addSQLMonitor` method.

Let's imagine your project contains SQLCipher database with "my_encrypted_db" name and other SQLite ones:

```java
AppSpector
            .build(this)
            .withDefaultMonitors()
            .addSQLMonitor(new SQLiteMonitor.DatabaseConnectionFactory() {
                @NonNull
                @Override
                public DatabaseConnection createDatabaseConnection(@NonNull Database database) {
                    if ("my_encrypted_db".equals(database.name)) {
                        return new SQLCipherDatabaseConnection(database, "password");
                    }
                    return new SQLiteDatabaseConnection(database);
                }
            })
            .run("YOUR_API_KEY");
```


## Filtering your data
Sometimes you may want to adjust or completely skip some pieces of data AppSpector gather. 

### Filtering HTTP requests and responses
For this aim, the HTTP monitor provides the interface `HTTPFilter` which can be pass to `addHttpMonitor(HTTPFilter)` method.

Let's say we want to skip our auth token from requests headers. Here is a sample of this filter:
```java
public class TokenFilter implements HTTPFilter {
    @Nullable
    @Override
    public HttpRequest filter(HttpRequest request) {
        if (request.getHeaders().containsKey("YOUR-AUTH-HEADER")) {
             request.getHeaders().remove("YOUR-AUTH-HEADER");
        }
        return request;
    }

    @Nullable
    @Override
    public HttpResponse filter(HttpResponse response) {
        return response;
    }
}
```

### Filtering SharedPreferences values and files
The SharedPreferences monitor allows specifying files you want to observe by using `SharedPreferencesSourceFactory`.
1. To observe all SharedPreferences files it provides `SharedPreferencesSourceFactory.all()` method. By default, the monitor uses this value.
2. To ignore some files it provides `SharedPreferencesSourceFactory.excludeFiles("preferences_name")` method, where "preferences_name" is a name of ignored file. You may pass as many file names as you want.
3. To observe only specified file it provides `SharedPreferencesSourceFactory.only("preferences_name")` method, where "preferences_name" is a name of file for observing. This method also receives as many argumens as you want. 

In additinal, the monitor allows to provide `SharedPreferencesMonitor.Filter` for removing or modifying some values before sending data on client.

Let's say you want to remove `key_1` and modify `key_2` preferences in the file `preferences_name`. So, your filter will look like that: 
```java
public class SimpleSharedPreferencesFilter implements SharedPreferencesMonitor.Filter {
    @NonNull
    @Override
    public Map<String, PreferenceValue> filter(@NonNull String fileName, @NonNull Map<String, PreferenceValue> values) {
        if (fileName.equals("preferences_name")) {
            values.remove("key_1");
            if (values.containsKey("key_2")) {
                values.put("key_2", PreferenceValue.stringValue("modified value"));
            }
        }
        return values;
    }
}
```
For applying these customizations, you need to use one of these methods: `addSharedPreferenceMonitor(SharedPreferencesMonitor.Filter)`, `addSharedPreferenceMonitor(SharedPreferencesSourceFactory)`, `addSharedPreferenceMonitor(SharedPreferencesSourceFactory, SharedPreferencesMonitor.Filter)`.

### Filtering Logs
To filter logs you need to implement `LogMonitor.Filter` and pass it to `addLogMonitor(LogMonitor.Filter)` method.

Let's consider an example where we want to change a log level to WARN for all messages with word *token*:
```java
public class LogFilter implements LogMonitor.Filter {
  
    @Nullable
    @Override
    public LogEvent filter(LogEvent event) {
        if (event.message.contains("token")) {
             event.level = LogLevel.WARN;
        }
        return request;
    }
}
```
### Applying filters
Let's provide the created filtes to monitors:
```java
AppSpector
            .build(this)
            .withDefaultMonitors()
            .addHttpMonitor(new TokenFilter())
            .addSharedPreferenceMonitor(new SimpleSharedPreferencesFilter()) 
            .addLogMonitor(new LogFilter())
            .run("YOUR_API_KEY");
```

## Getting session URL

Sometimes you may need to get URL pointing to current session from code. Say you want link crash in your crash reporter with it, write it to logs or display in your debug UI. To get this URL you have to add a session start callback:

```java
AppSpector.shared().setSessionUrlListener(new SessionUrlListener() {
    @Override
    public void onReceived(@NonNull String sessionUrl) {
        // Save url for future use...
    }
});
```

## Disable background data collection
By default, AppSpector SDK is active until the application is killed by Android OS, even if no activities left.
It may lead to unnecessary data collection and long sessions for inactive apps.
We provide API to disable data collection for a case when the app has no started activities.

```java
AppSpector
        .build(this)
        .collectDataInBackground(false) // Set this flag to disable data collection if no activities left
        .withDefaultMonitors()
        .run("YOUR_API_KEY");
```

## Using OkHttp interceptor instead of AppSpector Gradle Plugin
If you don't want to use AppSpector Gradle Plugin you could use an alternative way to intercept HTTP requests and responses. You can manually add `AppSpectorOkHttp3Interceptor` to your OkHttpClient (Or `AppSpectorOkHttp2Interceptor` for old version of OkHttpClient). Also, **don't forget** to remove AppSpector plugin from your `app/build.gradle` file.

```java
new OkHttpClient.Builder()
  .addInterceptor(new AuthenticationInterceptor()) // for example, it adds auth token to you request
  .addInterceptor(new AppSpectorOkHttp3Interceptor()) // it will track your requests and responses
  .build()
```

## Logger integration with Timber
If Timber has been integrated into your project you can easily use it with AppSpector:
```java
Timber.plant(new Timber.DebugTree() {
    @Override
    void log(int priority, String tag, @NotNull String message, Throwable t) {
        Logger.log(priority, tag, message, t)
    }
})
```

# Features
AppSpector provides many monitors that tracks different activities inside your app:

#### SQLite monitor
Provides browser for sqlite databases found in your app. Allows to track all queries, shows DB scheme and data in DB. You can issue custom SQL query on any DB and see results in browser immediately.

![SQLite monitor](images/sqlite-monitor.png)

#### HTTP monitor
Shows all HTTP traffic in your app. You can examine any request, see request/response headers and body.
We provide XML and JSON highliting for request/responses with formatting and folding options so even huge responses are easy to look through.

![SQLite monitor](images/http-monitor.png)

#### Logs monitor
Displays all logs generated by your app.

![Logs](images/logs-monitor.png)

##### AppSpector Logger
AppSpector Logger allows you to collect log message only into AppSpector service. It is useful when you log some internal data witch can be leaked via Logcat. AppSpector Logger has the same API with `android.util.Log` class.

```java
Logger.d("MyTAG", "It won't be printed to the Logcat");
```

#### Location monitor
Most of the apps are location-aware. Testing it requires changing locations yourself. In this case, location mocking is a real time saver. Just point to the location on the map and your app will change its geodata right away.

![Location](images/location-monitor.png)

#### Performance monitor
Displays real-time graphs of the CPU / Memory / Network / Disk / Battery usage.

![Performance](images/performance-monitor.png)

#### Screenshot monitor
Simply captures screenshot from the device.

![Screenshots](images/screenshot-monitor.png)

#### SharedPreferences monitor
Provides browser and editor for SharedPreferences.

![SharedPreferences](images/screenshot-shared-preferences.png)

# Feedback
Let us know what do you think or what would you like to be improved: [info@appspector.com](mailto:info@appspector.com).

[Join our slack to discuss setup process and features](https://slack.appspector.com)
