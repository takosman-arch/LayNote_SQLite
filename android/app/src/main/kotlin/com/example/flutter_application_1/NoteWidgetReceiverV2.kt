package com.example.flutter_application_1

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.net.Uri
import android.os.Bundle
import android.util.Log
import android.util.TypedValue
import android.view.View
import android.widget.RemoteViews
import androidx.core.graphics.ColorUtils
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import org.json.JSONObject

class NoteWidgetReceiverV2 : AppWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        Log.e("NOTEWIDGET_DEBUG", "onUpdate CALLED, ids=${appWidgetIds.joinToString()}")
        for (appWidgetId in appWidgetIds) {
            updateWidget(context, appWidgetManager, appWidgetId)
        }
    }

    // Kullanıcı widget'ı ana ekranda yeniden boyutlandırdığında (ör. tek
    // satıra kadar küçülttüğünde) sistem bunu bize bildirir. Burada
    // updateWidget'ı tekrar çağırıyoruz; updateWidget içinde güncel
    // boyuta bakılıp gerekirse "compact" (yalnızca başlık) görünüme
    // geçiliyor. Bu override olmadan, widget yeniden boyutlandırılınca
    // içerik/sayaç satırları küçülen alana sığmadan kırpılmış kalırdı.
    override fun onAppWidgetOptionsChanged(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetId: Int,
        newOptions: Bundle
    ) {
        updateWidget(context, appWidgetManager, appWidgetId)
    }

    // Bir widget örneği ana ekrandan kaldırıldığında, o örneğe özel
    // kaydedilmiş "hangi not gösterilsin" seçimini de temizle; aksi halde
    // SharedPreferences'ta kalıcı olarak kullanılmayan kayıtlar birikir.
    override fun onDeleted(context: Context, appWidgetIds: IntArray) {
        val prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
        val editor = prefs.edit()
        for (id in appWidgetIds) {
            editor.remove(pinnedNoteKey(id))
        }
        editor.apply()
        super.onDeleted(context, appWidgetIds)
    }

    companion object {
        private const val TAG = "NOTEWIDGET_DEBUG"
        private const val PREFS_NAME = "HomeWidgetPreferences"

        private const val KEY_TITLE = "note_title"
        private const val KEY_CONTENT = "note_content"
        private const val KEY_COUNT = "note_count"
        private const val KEY_NOTE_ID = "note_id"
        private const val KEY_ALL_NOTES_JSON = "all_notes_json"

        // Widget'ın checklist/hesap tablosu bloklarını satır satır (checkbox
        // ikonlu, tablo hizalamalı) çizebilmesi için Dart tarafının
        // NoteWidgetService._buildStructuredLines ile ürettiği yapılandırılmış
        // satır listesi. Format: {"noteId": [ {satır...}, ... ], ...}
        private const val KEY_ALL_NOTES_LINES_JSON = "all_notes_lines_json"
        private const val KEY_FONT_SIZE = "widget_font_size"
        private const val KEY_BG_OPACITY = "widget_bg_opacity"
        private const val KEY_DARK = "widget_dark"

        // Bir widget örneğinin (appWidgetId) kullanıcı tarafından SEÇİLMİŞ
        // notunun id'sinin SharedPreferences'ta saklandığı anahtar. AYNI
        // ÖNEK NoteWidgetConfigActivity.kt içinde de kullanılıyor — anahtar
        // biçimi orada değişirse burada da değişmeli.
        fun pinnedNoteKey(appWidgetId: Int): String = "note_id_widget_$appWidgetId"

        // "all_notes_json" içinden verilen id'ye ait notun (title, preview)
        // çiftini döndürür. Not bulunamazsa (silinmiş/kilitlenmiş/JSON
        // bozuksa) null döner; çağıran taraf bu durumda "en son not"
        // yedeğine (fallback) düşer.
        private fun resolvePinnedNote(
            prefs: SharedPreferences,
            noteId: String
        ): Pair<String, String>? {
            val raw = prefs.getString(KEY_ALL_NOTES_JSON, null) ?: return null
            return try {
                val obj = JSONObject(raw)
                val note = obj.optJSONObject(noteId) ?: return null
                val t = note.optString("title", "")
                val p = note.optString("preview", "")
                t to p
            } catch (e: Throwable) {
                Log.e(TAG, "resolvePinnedNote JSON parse hatasi: ${e.message}", e)
                null
            }
        }

        // "all_notes_lines_json" içinden verilen not id'sine ait yapılandırılmış
        // satır dizisini (JSONArray) döndürür. Bu, pinned/latest ayrımı
        // yapmadan çalışır: noteId zaten updateWidget içinde pinned notu
        // veya en son notu doğru şekilde çözmüş oluyor, biz sadece o id'nin
        // satırlarını buluyoruz. Satır bulunamazsa (eski/senkronize
        // edilmemiş veri, silinmiş not vb.) null döner; çağıran taraf bu
        // durumda düz metin (KEY_CONTENT) yedeğine düşer.
        private fun resolveNoteLines(
            prefs: SharedPreferences,
            noteId: String?
        ): org.json.JSONArray? {
            if (noteId.isNullOrEmpty()) return null
            val raw = prefs.getString(KEY_ALL_NOTES_LINES_JSON, null) ?: return null
            return try {
                val obj = JSONObject(raw)
                val arr = obj.optJSONArray(noteId)
                if (arr != null && arr.length() > 0) arr else null
            } catch (e: Throwable) {
                Log.e(TAG, "resolveNoteLines JSON parse hatasi: ${e.message}", e)
                null
            }
        }

        private fun SharedPreferences.getFloatCompat(key: String, default: Float): Float {
            if (!contains(key)) return default
            return try {
                getFloat(key, default)
            } catch (e: ClassCastException) {
                try {
                    // home_widget paketi double değeri Long olarak, değerin
                    // ham IEEE 754 bit kalıbı şeklinde kaydediyor. Long'u
                    // doğrudan Float'a çevirmek (numeric conversion) yanlış
                    // sonuç verir (örn. 14.0 -> 4.6e18). Önce bit kalıbını
                    // Double'a geri yorumlamak (reinterpret), sonra Float'a
                    // indirmek gerekir.
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

        fun updateWidget(
            context: Context,
            appWidgetManager: AppWidgetManager,
            appWidgetId: Int
        ) {
            Log.e(TAG, "updateWidget START, appWidgetId=$appWidgetId")
            try {
                updateWidgetInner(context, appWidgetManager, appWidgetId)
            } catch (e: Throwable) {
                // DÜZELTME (2026-08-08): Bu genel try/catch, updateWidget
                // içindeki HERHANGİ bir beklenmedik hatanın (öngörülmemiş bir
                // edge-case) updateAppWidget() çağrısına hiç ulaşılamamasına
                // ve widget'ın sistem tarafından "eklenemedi/yüklenemedi"
                // durumunda bırakılmasına engel olur. Böyle bir durumda en
                // azından başlığı gösteren minimal, güvenli bir RemoteViews
                // uygulanır — widget tamamen boş/hatalı görünmez.
                Log.e(TAG, "updateWidget GENEL COKME: ${e.javaClass.simpleName}: ${e.message}", e)
                try {
                    val fallback = RemoteViews(context.packageName, R.layout.note_widget)
                    fallback.setTextViewText(R.id.widget_title, "Layout")
                    fallback.setViewVisibility(R.id.widget_content, View.GONE)
                    fallback.setViewVisibility(R.id.widget_lines_container, View.GONE)
                    fallback.setViewVisibility(R.id.widget_count, View.GONE)
                    appWidgetManager.updateAppWidget(appWidgetId, fallback)
                    Log.e(TAG, "updateWidget FALLBACK OK -> minimal widget uygulandi")
                } catch (e2: Throwable) {
                    Log.e(TAG, "updateWidget FALLBACK DA COKTU: ${e2.javaClass.simpleName}: ${e2.message}", e2)
                }
            }
        }

        private fun updateWidgetInner(
            context: Context,
            appWidgetManager: AppWidgetManager,
            appWidgetId: Int
        ) {
            val prefs: SharedPreferences =
                context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)

            val title0 = prefs.getString(KEY_TITLE, null) ?: "Henüz not yok"
            val content0 = prefs.getString(KEY_CONTENT, "") ?: ""
            val count = prefs.getInt(KEY_COUNT, 0)
            val latestNoteId = prefs.getString(KEY_NOTE_ID, null)
            val fontSize = prefs.getFloatCompat(KEY_FONT_SIZE, 14f)
            val bgOpacity = prefs.getFloatCompat(KEY_BG_OPACITY, 1f).coerceIn(0f, 1f)
            val dark = prefs.getBoolean(KEY_DARK, true)

            // Bu widget örneği için kullanıcı yapılandırma ekranından
            // (NoteWidgetConfigActivity) özel bir not seçmiş olabilir. Öyle
            // bir seçim varsa VE o not hâlâ görünürse (silinmemiş/kilitli
            // veya arşivli değilse, bkz. all_notes_json'ın Dart tarafındaki
            // üretimi) o notu göster. Aksi halde (widget hiç
            // yapılandırılmamışsa, veya seçilen not artık görünür değilse)
            // eskisi gibi "en son değiştirilen not" gösterilir.
            val pinnedNoteId = prefs.getString(pinnedNoteKey(appWidgetId), null)
            var title = title0
            var content = content0
            var noteId = latestNoteId
            if (!pinnedNoteId.isNullOrEmpty()) {
                val resolved = resolvePinnedNote(prefs, pinnedNoteId)
                if (resolved != null) {
                    title = resolved.first
                    content = resolved.second
                    noteId = pinnedNoteId
                }
            }
            Log.e(TAG, "ADIM 1 OK -> title='$title' content='$content' count=$count fontSize=$fontSize bgOpacity=$bgOpacity dark=$dark pinnedNoteId=$pinnedNoteId")

            val bgColor = if (dark) 0xFF1E1E1E.toInt() else 0xFFFFFFFF.toInt()
            val titleColor = if (dark) 0xFFFFFFFF.toInt() else 0xFF1A1A1A.toInt()
            // DÜZELTME: alt metin (içerik önizleme + satırlar) soluk/silik
            // görünmemesi için artık başlıkla aynı tam kontrastlı rengi
            // kullanıyor — koyu temada tam beyaz, açık temada tam koyu.
            val subTextColor = titleColor
            val bgWithOpacity = ColorUtils.setAlphaComponent(
                bgColor,
                (bgOpacity * 255).toInt().coerceIn(0, 255)
            )
            Log.e(TAG, "ADIM 2 OK -> bgColor=$bgColor titleColor=$titleColor subTextColor=$subTextColor bgWithOpacity=$bgWithOpacity")

            val views = RemoteViews(context.packageName, R.layout.note_widget)
            Log.e(TAG, "ADIM 3 OK -> RemoteViews olusturuldu")

            // Widget'ın GÜNCEL (kullanıcının o an ayarladığı) yüksekliğini
            // oku. Tek satıra kadar küçültüldüğünde (yaklaşık 1 grid
            // hücresi, bkz. note_widget_info.xml'deki minResizeHeight=40dp
            // notu) içerik önizlemesi ve sayaç satırını gizleyip yalnızca
            // başlığı gösteriyoruz; aksi halde metin taşıp alttan kırpılırdı.
            val widgetOptions = appWidgetManager.getAppWidgetOptions(appWidgetId)
            val minHeightDp = widgetOptions.getInt(
                AppWidgetManager.OPTION_APPWIDGET_MIN_HEIGHT,
                0
            )
            // 0 = boyut bilgisi henüz mevcut değil (ör. ilk ekleme anı) ->
            // güvenli varsayım olarak tam görünüm kullanılır.
            val isCompact = minHeightDp in 1..65
            Log.e(TAG, "ADIM 3.1 OK -> minHeightDp=$minHeightDp isCompact=$isCompact")

            val density = context.resources.displayMetrics.density
            val padDp = if (isCompact) 6f else 12f
            val padPx = (padDp * density).toInt()
            views.setViewPadding(R.id.widget_root, padPx, padPx, padPx, padPx)

            views.setTextViewText(R.id.widget_title, title)
            views.setTextViewText(R.id.widget_content, content)
            views.setTextViewText(R.id.widget_count, "$count not")
            Log.e(TAG, "ADIM 4 OK -> setTextViewText (3 view) tamamlandi")

            // Notun başlığı yoksa (title boş string) "Başlıksız not" gibi
            // bir yer tutucu YAZILMAZ; başlık satırı tamamen gizlenir ki
            // içerik (checklist/tablo/metin) doğrudan en üstten görünsün.
            // "Henüz not yok" durumu (hiç not yokken) title boş DEĞİL,
            // dolu bir metin olduğu için bu durumdan etkilenmez.
            views.setViewVisibility(
                R.id.widget_title,
                if (title.isEmpty()) View.GONE else View.VISIBLE
            )

            // Yapılandırılmış satırlar (checkbox/tablo satırları) varsa
            // bunlar in-app görünümle aynı düzende çizilir; yoksa (eski
            // senkronize veri, henüz güncellenmemiş uygulama sürümü vb.)
            // eskisi gibi tek satırlık düz metin (widget_content) gösterilir.
            val linesArray = if (isCompact) null else resolveNoteLines(prefs, noteId)
            val hasStructuredLines = linesArray != null && linesArray.length() > 0
            Log.e(TAG, "ADIM 4.1 OK -> hasStructuredLines=$hasStructuredLines noteId=$noteId")

            views.setViewVisibility(
                R.id.widget_lines_container,
                if (hasStructuredLines) View.VISIBLE else View.GONE
            )

            // DÜZELTME: Satırlar artık burada tek tek addView ile
            // eklenmiyor — widget_lines_container bir ListView oldu
            // (kaydırma desteği için, bkz. NoteWidgetRemoteViewsService).
            // Gerçek satır üretimi (checkbox/tablo/metin) o servise
            // taşındı; burada sadece o servise bağlanacak Intent'i
            // kuruyoruz. Intent'in "data" alanı her widget örneği/not
            // kombinasyonu için BENZERSİZ olmalı — aksi halde sistem
            // aynı adapter'ı tüm widget örnekleri için önbelleğe alıp
            // yanlış notun satırlarını gösterebilir.
            if (hasStructuredLines) {
                try {
                    val checkedColor = 0xFFFFC107.toInt() // amber - in-app'teki işaretli checkbox rengiyle aynı
                    val dividerColor = ColorUtils.setAlphaComponent(subTextColor, 90)

                    val serviceIntent = Intent(context, NoteWidgetRemoteViewsService::class.java).apply {
                        putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, appWidgetId)
                        putExtra(NoteWidgetRemoteViewsService.EXTRA_NOTE_ID, noteId ?: "")
                        putExtra(NoteWidgetRemoteViewsService.EXTRA_FONT_SIZE, fontSize)
                        putExtra(NoteWidgetRemoteViewsService.EXTRA_TITLE_COLOR, titleColor)
                        putExtra(NoteWidgetRemoteViewsService.EXTRA_SUBTEXT_COLOR, subTextColor)
                        putExtra(NoteWidgetRemoteViewsService.EXTRA_CHECKED_COLOR, checkedColor)
                        putExtra(NoteWidgetRemoteViewsService.EXTRA_DIVIDER_COLOR, dividerColor)
                        // DÜZELTME: Önceden burada `data =
                        // Uri.parse(toUri(Intent.URI_INTENT_SCHEME))` vardı.
                        // Bu, Intent'in kendi extra'larından türetilen bir
                        // URI üretiyordu — AYNI not/widget/tema için HER
                        // ZAMAN birebir aynı URI çıkıyordu, çünkü hiçbir
                        // extra değişmiyordu (sadece SharedPreferences'taki
                        // JSON içeriği değişiyordu). Android bazı
                        // cihaz/launcher'larda "data" alanı aynı kalan bir
                        // Intent için RemoteViewsService bağlantısını/
                        // adaptörünü güvenilir şekilde yenilemiyor —
                        // notifyAppWidgetViewDataChanged() çağrılsa bile not
                        // kaydedildiğinde widget güncellenmiyor, ancak
                        // widget kaldırılıp yeniden eklendiğinde (GERÇEKTEN
                        // yeni bir bağlantı kurulduğunda) güncel veri
                        // görünüyordu — bildirilen sorunun ta kendisi.
                        // Şimdi URI'ye her çağrıda değişen bir zaman damgası
                        // ekleniyor; böylece sistem HER updateWidget
                        // çağrısında (yani her not kaydında) tazelenmiş,
                        // gerçekten yeni bir adaptör bağlantısı kurmak
                        // ZORUNDA kalıyor.
                        data = Uri.parse(
                            "dnote-widget://lines/$appWidgetId/${System.currentTimeMillis()}"
                        )
                    }
                    views.setRemoteAdapter(R.id.widget_lines_container, serviceIntent)
                    Log.e(TAG, "ADIM 4.2 OK -> setRemoteAdapter cagrildi")
                } catch (e: Throwable) {
                    Log.e(TAG, "ADIM 4.2 HATA -> setRemoteAdapter: ${e.javaClass.simpleName}: ${e.message}", e)
                }
            }

            views.setViewVisibility(
                R.id.widget_content,
                if (isCompact || hasStructuredLines || content.isEmpty()) View.GONE else View.VISIBLE
            )
            // İstek üzerine widget'ta "X not" şeklindeki toplam not sayısı
            // artık hiç gösterilmiyor.
            views.setViewVisibility(R.id.widget_count, View.GONE)

            views.setTextViewTextSize(R.id.widget_title, TypedValue.COMPLEX_UNIT_SP, fontSize)
            views.setTextViewTextSize(
                R.id.widget_content,
                TypedValue.COMPLEX_UNIT_SP,
                (fontSize - 2f).coerceAtLeast(8f)
            )
            views.setTextViewTextSize(
                R.id.widget_count,
                TypedValue.COMPLEX_UNIT_SP,
                (fontSize - 3f).coerceAtLeast(8f)
            )
            Log.e(TAG, "ADIM 5 OK -> setTextViewTextSize (3 view) tamamlandi")

            views.setTextColor(R.id.widget_title, titleColor)
            views.setTextColor(R.id.widget_content, subTextColor)
            views.setTextColor(R.id.widget_count, subTextColor)
            Log.e(TAG, "ADIM 6 OK -> setTextColor (3 view) tamamlandi")

            try {
                views.setInt(R.id.widget_root, "setBackgroundColor", bgWithOpacity)
                Log.e(TAG, "ADIM 7 OK -> setBackgroundColor tamamlandi")
            } catch (e: Throwable) {
                Log.e(TAG, "ADIM 7 HATA -> setBackgroundColor: ${e.javaClass.simpleName}: ${e.message}", e)
            }

            try {
                val launchUri = if (!noteId.isNullOrEmpty()) {
                    Uri.parse("dnote://note?id=$noteId")
                } else {
                    Uri.parse("dnote://note")
                }
                val pendingIntent = HomeWidgetLaunchIntent.getActivity(
                    context,
                    MainActivity::class.java,
                    launchUri
                )
                views.setOnClickPendingIntent(R.id.widget_root, pendingIntent)
                Log.e(TAG, "ADIM 8 OK -> PendingIntent tamamlandi (noteId=$noteId)")

                // DÜZELTME: ListView kendi alanındaki dokunuşları kaydırma
                // için yutuyor; widget_root'a bağlı PendingIntent artık
                // liste üzerindeyken hiç tetiklenmiyor. Liste satırlarının
                // da tıklanınca notu açabilmesi için ListView'e ayrıca bir
                // PendingIntentTemplate veriyoruz — her satır bu şablonu
                // kullanacak (bkz. NoteWidgetRemoteViewsService.setOnClickFillInIntent).
                if (hasStructuredLines) {
                    try {
                        views.setPendingIntentTemplate(R.id.widget_lines_container, pendingIntent)
                        Log.e(TAG, "ADIM 8.1 OK -> PendingIntentTemplate (liste) tamamlandi")
                    } catch (e: Throwable) {
                        Log.e(TAG, "ADIM 8.1 HATA -> PendingIntentTemplate: ${e.javaClass.simpleName}: ${e.message}", e)
                    }
                }
            } catch (e: Throwable) {
                Log.e(TAG, "ADIM 8 HATA -> PendingIntent: ${e.javaClass.simpleName}: ${e.message}", e)
            }

            try {
                appWidgetManager.updateAppWidget(appWidgetId, views)
                Log.e(TAG, "ADIM 9 OK -> updateAppWidget basariyla cagrildi, BITTI")
                // ListView adapter'ının veriyi TAZE çekmesi için şart —
                // sadece updateAppWidget çağırmak liste içeriğini tazelemez.
                if (hasStructuredLines) {
                    appWidgetManager.notifyAppWidgetViewDataChanged(appWidgetId, R.id.widget_lines_container)
                    Log.e(TAG, "ADIM 10 OK -> notifyAppWidgetViewDataChanged cagrildi")
                }
            } catch (e: Throwable) {
                Log.e(TAG, "ADIM 9 HATA -> updateAppWidget: ${e.javaClass.simpleName}: ${e.message}", e)
            }
        }
    }
}
