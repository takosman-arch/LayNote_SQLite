package com.example.flutter_application_1

import android.content.Context
import android.content.Intent
import android.util.TypedValue
import android.widget.RemoteViews
import android.widget.RemoteViewsService
import org.json.JSONArray
import org.json.JSONObject

// ════════════════════════════════════════════════════════════════════════
// Widget'ın kaydırılabilir satır listesi. NoteWidgetReceiverV2 içindeki
// eski "for + addView" döngüsü buraya taşındı; satır tipine göre view
// üretme mantığı birebir aynı, sadece üretim yeri (loop -> getViewAt) ve
// veri kaynağı erişimi (doğrudan prefs okuma -> Intent extra'ları)
// değişti. Renkler/font boyutu NoteWidgetReceiverV2'de zaten hesaplanmış
// haliyle Intent extra'sıyla buraya geliyor; burada tekrar hesaplanmıyor.
// ════════════════════════════════════════════════════════════════════════
class NoteWidgetRemoteViewsService : RemoteViewsService() {
    override fun onGetViewFactory(intent: Intent): RemoteViewsFactory {
        return NoteLinesFactory(applicationContext, intent)
    }

    companion object {
        const val EXTRA_NOTE_ID = "extra_note_id"
        const val EXTRA_FONT_SIZE = "extra_font_size"
        const val EXTRA_TITLE_COLOR = "extra_title_color"
        const val EXTRA_SUBTEXT_COLOR = "extra_subtext_color"
        const val EXTRA_CHECKED_COLOR = "extra_checked_color"
        const val EXTRA_DIVIDER_COLOR = "extra_divider_color"
    }
}

