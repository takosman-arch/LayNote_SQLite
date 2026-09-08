package com.example.flutter_application_1

import android.app.Activity
import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.content.res.ColorStateList
import android.graphics.Canvas
import android.graphics.Color
import android.graphics.ColorFilter
import android.graphics.Paint
import android.graphics.Path
import android.graphics.PixelFormat
import android.graphics.Rect
import android.graphics.drawable.Drawable
import android.graphics.drawable.GradientDrawable
import android.graphics.drawable.RippleDrawable
import android.os.Bundle
import android.text.Editable
import android.text.TextUtils
import android.text.TextWatcher
import android.util.Log
import android.view.View
import android.view.ViewGroup
import android.view.WindowManager
import android.widget.EditText
import android.widget.ImageView
import android.widget.LinearLayout
import android.widget.TextView
import androidx.core.graphics.ColorUtils
import androidx.core.view.ViewCompat
import androidx.core.view.WindowInsetsCompat
import androidx.recyclerview.widget.RecyclerView
import androidx.recyclerview.widget.StaggeredGridLayoutManager
import org.json.JSONObject
import java.util.Locale

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
//
// DÜZELTME (Pinterest tarzı ızgara): Kullanıcı, uygulamanın kendi not
// ızgarasındaki gibi 2 sütunlu, kart yükseklikleri içeriğe göre değişen
// (staggered/masonry) bir görünüm istedi. Tek sütunlu dikey liste
// (ListView + BaseAdapter) yerine RecyclerView + StaggeredGridLayoutManager
// kullanılıyor; kart tasarımının kendisi (renk/köşe/tipografi/ripple)
// HİÇ DEĞİŞMEDİ — sadece dizilim (layout manager) değişti.
//
// DÜZELTME (2 EKRANLI AKIŞ): Bu ekran eskiden not seçimi + canlı önizleme +
// yazı boyutu/saydamlık kaydırıcılarını TEK ekranda birlikte gösteriyordu;
// bu da özellikle küçük ekranlarda kalabalık ve karışık görünüyordu
// (kullanıcı raporu: "şu an iki ekran birleşik"). Artık AYNI Activity
// içinde, tek bir kök view'ı değiştirerek iki ADIM gösteriliyor:
//   1) showNoteSelectionScreen(): sadece not arama + not ızgarası (ya da
//      not yoksa boş durum mesajı). Bir not seçilince (veya "Notsuz Devam
//      Et" ile) DOĞRUDAN 2. adıma geçilir.
//   2) showAppearanceScreen(noteId): canlı önizleme kartı + yazı boyutu/
//      saydamlık kaydırıcıları + "Widget'ı Ekle" butonu. Üstte 2. adımdan
//      1. adıma dönmeyi sağlayan bir "‹ Geri" satırı var; sistem geri
//      tuşu da (bkz. onBackPressed) aynı şekilde 1. adıma döner — widget
//      host'un beklediği "kullanıcı iptal ederse hiç eklenmesin" sözleşmesi
//      SADECE 1. adımdayken sistem geri tuşuna basılırsa bozulmadan
//      korunuyor (setResult(RESULT_CANCELED) hâlâ onCreate'in başında
//      ayarlanıyor).
// Yeni bir Activity/Manifest kaydı YOK — widget host'un
// APPWIDGET_CONFIGURE için başlattığı tek Activity hâlâ bu; sonuç
// (setResult/finish) hâlâ SADECE onNoteSelected() içinde, 2. adımdaki
// "Widget'ı Ekle" butonuna basılınca veriliyor.
// ════════════════════════════════════════════════════════════════════════
// DÜZELTME (geri tuşu şekli, "yan V" / chevron): Native taraftaki geri
// butonu önceden Unicode "←" karakteriyle (düz ok, çengelli baş + gövde)
// çiziliyordu. Uygulamanın geri kalanındaki (Flutter AppBar) standart geri
// oku ise gövdesiz, sadece iki çizginin birleşmesinden oluşan bir "‹"
// (yan yatmış V / chevron) şekli. Bir font glifine güvenmek yerine bunu
// doğrudan Canvas üzerine bir Path ile çiziyoruz — böylece kalınlık, uç
// yuvarlama ve oranlar cihaz/font bağımsız, her zaman uygulamanın geri
// tuşuyla BİREBİR aynı görünür.
private class ChevronDrawable(
    color: Int,
    private val strokeWidthPx: Float,
) : Drawable() {

    private val paint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
        style = Paint.Style.STROKE
        strokeWidth = strokeWidthPx
        strokeCap = Paint.Cap.ROUND
        strokeJoin = Paint.Join.ROUND
        this.color = color
    }
    private val path = Path()

    override fun onBoundsChange(bounds: Rect) {
        super.onBoundsChange(bounds)
        path.reset()
        val w = bounds.width().toFloat()
        val h = bounds.height().toFloat()
        // Uygulamanın standart geri okuyla aynı oran: sol-orta uca doğru
        // daralan, üstten ve alttan gelen iki çizgi ("<" şekli). Kenarlardan
        // bırakılan boşluk (inset), ikonun dokunma alanı içinde ortalı ve
        // Material/iOS tarzı chevron ikonlarındaki tipik orana yakın
        // durmasını sağlıyor.
        val insetX = w * 0.32f
        val insetY = h * 0.24f
        path.moveTo(w - insetX, insetY)
        path.lineTo(insetX, h / 2f)
        path.lineTo(w - insetX, h - insetY)
    }

    override fun draw(canvas: Canvas) {
        canvas.drawPath(path, paint)
    }

    override fun setAlpha(alpha: Int) {
        paint.alpha = alpha
    }

    override fun setColorFilter(colorFilter: ColorFilter?) {
        paint.colorFilter = colorFilter
    }

    @Deprecated("Deprecated in Java", ReplaceWith("PixelFormat.TRANSLUCENT"))
    override fun getOpacity(): Int = PixelFormat.TRANSLUCENT
}

class NoteWidgetConfigActivity : Activity() {

