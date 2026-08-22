package com.example.flutter_application_1

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.SharedPreferences
import android.graphics.Color
import android.net.Uri
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetLaunchIntent

// ════════════════════════════════════════════════════════════════════════
// "YENİ NOT EKLE" İKON WİDGET'I
//
// Ana ekrana eklenen, içerik göstermeyen sade bir ikon widget'ı. Tek
// işlevi var: dokununca uygulamayı açıp doğrudan boş bir not ekranına
// götürmek. NoteWidgetReceiverV2'nin aksine yapılandırma ekranı (config
// activity) yoktur ve tek bir sabit görünümü vardır — hangi not
// gösterileceği gibi bir seçim söz konusu değildir.
//
// Tema (açık/koyu) rengini, mevcut not widget'ıyla aynı kaynaktan
// (HomeWidgetPreferences -> is_dark_theme) okur ki uygulamanın genel
// temasıyla tutarlı kalsın (bkz. NoteWidgetConfigActivity.kt'deki aynı
// anahtar).
//
// ÖNEMLİ / TAMAMLANMASI GEREKEN (DART TARAFI):
// Bu dosya widget'a basılınca MainActivity'yi "dnote://newnote" URI'siyle
// açıyor. Mevcut not widget'ı "dnote://note?id=..." URI'sini
// NoteListLifecycleMixin (note_list_lifecycle_mixin.dart) içinde
// yakalayıp ilgili notu açıyor — bkz. NoteWidget.kt ve
// NoteWidgetReceiverV2.kt'deki ilgili yorumlar. "dnote://newnote" için
// AYNI YERE, bu URI geldiğinde doğrudan "yeni not oluştur" ekranını
// açacak bir dal eklenmesi gerekiyor. Bu native dosya tek başına yeterli
// değildir; Dart tarafındaki eşleşme yapılmadan tıklama sadece uygulamayı
// (muhtemelen not listesini) açar, boş not ekranını AÇMAZ.
// ════════════════════════════════════════════════════════════════════════
class NewNoteWidgetReceiver : AppWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        for (appWidgetId in appWidgetIds) {
            updateWidget(context, appWidgetManager, appWidgetId)
        }
    }

    companion object {
        private const val PREFS_NAME = "HomeWidgetPreferences"

        // theme.dart -> dNoteSyncThemeToWidgetStorage tarafından yazılır.
        // Anahtar bulunamazsa (widget hiç güncellenmemiş çok eski bir
        // kurulum) uygulamanın varsayılan teması olan Koyu'ya düşülür —
        // bkz. NoteWidgetConfigActivity.kt'deki aynı davranış.
        private const val KEY_IS_DARK_THEME = "is_dark_theme"

        // Mevcut not widget'ının kart renkleriyle aynı palet (bkz.
        // NoteWidgetConfigActivity.kt COLOR_CARD_DARK / COLOR_CARD_LIGHT)
        // ki iki widget yan yana dururken görsel tutarlılık bozulmasın.
        private const val COLOR_BG_DARK = "#2D2D2D"
        private const val COLOR_BG_LIGHT = "#FFFFFF"
        private const val COLOR_ICON_DARK = "#FFFFFF"
        private const val COLOR_ICON_LIGHT = "#1A1A1A"

        fun updateWidget(
            context: Context,
            appWidgetManager: AppWidgetManager,
            appWidgetId: Int
        ) {
            val prefs: SharedPreferences =
                context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
            val isDarkTheme = prefs.getBoolean(KEY_IS_DARK_THEME, true)

            val bgColor = Color.parseColor(if (isDarkTheme) COLOR_BG_DARK else COLOR_BG_LIGHT)
            val iconColor = Color.parseColor(if (isDarkTheme) COLOR_ICON_DARK else COLOR_ICON_LIGHT)

            val views = RemoteViews(context.packageName, R.layout.widget_new_note)
            views.setInt(R.id.new_note_widget_root, "setBackgroundColor", bgColor)
            views.setInt(R.id.new_note_widget_icon, "setColorFilter", iconColor)

            // Mevcut not widget'ıyla aynı yöntem: HomeWidgetLaunchIntent,
            // MainActivity'yi verilen URI intent-data'sıyla açan bir
            // PendingIntent üretir (bkz. NoteWidgetReceiverV2.kt ADIM 8).
            val launchUri = Uri.parse("dnote://newnote")
            val pendingIntent = HomeWidgetLaunchIntent.getActivity(
                context,
                MainActivity::class.java,
                launchUri
            )
            views.setOnClickPendingIntent(R.id.new_note_widget_root, pendingIntent)

            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }
}
