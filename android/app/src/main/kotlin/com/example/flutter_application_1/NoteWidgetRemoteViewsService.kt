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
        // DÜZELTME (zengin metin widget'ta görünmüyordu): "text"/"checkbox"
        // satırlarındaki span'ları (bkz. note_widget_service.dart ->
        // _buildStructuredLines) SpannableString'e çevirirken highlight
        // (vurgu kalemi) ve link rengi için tema bazlı bir renk gerekiyor.
        // Bu iki değer NoteWidgetReceiverV2.kt'de dark/light durumuna göre
        // hesaplanıp buraya Intent extra'sı olarak geçiriliyor.
        const val EXTRA_HIGHLIGHT_COLOR = "extra_highlight_color"
        const val EXTRA_LINK_COLOR = "extra_link_color"
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
    // rich_block_text_controller.dart -> _highlightColorLight/_highlightColorDark
    // ve _linkColor ile BİREBİR aynı tonlar (varsayılanlar, extra hiç
    // gelmezse kullanılır). Gerçek değer NoteWidgetReceiverV2.kt'de
    // dark/light durumuna göre hesaplanıp gönderilir.
    private val highlightColor: Int =
        intent.getIntExtra(NoteWidgetRemoteViewsService.EXTRA_HIGHLIGHT_COLOR, 0xFFFFF59D.toInt())
    private val linkColor: Int =
        intent.getIntExtra(NoteWidgetRemoteViewsService.EXTRA_LINK_COLOR, 0xFF1A73E8.toInt())

    // Eskisi 8'di (widget sabit yükseklikte taşmasın diye), sonra gerçek
    // kaydırma eklenince 20'ye çıkarıldı. DÜZELTME: Dart tarafındaki
    // note_widget_service.dart -> _buildStructuredLines(maxLines) ile
    // BİREBİR aynı tutulmalı — o taraf bu sayıdan ÖNCE keserse kullanıcı
    // kaydırırken içeriğin geri kalanını hiç görmeden "…" ile karşılaşır.
    // ANR riskine karşı yine de bir üst sınır bırakıldı.
    private val maxRenderLines = 40

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

    // ────────────────────────────────────────────────────────────────
    // DÜZELTME (zengin metin widget'ta görünmüyordu): note_widget_service
    // .dart artık her "text"/"checkbox" satırının "spans" alanında
    // bold/italic/underline/strikethrough/highlight/fontSize/color/
    // fontFamily/link bilgisini satır-yerel (0'dan başlayan) index'lerle
    // gönderiyor. RemoteViews süreç dışı (remote process) çalıştığından
    // normal bir Flutter/Compose stil sistemi kullanılamaz; bunun yerine
    // Android'in RemoteViews üzerinden PARCEL EDİLEBİLEN Spannable
    // tiplerini (StyleSpan, UnderlineSpan, StrikethroughSpan,
    // ForegroundColorSpan, BackgroundColorSpan, AbsoluteSizeSpan,
    // TypefaceSpan) kullanan bir SpannableString üretiyoruz.
    //
    // spansJson null/boşsa veya text boşsa, gereksiz yere SpannableString
    // oluşturmadan ham text döndürülür (RemoteViews için de düz
    // CharSequence yeterlidir).
    private fun buildRichLineText(
        text: String,
        spansJson: JSONArray?,
    ): CharSequence {
        if (spansJson == null || spansJson.length() == 0 || text.isEmpty()) return text

        val spannable = android.text.SpannableString(text)
        val len = text.length
        val flags = android.text.Spanned.SPAN_EXCLUSIVE_EXCLUSIVE

        for (i in 0 until spansJson.length()) {
            val s = spansJson.optJSONObject(i) ?: continue
            val start = s.optInt("start", -1).coerceIn(0, len)
            val end = s.optInt("end", -1).coerceIn(0, len)
            if (start >= end) continue

            val bold = s.optBoolean("bold", false)
            val italic = s.optBoolean("italic", false)
            val link = if (s.has("link") && !s.isNull("link")) s.optString("link") else null

            when {
                bold && italic -> spannable.setSpan(
                    android.text.style.StyleSpan(android.graphics.Typeface.BOLD_ITALIC),
                    start, end, flags,
                )
                bold -> spannable.setSpan(
                    android.text.style.StyleSpan(android.graphics.Typeface.BOLD),
                    start, end, flags,
                )
                italic -> spannable.setSpan(
                    android.text.style.StyleSpan(android.graphics.Typeface.ITALIC),
                    start, end, flags,
                )
            }
            if (s.optBoolean("underline", false) || !link.isNullOrEmpty()) {
                spannable.setSpan(android.text.style.UnderlineSpan(), start, end, flags)
            }
            if (s.optBoolean("strikethrough", false)) {
                spannable.setSpan(android.text.style.StrikethroughSpan(), start, end, flags)
            }
            if (s.optBoolean("highlight", false)) {
                spannable.setSpan(
                    android.text.style.BackgroundColorSpan(highlightColor), start, end, flags,
                )
            }
            // NOT: renk JSON'da büyük pozitif bir sayı olarak gelebilir
            // (ör. 0xFFFF0000 -> 4294901760), bu Int sınırını (2^31-1)
            // aşar. optLong ile okuyup toInt() ile 32 bit'e "sarmak"
            // (wrap), Dart tarafındaki orijinal ARGB int değerine geri
            // döndürür (aynı bit kalıbı, işaretli/işaretsiz yorum farkı).
            val color: Int? = if (s.has("color") && !s.isNull("color")) {
                s.optLong("color").toInt()
            } else {
                null
            }
            val effectiveColor = color ?: if (!link.isNullOrEmpty()) linkColor else null
            if (effectiveColor != null) {
                spannable.setSpan(
                    android.text.style.ForegroundColorSpan(effectiveColor), start, end, flags,
                )
            }
            if (s.has("fontSize") && !s.isNull("fontSize")) {
                val sp = s.optDouble("fontSize").toFloat()
                val px = TypedValue.applyDimension(
                    TypedValue.COMPLEX_UNIT_SP, sp, context.resources.displayMetrics
                ).toInt()
                spannable.setSpan(
                    android.text.style.AbsoluteSizeSpan(px, false), start, end, flags,
                )
            }
            val fontFamily = if (s.has("fontFamily") && !s.isNull("fontFamily")) {
                s.optString("fontFamily")
            } else {
                null
            }
            if (!fontFamily.isNullOrEmpty()) {
                // TypefaceSpan(String) yalnızca sistem genel ailelerini
                // ("serif", "monospace", "sans-serif") tanır; özel/gömülü
                // fontlar widget'ta yansımaz, sessizce sistem varsayılanına
                // düşer — RemoteViews'ta uygulamanın kendi font asset'lerini
                // yüklemek desteklenmiyor.
                spannable.setSpan(
                    android.text.style.TypefaceSpan(fontFamily), start, end, flags,
                )
            }
        }
        return spannable
    }

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
                child.setTextViewText(
                    R.id.line_checkbox_text,
                    buildRichLineText(line.optString("text", ""), line.optJSONArray("spans")),
                )
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
                val type = line.optString("type")
                val displayText: CharSequence = if (type == "drawing") {
                    "\u270F\uFE0F Çizim"
                } else {
                    buildRichLineText(line.optString("text", ""), line.optJSONArray("spans"))
                }
                child.setTextViewText(R.id.line_text, displayText)
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