    companion object {
        private const val TAG = "NOTEWIDGET_DEBUG"
        private const val PREFS_NAME = "HomeWidgetPreferences"

        // DÜZELTME (⚙️ ikonundan doğrudan Görünümü Ayarla ekranı): widget
        // üzerindeki ayarlar ikonuna basılınca (bkz. NoteWidgetReceiverV2.kt
        // -> settingsPendingIntent) bu Activity artık 1. adımı (not seçimi)
        // atlayıp doğrudan 2. adıma (showAppearanceScreen) geçebiliyor.
        // Bu davranış SADECE bu extra true olarak gönderildiğinde devreye
        // girer; widget EKLEME akışında (AndroidManifest'teki
        // ACTION_APPWIDGET_CONFIGURE ile açılışta) bu extra hiç
        // gönderilmediği için eski davranış (önce not seçimi) korunuyor.
        const val EXTRA_OPEN_APPEARANCE_STEP = "open_appearance_step"
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

        // DÜZELTME: Önizleme kutusunun dolgu rengi (previewBgColor), gerçek
        // widget'ı taklit etmek için ekranın kendi zeminiyle (colorBg())
        // AYNI ton (#1E1E1E). Kaydırıcıdaki saydamlık %0-100 arasında
        // ne olursa olsun, aynı renk üstüne aynı rengin şeffaf hali
        // bindirildiğinde kutunun sınırları hiç görünmüyordu (kullanıcı
        // raporu: "Önizleme kutusu görünmüyor"). Kutunun kendisini her
        // zaman, dolgu opaklığından bağımsız, ince bir kenarlıkla
        // çerçeveliyoruz — böylece saydamlık %0 bile olsa kutunun nerede
        // başlayıp bittiği belli oluyor.
        private const val COLOR_PREVIEW_BORDER_DARK = "#4A4A4A"

        // Vurgu (amber) rengi her iki temada da aynı — uygulamanın
        // appAccentColor varsayılanıyla (Colors.amber) birebir aynı.
        // NOT: Kullanıcı Ayarlar > Tema > Vurgu Rengi'nden bunu
        // değiştirebiliyor ama o tercih de (appThemeMode gibi) native
        // tarafa henüz yazılmıyor; bu yüzden burada sabit tutuluyor.
        private const val COLOR_AMBER = "#FFC107"

        // AŞAMA 3: kaydırıcıların başlangıç değerini okumak için — bu,
        // NoteWidgetReceiverV2.kt'deki (ve NoteWidget.kt'deki) KEY_FONT_SIZE/
        // KEY_BG_OPACITY ile BİREBİR AYNI anahtarlar; syncAppearanceSettings
        // (Dart tarafı) tüm widget'lar için ortak bu global değeri buraya
        // yazıyor. Sohbette netleşen karara göre kaydırıcılar ilk açıldığında
        // buradan okunan değerden başlıyor.
        private const val KEY_FONT_SIZE = "widget_font_size"
        private const val KEY_BG_OPACITY = "widget_bg_opacity"
        // NoteWidgetReceiverV2/NoteWidget.kt'deki AYNI global anahtar —
        // widget'a özel bir tercih (darkKey) kaydedilmemişse buraya düşülür.
        // NOT: KEY_IS_DARK_THEME'den (uygulamanın kendi arayüz teması) FARKLI
        // bir kavram — bu, widget'ın İÇERİĞİNİN koyu/açık göstereceğini
        // belirler.
        private const val KEY_DARK = "widget_dark"

        // Kaydırıcının izin verdiği yazı boyutu aralığı (sp).
        // DÜZELTME: minimum 10sp -> 16sp'ye yükseltildi (kullanıcı isteği:
        // çok küçük/okunması güç yazı boyutlarının seçilebilir olmaması).
        // NOT: Widget'ın varsayılanı hâlâ 14sp (bkz. NoteWidget.kt/
        // NoteWidgetReceiverV2.kt getFloatCompat(KEY_FONT_SIZE, 14f)) — yani
        // bu varsayılan artık slider'ın izin verdiği aralığın ALTINDA.
        // Kullanıcı slider'ı hiç açmadıysa (currentFontSize hâlâ 14f)
        // aşağıdaki progress hesaplaması coerceIn(0, max) sayesinde slider'ı
        // güvenle 0'a (yani 16sp karşılığına) sabitler, ancak bu durumda
        // gerçek widget hâlâ 14sp göstermeye devam eder; slider'a
        // dokunulmadan "Widget'ı Ekle" ile kaydedilirse sonuç aynı kalır.
        // Widget'ın gerçekte de en az 16sp göstermesini istiyorsanız
        // varsayılan değeri (14f) NoteWidget.kt ve NoteWidgetReceiverV2.kt
        // içinde 16f olarak güncellemek gerekir — bu dosya sadece
        // yapılandırma ekranındaki slider aralığını kapsar.
        private const val FONT_SIZE_MIN_SP = 16
        private const val FONT_SIZE_MAX_SP = 30

        // DÜZELTME (bkz. NoteWidget.kt / NoteWidgetReceiverV2.kt'deki AYNI
        // fonksiyon): home_widget paketi Dart'tan gelen int değerleri
        // putLong, double değerleri putFloat ile yazıyor; hangisinin
        // geldiği önceden bilinemediğinden sabit getFloat() ClassCastException
        // atabilir. Bu yardımcı, hangi tip gelirse gelsin doğru okuyor.
        // NOT: NoteWidgetReceiverV2'deki private companion fonksiyonuna
        // buradan erişilemediği için (farklı sınıf) aynısı burada da
        // tutuluyor — iki dosyada birbirinden bağımsız yaşıyorlar, biri
        // değişirse diğeri de gözden geçirilmeli.
        private fun SharedPreferences.getFloatCompat(key: String, default: Float): Float {
            if (!contains(key)) return default
            return try {
                getFloat(key, default)
            } catch (e: ClassCastException) {
                try {
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
    private lateinit var prefs: SharedPreferences

    // 2. adımda (canlı önizleme + kaydırıcılar) kullanılacak, uygulama
    // genelindeki not listesi ve ortak (global) ön ayarlar — sadece
    // onCreate'te bir kez okunur, iki ekran arasında geçişte tekrar
    // diskten okunmaz.
    private var notesCache: List<NoteEntry> = emptyList()
    // DÜZELTME: Kaydırıcıların ilk açıldığında (henüz hiçbir global ayar
    // kaydedilmemişse) başlangıç değeri 14sp/%100 yerine 23sp/%50 oldu —
    // kullanıcı isteği. Bu, SADECE hiç kayıtlı KEY_FONT_SIZE/KEY_BG_OPACITY
    // yokken devreye giren varsayılan; aşağıdaki onCreate'teki
    // getFloatCompat çağrılarındaki ikinci parametre ile AYNI tutulmalı.
    private var globalFontSize = 23f
    private var globalBgOpacity = 0.5f

    // 1. adımdan 2. adıma geçince bu widget örneği için o anki yazı
    // boyutu/saydamlık burada tutulur — kullanıcı 2. adımdan "‹ Geri" ile
    // 1. adıma dönüp sonra tekrar bir not seçerse (ya da geri tuşuna
    // basarsa) kaydırıcılardaki en son değerler kaybolmaz.
    private var currentFontSize = 23f
    private var currentBgOpacity = 0.5f
    // Kullanıcı isteği: koyu/açık artık widget'a özel — her widget kendi
    // temasını seçebilir (font boyutu/saydamlık ile AYNI desen). Diğer
    // ikisi gibi başlangıçta o anki GLOBAL değerden başlar (bkz. onCreate).
    private var currentDark = true

    // Kullanıcı isteği: sağ üstteki ⚙️ ikonunun widget üzerinde gösterilip
    // gösterilmeyeceği, koyu/açık ile AYNI desende, widget'a özel.
    // Varsayılan true — eski (bu switch'ten önce eklenmiş) widget
    // örnekleri, kaydedilmiş bir tercih bulunamadığında ikonu göstermeye
    // devam eder (bkz. NoteWidgetReceiverV2.DEFAULT_SHOW_SETTINGS_ICON).
    // (➕ "yeni not" ikonu/switch'i kaldırıldı.)
    private var currentShowSettingsIcon = true

    // DÜZELTME (2 EKRANLI AKIŞ): şu an 2. ekranda (görünüm ayarları)
    // olup olmadığımızı tutar — sistem geri tuşuna (onBackPressed) basılınca
    // 2. ekrandaysak Activity'yi KAPATMAK yerine 1. ekrana (not seçimi)
    // dönülür; widget host'un "kullanıcı iptal ederse hiç eklenmesin"
    // sözleşmesi sadece GERÇEKTEN 1. ekrandayken geri tuşuna basılırsa
    // devreye giriyor.
    private var showingAppearanceScreen = false

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // DÜZELTME (hata.txt: "ayarlar ikonuna tıklayınca pencere açılırken
        // widget'ın kendisi görünmeye devam ediyor ve çakışıyor"): Bu
        // Activity FLAG_SHOW_WALLPAPER + TRANSLUCENT ile saydam olduğu için,
        // sistemin varsayılan giriş geçiş animasyonu sırasında (~300-450ms)
        // eski ekran (ana ekran + widget) ile bu ekran BİRLİKTE çiziliyor —
        // saydamlık yüzünden arkadaki widget bu geçiş penceresinde doğrudan
        // görünür kalıp yeni ekranla çakışıyormuş gibi hissettiriyor. Giriş
        // animasyonunu tamamen kapatarak Activity'nin anında (animasyonsuz)
        // belirmesini sağlıyoruz; bu, ana ekranın widget'la birlikte görünme
        // penceresini ortadan kaldırır. En başta (super.onCreate'ten hemen
        // sonra, başka hiçbir şey çalışmadan önce) çağrılmalı ki geçiş daha
        // başlamadan iptal edilsin.
        //
        // Android 14 (UPSIDE_DOWN_CAKE) itibarıyla overridePendingTransition
        // deprecated olduğu için yeni overrideActivityTransition API'si
        // kullanılıyor; altındaki sürümlerde eski API'ye düşülüyor.
        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.UPSIDE_DOWN_CAKE) {
            overrideActivityTransition(Activity.OVERRIDE_TRANSITION_OPEN, 0, 0)
        } else {
            @Suppress("DEPRECATION")
            overridePendingTransition(0, 0)
        }

        // DÜZELTME (gerçek duvar kağıdı arka planı — 2. adımdaki önizleme
        // kutusunun ARKASINA): İlk denemede WallpaperManager.getDrawable()
        // ile duvar kağıdını bitmap olarak çekip elle çizmeyi düşündük, ama
        // bu API Android 13'te kısıtlanıyor ve Android 14+'ta SecurityException
        // fırlatıyor — yani modern cihazlarda hiç çalışmayacaktı. Bunun
        // yerine Android'in resmi yöntemi kullanılıyor: pencereye
        // FLAG_SHOW_WALLPAPER bayrağını koyup, pencerenin kendi arka plan
        // drawable'ını (windowBackground) null yapıyoruz. Bu, hiçbir izin
        // GEREKTİRMEZ ve tüm Android sürümlerinde çalışır (launcher'ların
        // simgeleri duvar kağıdı üzerinde göstermesiyle aynı mekanizma).
        // NOT: Bu tek başına HİÇBİR ŞEYİ görünür kılmaz — gerçek duvar
        // kağıdı, YALNIZCA içerik view hiyerarşisinde arka plan rengi
        // TAŞIMAYAN (şeffaf bırakılan) alanların ARKASINDA görünür. Bu
        // yüzden showAppearanceScreen()'de root/topHalf artık kendi
        // arka plan rengini taşımıyor; sadece header/bottomHalf/
        // addWidgetBtn opak (colorBg()) kalıyor — böylece duvar kağıdı
        // SADECE önizleme kutusunun bulunduğu üst yarıda görünür.
        window.addFlags(WindowManager.LayoutParams.FLAG_SHOW_WALLPAPER)
        window.setBackgroundDrawable(null)
        // DÜZELTME (duvar kağıdı hâlâ görünmüyor sorunu): FLAG_SHOW_WALLPAPER
        // + null windowBackground TEK BAŞINA yeterli değilmiş. Pencere
        // varsayılan olarak OPAK bir yüzey (surface) istiyor; bu durumda
        // içerikte şeffaf bıraktığımız alanlar duvar kağıdıyla karıştırılmak
        // yerine tanımsız/siyah çiziliyor, çünkü sistem o pencere için alfa
        // kanalı barındıran bir katman ayırmıyor. Bunu düzeltmek için
        // pencerenin piksel formatını açıkça TRANSLUCENT yapmak gerekiyor —
        // bu, pencereye "şeffaf pikseller taşıyabilirsin, altındakiyle
        // karıştırılsın" der. setContentView'dan ÖNCE çağrılmalı.
        window.setFormat(PixelFormat.TRANSLUCENT)
        // DÜZELTME ("Görünümü ayarla" ekranında sadece 3 satır görünüyor
        // sorunu): styles.xml'e eklenen android:windowIsTranslucent=true,
        // bazı cihazlarda pencereyi TAM EKRAN yerine sadece İÇERİĞİ KADAR
        // (wrap_content) boyutlandırıyor — saydam temalar tarihsel olarak
        // dialog benzeri Activity'ler için kullanıldığından sistem bunu
        // varsayılan davranış sanıyor. showAppearanceScreen()'deki
        // splitContainer (önizleme + kaydırıcılar), height=0dp + weight=1f
        // ile kalan TÜM boşluğu doldurmayı bekliyor; pencere kendisi tam
        // ekran yüksekliğinde değilse dağıtılacak "kalan boşluk" da
        // olmadığından o alan 0'a düşüyor — geriye sadece sabit boyutlu
        // (WRAP_CONTENT) header ve "Widget'ı Ekle" butonu gibi birkaç satır
        // kalıyor. Bunu önlemek için pencerenin boyutunu MATCH_PARENT
        // olarak AÇIKÇA zorluyoruz; windowIsTranslucent sadece surface'ın
        // saydamlığını etkiler, boyutunu bu satırla biz belirliyoruz.
        window.setLayout(
            WindowManager.LayoutParams.MATCH_PARENT,
            WindowManager.LayoutParams.MATCH_PARENT
        )

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

        prefs = getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
        // KEY_IS_DARK_THEME anahtarı yoksa (Boolean için getBoolean 2.
        // parametre olarak varsayılan alır) uygulamanın varsayılan teması
        // olan Koyu'ya düşülür — bkz. theme.dart appThemeMode = ThemeMode.dark.
        isDarkTheme = prefs.getBoolean(KEY_IS_DARK_THEME, true)
        notesCache = readNotes(prefs)
        // AŞAMA 3: kaydırıcılar ilk açıldığında o anki GLOBAL değerden
        // başlayacak (sohbette netleşen karar) — henüz bu widget'a özel bir
        // ön ayar yok (o, AŞAMA 6'da "Widget'ı Ekle" ile kaydediliyor).
        // DÜZELTME: hiç global değer kaydedilmemişse (KEY_FONT_SIZE/
        // KEY_BG_OPACITY anahtarları yoksa) kullanılan varsayılan
        // 14sp/%100'den 23sp/%50'ye değiştirildi (kullanıcı isteği).
        globalFontSize = prefs.getFloatCompat(KEY_FONT_SIZE, 23f)
        globalBgOpacity = prefs.getFloatCompat(KEY_BG_OPACITY, 0.5f).coerceIn(0f, 1f)
        // DÜZELTME: Kayıtlı global değer, slider'ın yeni minimumu (16sp)
        // yükseltilmeden ÖNCE kaydedilmiş olabilir (ör. varsayılan 14sp).
        // Bu durumda slider'ı yeni aralığın en altına (0 -> 16sp) sabitleyip
        // ETİKETİ ise eski 14 değerinde bırakmak tutarsız görünürdü. Bu
        // yüzden ekran açılışında da değer doğrudan yeni minimuma
        // yükseltiliyor; kullanıcı slider'a hiç dokunmadan "Widget'ı Ekle"
        // derse bile artık en az 16sp kaydedilir.
        currentFontSize = globalFontSize.coerceAtLeast(FONT_SIZE_MIN_SP.toFloat())
        currentBgOpacity = globalBgOpacity
        currentDark = prefs.getBoolean(KEY_DARK, true)

        // DÜZELTME (widget'a uzun basıp sistemin "düzenle/ayarlar"
        // seçeneğine dokununca da doğrudan Görünümü Ayarla ekranı açılsın):
        // Bu Activity iki farklı yoldan, iki farklı amaçla açılabiliyor:
        //   1) Widget'ı ana ekrana YENİ eklerken — sistem bunu
        //      ACTION_APPWIDGET_CONFIGURE ile (AndroidManifest'teki
        //      intent-filter üzerinden) EXTRA_OPEN_APPEARANCE_STEP OLMADAN
        //      açar. Bu appWidgetId için henüz hiçbir şey kaydedilmemiştir.
        //   2) Ana ekranda widget'a uzun basıp sistemin kendi "düzenle"
        //      seçeneğine (ya da ⚙️ ikonuna) dokunulunca — İKİSİ de AYNI
        //      ACTION_APPWIDGET_CONFIGURE mekanizmasını kullanır; tek fark
        //      ⚙️ ikonu (NoteWidgetReceiverV2 -> settingsPendingIntent)
        //      EXTRA_OPEN_APPEARANCE_STEP=true extra'sını EKLERKEN,
        //      sistemin kendi "düzenle" seçeneği bu extra'yı GÖNDERMİYOR —
        //      bu yüzden önceden sadece extra kontrol edilince bu ikinci
        //      yol yanlışlıkla 1. adıma (not seçimi) düşüyordu.
        // İkisini ayırt etmenin güvenilir yolu extra değil, appWidgetId'ye
        // özel pinnedNoteKey'in DAHA ÖNCE kaydedilip kaydedilmediği:
        // onNoteSelected() bu anahtarı her zaman yazıyor (bkz. aşağıda),
        // yani widget zaten bir kez eklenip yapılandırıldıysa bu anahtar
        // prefs'te bulunur. Böylece "bu appWidgetId zaten mevcut mu"
        // sorusu extra'dan bağımsız, doğrudan kontrol edilebiliyor.
        val alreadyConfigured = prefs.contains(NoteWidgetReceiverV2.pinnedNoteKey(appWidgetId))
        val openAppearanceStep =
            intent?.extras?.getBoolean(EXTRA_OPEN_APPEARANCE_STEP, false) == true || alreadyConfigured
        if (openAppearanceStep) {
            val pinnedNoteId = prefs.getString(NoteWidgetReceiverV2.pinnedNoteKey(appWidgetId), "") ?: ""
            currentFontSize = prefs.getFloatCompat(
                NoteWidgetReceiverV2.fontSizeKey(appWidgetId),
                currentFontSize
            ).coerceAtLeast(FONT_SIZE_MIN_SP.toFloat())
            currentBgOpacity = prefs.getFloatCompat(
                NoteWidgetReceiverV2.bgOpacityKey(appWidgetId),
                currentBgOpacity
            ).coerceIn(0f, 1f)
            currentDark = prefs.getBoolean(NoteWidgetReceiverV2.darkKey(appWidgetId), currentDark)
            currentShowSettingsIcon = prefs.getBoolean(
                NoteWidgetReceiverV2.showSettingsIconKey(appWidgetId),
                currentShowSettingsIcon
            )
            showAppearanceScreen(pinnedNoteId)
            return
        }

        showNoteSelectionScreen()
    }

    override fun onBackPressed() {
        if (showingAppearanceScreen) {
            showingAppearanceScreen = false
            showNoteSelectionScreen()
        } else {
            super.onBackPressed()
        }
    }

    // ── 1. ADIM: sadece not arama + not ızgarası (veya not yoksa boş
    // durum mesajı). Kaydırıcı/önizleme burada YOK — bir not seçilince
    // (veya "Notsuz Devam Et" ile) doğrudan showAppearanceScreen()'e geçilir.
    private fun showNoteSelectionScreen() {
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

        if (notesCache.isEmpty()) {
            // DÜZELTME (2026-08-08): Bu dal daha önce kullanıcıyı bilgi
            // metniyle baş başa bırakıyordu; tıklanacak hiçbir öğe
            // olmadığından RESULT_CANCELED (onCreate'in başında ayarlanan
            // varsayılan) hiç RESULT_OK'a çevrilmiyordu. Kullanıcı geri
            // tuşuna basınca sistem "Widget eklenemedi" mesajı gösteriyordu
            // — kullanıcı raporundaki sorun buydu. Şimdi "Notsuz Devam Et"
            // seçeneğiyle bu durumdan da (2. adıma geçip oradaki "Widget'ı
            // Ekle" ile) RESULT_OK ile çıkılabiliyor; NoteWidget.kt zaten
            // notId boşken "Henüz not yok" göstermeye hazır, ilk not
            // kaydedildiğinde widget otomatik güncellenir.
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
                setOnClickListener { showAppearanceScreen("") }
            }
            root.addView(continueBtn)
        } else {
            val recyclerView = RecyclerView(this).apply {
                clipToPadding = false
                setPadding(dp(8), dp(4), dp(8), dp(16))
                setBackgroundColor(Color.parseColor(colorBg()))
                // Pinterest tarzı 2 sütunlu, kart yüksekliği içeriğe göre
                // değişen (staggered/masonry) ızgara. Dikey akış içinde
                // sütunlar arasında dengesizlik oluşmaması için
                // GAP_HANDLING_MOVE_ITEM_BETWEEN_SPANS kullanılıyor (bir
                // kart kaldırıldığında/eklendiğinde diğer sütundaki
                // kartlar gerekirse yer değiştirip boşluk bırakmıyor).
                layoutManager = StaggeredGridLayoutManager(
                    2,
                    StaggeredGridLayoutManager.VERTICAL
                ).apply {
                    gapStrategy =
                        StaggeredGridLayoutManager.GAP_HANDLING_MOVE_ITEMS_BETWEEN_SPANS
                }
            }

            // DÜZELTME (2 EKRANLI AKIŞ): bir kart artık seçim durumunu
            // burada tutmuyor / bir onay butonunu etkinleştirmiyor — karta
            // dokunmak DOĞRUDAN 2. adıma (görünüm ayarları) geçiyor.
            val adapter = NoteCardAdapter(this, notesCache, isDarkTheme) { noteId ->
                showAppearanceScreen(noteId)
            }
            recyclerView.adapter = adapter

            // DÜZELTME (arama çubuğu): Arama sonucunda hiç not eşleşmezse
            // RecyclerView boş kalıp kullanıcıya hiçbir geri bildirim
            // vermiyordu. Bu yüzden RecyclerView'ın yerini alan ayrı bir
            // "sonuç bulunamadı" mesajı eklendi — arama kutusu boşken
            // (ilk açılış) hep gizli, filtre sonucu boş olduğunda görünür.
            val noResults = TextView(this).apply {
                text = getString(R.string.widget_config_no_results)
                setTextColor(Color.parseColor(colorMutedText()))
                textSize = 14f
                setPadding(dp(20), dp(24), dp(20), dp(12))
                visibility = View.GONE
            }

            // Arama, hem not başlığında hem de içerik önizlemesinde
            // (all_notes_json -> "preview") büyük/küçük harf duyarsız
            // olarak yapılır. Locale("tr") kullanılıyor ki Türkçe'ye özgü
            // İ/ı büyük-küçük harf dönüşümü doğru çalışsın (varsayılan
            // locale ile "İ".lowercase() bazı cihazlarda "i" değil "i̇"
            // gibi beklenmedik sonuçlar verebiliyor).
            val turkishLocale = Locale("tr")
            fun filterNotes(query: String): List<NoteEntry> {
                if (query.isBlank()) return notesCache
                val q = query.lowercase(turkishLocale)
                return notesCache.filter {
                    it.title.lowercase(turkishLocale).contains(q) ||
                        it.preview.lowercase(turkishLocale).contains(q)
                }
            }

            val searchBox = EditText(this).apply {
                hint = getString(R.string.widget_config_search_hint)
                setHintTextColor(Color.parseColor(colorMutedText()))
                setTextColor(Color.parseColor(colorTitle()))
                textSize = 15f
                isSingleLine = true
                setPadding(dp(14), dp(10), dp(14), dp(10))
                background = GradientDrawable().apply {
                    cornerRadius = dp(10).toFloat()
                    setColor(Color.parseColor(colorCard()))
                    if (!isDarkTheme) {
                        setStroke(dp(1), Color.parseColor(COLOR_CARD_BORDER_LIGHT))
                    }
                }
                addTextChangedListener(object : TextWatcher {
                    override fun beforeTextChanged(
                        s: CharSequence?, start: Int, count: Int, after: Int
                    ) {}

                    override fun onTextChanged(
                        s: CharSequence?, start: Int, before: Int, count: Int
                    ) {}

                    override fun afterTextChanged(s: Editable?) {
                        val filtered = filterNotes(s?.toString().orEmpty())
                        adapter.updateItems(filtered)
                        val hasResults = filtered.isNotEmpty()
                        recyclerView.visibility = if (hasResults) View.VISIBLE else View.GONE
                        noResults.visibility = if (hasResults) View.GONE else View.VISIBLE
                    }
                })
            }
            root.addView(
                searchBox,
                LinearLayout.LayoutParams(
                    LinearLayout.LayoutParams.MATCH_PARENT,
                    LinearLayout.LayoutParams.WRAP_CONTENT
                ).apply {
                    leftMargin = dp(20)
                    rightMargin = dp(20)
                    bottomMargin = dp(8)
                }
            )
            root.addView(noResults)
            root.addView(
                recyclerView,
                LinearLayout.LayoutParams(
                    LinearLayout.LayoutParams.MATCH_PARENT,
                    0,
                    1f
                )
            )
        }

        showingAppearanceScreen = false
        setContentView(root)
        applySystemInsetPadding(insetsSource = root, topTarget = heading, bottomTarget = root)
    }

    // ── 2. ADIM: canlı önizleme kartı + yazı boyutu/saydamlık kaydırıcıları
    // + "Widget'ı Ekle" butonu. `noteId` boş string olabilir ("Notsuz Devam
    // Et" dalından gelindiyse) — bu durumda önizleme, NoteWidget.kt'nin
    // notId boşken gösterdiği "Henüz not yok" durumunu yansıtır.
    private fun showAppearanceScreen(noteId: String) {
        showingAppearanceScreen = true
        val entry = notesCache.find { it.id == noteId }

        // DÜZELTME (gerçek duvar kağıdı arka planı): bu ekranın kökü artık
        // KENDİ arka plan rengini TAŞIMIYOR (setBackgroundColor kaldırıldı).
        // Neden: pencereye eklenen FLAG_SHOW_WALLPAPER + null windowBackground
        // (bkz. onCreate) sayesinde gerçek sistem duvar kağıdı, İÇERİK
        // hiyerarşisinde şeffaf bırakılan her yerin arkasından görünür.
        // root opak olsaydı, duvar kağıdı hiçbir yerde görünmeyecekti. Opak
        // renk artık SADECE bunu isteyen alt view'lara (headerRow,
        // bottomHalf, addWidgetBtn) tek tek veriliyor — topHalf (ve içindeki
        // previewLabel) kasıtlı olarak şeffaf bırakılıyor ki önizleme kutusu
        // gerçek duvar kağıdının ÜSTÜNDE görünsün ve saydamlık kaydırıcısının
        // gerçek etkisi görülebilsin.
        val root = LinearLayout(this).apply {
            orientation = LinearLayout.VERTICAL
            layoutParams = LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT,
                LinearLayout.LayoutParams.MATCH_PARENT
            )
        }

        // Üst satır: 1. adıma (not seçimi) dönmeyi sağlayan "‹ Geri" +
        // ekran başlığı. Sistem geri tuşu da (bkz. onBackPressed) aynı
        // yere döner; bu satır sadece dokunarak da yapılabilmesi için.
        // NOT: geri ok ikonu (ChevronDrawable) hâlâ görsel bir çizim,
        // string değil. Başlık artık widget_strings.xml'deki (26 dile
        // çevrilmiş) widget_config_appearance_heading'den okunuyor.
        val headerRow = LinearLayout(this).apply {
            orientation = LinearLayout.HORIZONTAL
            gravity = android.view.Gravity.CENTER_VERTICAL
            // DÜZELTME: root artık şeffaf olduğundan, bu satırın kendi
            // opak arka planını taşıması gerekiyor — aksi halde duvar
            // kağıdı, header'ın metinlerin OLMADIĞI (sağ taraftaki) boş
            // kısmından da sızardı. LayoutParams'ı MATCH_PARENT genişlikte
            // veriyoruz ki bu opak zemin tüm satır genişliğini kaplasın
            // (aşağıdaki root.addView çağrısına bakın).
            setBackgroundColor(Color.parseColor(colorBg()))
        }
        // DÜZELTME (geri tuşunun şekli VE rengi): Uygulamanın gerçek geri
        // tuşu (main.dart -> appBarTheme'de özel bir iconTheme/leading
        // TANIMLANMADIĞI için Flutter'ın varsayılan AppBar geri ikonu)
        // rengi başlıkla AYNI (koyu temada beyaz, açık temada koyu —
        // amber DEĞİL) ve arkasında dairesel bir zemin/ripple YOK, sade
        // bir ikon. Önceki amber + dairesel zemin varsayımı bu yüzden
        // kaldırıldı; artık sadece chevron şekli (bkz. yukarıdaki
        // ChevronDrawable) + colorTitle() rengiyle, zeminsiz çiziliyor.
        val backBtnSize = dp(40)
        val backBtn = ImageView(this).apply {
            setImageDrawable(
                ChevronDrawable(
                    color = Color.parseColor(colorTitle()),
                    strokeWidthPx = dp(2).toFloat(),
                )
            )
            // Dokunma alanı yine dp(40) olarak korunuyor (erişilebilirlik
            // için standart minimum dokunma hedefi) ama görsel olarak
            // hiçbir zemin/arka plan YOK — background hiç atanmıyor.
            setPadding(dp(10), dp(10), dp(10), dp(10))
            layoutParams = LinearLayout.LayoutParams(backBtnSize, backBtnSize).apply {
                leftMargin = dp(16)
                topMargin = dp(12)
                bottomMargin = dp(8)
            }
            setOnClickListener { onBackPressed() }
        }
        val stepHeading = TextView(this).apply {
            text = getString(R.string.widget_config_appearance_heading)
            setTextColor(Color.parseColor(colorTitle()))
            textSize = 18f
            setPadding(0, dp(20), dp(20), dp(12))
        }
        headerRow.addView(backBtn)
        headerRow.addView(stepHeading)
        root.addView(
            headerRow,
            LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT,
                LinearLayout.LayoutParams.WRAP_CONTENT
            )
        )

