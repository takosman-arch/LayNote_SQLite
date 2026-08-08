package com.example.flutter_application_1

// ════════════════════════════════════════════════════════════════════════
// ÖNEMLİ / DOĞRULA: Bu dosya `es.antonborri.home_widget.HomeWidgetGlanceStateDefinition`
// import'unu kullanıyor. Bu, home_widget paketinin (pub.dev) resmi Glance
// örneğindeki paket adı, ancak paketin senin projene eklenen sürümünde
// (0.9.1) bu paket adı değişmiş olabilir. Derlemeden önce şunu çalıştırıp
// gerçek paket adını doğrula:
//
//   find ~/.pub-cache/hosted/pub.dev/home_widget-0.9.1 -name "*.kt" | xargs grep -l "GlanceStateDefinition"
//
// Bulduğun dosyanın en üstündeki `package ...` satırını al ve aşağıdaki
// import satırını ona göre düzelt. Yanlışsa Android Studio importu kırmızı
// gösterip "unresolved reference" verecektir — derlemeden önce mutlaka
// kontrol et.
//
// DÜZELTME (2026-08-07, revize): home_widget 0.9.1'de
// HomeWidgetGlanceStateDefinition, currentState<HomeWidgetGlanceState>()
// ile bir sarmalayıcı (wrapper) döndürüyor — bu doğruydu. FAKAT bu
// sarmalayıcının `.preferences` alanı DataStore'un
// androidx.datastore.preferences.core.Preferences tipinde DEĞİL, düz
// android.content.SharedPreferences tipinde. Derleyici bunu net söylüyor:
// "Argument type mismatch: actual type is 'SharedPreferences', but
// 'Preferences' was expected." (NoteWidget.kt:80). Bu yüzden
// stringPreferencesKey/intPreferencesKey/... ile prefs[KEY] okuma şekli bu
// kurulu sürümde çalışmıyor. Bunun yerine düz SharedPreferences API'si
// (getString/getInt/getFloat/getBoolean) kullanılıyor — bkz. aşağıdaki
// NoteWidgetContent imzası ve okuma satırları.
// ════════════════════════════════════════════════════════════════════════

import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.net.Uri
import androidx.compose.runtime.Composable
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.glance.GlanceId
import androidx.glance.GlanceModifier
import androidx.glance.action.clickable
import androidx.glance.appwidget.GlanceAppWidget
import androidx.glance.appwidget.action.actionStartActivity
import androidx.glance.appwidget.provideContent
import androidx.glance.background
import androidx.glance.currentState
import androidx.glance.layout.Column
import androidx.glance.layout.fillMaxSize
import androidx.glance.layout.padding
import androidx.glance.text.FontWeight
import androidx.glance.text.Text
import androidx.glance.text.TextStyle
import androidx.glance.unit.ColorProvider
import es.antonborri.home_widget.HomeWidgetGlanceState
import es.antonborri.home_widget.HomeWidgetGlanceStateDefinition

// Bu anahtarlar note_widget_service.dart içindeki keyNoteTitle,
// keyNoteContent, keyNoteCount sabitleri ve syncAppearanceSettings'in
// yazdığı widget_font_size / widget_bg_opacity / widget_dark ile BİREBİR
// aynı isim ve tipte olmak zorunda (String/int/double/bool). Dart tarafında
// bu isimlerden biri değişirse burası da güncellenmeli.
private const val KEY_TITLE = "note_title"
private const val KEY_CONTENT = "note_content"
private const val KEY_COUNT = "note_count"
private const val KEY_NOTE_ID = "note_id"
private const val KEY_FONT_SIZE = "widget_font_size"
private const val KEY_BG_OPACITY = "widget_bg_opacity"
private const val KEY_DARK = "widget_dark"

// ────────────────────────────────────────────────────────────────────────
// DÜZELTME (2026-08-07): home_widget paketi Dart tarafından int olarak
// gönderilen değerleri (örn. HomeWidget.saveWidgetData('widget_font_size', 14))
// Android SharedPreferences'a putLong ile yazıyor; double gönderilirse
// putFloat ile yazıyor. Hangisinin geldiği Dart tarafındaki değere bağlı
// olduğu için sabit getFloat()/getInt() çağrısı ClassCastException atabilir
// (bkz. "Long cannot be cast to Float" hatası). Bu yüzden gerçek saklanan
// tipi runtime'da deneyerek okuyan esnek yardımcılar kullanıyoruz.
// Not: Dart tarafında ilgili değerleri hep double (örn. 14.0) olarak
// göndermek de sorunu çözer, ama bu yardımcılar hangi tip gelirse gelsin
// çalışacağı için daha sağlam.
private fun SharedPreferences.getFloatCompat(key: String, default: Float): Float {
    if (!contains(key)) return default
    return try {
        getFloat(key, default)
    } catch (e: ClassCastException) {
        try {
            // home_widget paketi double değeri Long olarak, değerin ham
            // IEEE 754 bit kalıbı şeklinde kaydediyor. Long'u doğrudan
            // Float'a çevirmek (numeric conversion) yanlış sonuç verir
            // (örn. 14.0 -> 4.6e18). Önce bit kalıbını Double'a geri
            // yorumlamak (reinterpret), sonra Float'a indirmek gerekir.
            val longBits = getLong(key, default.toLong())
            java.lang.Double.longBitsToDouble(longBits).toFloat()
        } catch (e2: ClassCastException) {
            try {
                getInt(key, default.toInt()).toFloat()
            } catch (e3: ClassCastException) {
                default
            }
        }
    }
}

