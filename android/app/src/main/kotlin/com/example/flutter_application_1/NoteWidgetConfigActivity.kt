package com.example.flutter_application_1

import android.app.Activity
import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.content.res.ColorStateList
import android.graphics.Color
import android.graphics.drawable.ColorDrawable
import android.graphics.drawable.GradientDrawable
import android.graphics.drawable.RippleDrawable
import android.os.Bundle
import android.text.TextUtils
import android.util.Log
import android.view.View
import android.view.ViewGroup
import android.widget.AbsListView
import android.widget.AdapterView
import android.widget.BaseAdapter
import android.widget.LinearLayout
import android.widget.ListView
import android.widget.TextView
import org.json.JSONObject

// ════════════════════════════════════════════════════════════════════════
// WIDGET YAPILANDIRMA (NOT SEÇİCİ) EKRANI
//
// Kullanıcı DNote widget'ını ana ekrana sürüklediği anda, sistem widget'ı
// yerleştirmeden ÖNCE bu Activity'yi açar (bkz. AndroidManifest.xml'deki
// APPWIDGET_CONFIGURE intent-filter'ı ve note_widget_info.xml'deki
// android:configure özniteliği). Kullanıcı bir not seçer; o seçim SADECE
// bu widget örneğine (appWidgetId) özel olarak kaydedilir — aynı ekranda
// birden fazla DNote widget'ı varsa her biri farklı bir not gösterebilir.
// Kullanıcı seçim yapmadan (geri tuşu/jest ile) çıkarsa widget hiç
// eklenmez; bu, Android'in standart yapılandırma ekranı sözleşmesidir.
//
// Not listesi, NoteWidgetService.syncFromNotes tarafından uygulama her
// not kaydettiğinde "all_notes_json" anahtarına (id -> {title, preview,
// modifiedDate} haritası, JSON) yazılır. Bu yüzden widget eklenmeden önce
// uygulamanın en az bir kez açılıp senkronize olmuş olması gerekir; hiç
// veri yoksa aşağıda buna uygun bir boş durum mesajı gösterilir.
//
// DÜZELTME (2026-08-08): Bu ekran eskiden düz ArrayAdapter + tek satırlık
// sistem stiliyle (android.R.layout.simple_list_item_1) çiziliyordu ve
// uygulamanın geri kalanıyla hiç görsel tutarlılığı yoktu. Şimdi Flutter
// tarafındaki gerçek not kartlarıyla aynı dili kullanan (koyu kart
// #2D2D2D, 12dp köşe yuvarlama, kalın beyaz başlık + altında gri
// önizleme, amber dokunma efekti) programatik bir kart listesi çiziyor
// (bkz. NoteCardAdapter, aşağıda).
// ════════════════════════════════════════════════════════════════════════
class NoteWidgetConfigActivity : Activity() {

    companion object {
        private const val TAG = "NOTEWIDGET_DEBUG"
        private const val PREFS_NAME = "HomeWidgetPreferences"
        private const val KEY_ALL_NOTES_JSON = "all_notes_json"
        // theme.dart -> dNoteSyncThemeToWidgetStorage tarafından yazılır
        // (main() içinde açılışta bir kez, ve appThemeMode her
        // değiştiğinde tekrar). Anahtar bulunamazsa (widget'ı hiç
        // güncellenmemiş çok eski bir kurulum) uygulamanın varsayılan
        // teması olan Koyu'ya (appThemeMode = ThemeMode.dark) düşülür.
        private const val KEY_IS_DARK_THEME = "is_dark_theme"

        // ── Koyu tema paleti (bkz. main.dart _dNoteDarkTheme /
        // dNoteCardColor / dNoteTextColor ve note_list_build_mixin.dart
        // _buildGridNoteCard'daki gerçek grid kart rengi) ──
        private const val COLOR_BG_DARK = "#1E1E1E"
        private const val COLOR_CARD_DARK = "#2D2D2D"
        private const val COLOR_TITLE_DARK = "#FFFFFF"
        private const val COLOR_CARD_PREVIEW_TEXT_DARK = "#FFFFFF"
        // Boş durum mesajı için soluk/muted metin — bilgilendirme metni,
        // not kartı önizlemesi değil, bu yüzden diğerlerinden ayrı tutulur.
        private const val COLOR_MUTED_TEXT_DARK = "#B0B0B0"

        // ── Açık tema paleti (bkz. main.dart _dNoteLightTheme:
        // scaffoldBackgroundColor #F5F5F5, cardTheme Colors.white,
        // dNoteTextColor light #1A1A1A, dNoteBorderColor light #DADADA) ──
        private const val COLOR_BG_LIGHT = "#F5F5F5"
        private const val COLOR_CARD_LIGHT = "#FFFFFF"
        private const val COLOR_TITLE_LIGHT = "#1A1A1A"
        private const val COLOR_CARD_PREVIEW_TEXT_LIGHT = "#1A1A1A"
        private const val COLOR_MUTED_TEXT_LIGHT = "#6B6B6B"
        // Açık temada beyaz kart, açık gri (#F5F5F5) zemin üzerinde
        // kendiliğinden ayırt edilmiyor; ince bir kenarlık eklenir (bkz.
        // main.dart dNoteBorderColor light değeriyle aynı ton).
        private const val COLOR_CARD_BORDER_LIGHT = "#DADADA"

        // Vurgu (amber) rengi her iki temada da aynı — uygulamanın
        // appAccentColor varsayılanıyla (Colors.amber) birebir aynı.
        // NOT: Kullanıcı Ayarlar > Tema > Vurgu Rengi'nden bunu
        // değiştirebiliyor ama o tercih de (appThemeMode gibi) native
        // tarafa henüz yazılmıyor; bu yüzden burada sabit tutuluyor.
        private const val COLOR_AMBER = "#FFC107"
    }