        // Canlı önizleme kartı. Gerçek widget'ın görünümünü (bkz.
        // NoteWidgetReceiverV2.updateWidgetInner / NoteWidget.kt
        // NoteWidgetContent — aynı renk mantığı: koyu temada #1E1E1E
        // zemin + beyaz metin, açık temada beyaz zemin + koyu metin) taklit
        // eder.
        // DÜZELTME: Önceden bu renkler ekranın kendi arayüz temasına
        // (isDarkTheme / KEY_IS_DARK_THEME) bağlıydı — koyu/açık widget'a
        // özel hâle gelmeden önce bu ikisi pratikte hep aynı sonucu
        // veriyordu. Artık aşağıya eklenen switch ile widget'ın kendi
        // teması (currentDark) bağımsız değişebildiğinden, önizleme de
        // ekranın DEĞİL widget'ın temasını yansıtmalı — aksi halde
        // kullanıcı switch'i değiştirdiğinde önizleme yanlış kalırdı.
        var previewTitleColor =
            if (currentDark) Color.parseColor("#FFFFFF") else Color.parseColor("#1A1A1A")
        var previewBgColor =
            if (currentDark) Color.parseColor("#1E1E1E") else Color.parseColor("#FFFFFF")

        val previewLabel = TextView(this).apply {
            text = getString(R.string.widget_config_preview_label)
            setTextColor(Color.parseColor(colorMutedText()))
            textSize = 12f
            setPadding(dp(20), dp(4), dp(20), dp(4))
        }

