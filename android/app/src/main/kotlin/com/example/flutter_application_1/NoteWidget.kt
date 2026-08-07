package com.example.flutter_application_1

import android.content.Context
import androidx.glance.GlanceId
import androidx.glance.GlanceModifier
import androidx.glance.action.ActionParameters
import androidx.glance.action.clickable
import androidx.glance.appwidget.GlanceAppWidget
import androidx.glance.appwidget.action.ActionCallback
import androidx.glance.appwidget.action.actionRunCallback
import androidx.glance.appwidget.provideContent
import androidx.glance.background
import androidx.glance.layout.Alignment
import androidx.glance.layout.Column
import androidx.glance.layout.fillMaxSize
import androidx.glance.layout.padding
import androidx.glance.text.FontWeight
import androidx.glance.text.Text
import androidx.glance.text.TextStyle
import androidx.glance.unit.ColorProvider
import androidx.compose.ui.unit.sp
import androidx.compose.ui.unit.dp
import androidx.compose.ui.graphics.Color

// ════════════════════════════════════════════════════════════════════════
// ANA EKRAN WİDGET'I - GLANCE UI
// home_widget paketinin Flutter tarafından yazdığı SharedPreferences
// ("HomeWidgetPreferences") dosyasını okuyup widget içeriğini çizer.
// Anahtar adları Dart tarafındaki note_widget_service.dart ile birebir
// eşleşmelidir.
//
// NOT: widget_dark / widget_font_size / widget_bg_opacity anahtarları
// Aşama 4'te (ayarlar ekranı aktifleştirildiğinde) Dart tarafından
// yazılmaya başlanacak. O zamana kadar burada tanımlı varsayılan
// değerler kullanılır; widget o anahtarlar hiç yazılmamış olsa bile
// çalışır.
// ════════════════════════════════════════════════════════════════════════
class NoteWidget : GlanceAppWidget() {

    companion object {
        private const val PREFS_NAME = "HomeWidgetPreferences"

        private const val KEY_TITLE = "note_title"
        private const val KEY_CONTENT = "note_content"
        private const val KEY_COUNT = "note_count"

        private const val KEY_DARK = "widget_dark"
        private const val KEY_FONT_SIZE = "widget_font_size"
        private const val KEY_BG_OPACITY = "widget_bg_opacity"
    }

    override suspend fun provideGlance(context: Context, id: GlanceId) {
        val prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)

        val title = prefs.getString(KEY_TITLE, null) ?: "Henüz not yok"
        val content = prefs.getString(KEY_CONTENT, null) ?: ""
        val noteCount = prefs.getInt(KEY_COUNT, 0)

        val isDark = prefs.getBoolean(KEY_DARK, true)
        val fontSize = prefs.getFloat(KEY_FONT_SIZE, 14f)
        val bgOpacity = prefs.getFloat(KEY_BG_OPACITY, 1f)

        provideContent {
            NoteWidgetContent(
                title = title,
                content = content,
                noteCount = noteCount,
                isDark = isDark,
                fontSize = fontSize,
                bgOpacity = bgOpacity,
            )
        }
    }
}

@androidx.compose.runtime.Composable
private fun NoteWidgetContent(
    title: String,
    content: String,
    noteCount: Int,
    isDark: Boolean,
    fontSize: Float,
    bgOpacity: Float,
) {
    val backgroundColor = if (isDark) Color(0xFF1E1E1E) else Color(0xFFFFFFFF)
    val textColor = if (isDark) Color(0xFFFFFFFF) else Color(0xFF1A1A1A)
    val subTextColor = if (isDark) Color(0xFFB0B0B0) else Color(0xFF6A6A6A)

    Column(
        modifier = GlanceModifier
            .fillMaxSize()
            .background(backgroundColor.copy(alpha = bgOpacity))
            .padding(12.dp)
            .clickable(actionRunCallback<OpenAppAction>()),
        horizontalAlignment = Alignment.Start,
    ) {
        Text(
            text = title,
            style = TextStyle(
                color = ColorProvider(textColor),
                fontSize = fontSize.sp,
                fontWeight = FontWeight.Bold,
            ),
            maxLines = 1,
        )
        if (content.isNotEmpty()) {
            Text(
                text = content,
                style = TextStyle(
                    color = ColorProvider(subTextColor),
                    fontSize = (fontSize - 2f).coerceAtLeast(10f).sp,
                ),
                maxLines = 2,
            )
        }
        Text(
            text = "$noteCount not",
            style = TextStyle(
                color = ColorProvider(subTextColor),
                fontSize = (fontSize - 3f).coerceAtLeast(9f).sp,
            ),
        )
    }
}

// Widget'a dokunulunca uygulamayı açan aksiyon.
class OpenAppAction : ActionCallback {
    override suspend fun onAction(
        context: Context,
        glanceId: GlanceId,
        parameters: ActionParameters,
    ) {
        val launchIntent =
            context.packageManager.getLaunchIntentForPackage(context.packageName)
        launchIntent?.let {
            it.addFlags(android.content.Intent.FLAG_ACTIVITY_NEW_TASK)
            context.startActivity(it)
        }
    }
}
