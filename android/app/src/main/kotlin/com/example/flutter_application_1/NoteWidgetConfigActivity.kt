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

        // Uygulamanın not kartlarıyla aynı renk paleti (bkz.
        // note_list_build_mixin.dart _buildGridNoteCard).
        private const val COLOR_BG = "#1E1E1E"
        private const val COLOR_CARD = "#2D2D2D"
        private const val COLOR_TITLE = "#FFFFFF"
        private const val COLOR_PREVIEW = "#B0B0B0"
        private const val COLOR_AMBER = "#FFC107"
    }

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
        val notes = readNotes(prefs)

        val root = LinearLayout(this).apply {
            orientation = LinearLayout.VERTICAL
            setBackgroundColor(Color.parseColor(COLOR_BG))
            layoutParams = LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT,
                LinearLayout.LayoutParams.MATCH_PARENT
            )
        }

        val heading = TextView(this).apply {
            text = "Widget'ta gösterilecek notu seç"
            setTextColor(Color.WHITE)
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
                text = "Henüz senkronize edilmiş not bulunamadı.\n\n" +
                    "Önce DNote uygulamasını açıp en az bir not oluşturun " +
                    "(veya mevcut bir notu düzenleyip kaydedin), ardından " +
                    "widget'ı tekrar eklemeyi deneyin.\n\n" +
                    "Ya da widget'ı şimdilik notsuz ekleyebilirsiniz; " +
                    "ilk not oluşturulduğunda otomatik güncellenecektir."
                setTextColor(Color.parseColor(COLOR_PREVIEW))
                textSize = 14f
                setPadding(dp(20), dp(8), dp(20), dp(12))
            }
            root.addView(empty)

            val continueBtn = TextView(this).apply {
                text = "Notsuz Devam Et"
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
                setBackgroundColor(Color.parseColor(COLOR_BG))
                selector = ColorDrawable(Color.TRANSPARENT)
            }
            listView.adapter = NoteCardAdapter(this, notes)
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
                val noteTitle = note.optString("title", "Başlıksız not")
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
    ) : BaseAdapter() {

        private fun dp(value: Int): Int =
            (value * ctx.resources.displayMetrics.density).toInt()

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
            holder.title.text = entry.title
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
                setColor(Color.parseColor(COLOR_CARD))
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
                setTextColor(Color.parseColor(COLOR_TITLE))
                textSize = 16f
                setTypeface(typeface, android.graphics.Typeface.BOLD)
                maxLines = 1
                ellipsize = TextUtils.TruncateAt.END
            }
            card.addView(title)

            val preview = TextView(ctx).apply {
                setTextColor(Color.parseColor(COLOR_PREVIEW))
                textSize = 13f
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
