# Add project specific ProGuard rules here.
# By default, the flags in this file are appended to flags specified
# in /Users/zen/Library/Android/sdk/tools/proguard/proguard-android.txt
# You can edit the include path and order by changing the proguardFiles
# directive in run.gradle.
#
# For more details, see
#   http://developer.android.com/guide/developing/tools/proguard.html

# Add any project specific keep options here:

# If your project uses WebView with JS, uncomment the following
# and specify the fully qualified class name to the JavaScript interface
# class:
#-keepclassmembers class fqcn.of.javascript.interface.for.webview {
#   public *;
#}

# Appspector
-keep class com.appspector.sdk.** { *; }
-keep interface com.appspector.sdk.** { *; }
-keep @interface com.appspector.sdk.** { *; }
-keep enum com.appspector.sdk.** { *; }
-dontwarn com.appspector.sdk.instrumentation.**

# Message pack
-keep class net.jpountz.lz4.** { *; }
-dontwarn net.jpountz.util.**
-keep class org.msgpack.core.buffer.** { *; }
-dontwarn org.msgpack.core.buffer.**

# Proguard configuration for Jackson 2.x (fasterxml package instead of codehaus package)
-keep class com.fasterxml.jackson.databind.ObjectMapper {
    public <methods>;
    protected <methods>;
}
-keep class com.fasterxml.jackson.databind.ObjectWriter {
    public ** writeValueAsString(**);
}
-keepnames class com.fasterxml.jackson.** { *; }
-dontwarn com.fasterxml.jackson.databind.**

-keepnames class com.google.android.gms.location.LocationServices