        val previewTitle = TextView(this).apply {
            setTextColor(previewTitleColor)
            setTypeface(typeface, android.graphics.Typeface.BOLD)
            textSize = currentFontSize
            // DÜZELTME: previewContent ile aynı sebep — uzun başlık
            // kutuyu (ve altındaki her şeyi) taşırmasın diye sınırlandı.
            maxLines = 2
            ellipsize = TextUtils.TruncateAt.END
            if (entry != null && entry.title.isNotEmpty()) {
                text = entry.title
                visibility = View.VISIBLE
            } else if (entry != null) {
                // DÜZELTME (başlık+ikonlar hepsi boşken üstte boş satır
                // kalıyordu — gerçek widget'taki AYNI düzeltme burada da
                // uygulandı, bkz. NoteWidgetReceiverV2.kt): en az bir ikon
                // gösteriliyorsa previewIconRow'un yüksekliği zaten o
                // ikonlardan geliyor, previewTitle'ın burada GONE/INVISIBLE
                // olması satırın boyunu etkilemiyor. Ama HİÇBİR ikon da
                // gösterilmiyorsa previewTitle bu satırdaki TEK view,
                // dolayısıyla GONE (zaten burada kullanılıyordu) satırı
                // tamamen çökertiyor — bu artık koşulsuz doğru, çünkü
                // korunacak bir "ikonları sağda tutma" ihtiyacı yok.
                visibility = View.GONE
            } else {
                // NoteWidget.kt'deki NoteWidgetContent ile AYNI sabit
                // varsayılan metin ("?: "Henüz not yok"") — orada da bir
                // string kaynağı değil, sabit (hardcoded) string olarak
                // tutuluyor; burada da tutarlılık için aynısı kullanıldı,
                // var olmayan bir strings.xml girdisine referans
                // verilmedi.
                text = "Henüz not yok"
                visibility = View.VISIBLE
            }
        }
        val previewContent = TextView(this).apply {
            setTextColor(previewTitleColor)
            textSize = (currentFontSize - 2f).coerceAtLeast(8f)
            setPadding(0, dp(4), 0, 0)
            // DÜZELTME (sığdığı kadar satır): Önceden burada sabit
            // "maxLines = 3" vardı. Artık önizleme kutusu KARE boyutuna
            // (aşağıdaki squareSize hesaplaması, DEĞİŞMEDİ) göre sabit
            // kalıyor ve bu TextView'ın gösterdiği satır sayısı, o sabit
            // karenin içine gerçekten kaç satır sığıyorsa ona göre
            // updatePreviewContentMaxLines() tarafından RUNTIME'da
            // hesaplanıp atanıyor (bkz. aşağıda, kare boyutu belirlendikten
            // hemen sonra ve yazı boyutu kaydırıcısı her değiştiğinde
            // çağrılıyor). Buradaki 3 sadece o hesaplama çalışana kadarki
            // ilk (çok kısa süreli) çizim için bir başlangıç değeri.
            maxLines = 3
            ellipsize = TextUtils.TruncateAt.END
            if (entry != null && entry.preview.isNotEmpty()) {
                text = entry.preview
                visibility = View.VISIBLE
            } else {
                visibility = View.GONE
            }
        }
        // DÜZELTME: kutunun kendisi düz bir renk (setBackgroundColor)
        // yerine bir GradientDrawable kullanıyor; böylece dolgu rengi
        // (previewBgColor + saydamlık) ekranın zeminiyle birebir aynı
        // olsa bile kenarlık HER ZAMAN görünür kalıyor (bkz.
        // COLOR_PREVIEW_BORDER_DARK açıklaması) — "Önizleme kutusu
        // görünmüyor" sorununun kaynağı buydu.
        val previewCardBg = GradientDrawable().apply {
            cornerRadius = dp(12).toFloat()
            setStroke(
                dp(1),
                Color.parseColor(
                    if (isDarkTheme) COLOR_PREVIEW_BORDER_DARK else COLOR_CARD_BORDER_LIGHT
                )
            )
        }
        // DÜZELTME (önizleme <-> gerçek widget birebir eşleşsin): gerçek
        // widget'ta (note_widget.xml) başlık tek başına değil, sağında
        // ⚙️ ikonuyla aynı yatay satırda (bkz. NoteWidgetReceiverV2.kt
        // ADIM 6.1/8.2). Önizleme kartı bu satırı taşımadığı için kullanıcı,
        // ayarları değiştirirken gerçekte nasıl görüneceğini tam
        // göremiyordu. Aşağıdaki previewIconRow, previewTitle'ı weight=1
        // ile sararak AYNI ikonu (dokunulamaz, sadece görsel — bu ekranın
        // kendisi zaten ayarlar akışının içinde) previewTitleColor ile
        // boyayıp ekliyor. (➕ "yeni not" önizleme ikonu kaldırıldı.)
        val previewSettingsIcon = ImageView(this).apply {
            setImageResource(R.drawable.ic_widget_settings)
            setColorFilter(previewTitleColor)
            // DÜZELTME (önizleme ikonu, gerçek switch durumunu yansıtmıyordu):
            // Başlangıç görünürlüğü currentShowSettingsIcon'a göre ayarlanmalı;
            // aksi halde switch kapalı okunsa bile ikon hep VISIBLE başlıyor ve
            // yalnızca kullanıcı switch'e dokunup onCheckedChangeListener'ı
            // (satır ~1070) tetikleyene kadar güncellenmiyordu.
            visibility = if (currentShowSettingsIcon) View.VISIBLE else View.GONE
            layoutParams = LinearLayout.LayoutParams(dp(18), dp(18)).apply {
                marginStart = dp(4)
            }
        }
        val previewIconRow = LinearLayout(this).apply {
            orientation = LinearLayout.HORIZONTAL
            // DÜZELTME (başlık boşken ikonlar sola yapışıyordu): previewTitle
            // GONE olduğunda satırdaki weight=1 view kalmadığından, sadece
            // CENTER_VERTICAL gravity ile satırın kullanılmayan genişliği
            // varsayılan olarak SOLA (start) yığılıyor, ikonlar görünürde
            // sola kaymış gibi duruyordu. Gerçek widget'ta ikonlar her zaman
            // sağda durduğundan, buraya da END gravity eklendi: previewTitle
            // görünürken zaten weight=1 ile tüm alanı kapladığından bu END
            // gravity'nin bir etkisi olmuyor; previewTitle GONE olduğunda ise
            // ikon çifti satırın sağına yaslanıyor.
            gravity = android.view.Gravity.CENTER_VERTICAL or android.view.Gravity.END
            addView(
                previewTitle,
                LinearLayout.LayoutParams(0, LinearLayout.LayoutParams.WRAP_CONTENT, 1f)
            )
            addView(previewSettingsIcon)
        }
        val previewCard = LinearLayout(this).apply {
            orientation = LinearLayout.VERTICAL
            setPadding(dp(12), dp(12), dp(12), dp(12))
            background = previewCardBg
            addView(previewIconRow)
            addView(previewContent)
        }

