# Google Sign-In / Google API Client / Google Drive için gerekli keep kuralları
-keep class com.google.android.gms.** { *; }
-keep class com.google.api.client.** { *; }
-keep class com.google.api.services.** { *; }
-keep class com.google.auth.** { *; }
-keep class com.google.gson.** { *; }
-keep class com.google.errorprone.annotations.** { *; }

-dontwarn com.google.**
-dontwarn org.conscrypt.**
-dontwarn org.bouncycastle.**
-dontwarn org.openjsse.**

-keepattributes Signature
-keepattributes *Annotation*
-keepattributes EnclosingMethod
-keepattributes InnerClasses

# Retrofit/OkHttp kullanan google api paketleri reflection ile model sınıflarını
# okuyabildiği için, kendi model (data) sınıflarınızı da koruma altına almanız gerekebilir.
# Örnek: -keep class com.example.flutter_application_1.models.** { *; }

# Gson TypeToken kullanan generic tipler için
-keep class * extends com.google.gson.reflect.TypeToken
-keep,allowobfuscation,allowshrinking class com.google.gson.reflect.TypeToken

# Flutter play_core / deferred components uyarılarını bastır (gerekirse)
-dontwarn com.google.android.play.core.**

# WorkManager + Room için gerekli keep kuralları
-keep class androidx.work.** { *; }
-keep class androidx.room.** { *; }
-keep class * extends androidx.room.RoomDatabase
-keep @androidx.room.Entity class *
-keep @androidx.room.Dao class *
-keepclassmembers class * extends androidx.room.RoomDatabase {
    public static <fields>;
}
-keep class androidx.sqlite.** { *; }
-dontwarn androidx.work.**
-dontwarn androidx.room.**