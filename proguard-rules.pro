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


# End-To-End module
-keepnames class com.appspector.sdk.encryption.EncryptionModuleFactory
-keep class com.cossacklabs.themis.** { *; }