private class NoteLinesFactory(
    private val context: Context,
    intent: Intent
) : RemoteViewsService.RemoteViewsFactory {

    private val noteId: String? =
        intent.getStringExtra(NoteWidgetRemoteViewsService.EXTRA_NOTE_ID)
    private val fontSize: Float =
        intent.getFloatExtra(NoteWidgetRemoteViewsService.EXTRA_FONT_SIZE, 14f)
    private val titleColor: Int =
        intent.getIntExtra(NoteWidgetRemoteViewsService.EXTRA_TITLE_COLOR, 0xFFFFFFFF.toInt())
    private val subTextColor: Int =
        intent.getIntExtra(NoteWidgetRemoteViewsService.EXTRA_SUBTEXT_COLOR, 0xFFFFFFFF.toInt())
    private val checkedColor: Int =
        intent.getIntExtra(NoteWidgetRemoteViewsService.EXTRA_CHECKED_COLOR, 0xFFFFC107.toInt())
    private val dividerColor: Int =
        intent.getIntExtra(NoteWidgetRemoteViewsService.EXTRA_DIVIDER_COLOR, 0x5AFFFFFF)

    // Eskisi 8'di (widget sabit yükseklikte taşmasın diye). Artık gerçek
    // kaydırma olduğu için yükseltildi; ANR riskine karşı yine de bir üst
    // sınır bırakıldı.
    private val maxRenderLines = 20

    private var lines: JSONArray = JSONArray()

    override fun onCreate() {}

    // notifyAppWidgetViewDataChanged() çağrıldığında sistem bunu çağırır;
    // veri burada TAZE okunmalı (onCreate'te değil, çünkü Factory örneği
    // widget yaşam döngüsü boyunca yeniden kullanılabiliyor).
    override fun onDataSetChanged() {
        lines = resolveLines()
    }

    override fun onDestroy() {}

    override fun getCount(): Int = minOf(lines.length(), maxRenderLines)

    override fun getViewAt(position: Int): RemoteViews {
        val line = lines.optJSONObject(position)
            ?: return RemoteViews(context.packageName, R.layout.widget_line_text)
        val lineFontSize = (fontSize - 2f).coerceAtLeast(8f)

        return when (line.optString("type")) {
            "checkbox" -> {
                val child = RemoteViews(context.packageName, R.layout.widget_line_checkbox)
                val checked = line.optBoolean("checked", false)
                child.setTextViewText(
                    R.id.line_checkbox_icon,
                    if (checked) "\u2611" else "\u2610"
                )
                child.setTextViewText(R.id.line_checkbox_text, line.optString("text", ""))
                child.setTextColor(
                    R.id.line_checkbox_icon,
                    if (checked) checkedColor else subTextColor
                )
                child.setTextColor(
                    R.id.line_checkbox_text,
                    if (checked) subTextColor else titleColor
                )
                child.setTextViewTextSize(R.id.line_checkbox_icon, TypedValue.COMPLEX_UNIT_SP, lineFontSize)
                child.setTextViewTextSize(R.id.line_checkbox_text, TypedValue.COMPLEX_UNIT_SP, lineFontSize)
                // İşaretli maddede üstü çizili görünüm (in-app'teki
                // TextDecoration.lineThrough ile aynı).
                val flags = if (checked) {
                    android.graphics.Paint.STRIKE_THRU_TEXT_FLAG or android.graphics.Paint.ANTI_ALIAS_FLAG
                } else {
                    android.graphics.Paint.ANTI_ALIAS_FLAG
                }
                child.setInt(R.id.line_checkbox_text, "setPaintFlags", flags)
                // DÜZELTME: satıra tıklayınca da notu açabilmesi için,
                // NoteWidgetReceiverV2'nin ListView'e verdiği
                // PendingIntentTemplate'i bu satırda "doldur" (fillIn).
                // Şablon zaten hedef notu (noteId) belirlediği için burada
                // boş bir Intent yeterli — tüm satırlar aynı notu açar.
                child.setOnClickFillInIntent(R.id.line_checkbox_icon, Intent())
                child.setOnClickFillInIntent(R.id.line_checkbox_text, Intent())
                child
            }
            "table_row" -> {
                val child = RemoteViews(context.packageName, R.layout.widget_line_table_row)
                child.setTextViewText(R.id.line_table_label, line.optString("label", ""))
                child.setTextViewText(R.id.line_table_value, line.optString("value", ""))
                child.setTextColor(R.id.line_table_label, titleColor)
                child.setTextColor(R.id.line_table_value, titleColor)
                child.setTextViewTextSize(R.id.line_table_label, TypedValue.COMPLEX_UNIT_SP, lineFontSize)
                child.setTextViewTextSize(R.id.line_table_value, TypedValue.COMPLEX_UNIT_SP, lineFontSize)
                child.setOnClickFillInIntent(R.id.line_table_label, Intent())
                child.setOnClickFillInIntent(R.id.line_table_value, Intent())
                child
            }
            "table_total" -> {
                val child = RemoteViews(context.packageName, R.layout.widget_line_table_total)
                child.setTextViewText(R.id.line_total_value, line.optString("value", ""))
                child.setTextColor(R.id.line_total_label, titleColor)
                child.setTextColor(R.id.line_total_value, titleColor)
                child.setInt(R.id.line_total_divider, "setBackgroundColor", dividerColor)
                child.setTextViewTextSize(R.id.line_total_label, TypedValue.COMPLEX_UNIT_SP, lineFontSize)
                child.setTextViewTextSize(R.id.line_total_value, TypedValue.COMPLEX_UNIT_SP, lineFontSize)
                child.setOnClickFillInIntent(R.id.line_total_label, Intent())
                child.setOnClickFillInIntent(R.id.line_total_value, Intent())
                child
            }
            else -> { // "text", "drawing"
                val child = RemoteViews(context.packageName, R.layout.widget_line_text)
                val text = when (line.optString("type")) {
                    "drawing" -> "\u270F\uFE0F Çizim"
                    else -> line.optString("text", "")
                }
                child.setTextViewText(R.id.line_text, text)
                child.setTextColor(R.id.line_text, subTextColor)
                child.setTextViewTextSize(R.id.line_text, TypedValue.COMPLEX_UNIT_SP, lineFontSize)
                child.setOnClickFillInIntent(R.id.line_text, Intent())
                child
            }
        }
    }

    override fun getLoadingView(): RemoteViews? = null
    override fun getViewTypeCount(): Int = 4
    override fun getItemId(position: Int): Long = position.toLong()
    override fun hasStableIds(): Boolean = true

    private fun resolveLines(): JSONArray {
        val id = noteId
        if (id.isNullOrEmpty()) return JSONArray()
        val prefs = context.getSharedPreferences("HomeWidgetPreferences", Context.MODE_PRIVATE)
        val raw = prefs.getString("all_notes_lines_json", null) ?: return JSONArray()
        return try {
            JSONObject(raw).optJSONArray(id) ?: JSONArray()
        } catch (e: Throwable) {
            JSONArray()
        }
    }
}
