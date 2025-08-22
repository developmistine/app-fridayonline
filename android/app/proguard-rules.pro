-keep class com.google.android.gms.** { *; }
-keep class com.huawei.hms.ads.** { *; }
-keep interface com.huawei.hms.ads.** { *; }
# Add rules from missing_rules.txt
-dontwarn com.linecorp.linesdk.BR
-keep class com.linecorp.linesdk.BR { *; }