package com.example.flutter_application_1

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.app.ActivityOptions
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.graphics.Color
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
            // AŞAMA 1: font boyutu/saydamlık artık bu widget örneğine özel
            // olabildiği için (bkz. fontSizeKey/bgOpacityKey), pinnedNoteKey
            // ile aynı yaşam döngüsünde temizlenmesi gerekiyor — aksi halde
            // widget kaldırılıp appWidgetId ileride başka bir widget'a
            // yeniden atandığında eski değer sızabilirdi.
            editor.remove(fontSizeKey(id))
            editor.remove(bgOpacityKey(id))
            // Koyu/açık artık bu widget örneğine özel olabildiği için
            // (bkz. darkKey), aynı yaşam döngüsünde temizlenmesi gerekiyor.
            editor.remove(darkKey(id))
            // Kullanıcı isteği (arka plan rengi paleti, sadece Koyu kapalıyken
            // devreye girer): darkKey ile AYNI yaşam döngüsünde temizlenir.
            editor.remove(bgColorKey(id))
            // Kullanıcı isteği (⚙️ ikon görünürlük tercihi) darkKey ile
            // AYNI yaşam döngüsünde temizlenir. (➕ "yeni not" ikonu ve
            // ayrı "Yeni Not Ekle" widget'ı kaldırıldı — showAddIconKey
            // artık yok.)
            editor.remove(showSettingsIconKey(id))
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
        // DÜZELTME: Ayarlar sayfasındaki genel (tüm widget'lar için ortak)
        // Yazı Boyutu/Saydamlık/Koyu Mod bölümü kaldırıldı — bu değerleri
        // yazan tek yer oydu. Aşağıdaki DEFAULT_* sabitleri artık hiçbir
        // yerden yazılmayacakları için doğrudan sabit olarak tutuluyor.
        // Her widget örneği zaten NoteWidgetConfigActivity'nin "Widget'ı
        // Ekle" adımında kendi fontSizeKey/bgOpacityKey/darkKey değerini
        // koşulsuz kaydediyor (bkz. NoteWidgetConfigActivity.onNoteSelected),
        // bu yüzden bu sabitler pratikte sadece o kayıt hiç oluşmamışsa
        // (çok eski/olağandışı bir widget örneği) devreye girer. Tutarlılık
        // için NoteWidgetConfigActivity.kt'deki globalFontSize/
        // globalBgOpacity varsayılanlarıyla (23f/0.5f) AYNI tutuluyor;
        // NoteWidget.kt'deki AYNI sabitlerle senkron kalmalı.
        private const val DEFAULT_FONT_SIZE = 23f
        private const val DEFAULT_BG_OPACITY = 0.5f
        private const val DEFAULT_DARK = true

        // Kullanıcı isteği: Koyu kapatıldığında seçilebilen arka plan rengi
        // paleti. Beyaz varsayılan/başlangıç seçili — bu, darkKey false
        // olup bgColorKey hiç kaydedilmemiş ESKİ widget örnekleri için de
        // önceki sabit açık-tema rengiyle (0xFFFFFFFF) birebir aynı sonucu
        // verir, yani geriye dönük davranış DEĞİŞMEZ.
        const val DEFAULT_BG_COLOR_HEX = "#FFFFFF"

        // Kullanıcı isteği: sağ üstteki ⚙️ ikonunun varsayılan olarak
        // gösterilmesi — bu switch'ten ÖNCE eklenmiş widget örnekleri için
        // de (kaydedilmiş tercih yoksa) davranış DEĞİŞMEMİŞ olur, ikon
        // önceki gibi görünmeye devam eder. (➕ "yeni not" ikonu kaldırıldı.)
        private const val DEFAULT_SHOW_SETTINGS_ICON = true

        // Bir widget örneğinin (appWidgetId) kullanıcı tarafından SEÇİLMİŞ
        // notunun id'sinin SharedPreferences'ta saklandığı anahtar. AYNI
        // ÖNEK NoteWidgetConfigActivity.kt içinde de kullanılıyor — anahtar
        // biçimi orada değişirse burada da değişmeli.
        fun pinnedNoteKey(appWidgetId: Int): String = "note_id_widget_$appWidgetId"

        // AŞAMA 1 (widget'a özel ön ayarlar): widget_font_size ve
        // widget_bg_opacity artık TÜM widget'lar için ortak/global tek bir
        // değer değil — her appWidgetId kendi değerini saklayabilir.
        // pinnedNoteKey ile BİREBİR aynı desen: anahtar appWidgetId'ye göre
        // üretilir, bu widget örneği silinince onDeleted içinde temizlenir.
        //
        // NoteWidgetConfigActivity.onNoteSelected, widget her eklendiğinde
        // bu anahtarlara koşulsuz yazıyor — updateWidgetInner içindeki
        // okuma bu yüzden bulunamazsa artık DEFAULT_FONT_SIZE/DEFAULT_BG_OPACITY
        // sabitlerine düşüyor (eski global widget_font_size/widget_bg_opacity
        // anahtarları kaldırıldı, bkz. yukarıdaki not).
        fun fontSizeKey(appWidgetId: Int): String = "widget_font_size_widget_$appWidgetId"

        fun bgOpacityKey(appWidgetId: Int): String = "widget_bg_opacity_widget_$appWidgetId"

        // Koyu/açık, font boyutu/saydamlık ile AYNI desen: bulunamazsa
        // DEFAULT_DARK sabitine düşülür (bkz. updateWidgetInner'daki okuma
        // ve NoteWidget.kt'deki AYNI mantık).
        fun darkKey(appWidgetId: Int): String = "widget_dark_widget_$appWidgetId"

        // Kullanıcı isteği: Koyu switch'i kapatıldığında seçilen arka plan
        // rengi (hex string, ör. "#1565C0"). darkKey ile AYNI desen:
        // bulunamazsa DEFAULT_BG_COLOR_HEX sabitine düşülür. Bu değer
        // SADECE dark=false iken kullanılır — Koyu açıkken hâlâ sabit
        // #1E1E1E zemin uygulanır (bkz. updateWidgetInner).
        fun bgColorKey(appWidgetId: Int): String = "widget_bg_color_widget_$appWidgetId"

        // Kullanıcı isteği: darkKey ile BİREBİR aynı desen — bu widget
        // örneğine özel, bulunamazsa DEFAULT_SHOW_SETTINGS_ICON sabitine
        // düşülür (bkz. updateWidgetInner'daki okuma).
        fun showSettingsIconKey(appWidgetId: Int): String =
            "widget_show_settings_icon_widget_$appWidgetId"

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

        // Kullanıcı isteği (renk paleti): Koyu kapalıyken hangi arka plan
        // rengi seçilirse seçilsin metnin okunabilir kalması için, rengin
        // parlaklığına (luminance) bakılıp koyu/açık metin arasında karar
        // veriliyor. Eşik 0.5 — standart WCAG benzeri yaklaşım.
        private fun isColorLight(color: Int): Boolean =
            ColorUtils.calculateLuminance(color) > 0.5

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
            // Bu widget örneğine özel değer aranır (fontSizeKey/bgOpacityKey);
            // bulunamazsa (NoteWidgetConfigActivity akışı dışında oluşmuş,
            // olağandışı bir widget örneğiyse) sabit DEFAULT_* değerlerine
            // düşülür — bkz. yukarıdaki DEFAULT_FONT_SIZE/DEFAULT_BG_OPACITY notu.
            val fontSize = prefs.getFloatCompat(fontSizeKey(appWidgetId), DEFAULT_FONT_SIZE)
            val bgOpacity = prefs.getFloatCompat(bgOpacityKey(appWidgetId), DEFAULT_BG_OPACITY)
                .coerceIn(0f, 1f)
            // Koyu/açık: önce bu widget örneğine özel değer aranır
            // (NoteWidgetConfigActivity'deki switch ile kaydedilir); yoksa
            // sabit DEFAULT_DARK değerine düşülür.
            val dark = prefs.getBoolean(darkKey(appWidgetId), DEFAULT_DARK)

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

            // DÜZELTME (renk paleti): Koyu kapatıldığında artık sabit beyaz
            // yerine kullanıcının NoteWidgetConfigActivity'deki paletten
            // seçtiği renk kullanılıyor (bgColorKey). Koyu açıkken bu hiç
            // devreye girmiyor, davranış DEĞİŞMEDİ (hâlâ sabit #1E1E1E).
            val bgColor = if (dark) {
                0xFF1E1E1E.toInt()
            } else {
                val bgColorHex = prefs.getString(bgColorKey(appWidgetId), DEFAULT_BG_COLOR_HEX)
                    ?: DEFAULT_BG_COLOR_HEX
                try {
                    Color.parseColor(bgColorHex)
                } catch (e: Throwable) {
                    Log.e(TAG, "bgColorHex parse hatasi ('$bgColorHex'), beyaza dusuluyor: ${e.message}")
                    Color.parseColor(DEFAULT_BG_COLOR_HEX)
                }
            }
            // Metin/ikon rengi: Koyu açıkken hep beyaz (DEĞİŞMEDİ). Koyu
            // kapalıyken artık sabit koyu gri yerine seçilen arka plan
            // rengine göre KONTRAST hesaplanıyor — kullanıcı kırmızı/mavi/
            // mor gibi koyu tonlu bir renk seçerse metin beyaza, beyaz/
            // amber/turuncu gibi açık tonlu bir renk seçerse metin koyuya
            // düşer (bkz. isColorLight, luminance tabanlı).
            val titleColor = if (dark) {
                0xFFFFFFFF.toInt()
            } else if (isColorLight(bgColor)) {
                0xFF1A1A1A.toInt()
            } else {
                0xFFFFFFFF.toInt()
            }
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

            // DÜZELTME (başlık+ikon hepsi boşken üstte boş satır kalıyordu):
            // widget_title'ın INVISIBLE/GONE kararı, ikonun gösterilip
            // gösterilmediğine bağlı hale getirildi — bu yüzden
            // showSettingsIcon değeri (aşağıda ADIM 6.1'de ikon view'ına
            // uygulanan AYNI prefs okuması) buraya taşındı; tek kaynak
            // burada, aşağıda tekrar okunmuyor. (➕ "yeni not" ikonu
            // kaldırıldığı için anyIconVisible artık showSettingsIcon'la
            // aynı.)
            val showSettingsIcon = prefs.getBoolean(
                showSettingsIconKey(appWidgetId),
                DEFAULT_SHOW_SETTINGS_ICON
            )
            val anyIconVisible = showSettingsIcon

            // Notun başlığı yoksa (title boş string) "Başlıksız not" gibi
            // bir yer tutucu YAZILMAZ; başlık metni görünmez olur ki
            // içerik (checklist/tablo/metin) görsel olarak öne çıksın.
            // "Henüz not yok" durumu (hiç not yokken) title boş DEĞİL,
            // dolu bir metin olduğu için bu durumdan etkilenmez.
            //
            // DÜZELTME (ikonlar sola kayıyordu): önceden burada koşulsuz
            // GONE kullanılıyordu. Ama widget_title, note_widget.xml'de
            // layout_width="0dp" + layout_weight="1" ile ⚙️/➕ ikonlarını
            // sağda tutan "boşluk dolgusu" görevi de görüyor. GONE, view'ı
            // satırdan TAMAMEN çıkarıp bu boşluğu da yok ediyor; geriye
            // weight'siz sadece iki ikon kalınca satırın varsayılan
            // (sol) hizalamasına düşüp sol üstte görünüyorlardı. INVISIBLE
            // ise metni gizler ama weight ile ayrılan alanı/layout'u
            // KORUR, böylece ikonlar her durumda sağda kalır.
            //
            // DÜZELTME (2): fakat ikonların İKİSİ de kapatılmışsa (switch'ler
            // kapalıysa) artık korunacak bir "sağda tutma" ihtiyacı da yok —
            // bu durumda INVISIBLE, sadece görünmeyen ama yine de satır
            // yüksekliği kadar yer kaplayan boş bir satıra sebep oluyordu.
            // Böyle bir durumda (başlık boş VE hiçbir ikon görünmüyor)
            // widget_title GONE yapılıyor, satır tamamen çöküyor.
            views.setViewVisibility(
                R.id.widget_title,
                if (title.isEmpty()) {
                    if (anyIconVisible) View.INVISIBLE else View.GONE
                } else {
                    View.VISIBLE
                }
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
                    // DÜZELTME (zengin metin widget'ta görünmüyordu): satır
                    // içi span'ları (bold/italic/vb.) SpannableString'e
                    // çeviren NoteWidgetRemoteViewsService.buildRichLineText,
                    // highlight (vurgu kalemi) ve link rengini bu extra'lardan
                    // okuyor. Değerler rich_block_text_controller.dart'taki
                    // _highlightColorLight/_highlightColorDark ve _linkColor
                    // ile BİREBİR aynı — biri değişirse diğeri de güncellenmeli.
                    val highlightColor =
                        if (dark) 0xFF7A5B00.toInt() else 0xFFFFF59D.toInt()
                    val linkColor = 0xFF1A73E8.toInt()

                    val serviceIntent = Intent(context, NoteWidgetRemoteViewsService::class.java).apply {
                        putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, appWidgetId)
                        putExtra(NoteWidgetRemoteViewsService.EXTRA_NOTE_ID, noteId ?: "")
                        putExtra(NoteWidgetRemoteViewsService.EXTRA_FONT_SIZE, fontSize)
                        putExtra(NoteWidgetRemoteViewsService.EXTRA_TITLE_COLOR, titleColor)
                        putExtra(NoteWidgetRemoteViewsService.EXTRA_SUBTEXT_COLOR, subTextColor)
                        putExtra(NoteWidgetRemoteViewsService.EXTRA_CHECKED_COLOR, checkedColor)
                        putExtra(NoteWidgetRemoteViewsService.EXTRA_DIVIDER_COLOR, dividerColor)
                        putExtra(NoteWidgetRemoteViewsService.EXTRA_HIGHLIGHT_COLOR, highlightColor)
                        putExtra(NoteWidgetRemoteViewsService.EXTRA_LINK_COLOR, linkColor)
                        // DÜZELTME (2026-08-08, revize): Önceden burada `data =
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
                        // görünüyordu.
                        //
                        // Bunun düzeltmesi olarak URI'ye her çağrıda değişen
                        // bir System.currentTimeMillis() zaman damgası
                        // eklenmişti. Ancak bu, updateWidget'ı SADECE boyut
                        // değişikliği yüzünden çağıran onAppWidgetOptionsChanged
                        // (widget büyütülüp küçültülürken) için de HER SEFERİNDE
                        // yeni bir URI üretiyordu — not içeriği/renk/font hiç
                        // değişmemiş olsa bile. Android, "data" alanı önceki
                        // çağrıdan farklı olan bir Intent için adaptör
                        // bağlantısını koparıp sıfırdan kuruyor; bu kısa
                        // aradaki NoteLinesFactory.getLoadingView() ile
                        // gösterilen sistem varsayılanı, kullanıcının
                        // widget'ı yeniden boyutlandırırken gördüğü "Yükleniyor"
                        // yanıp sönmesinin sebebiydi.
                        //
                        // YENİ DÜZELTME: zaman damgası yerine, adaptörün
                        // gerçekten göstereceği verilerden (not id, satır
                        // JSON'u, font boyutu, renkler) türeyen DETERMİNİSTİK
                        // bir imza (hash) kullanılıyor. Böylece:
                        //  - Sırf boyut değiştiğinde (içerik/renk/font AYNI)
                        //    imza da aynı kalıyor -> URI değişmiyor -> sistem
                        //    mevcut adaptör bağlantısını koruyor -> "Yükleniyor"
                        //    hiç görünmüyor.
                        //  - Not gerçekten değiştiğinde (metin, satırlar,
                        //    tema/renk, font boyutu) imza da değişiyor -> URI
                        //    değişiyor -> adaptör eskisi gibi doğru şekilde
                        //    tazeleniyor (yukarıdaki orijinal sorunun çözümü
                        //    korunuyor).
                        val dataSignature = buildString {
                            append(noteId ?: "")
                            append('|'); append(linesArray?.toString() ?: "")
                            append('|'); append(fontSize)
                            append('|'); append(titleColor)
                            append('|'); append(subTextColor)
                            append('|'); append(checkedColor)
                            append('|'); append(dividerColor)
                            append('|'); append(highlightColor)
                            append('|'); append(linkColor)
                        }.hashCode()

                        data = Uri.parse(
                            "dnote-widget://lines/$appWidgetId/$dataSignature"
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

            // DÜZELTME: ⚙️ ikonunun çizim rengi de koyu/açık temaya göre
            // (titleColor ile AYNI ton) ayarlanıyor — beyaz sabit ikon
            // açık temada görünmez kalırdı.
            // Kullanıcı isteği: ⚙️ ikonu artık widget'a özel olarak
            // gizlenebiliyor. darkKey/fontSizeKey ile AYNI desen:
            // bulunamazsa DEFAULT_SHOW_SETTINGS_ICON'a (true) düşülür,
            // yani bu switch'ten ÖNCE eklenmiş widget'lar eskisi gibi
            // ikonu göstermeye devam eder.
            // (showSettingsIcon artık yukarıda, widget_title görünürlük
            // kararı için de kullanılabilmesi için hesaplanıyor.)
            // (➕ "yeni not" ikonu ve buna ait widget_add_button kaldırıldı
            // — bkz. note_widget.xml'de bu view'ın da kaldırılması gerekiyor.)
            views.setViewVisibility(
                R.id.widget_settings_button,
                if (showSettingsIcon) View.VISIBLE else View.GONE
            )

            try {
                views.setInt(R.id.widget_settings_button, "setColorFilter", titleColor)
            } catch (e: Throwable) {
                Log.e(TAG, "ADIM 6.1 HATA -> ikon setColorFilter: ${e.javaClass.simpleName}: ${e.message}", e)
            }

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

            // DÜZELTME: widget_settings_button'a AYRI bir PendingIntent
            // atanıyor — RemoteViews'te bir çocuk view'ın kendi
            // PendingIntent'i, üstündeki widget_root'unkinin ÖNÜNE geçer
            // (yani ikona dokunmak notu AÇMAZ, kendi eylemini yapar).
            try {
                // ⚙️ Ayarlar: NoteWidgetConfigActivity'yi bu appWidgetId ile
                // DOĞRUDAN açar. DÜZELTME (kullanıcı isteği): sistemin normal
                // APPWIDGET_CONFIGURE akışındaki (ör. uzun-bas menüsü) 1. adım
                // olan "not seçimi" ekranı BURADA atlanıyor — EXTRA_OPEN_APPEARANCE_STEP
                // extra'sı sayesinde Activity doğrudan "Görünümü ayarla" (2.
                // adım) ekranını, bu widget'ın zaten kayıtlı notu/ayarlarıyla
                // açıyor (bkz. NoteWidgetConfigActivity.onCreate).
                val configIntent = Intent(context, NoteWidgetConfigActivity::class.java).apply {
                    putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, appWidgetId)
                    putExtra(NoteWidgetConfigActivity.EXTRA_OPEN_APPEARANCE_STEP, true)
                    flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
                }
                // requestCode olarak appWidgetId kullanılıyor ki farklı
                // widget örneklerinin PendingIntent'leri birbirinin
                // üzerine yazılmasın (aksi halde sistem, aynı requestCode'a
                // sahip PendingIntent'leri "aynı" sayıp ilkini günceller).
                //
                // DÜZELTME (⚙️ ikonuna basınca widget'ın yeni pencerenin
                // ÜZERİNE binip sonra kaybolması): NoteWidgetConfigActivity
                // içinde zaten overrideActivityTransition(OPEN, 0, 0) /
                // overridePendingTransition(0, 0) çağrısı var, ama bu SADECE
                // Activity'nin KENDİ temasına bağlı (Animation.Activity
                // kaynaklı) çapraz geçişi kapatıyor. Widget'a dokunulunca
                // PendingIntent'i asıl TETİKLEYEN taraf biz değil, launcher
                // (ana ekran) sürecidir; launcher, AppWidgetHostView'in
                // dokunulan görünümden (view bounds) "yakınlaştırarak açılma"
                // (clip-reveal/scale-up) ActivityOptions'ı ile gönderiyor —
                // bu da tam olarak "widget büyüyerek yeni ekranın üzerine
                // biniyor, sonra kayboluyor" görüntüsünü veren şey. Bu
                // launcher-kaynaklı animasyon, hedef Activity'nin
                // overrideActivityTransition çağrısıyla HER ZAMAN
                // bastırılamıyor. Bunu güvenilir biçimde önlemenin yolu,
                // PendingIntent'i OLUŞTURURKEN (burada, gönderilmeden ÖNCE)
                // animasyonsuz bir ActivityOptions'ı doğrudan PendingIntent'e
                // GÖMMEK — güvenlik sertleştirmeleri nedeniyle sistem, PendingIntent
                // oluşturucusunun gömdüğü animasyon seçeneklerini gönderenin
                // (launcher'ın) kendi seçeneklerinin ÖNÜNE koyar, bu yüzden
                // launcher'ın clip-reveal denemesi devre dışı kalır.
                val noAnimationOptions = ActivityOptions.makeCustomAnimation(context, 0, 0).toBundle()
                val settingsPendingIntent = PendingIntent.getActivity(
                    context,
                    appWidgetId,
                    configIntent,
                    PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
                    noAnimationOptions
                )
                views.setOnClickPendingIntent(R.id.widget_settings_button, settingsPendingIntent)
                Log.e(TAG, "ADIM 8.2 OK -> ayarlar ikonu PendingIntent tamamlandi")
                // (➕ "yeni not" ikonu ve buna ait PendingIntent kaldırıldı —
                // özellik tamamen kaldırıldı, bkz. NewNoteWidgetReceiver.kt'nin
                // silinmesi.)
            } catch (e: Throwable) {
                Log.e(TAG, "ADIM 8.4 HATA -> ikon PendingIntent'leri: ${e.javaClass.simpleName}: ${e.message}", e)
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