        // DÜZELTME (sığdığı kadar satır): previewCard'ın KARE yüksekliği
        // sabitlendikten sonra (bkz. aşağıdaki squareSize hesaplaması,
        // mantığı DEĞİŞMEDİ), o sabit kare yüksekliğin içine previewContent
        // için gerçekte kaç satırlık yer kaldığını hesaplayıp previewContent
        // .maxLines'a atar. previewCardHeightPx, kare hesaplanınca (bir kez)
        // doldurulur; previewTitle'ın kendi yüksekliği (maxLines=2 ile
        // sınırlı, ama içerik 1 satırsa daha kısa olabilir) her seferinde
        // canlı ölçülüp düşülür ki başlık kısa/uzun/gizliyken de doğru
        // sonuç versin.
        var previewCardHeightPx = 0
        fun updatePreviewContentMaxLines() {
            if (previewCardHeightPx <= 0) return
            val cardVerticalPadding = dp(12) * 2
            val contentTopPadding = dp(4)
            val availableForContent = previewCardHeightPx -
                cardVerticalPadding -
                previewTitle.height -
                contentTopPadding
            val lineHeight = previewContent.lineHeight
            val fittingLines =
                if (lineHeight > 0) availableForContent / lineHeight else 0
            previewContent.maxLines = fittingLines.coerceAtLeast(1)
        }

        // Kaydırıcıyı önizleme kartına bağlayan küçük yardımcı — o anki
        // currentBgOpacity'yi previewCard'ın arka planına uygular.
        // previewCard.setBackgroundColor(...) yerine previewCardBg.setColor(...)
        // kullanılıyor — bu, arka plan drawable'ını komple DEĞİŞTİRMEK
        // yerine sadece dolgu rengini günceller, kenarlık (stroke) her
        // seferinde korunur.
        fun applyPreviewOpacity(opacity: Float) {
            previewCardBg.setColor(
                ColorUtils.setAlphaComponent(
                    previewBgColor,
                    (opacity * 255).toInt().coerceIn(0, 255)
                )
            )
        }
        applyPreviewOpacity(currentBgOpacity)