    // Bu widget örneğine özel değil, tüm uygulamanın o anki Açık/Koyu tema
    // tercihine göre karar verilir (bkz. KEY_IS_DARK_THEME açıklaması).
    private var isDarkTheme = true
    private fun colorBg() = if (isDarkTheme) COLOR_BG_DARK else COLOR_BG_LIGHT
    private fun colorCard() = if (isDarkTheme) COLOR_CARD_DARK else COLOR_CARD_LIGHT
    private fun colorTitle() = if (isDarkTheme) COLOR_TITLE_DARK else COLOR_TITLE_LIGHT
    private fun colorCardPreviewText() =
        if (isDarkTheme) COLOR_CARD_PREVIEW_TEXT_DARK else COLOR_CARD_PREVIEW_TEXT_LIGHT
    private fun colorMutedText() =
        if (isDarkTheme) COLOR_MUTED_TEXT_DARK else COLOR_MUTED_TEXT_LIGHT

    private var appWidgetId = AppWidgetManager.INVALID_APPWIDGET_ID

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Kullanıcı bir not seçmeden çıkarsa widget eklenmesin diye
        // başlangıçta İPTAL sonucu ayarlanır; seçim yapılınca RESULT_OK'a
        // çevrilir (bkz. onNoteSelected).
        setResult(RESULT_CANCELED)

        appWidgetId = intent?.extras?.getInt(
            AppWidgetManager.EXTRA_APPWIDGET_ID,
            AppWidgetManager.INVALID_APPWIDGET_ID
        ) ?: AppWidgetManager.INVALID_APPWIDGET_ID

        if (appWidgetId == AppWidgetManager.INVALID_APPWIDGET_ID) {
            finish()
            return
        }

        val prefs = getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
        // KEY_IS_DARK_THEME anahtarı yoksa (Boolean için getBoolean 2.
        // parametre olarak varsayılan alır) uygulamanın varsayılan teması
        // olan Koyu'ya düşülür — bkz. theme.dart appThemeMode = ThemeMode.dark.
        isDarkTheme = prefs.getBoolean(KEY_IS_DARK_THEME, true)
        val notes = readNotes(prefs)