private fun SharedPreferences.getIntCompat(key: String, default: Int): Int {
    if (!contains(key)) return default
    return try {
        getInt(key, default)
    } catch (e: ClassCastException) {
        try {
            getLong(key, default.toLong()).toInt()
        } catch (e2: ClassCastException) {
            try {
                getFloat(key, default.toFloat()).toInt()
            } catch (e3: ClassCastException) {
                default
            }
        }
    }
}

class NoteWidget : GlanceAppWidget() {

    // HomeWidgetGlanceStateDefinition, Flutter tarafında
    // HomeWidget.saveWidgetData ile yazılan SharedPreferences verisini
    // Glance'ın currentState<HomeWidgetGlanceState>() ile okunabilir hale
    // getirir. Preferences nesnesine erişmek için .preferences kullanılır
    // (bkz. provideGlance() ve yukarıdaki DÜZELTME notu).
    override val stateDefinition = HomeWidgetGlanceStateDefinition()

    override suspend fun provideGlance(context: Context, id: GlanceId) {
        provideContent {
            // Bu kurulu home_widget sürümünde .preferences alanı düz
            // android.content.SharedPreferences döndürüyor (DataStore
            // Preferences DEĞİL) — bkz. yukarıdaki DÜZELTME notu.
            val prefs = currentState<HomeWidgetGlanceState>().preferences
            NoteWidgetContent(context, prefs)
        }
    }
}

@Composable
private fun NoteWidgetContent(context: Context, prefs: SharedPreferences) {
    // Hiç senkronizasyon yapılmamışsa (uygulama hiç açılmamış / Aşama 3
    // entegrasyonu henüz devreye girmemiş) makul varsayılanlar kullanılır.
    val title = prefs.getString(KEY_TITLE, null) ?: "Henüz not yok"
    val content = prefs.getString(KEY_CONTENT, null) ?: ""
    val count = prefs.getIntCompat(KEY_COUNT, 0)
    val noteId = prefs.getString(KEY_NOTE_ID, null)
    val fontSize = prefs.getFloatCompat(KEY_FONT_SIZE, 14f)
    val bgOpacity = prefs.getFloatCompat(KEY_BG_OPACITY, 1f).coerceIn(0f, 1f)
    val dark = prefs.getBoolean(KEY_DARK, true)

    val bgColor = if (dark) Color(0xFF1E1E1E) else Color(0xFFFFFFFF)
    val titleColor = if (dark) Color(0xFFFFFFFF) else Color(0xFF1A1A1A)
    val subTextColor = if (dark) Color(0xFFB0B0B0) else Color(0xFF666666)

    Column(
        modifier = GlanceModifier
            .fillMaxSize()
            .background(bgColor.copy(alpha = bgOpacity))
            .padding(12.dp)
            // Widget'a dokununca uygulamayı aç. noteId doluysa
            // "dnote://note?id=..." URI'si ile açılır; Dart tarafı
            // (NoteListLifecycleMixin._handleWidgetLaunchUri)
            // HomeWidget.initiallyLaunchedFromHomeWidget() /
            // HomeWidget.widgetClicked ile bu URI'yi okuyup doğrudan ilgili
            // notu açar.
            //
            // DÜZELTME (2026-08-08): kurulu Glance sürümünde
            // actionStartActivity<T>(context, uri) generic+Uri overload'ı
            // yok; derleyici bunu actionStartActivity(intent: Intent, ...)
            // overload'ına eşlemeye çalışıp tip hatası veriyordu. Bunun
            // yerine Intent'i elle oluşturup actionStartActivity(intent)
            // kullanıyoruz.
            .clickable(
                actionStartActivity(
                    Intent(context, MainActivity::class.java).apply {
                        action = Intent.ACTION_VIEW
                        data = if (!noteId.isNullOrEmpty()) {
                            Uri.parse("dnote://note?id=$noteId")
                        } else {
                            Uri.parse("dnote://note")
                        }
                    }
                )
            ),
    ) {
        Text(
            text = title,
            style = TextStyle(
                color = ColorProvider(titleColor),
                fontSize = fontSize.sp,
                fontWeight = FontWeight.Bold,
            ),
        )
        if (content.isNotEmpty()) {
            Text(
                text = content,
                style = TextStyle(
                    color = ColorProvider(subTextColor),
                    fontSize = (fontSize - 2f).sp,
                ),
            )
        }
        Text(
            text = "$count not",
            style = TextStyle(
                color = ColorProvider(subTextColor),
                fontSize = (fontSize - 3f).sp,
            ),
        )
    }
}