        // Switch değişince önizlemenin (metin rengi + zemin) gerçek
        // widget'takiyle AYNI şekilde anında tepki vermesini sağlar —
        // applyPreviewOpacity'nin previewBgColor kapanışını (closure)
        // kullanabilmesi için ikisi de previewBgColor değiştikten SONRA
        // çağrılıyor.
        fun applyPreviewTheme(dark: Boolean) {
            previewTitleColor =
                if (dark) Color.parseColor("#FFFFFF") else Color.parseColor("#1A1A1A")
            previewBgColor =
                if (dark) Color.parseColor("#1E1E1E") else Color.parseColor("#FFFFFF")
            previewTitle.setTextColor(previewTitleColor)
            previewContent.setTextColor(previewTitleColor)
            previewSettingsIcon.setColorFilter(previewTitleColor)
            applyPreviewOpacity(currentBgOpacity)
        }

        // Yazı boyutu / saydamlık kaydırıcıları — artık bu ekranın ana
        // içeriği, not seçilene kadar beklemiyor (2. adıma zaten bir not
        // seçildikten sonra geliniyor).
        val presetContainer = LinearLayout(this).apply {
            orientation = LinearLayout.VERTICAL
        }

        val fontSizeLabel = TextView(this).apply {
            setTextColor(Color.parseColor(colorTitle()))
            textSize = 13f
            setPadding(dp(20), dp(16), dp(20), dp(0))
            text = getString(R.string.widget_config_font_size_label, currentFontSize.toInt())
        }
        val fontSizeSeekBar = android.widget.SeekBar(this).apply {
            max = FONT_SIZE_MAX_SP - FONT_SIZE_MIN_SP
            progress = (currentFontSize.toInt() - FONT_SIZE_MIN_SP).coerceIn(0, max)
            setPadding(dp(16), dp(4), dp(16), dp(4))
            setOnSeekBarChangeListener(object : android.widget.SeekBar.OnSeekBarChangeListener {
                override fun onProgressChanged(
                    seekBar: android.widget.SeekBar?, progress: Int, fromUser: Boolean
                ) {
                    currentFontSize = (FONT_SIZE_MIN_SP + progress).toFloat()
                    fontSizeLabel.text = getString(
                        R.string.widget_config_font_size_label,
                        currentFontSize.toInt()
                    )
                    // Önizlemedeki başlık + içerik yazı boyutu gerçek
                    // widget'takiyle AYNI oranı korur (içerik her zaman
                    // başlıktan 2sp küçük — bkz. NoteWidgetContent /
                    // updateWidgetInner).
                    previewTitle.textSize = currentFontSize
                    previewContent.textSize = (currentFontSize - 2f).coerceAtLeast(8f)
                    // DÜZELTME (sığdığı kadar satır): yazı boyutu
                    // değişince satır yüksekliği de değiştiğinden, kaç
                    // satırın sığdığı yeniden hesaplanmalı. textSize
                    // değişikliği henüz layout'a yansımadığı için
                    // (requestLayout asenkron), bir sonraki layout turunu
                    // bekleyip öyle hesaplıyoruz.
                    previewTitle.post { updatePreviewContentMaxLines() }
                }

                override fun onStartTrackingTouch(seekBar: android.widget.SeekBar?) {}
                override fun onStopTrackingTouch(seekBar: android.widget.SeekBar?) {}
            })
        }

        val opacityLabel = TextView(this).apply {
            setTextColor(Color.parseColor(colorTitle()))
            textSize = 13f
            setPadding(dp(20), dp(8), dp(20), dp(0))
            text = getString(
                R.string.widget_config_opacity_label,
                (currentBgOpacity * 100).toInt()
            )
        }
        val opacitySeekBar = android.widget.SeekBar(this).apply {
            max = 100
            progress = (currentBgOpacity * 100).toInt().coerceIn(0, 100)
            setPadding(dp(16), dp(4), dp(16), dp(4))
            setOnSeekBarChangeListener(object : android.widget.SeekBar.OnSeekBarChangeListener {
                override fun onProgressChanged(
                    seekBar: android.widget.SeekBar?, progress: Int, fromUser: Boolean
                ) {
                    currentBgOpacity = (progress / 100f).coerceIn(0f, 1f)
                    opacityLabel.text =
                        getString(R.string.widget_config_opacity_label, progress)
                    // Önizleme kartının arka planı anlık güncellenir.
                    applyPreviewOpacity(currentBgOpacity)
                }

                override fun onStartTrackingTouch(seekBar: android.widget.SeekBar?) {}
                override fun onStopTrackingTouch(seekBar: android.widget.SeekBar?) {}
            })
        }

        // Koyu/açık switch'i — kullanıcı isteği: yazı boyutu/saydamlık
        // kaydırıcılarının hemen altında, bu widget'a özel olarak. Etiket
        // + switch aynı satırda; metni artık widget_strings.xml'deki
        // (26 dile çevrilmiş) widget_config_dark_switch_label'dan okunuyor.
        val darkRow = LinearLayout(this).apply {
            orientation = LinearLayout.HORIZONTAL
            gravity = android.view.Gravity.CENTER_VERTICAL
            // DÜZELTME (satırlar birbirine çok yakındı): alt padding
            // 4dp -> 10dp yükseltildi; buildIconToggleRow'daki üst
            // padding ile AYNI değere getirildi ki darkRow ile
            // showSettingsRow arası, diğer switch satırları arasıyla
            // TUTARLI bir boşlukta olsun.
            setPadding(dp(20), dp(16), dp(20), dp(10))
        }
        val darkLabel = TextView(this).apply {
            text = getString(R.string.widget_config_dark_switch_label)
            setTextColor(Color.parseColor(colorTitle()))
            textSize = 13f
            layoutParams = LinearLayout.LayoutParams(
                0,
                LinearLayout.LayoutParams.WRAP_CONTENT,
                1f
            )
        }
        val darkSwitch = android.widget.Switch(this).apply {
            isChecked = currentDark
            // Vurgu rengi ekranın geri kalanıyla (buton, ripple) AYNI amber.
            thumbTintList = ColorStateList(
                arrayOf(
                    intArrayOf(android.R.attr.state_checked),
                    intArrayOf(-android.R.attr.state_checked),
                ),
                intArrayOf(Color.parseColor(COLOR_AMBER), Color.parseColor(colorMutedText()))
            )
            trackTintList = ColorStateList(
                arrayOf(
                    intArrayOf(android.R.attr.state_checked),
                    intArrayOf(-android.R.attr.state_checked),
                ),
                intArrayOf(
                    ColorUtils.setAlphaComponent(Color.parseColor(COLOR_AMBER), 130),
                    ColorUtils.setAlphaComponent(Color.parseColor(colorMutedText()), 90),
                )
            )
            setOnCheckedChangeListener { _, isChecked ->
                currentDark = isChecked
                applyPreviewTheme(currentDark)
            }
        }
        darkRow.addView(darkLabel)
        darkRow.addView(darkSwitch)

        // Kullanıcı isteği: koyu/açık switch'inin hemen altına, sağ
        // üstteki ⚙️ ikonunu açıp kapatan bir switch. darkRow ile BİREBİR
        // aynı desen (satır yapısı, renkler); tek fark
        // currentShowSettingsIcon değişkenini güncellemesi ve
        // önizlemedeki ikonun görünürlüğünü (renk değil, VISIBLE/GONE)
        // anında yansıtması. (➕ "yeni not" switch'i kaldırıldı.)
        fun buildIconToggleRow(
            labelText: String,
            initiallyChecked: Boolean,
            previewIcon: ImageView,
            onChanged: (Boolean) -> Unit,
        ): LinearLayout {
            val row = LinearLayout(this).apply {
                orientation = LinearLayout.HORIZONTAL
                gravity = android.view.Gravity.CENTER_VERTICAL
                // DÜZELTME (satırlar birbirine çok yakındı): dikey
                // padding 4dp -> 10dp yükseltildi (darkRow'un alt
                // padding'iyle AYNI), üç switch satırı arasında daha
                // ferah, tutarlı bir boşluk bırakmak için.
                setPadding(dp(20), dp(10), dp(20), dp(10))
            }
            val label = TextView(this).apply {
                text = labelText
                setTextColor(Color.parseColor(colorTitle()))
                textSize = 13f
                layoutParams = LinearLayout.LayoutParams(
                    0,
                    LinearLayout.LayoutParams.WRAP_CONTENT,
                    1f
                )
            }
            val switchView = android.widget.Switch(this).apply {
                isChecked = initiallyChecked
                thumbTintList = ColorStateList(
                    arrayOf(
                        intArrayOf(android.R.attr.state_checked),
                        intArrayOf(-android.R.attr.state_checked),
                    ),
                    intArrayOf(Color.parseColor(COLOR_AMBER), Color.parseColor(colorMutedText()))
                )
                trackTintList = ColorStateList(
                    arrayOf(
                        intArrayOf(android.R.attr.state_checked),
                        intArrayOf(-android.R.attr.state_checked),
                    ),
                    intArrayOf(
                        ColorUtils.setAlphaComponent(Color.parseColor(COLOR_AMBER), 130),
                        ColorUtils.setAlphaComponent(Color.parseColor(colorMutedText()), 90),
                    )
                )
                setOnCheckedChangeListener { _, isChecked ->
                    onChanged(isChecked)
                    previewIcon.visibility = if (isChecked) View.VISIBLE else View.GONE
                }
            }
            row.addView(label)
            row.addView(switchView)
            return row
        }