        val root = LinearLayout(this).apply {
            orientation = LinearLayout.VERTICAL
            setBackgroundColor(Color.parseColor(colorBg()))
            layoutParams = LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT,
                LinearLayout.LayoutParams.MATCH_PARENT
            )
        }

        val heading = TextView(this).apply {
            text = getString(R.string.widget_config_heading)
            setTextColor(Color.parseColor(colorTitle()))
            textSize = 18f
            setPadding(dp(20), dp(24), dp(20), dp(12))
        }
        root.addView(heading)

        if (notes.isEmpty()) {
            // DÜZELTME (2026-08-08): Bu dal daha önce kullanıcıyı bilgi
            // metniyle baş başa bırakıyordu; tıklanacak hiçbir öğe
            // olmadığından RESULT_CANCELED (onCreate'in başında ayarlanan
            // varsayılan) hiç RESULT_OK'a çevrilmiyordu. Kullanıcı geri
            // tuşuna basınca sistem "Widget eklenemedi" mesajı gösteriyordu
            // — kullanıcı raporundaki sorun buydu. Şimdi "Notsuz Devam Et"
            // seçeneğiyle bu durumdan da RESULT_OK ile çıkılabiliyor;
            // NoteWidget.kt zaten notId boşken "Henüz not yok" göstermeye
            // hazır, ilk not kaydedildiğinde widget otomatik güncellenir.
            val empty = TextView(this).apply {
                text = getString(R.string.widget_config_empty_state)
                setTextColor(Color.parseColor(colorMutedText()))
                textSize = 14f
                setPadding(dp(20), dp(8), dp(20), dp(12))
            }
            root.addView(empty)

            val continueBtn = TextView(this).apply {
                text = getString(R.string.widget_config_continue_without_note)
                setTextColor(Color.parseColor(COLOR_AMBER))
                textSize = 15f
                setTypeface(typeface, android.graphics.Typeface.BOLD)
                setPadding(dp(20), dp(12), dp(20), dp(20))
                setOnClickListener { onNoteSelected(prefs, "") }
            }
            root.addView(continueBtn)
        } else {
            val listView = ListView(this).apply {
                divider = null
                dividerHeight = 0
                clipToPadding = false
                setPadding(dp(12), dp(4), dp(12), dp(16))
                setBackgroundColor(Color.parseColor(colorBg()))
                selector = ColorDrawable(Color.TRANSPARENT)
            }
            listView.adapter = NoteCardAdapter(this, notes, isDarkTheme)
            listView.onItemClickListener =
                AdapterView.OnItemClickListener { _, _: View, position: Int, _ ->
                    onNoteSelected(prefs, notes[position].id)
                }
            root.addView(
                listView,
                LinearLayout.LayoutParams(
                    LinearLayout.LayoutParams.MATCH_PARENT,
                    0,
                    1f
                )
            )
        }

        setContentView(root)
    }

    private fun dp(value: Int): Int =
        (value * resources.displayMetrics.density).toInt()

    // Widget'ta gösterilecek her not için gerekli alanlar. `title` ve
    // `preview` ayrı tutulur ki kart, uygulamadaki not kartlarıyla aynı
    // şekilde (kalın başlık + altında gri önizleme) çizilebilsin.
    data class NoteEntry(
        val id: String,
        val title: String,
        val preview: String,
        val modifiedDate: String,
    )

    // "all_notes_json" -> NoteEntry listesi, en son değiştirilen not
    // listenin en üstünde olacak şekilde sıralanmış.
    private fun readNotes(prefs: SharedPreferences): List<NoteEntry> {
        val raw = prefs.getString(KEY_ALL_NOTES_JSON, null) ?: return emptyList()
        return try {
            val obj = JSONObject(raw)
            val items = mutableListOf<NoteEntry>()
            val keys = obj.keys()
            while (keys.hasNext()) {
                val id = keys.next()
                val note = obj.optJSONObject(id) ?: continue
                // NoteWidgetService.syncFromNotes bilinçli olarak boş
                // başlığı "Başlıksız not" ile doldurmuyor (bkz. o
                // dosyadaki açıklama); burada da aynı davranış korunur ki
                // getView()'daki boş-başlık gizleme mantığı doğru çalışsın.
                val noteTitle = note.optString("title", "")
                val preview = note.optString("preview", "")
                val modifiedDate = note.optString("modifiedDate", "")
                items.add(NoteEntry(id, noteTitle, preview, modifiedDate))
            }
            items.sortByDescending { it.modifiedDate }
            items
        } catch (e: Throwable) {
            Log.e(TAG, "readNotes JSON parse hatasi: ${e.message}", e)
            emptyList()
        }
    }

    private fun onNoteSelected(prefs: SharedPreferences, noteId: String) {
        prefs.edit()
            .putString(NoteWidgetReceiverV2.pinnedNoteKey(appWidgetId), noteId)
            .apply()

        // Widget'ı hemen, seçilen notla güncelle — sistemin varsayılan
        // onUpdate döngüsünü beklemeden widget doğru içerikle belirir.
        val appWidgetManager = AppWidgetManager.getInstance(this)
        NoteWidgetReceiverV2.updateWidget(this, appWidgetManager, appWidgetId)

        val resultValue = Intent().putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, appWidgetId)
        setResult(RESULT_OK, resultValue)
        finish()
    }

    // Uygulamanın not kartlarıyla (bkz. note_list_build_mixin.dart
    // _buildGridNoteCard) aynı görsel dili kullanan kart adaptörü: koyu
    // kart zemini, 12dp köşe yuvarlama, dokununca beliren amber ripple,
    // kalın beyaz başlık + altında gri önizleme (varsa).
    //
    // DÜZELTME: Bu sınıf önceden `inner class` idi (Activity'nin dp()
    // fonksiyonuna erişebilmek için). Ancak Kotlin, bir `inner class`
    // içine düz (inner olmayan) bir nested class tanımlamaya izin vermez
    // ("'Class' is prohibited here" derleme hatası — bkz. ViewHolder ve
    // InflatedRow altta). Bu yüzden sınıf artık `inner` değil ve dp()
    // hesaplamasını kendi Context'inden bağımsız olarak yapıyor.
    private class NoteCardAdapter(
        private val ctx: Context,
        private val items: List<NoteEntry>,
        private val isDarkTheme: Boolean,
    ) : BaseAdapter() {

        private fun dp(value: Int): Int =
            (value * ctx.resources.displayMetrics.density).toInt()

        private fun colorCard() = if (isDarkTheme) COLOR_CARD_DARK else COLOR_CARD_LIGHT
        private fun colorTitle() = if (isDarkTheme) COLOR_TITLE_DARK else COLOR_TITLE_LIGHT
        private fun colorCardPreviewText() =
            if (isDarkTheme) COLOR_CARD_PREVIEW_TEXT_DARK else COLOR_CARD_PREVIEW_TEXT_LIGHT

        override fun getCount(): Int = items.size
        override fun getItem(position: Int): NoteEntry = items[position]
        override fun getItemId(position: Int): Long = position.toLong()

        override fun getView(position: Int, convertView: View?, parent: ViewGroup): View {
            val holder: ViewHolder
            val rowView: View
            if (convertView == null) {
                val inflated = createCardRow()
                rowView = inflated.root
                holder = inflated.holder
                rowView.tag = holder
            } else {
                rowView = convertView
                holder = rowView.tag as ViewHolder
            }

            val entry = items[position]
            // DÜZELTME: Başlık boşsa (bkz. NoteWidgetService.syncFromNotes —
            // boş başlık artık "Başlıksız not" ile doldurulmuyor, olduğu
            // gibi boş string yazılıyor) satır tamamen gizlenir; aksi halde
            // kartın üstünde boş bir satır/boşluk kalıyordu. Aynı mantık
            // zaten preview için burada uygulanıyordu, title için de
            // eşitlendi.
            if (entry.title.isNotEmpty()) {
                holder.title.text = entry.title
                holder.title.visibility = View.VISIBLE
            } else {
                holder.title.visibility = View.GONE
            }
            if (entry.preview.isNotEmpty()) {
                holder.preview.text = entry.preview
                holder.preview.visibility = View.VISIBLE
            } else {
                holder.preview.visibility = View.GONE
            }
            return rowView
        }

        private class ViewHolder(val title: TextView, val preview: TextView)

        private class InflatedRow(val root: View, val holder: ViewHolder)

        private fun createCardRow(): InflatedRow {
            // Dış kapsayıcı: kartlar arasında boşluk bırakmak için (ListView
            // satırlarında margin doğrudan desteklenmediğinden alt padding
            // ile boşluk sağlanır).
            val outer = LinearLayout(ctx).apply {
                orientation = LinearLayout.VERTICAL
                setPadding(0, 0, 0, dp(10))
                layoutParams = AbsListView.LayoutParams(
                    AbsListView.LayoutParams.MATCH_PARENT,
                    AbsListView.LayoutParams.WRAP_CONTENT,
                )
            }

            val cardBackground = GradientDrawable().apply {
                cornerRadius = dp(12).toFloat()
                setColor(Color.parseColor(colorCard()))
                // Açık temada beyaz kart, #F5F5F5 zemin üzerinde neredeyse
                // hiç ayırt edilmiyor; ince bir kenarlıkla belirginleştirilir.
                // Koyu temada zaten yeterli kontrast olduğundan eklenmez.
                if (!isDarkTheme) {
                    setStroke(dp(1), Color.parseColor(COLOR_CARD_BORDER_LIGHT))
                }
            }
            val ripple = RippleDrawable(
                ColorStateList.valueOf(Color.parseColor(COLOR_AMBER)).withAlpha(60),
                cardBackground,
                null,
            )

            val card = LinearLayout(ctx).apply {
                orientation = LinearLayout.VERTICAL
                background = ripple
                setPadding(dp(16), dp(14), dp(16), dp(14))
                layoutParams = LinearLayout.LayoutParams(
                    LinearLayout.LayoutParams.MATCH_PARENT,
                    LinearLayout.LayoutParams.WRAP_CONTENT,
                )
            }

            val title = TextView(ctx).apply {
                setTextColor(Color.parseColor(colorTitle()))
                textSize = 18f
                setTypeface(typeface, android.graphics.Typeface.BOLD)
                maxLines = 1
                ellipsize = TextUtils.TruncateAt.END
            }
            card.addView(title)

            val preview = TextView(ctx).apply {
                setTextColor(Color.parseColor(colorCardPreviewText()))
                textSize = 16f
                maxLines = 2
                ellipsize = TextUtils.TruncateAt.END
                setPadding(0, dp(6), 0, 0)
            }
            card.addView(preview)

            outer.addView(card)
            return InflatedRow(outer, ViewHolder(title, preview))
        }
    }
}
