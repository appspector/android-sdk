# ![AppSpector](https://github.com/appspector/ios-sdk/raw/master/appspector-logo.png)

With AppSpector you can remotely debug your app running in the same room or on another continent. 
You can measure app performance, view database content, logs, network requests and many more in realtime. 
This is the instrument that you've been looking for. Don't limit yourself only to simple logs. 
Debugging don't have to be painful!

## Setup
Each app you want to use with AppSpector SDK you have to register on the web (https://app.appspector.com).
After adding the application navigate to app settings and copy API key.

## Add AppSpector SDK to your build.gradle

```groovy
buildscript {
  repositories {
      maven {
          url "https://maven.appspector.com/artifactory/android-sdk"
      }
  }
  
  dependencies {
      // We recommend changing it to the latest version from our changelog:
      // https://news.appspector.com
      classpath "com.appspector:android-sdk-plugin:latest_version"
  }
}

apply plugin: 'com.android.application'
// Put AppSpector plugin after Android plugin
apply plugin: 'com.appspector.sdk'

repositories {
    maven {
        url "https://maven.appspector.com/artifactory/android-sdk"
    }
}

dependencies {
    // We recommend changing it to the latest version from our changelog:
    // https://news.appspector.com
    classpath "com.appspector:android-sdk:latest_version"
}
```

## Initialize AppSpector SDK

```java
import android.app.Application;

import com.appspector.sdk.AppSpector;

public class AmazingApp extends Application {

   @Override
   public void onCreate() {
      super.onCreate();
      
      // We recommend to start AppSpector from Application#onCreate method
      AppSpector
            .build(this)
            .addPerformanceMonitor()
            .addHttpMonitor()
            .addLogMonitor()
            .addScreenshotMonitor()
            .addSQLMonitor()
            .run("#APP_API_KEY#");
   }

}
```

## Build and Run

Build your project and see everything work! When your app is up and running you can go to https://app.appspector.com and connection to your application session.