        // DÜZELTME: widget_strings.xml (26 dile çevrilmiş) artık
        // widget_config_show_settings_icon_label anahtarını da içeriyor;
        // diğer etiketlerle (ör. widget_config_dark_switch_label) AYNI
        // desende getString() ile okunuyor. (widget_config_show_add_icon_label
        // artık kullanılmıyor — kaldırılabilir.)
        val showSettingsRow = buildIconToggleRow(
            labelText = getString(R.string.widget_config_show_settings_icon_label),
            initiallyChecked = currentShowSettingsIcon,
            previewIcon = previewSettingsIcon,
        ) { isChecked -> currentShowSettingsIcon = isChecked }

        presetContainer.addView(fontSizeLabel)
        presetContainer.addView(fontSizeSeekBar)
        presetContainer.addView(opacityLabel)
        presetContainer.addView(opacitySeekBar)
        presetContainer.addView(darkRow)
        presetContainer.addView(showSettingsRow)

        // DÜZELTME (2 EKRANLI AKIŞ): bu ekrana zaten bir not/boş-durum
        // seçilmiş olarak gelindiği için buton artık başlangıçtan itibaren
        // etkin ve tam opak — eskideki "not seçilene kadar devre dışı"
        // durumuna gerek kalmadı.
        val addWidgetBtn = TextView(this).apply {
            text = getString(R.string.widget_config_add_widget)
            setTextColor(Color.parseColor(COLOR_AMBER))
            textSize = 16f
            gravity = android.view.Gravity.CENTER
            setTypeface(typeface, android.graphics.Typeface.BOLD)
            setPadding(dp(20), dp(16), dp(20), dp(16))
            // DÜZELTME: root artık şeffaf; bu buton ekranın en altında,
            // sistem gezinme çubuğunun hemen üstünde durduğundan (bkz.
            // applySystemInsetPadding) duvar kağıdının üstünde
            // yüzen bir buton yerine, gerçek widget zeminiyle aynı düz
            // (colorBg()) bir şerit üstünde durması tercih edildi.
            setBackgroundColor(Color.parseColor(colorBg()))
            setOnClickListener {
                onNoteSelected(
                    prefs,
                    noteId,
                    currentFontSize,
                    currentBgOpacity,
                    currentDark,
                    currentShowSettingsIcon,
                )
            }
        }

        // DÜZELTME (ekranı ikiye böl): header hariç kalan alan artık eşit
        // iki yarıya bölünüyor — ÜST yarı önizlemeyi ortalayarak gösterir,
        // ALT yarı kaydırıcıları üstten hizalı gösterir. Önceki tasarımda
        // (tek akış + kaydırıcılarla buton arasında boş bir View) ekranın
        // ortasında amaçsız bir boşluk oluşuyordu; artık o boşluk, iki
        // yarının kendi içinde (üstte ortalama, altta üstten hizalama)
        // anlamlı şekilde kullanılıyor.
        val topHalf = LinearLayout(this).apply {
            orientation = LinearLayout.VERTICAL
            gravity = android.view.Gravity.CENTER
        }
        topHalf.addView(previewLabel)
        topHalf.addView(
            previewCard,
            LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT,
                LinearLayout.LayoutParams.WRAP_CONTENT
            ).apply {
                leftMargin = dp(20)
                rightMargin = dp(20)
            }
        )
        // DÜZELTME (kare önizleme): Kullanıcı, referans ekran görüntüsündeki
        // (Color Notes) gibi önizleme kutusunun TAM KARE görünmesini istedi.
        // Sabit bir dp değeri yerine topHalf'ın GERÇEK ölçülen genişlik/
        // yüksekliğine göre karar veriliyor ki hem farklı ekran
        // boyutlarında hem de üst yarının kendi (ekranı ikiye bölen)
        // yüksekliğinde her zaman TAM kare kalsın ve taşmasın: kenar
        // uzunluğu = min(kullanılabilir genişlik, kullanılabilir yükseklik).
        // Bu ölçüm, view'lar gerçekten ekrana yerleştirilip boyutlanana
        // kadar bilinmediğinden (weight=1f ile paylaşılan yükseklik derleme
        // anında hesaplanamaz), bir kerelik bir "global layout" dinleyicisi
        // ile YALNIZCA topHalf ilk kez ölçülüp yerleştirildiğinde çalışıyor.
        val squareMarginPx = dp(20)
        topHalf.viewTreeObserver.addOnGlobalLayoutListener(
            object : android.view.ViewTreeObserver.OnGlobalLayoutListener {
                override fun onGlobalLayout() {
                    topHalf.viewTreeObserver.removeOnGlobalLayoutListener(this)
                    val availableWidth = topHalf.width - squareMarginPx * 2
                    val availableHeight = topHalf.height - previewLabel.height - squareMarginPx
                    val squareSize = minOf(availableWidth, availableHeight)
                    if (squareSize > 0) {
                        val lp = previewCard.layoutParams as LinearLayout.LayoutParams
                        lp.width = squareSize
                        lp.height = squareSize
                        previewCard.layoutParams = lp
                        previewCardHeightPx = squareSize
                        // DÜZELTME (sığdığı kadar satır): kare yükseklik
                        // artık BELLİ — previewContent'in kaç satır
                        // gösterebileceğini buna göre hesapla. previewTitle
                        // henüz yeni kare genişliğine göre yeniden
                        // ölçülmediği için (requestLayout asenkron), bir
                        // sonraki layout turunu bekleyip öyle hesaplıyoruz.
                        previewCard.post { updatePreviewContentMaxLines() }
                    }
                }
            }
        )

        val bottomHalf = LinearLayout(this).apply {
            orientation = LinearLayout.VERTICAL
            gravity = android.view.Gravity.TOP
            // DÜZELTME: topHalf'ın aksine bu yarı şeffaf KALMIYOR — kaydırıcı
            // satırları duvar kağıdının üstünde değil, gerçek widget'ın
            // arka planıyla aynı düz zeminin (colorBg()) üstünde okunması
            // daha kolay olduğundan burası opak. splitContainer zaten
            // weight=1f ile bu view'a tam yarı yüksekliği verdiğinden,
            // arka plan rengi içerik kısa olsa bile tüm yarıyı kaplar.
            setBackgroundColor(Color.parseColor(colorBg()))
        }
        bottomHalf.addView(presetContainer)

        val splitContainer = LinearLayout(this).apply {
            orientation = LinearLayout.VERTICAL
        }
        splitContainer.addView(
            topHalf,
            LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, 0, 1f)
        )
        splitContainer.addView(
            bottomHalf,
            LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, 0, 1f)
        )
        root.addView(
            splitContainer,
            LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, 0, 1f)
        )
        // "Widget'ı Ekle" butonu bölünen alanın DIŞINDA, ekranın en altında
        // sabit kalmaya devam ediyor (bkz. applySystemInsetPadding).
        root.addView(
            addWidgetBtn,
            LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT,
                LinearLayout.LayoutParams.WRAP_CONTENT
            )
        )

        setContentView(root)
        applySystemInsetPadding(insetsSource = root, topTarget = headerRow, bottomTarget = addWidgetBtn)
    }

    // DÜZELTME: Ekran edge-to-edge çizildiğinden (bkz. modern Android
    // sürümlerinin varsayılan davranışı) en alttaki view (addWidgetBtn ya
    // da boş durumdaki continueBtn) sistemin gezinme çubuğunun (navigation
    // bar) ARKASINDA kalıyor, üstüne biniyordu (kullanıcı raporu:
    // "'Widget'ı Ekle' butonu telefonun alt çubuğuyla çakışıyor"). Her iki
    // ekran de kendi kök view'ını setContentView ile değiştirdiğinden, bu
    // yardımcı ekran her değiştiğinde (showNoteSelectionScreen VE
    // showAppearanceScreen) yeni kök view üzerinde tekrar çağrılıyor.
    //
    // DÜZELTME (gerçek duvar kağıdı arka planı): `insetsSource` (insets'i
    // DİNLEYEN view) ile `paddingTarget` (alt boşluğun asıl UYGULANDIĞI
    // view) artık ayrı parametreler. Neden: showAppearanceScreen'de root
    // artık opak değil (şeffaf, duvar kağıdının görünmesi için); padding
    // doğrudan root'a uygulanırsa, nav bar ile addWidgetBtn arasında kalan
    // o ince şerit root'un şeffaf zemininden dolayı duvar kağıdını
    // gösterirdi — butonun altında beklenmedik bir "pencere" gibi
    // görünürdü. Bunun yerine padding, ZATEN opak arka plana sahip
    // addWidgetBtn'in kendisine veriliyor; böylece o ekstra boşluk da
    // butonun opak renginin bir uzantısı gibi kalıyor. showNoteSelectionScreen
    // için (root hâlâ opak) davranış DEĞİŞMEDİ — paddingTarget varsayılan
    // olarak insetsSource'un kendisi.
    // DÜZELTME (başlıklar saate/durum çubuğuna çok yakın duruyor sorunu):
    // Fonksiyon artık sadece alt değil, üst inset'i de (durum çubuğu/saat
    // yüksekliği) ayrı bir hedef view'a uygulayabiliyor — bkz. aşağıdaki
    // topTarget parametresi. Mantık alt boşlukla BİREBİR aynı: taban
    // (orijinal) üst boşluk bir kez okunup sabit tutuluyor, listener her
    // tetiklendiğinde "orijinal + güncel inset" hesaplanıyor ki katlanarak
    // büyümesin.
    private fun applySystemInsetPadding(
        insetsSource: View,
        topTarget: View? = null,
        bottomTarget: View? = insetsSource,
    ) {
        val baseTopPadding = topTarget?.paddingTop ?: 0
        val baseBottomPadding = bottomTarget?.paddingBottom ?: 0
        ViewCompat.setOnApplyWindowInsetsListener(insetsSource) { _, insets ->
            val systemBars = insets.getInsets(WindowInsetsCompat.Type.systemBars())
            topTarget?.setPadding(
                topTarget.paddingLeft,
                baseTopPadding + systemBars.top,
                topTarget.paddingRight,
                topTarget.paddingBottom
            )
            bottomTarget?.setPadding(
                bottomTarget.paddingLeft,
                bottomTarget.paddingTop,
                bottomTarget.paddingRight,
                baseBottomPadding + systemBars.bottom
            )
            insets
        }
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

    // AŞAMA 6: fontSize/bgOpacity parametreleri null olabilir — hiçbir
    // çağıran artık null vermiyor (2. adım her zaman kaydırıcı değerlerini
    // gönderiyor) ama imza geriye dönük uyumluluk için opsiyonel bırakıldı.
    // Bu, widget'a özel fontSizeKey/bgOpacityKey anahtarlarını kalıcı
    // olarak kaydeder; NoteWidget.kt ve NoteWidgetReceiverV2 zaten bu
    // anahtarlar bulunamazsa global ayara (KEY_FONT_SIZE/KEY_BG_OPACITY)
    // düşecek şekilde yazılmıştı.
    private fun onNoteSelected(
        prefs: SharedPreferences,
        noteId: String,
        fontSize: Float? = null,
        bgOpacity: Float? = null,
        dark: Boolean? = null,
        showSettingsIcon: Boolean? = null,
    ) {
        val editor = prefs.edit()
            .putString(NoteWidgetReceiverV2.pinnedNoteKey(appWidgetId), noteId)
        if (fontSize != null) {
            editor.putFloat(NoteWidgetReceiverV2.fontSizeKey(appWidgetId), fontSize)
        }
        if (bgOpacity != null) {
            editor.putFloat(NoteWidgetReceiverV2.bgOpacityKey(appWidgetId), bgOpacity)
        }
        if (dark != null) {
            editor.putBoolean(NoteWidgetReceiverV2.darkKey(appWidgetId), dark)
        }
        // Kullanıcı isteği: ⚙️ ikonunun widget'ta gösterilip
        // gösterilmeyeceği, darkKey ile AYNI desende.
        if (showSettingsIcon != null) {
            editor.putBoolean(
                NoteWidgetReceiverV2.showSettingsIconKey(appWidgetId),
                showSettingsIcon
            )
        }
        editor.apply()

        // Widget'ı hemen, seçilen not + ön ayarlarla güncelle — sistemin
        // varsayılan onUpdate döngüsünü beklemeden widget doğru içerikle
        // belirir.
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
    //
    // DÜZELTME (Pinterest tarzı ızgara): BaseAdapter/ListView yerine
    // RecyclerView.Adapter'a çevrildi (2 sütunlu StaggeredGridLayoutManager
    // ile kullanılabilmesi için). Kart tasarımının (createCardRow) kendisi
    // BİREBİR aynı kaldı; sadece view-recycling mekanizması (getView ->
    // onCreateViewHolder/onBindViewHolder) ve tıklama (OnItemClickListener
    // -> constructor'a verilen onSelect lambda'sı) değişti.
    //
    // DÜZELTME (2 EKRANLI AKIŞ): Karta dokunmak artık ekranda "seçili"
    // görünmüyor (amber kenarlık kaldırıldı) — çünkü dokununca zaten
    // DOĞRUDAN 2. adıma geçiliyor, bu ekrana bir daha dönülene kadar
    // seçim durumu görsel olarak anlamsızdı.
    private class NoteCardAdapter(
        private val ctx: Context,
        private var items: List<NoteEntry>,
        private val isDarkTheme: Boolean,
        private val onSelect: (String) -> Unit,
    ) : RecyclerView.Adapter<NoteCardAdapter.ViewHolder>() {

        private fun dp(value: Int): Int =
            (value * ctx.resources.displayMetrics.density).toInt()

        private fun colorCard() = if (isDarkTheme) COLOR_CARD_DARK else COLOR_CARD_LIGHT
        private fun colorTitle() = if (isDarkTheme) COLOR_TITLE_DARK else COLOR_TITLE_LIGHT
        private fun colorCardPreviewText() =
            if (isDarkTheme) COLOR_CARD_PREVIEW_TEXT_DARK else COLOR_CARD_PREVIEW_TEXT_LIGHT

        // Arama kutusundaki metin değiştikçe çağrılır: gösterilen listeyi
        // filtrelenmiş sonuçla değiştirip RecyclerView'ı yeniden çizer.
        // Liste küçük olduğundan (tek kullanıcının notları) DiffUtil yerine
        // basit notifyDataSetChanged() yeterli ve daha az karmaşık.
        fun updateItems(newItems: List<NoteEntry>) {
            items = newItems
            notifyDataSetChanged()
        }

        override fun getItemCount(): Int = items.size

        override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
            val inflated = createCardRow()
            return ViewHolder(inflated.root, inflated.title, inflated.preview, inflated.cardBackground)
        }

        override fun onBindViewHolder(holder: ViewHolder, position: Int) {
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

            // Açık temada zeminden ayırt etmek için ince kenarlık, koyu
            // temada kenarlıksız (bkz. createCardRow'daki orijinal mantık).
            if (!isDarkTheme) {
                holder.cardBackground.setStroke(dp(1), Color.parseColor(COLOR_CARD_BORDER_LIGHT))
            } else {
                holder.cardBackground.setStroke(0, Color.TRANSPARENT)
            }

            holder.itemView.setOnClickListener {
                // Karta dokunmak DOĞRUDAN 2. adıma (görünüm ayarları)
                // geçiyor — bu ekranda ayrıca bir "seçili" görünüm veya
                // onay butonu yok.
                onSelect(entry.id)
            }
        }

        private class ViewHolder(
            root: View,
            val title: TextView,
            val preview: TextView,
            val cardBackground: GradientDrawable,
        ) : RecyclerView.ViewHolder(root)

        private class InflatedRow(
            val root: View,
            val title: TextView,
            val preview: TextView,
            val cardBackground: GradientDrawable,
        )

        private fun createCardRow(): InflatedRow {
            // DÜZELTME (kart yüksekliği artırıldı): Önceki küçültme (6 satır
            // sığsın diye) kartları okunması güç ve birbirinden çok
            // farklı yükseklikte (bazıları neredeyse tek satır) bıraktı.
            // Kullanıcı isteği üzerine iç boşluklar, yazı boyutları ve
            // önizleme satır sayısı tekrar büyütüldü; ayrıca kartın kendisine
            // bir minHeight verildi ki kısa içerikli notlar da (örn. tek
            // satırlık başlık) çok cılız görünmesin, tüm kartlar daha
            // tutarlı/dolgun bir yükseklikte dursun.
            //
            // Dış kapsayıcı: kartlar arasında (hem sütunlar arasında hem
            // alt alta) boşluk bırakmak için padding kullanılıyor —
            // StaggeredGridLayoutManager öğeleri kendi genişliğine göre
            // eşit sütunlara böldüğünden, gutter'ı margin yerine padding
            // ile vermek RecyclerView içinde de aynı görsel sonucu verir.
            val outer = LinearLayout(ctx).apply {
                orientation = LinearLayout.VERTICAL
                setPadding(dp(6), dp(6), dp(6), dp(6))
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
                setPadding(dp(16), dp(16), dp(16), dp(16))
                // DÜZELTME: Önceden 120dp idi — bu, başlık+preview
                // toplamı bundan kısa olan (örn. tek satır başlık, 2
                // satır preview'lu) notların kartını da 120dp'ye
                // şişiriyor, metnin altında boş alan kalıyordu. Artık
                // sadece boş/çok kısa içerikli notlarda kartın çok ince
                // bir çizgiye düşmesini (ve dokunma hedefinin
                // küçülmesini) önleyecek küçük bir taban bırakılıyor;
                // kartın gerçek yüksekliği (StaggeredGridLayoutManager
                // ile) yine içeriğe (title maxLines=2 + preview
                // maxLines=6) göre serbestçe değişiyor.
                minimumHeight = dp(48)
                layoutParams = LinearLayout.LayoutParams(
                    LinearLayout.LayoutParams.MATCH_PARENT,
                    LinearLayout.LayoutParams.WRAP_CONTENT,
                )
            }

            val title = TextView(ctx).apply {
                setTextColor(Color.parseColor(colorTitle()))
                textSize = 18f
                setTypeface(typeface, android.graphics.Typeface.BOLD)
                // DÜZELTME: Tek sütunlu listede başlık tek satıra
                // kısıtlanıp kesiliyordu (ellipsize); artık kart dar bir
                // sütuna (ekran genişliğinin yarısına) sığdığından ve
                // yükseklik içeriğe göre serbestçe uzayabildiğinden
                // (staggered grid) başlığın 2 satıra kadar tam görünmesine
                // izin veriliyor.
                maxLines = 2
                ellipsize = TextUtils.TruncateAt.END
            }
            card.addView(title)

            val preview = TextView(ctx).apply {
                setTextColor(Color.parseColor(colorCardPreviewText()))
                textSize = 17f
                maxLines = 6
                ellipsize = TextUtils.TruncateAt.END
                setPadding(0, dp(8), 0, 0)
            }
            card.addView(preview)

            outer.addView(card)
            return InflatedRow(outer, title, preview, cardBackground)
        }
    }
}
