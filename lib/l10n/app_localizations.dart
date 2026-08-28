import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_cs.dart';
import 'app_localizations_da.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fi.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_he.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_id.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_nl.dart';
import 'app_localizations_no.dart';
import 'app_localizations_pl.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ro.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_sv.dart';
import 'app_localizations_th.dart';
import 'app_localizations_tr.dart';
import 'app_localizations_uk.dart';
import 'app_localizations_vi.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('cs'),
    Locale('da'),
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fi'),
    Locale('fr'),
    Locale('he'),
    Locale('hi'),
    Locale('id'),
    Locale('it'),
    Locale('ja'),
    Locale('ko'),
    Locale('nl'),
    Locale('no'),
    Locale('pl'),
    Locale('pt'),
    Locale('ro'),
    Locale('ru'),
    Locale('sv'),
    Locale('th'),
    Locale('tr'),
    Locale('uk'),
    Locale('vi'),
    Locale('zh'),
  ];

  /// Metin biçimlendirme araç çubuğunda kalın yapma düğmesinin ipucu metni
  ///
  /// In tr, this message translates to:
  /// **'Kalın'**
  String get toolbarBoldTooltip;

  /// Metin biçimlendirme araç çubuğunda italik yapma düğmesinin ipucu metni
  ///
  /// In tr, this message translates to:
  /// **'İtalik'**
  String get toolbarItalicTooltip;

  /// Metin biçimlendirme araç çubuğunda altı çizili yapma düğmesinin ipucu metni
  ///
  /// In tr, this message translates to:
  /// **'Altı Çizili'**
  String get toolbarUnderlineTooltip;

  /// Metin biçimlendirme araç çubuğunda üzeri çizili yapma düğmesinin ipucu metni
  ///
  /// In tr, this message translates to:
  /// **'Üzeri Çizili'**
  String get toolbarStrikethroughTooltip;

  /// Metin biçimlendirme araç çubuğunda yazı boyutu seçme düğmesinin ipucu metni
  ///
  /// In tr, this message translates to:
  /// **'Yazı Boyutu'**
  String get toolbarFontSizeTooltip;

  /// Metin biçimlendirme araç çubuğunda yazı rengi seçme düğmesinin ipucu metni
  ///
  /// In tr, this message translates to:
  /// **'Yazı Rengi'**
  String get toolbarColorTooltip;

  /// Blok araç çubuğunda madde işaretli liste ekleme düğmesinin ipucu metni
  ///
  /// In tr, this message translates to:
  /// **'Madde İşareti'**
  String get toolbarBulletTooltip;

  /// Blok araç çubuğunda numaralı liste ekleme düğmesinin ipucu metni
  ///
  /// In tr, this message translates to:
  /// **'Numara İşareti'**
  String get toolbarNumberTooltip;

  /// Blok araç çubuğunda paragraf girintisi uygulama düğmesinin ipucu metni
  ///
  /// In tr, this message translates to:
  /// **'Paragraf Girintisi'**
  String get toolbarIndentTooltip;

  /// Blok araç çubuğunda link ekleme/düzenleme/kaldırma düğmesinin ipucu metni
  ///
  /// In tr, this message translates to:
  /// **'Link Ekle / Düzenle / Kaldır'**
  String get toolbarLinkTooltip;

  /// Blok araç çubuğunda yatay çizgi (ayraç) ekleme düğmesinin ipucu metni
  ///
  /// In tr, this message translates to:
  /// **'Yatay Çizgi Ekle'**
  String get toolbarDividerTooltip;

  /// Blok araç çubuğunda yapılacaklar listesi ekleme düğmesinin ipucu metni
  ///
  /// In tr, this message translates to:
  /// **'Yapılacaklar Listesi Ekle'**
  String get toolbarChecklistTooltip;

  /// Kullanıcı metin seçmeden link ekleme düğmesine bastığında gösterilen snackbar uyarı mesajı
  ///
  /// In tr, this message translates to:
  /// **'Önce link eklemek istediğiniz metni seçin'**
  String get linkSelectTextSnackbar;

  /// Seçili metinde zaten bir link varken açılan diyaloğun başlığı
  ///
  /// In tr, this message translates to:
  /// **'Linki Düzenle'**
  String get linkDialogEditTitle;

  /// Seçili metinde henüz link yokken açılan diyaloğun başlığı
  ///
  /// In tr, this message translates to:
  /// **'Link Ekle'**
  String get linkDialogAddTitle;

  /// Link diyaloğunda var olan linki kaldırma düğmesi (yalnızca link zaten varsa gösterilir)
  ///
  /// In tr, this message translates to:
  /// **'Linki Kaldır'**
  String get linkDialogRemoveButton;

  /// Link diyaloğunda işlemi iptal etme düğmesi
  ///
  /// In tr, this message translates to:
  /// **'Vazgeç'**
  String get linkDialogCancelButton;

  /// Link diyaloğunda girilen URL'yi onaylama düğmesi
  ///
  /// In tr, this message translates to:
  /// **'Ekle'**
  String get linkDialogConfirmButton;

  /// Kullanıcı kamera iznini kalıcı olarak reddettiğinde video çekme denemesinde gösterilen snackbar mesajı
  ///
  /// In tr, this message translates to:
  /// **'Kamera izni reddedilmiş. Video çekmek için ayarlardan izin vermen gerekiyor.'**
  String get cameraPermissionPermanentlyDeniedMessage;

  /// Kamera izni henüz verilmemişken (kalıcı red değil) video çekme denemesinde gösterilen snackbar mesajı
  ///
  /// In tr, this message translates to:
  /// **'Video çekmek için kamera izni gerekiyor.'**
  String get cameraPermissionRequiredMessage;

  /// İzin kalıcı olarak reddedildiğinde uygulama ayarlarını açan snackbar eylem düğmesi (kamera ve mikrofon izin uyarılarında ortak kullanılır)
  ///
  /// In tr, this message translates to:
  /// **'Ayarlar'**
  String get openSettingsButtonLabel;

  /// Belge tarama işlemi başlatılamadığında gösterilen snackbar mesajı
  ///
  /// In tr, this message translates to:
  /// **'Tarama başlatılamadı: {error}'**
  String documentScanStartFailedMessage(String error);

  /// Taranan belge üzerinde OCR (metin tanıma) işlemi başarısız olduğunda gösterilen snackbar mesajı
  ///
  /// In tr, this message translates to:
  /// **'Metin tanıma başarısız: {error}'**
  String ocrRecognitionFailedMessage(String error);

  /// OCR işlemi başarılı olduğu halde taranan belgede okunabilir metin çıkmadığında gösterilen bilgi mesajı
  ///
  /// In tr, this message translates to:
  /// **'Belgede okunabilir metin bulunamadı'**
  String get ocrNoReadableTextMessage;

  /// Belge tarandıktan sonra kullanıcıya ekleme şeklini soran bottom sheet'in başlığı
  ///
  /// In tr, this message translates to:
  /// **'Taranan belge nasıl eklensin?'**
  String get scanResultSheetTitle;

  /// Tarama sonuç sheet'inde yalnızca tanınan metni nota ekleme seçeneği
  ///
  /// In tr, this message translates to:
  /// **'Sadece metin olarak ekle'**
  String get scanResultTextOnlyOption;

  /// Tarama sonuç sheet'inde hem tanınan metni hem taranan görseli nota ekleme seçeneği
  ///
  /// In tr, this message translates to:
  /// **'Metin + taranan görseli ekle'**
  String get scanResultTextAndImageOption;

  /// Tarama sonuç sheet'inde işlemi iptal etme seçeneği
  ///
  /// In tr, this message translates to:
  /// **'Vazgeç'**
  String get scanResultCancelOption;

  /// Kullanıcı mikrofon iznini kalıcı olarak reddettiğinde ses kaydı denemesinde gösterilen snackbar mesajı
  ///
  /// In tr, this message translates to:
  /// **'Mikrofon izni reddedilmiş. Ses kaydı için ayarlardan izin vermen gerekiyor.'**
  String get audioPermissionPermanentlyDeniedMessage;

  /// Mikrofon izni henüz verilmemişken (kalıcı red değil) ses kaydı denemesinde gösterilen snackbar mesajı
  ///
  /// In tr, this message translates to:
  /// **'Ses kaydı için mikrofon izni gerekiyor.'**
  String get audioPermissionRequiredMessage;

  /// Yeni kaydedilen ses notu için otomatik dosya adı öneki ve oynatıcı sheet'inde dosya adı yoksa gösterilen varsayılan başlık
  ///
  /// In tr, this message translates to:
  /// **'Ses Kaydı'**
  String get voiceRecordingDefaultLabel;

  /// Blokları Sırala listesinde bir hesap tablosu bloğu için gösterilen önizleme metni
  ///
  /// In tr, this message translates to:
  /// **'Hesap Listesi ({count} satır)'**
  String blockPreviewCalcTableLabel(int count);

  /// Blokları Sırala listesinde bir çizim bloğu için gösterilen önizleme metni
  ///
  /// In tr, this message translates to:
  /// **'Çizim'**
  String get blockPreviewDrawingLabel;

  /// Blokları Sırala listesinde bir ek grubu bloğu için gösterilen önizleme metni
  ///
  /// In tr, this message translates to:
  /// **'{count} ek (fotoğraf/belge)'**
  String blockPreviewAttachmentsLabel(int count);

  /// Blokları Sırala listesinde bir yatay çizgi (ayraç) bloğu için gösterilen önizleme metni
  ///
  /// In tr, this message translates to:
  /// **'Ayırıcı Çizgi'**
  String get blockPreviewDividerLabel;

  /// Blokları Sırala listesinde bir yapılacaklar listesi bloğu için gösterilen önizleme metni
  ///
  /// In tr, this message translates to:
  /// **'Kontrol Listesi ({count} madde)'**
  String blockPreviewChecklistLabel(int count);

  /// Blokları Sırala listesinde içeriği boş olan bir metin bloğu için gösterilen önizleme metni
  ///
  /// In tr, this message translates to:
  /// **'(boş metin)'**
  String get blockPreviewEmptyTextLabel;

  /// Blokları yeniden sıralama alt menüsünün (bottom sheet) başlığı
  ///
  /// In tr, this message translates to:
  /// **'Blokları Sırala'**
  String get reorderBlocksSheetTitle;

  /// Blokları Sırala menüsünde seçili bloğu bir yukarı taşıma düğmesinin ipucu metni
  ///
  /// In tr, this message translates to:
  /// **'Yukarı Taşı'**
  String get reorderBlocksMoveUpTooltip;

  /// Blokları Sırala menüsünde seçili bloğu bir aşağı taşıma düğmesinin ipucu metni
  ///
  /// In tr, this message translates to:
  /// **'Aşağı Taşı'**
  String get reorderBlocksMoveDownTooltip;

  /// Blokları Sırala menüsünü kapatma düğmesinin ipucu metni
  ///
  /// In tr, this message translates to:
  /// **'Kapat'**
  String get reorderBlocksCloseTooltip;

  /// Blokları Sırala menüsünde kullanıcıya nasıl kullanılacağını açıklayan yardım metni
  ///
  /// In tr, this message translates to:
  /// **'Taşımak istediğiniz bloğa dokunup seçin, sonra yukarı/aşağı ok ile taşıyın.'**
  String get reorderBlocksDescription;

  /// Not üzerindeki ek özellikler menüsünde Blokları Sırala alt menüsünü açan seçenek
  ///
  /// In tr, this message translates to:
  /// **'Sırala'**
  String get reorderBlocksMenuItemLabel;

  /// TXT içe aktarma için dosya seçici penceresinin başlığı
  ///
  /// In tr, this message translates to:
  /// **'İçe aktarılacak TXT dosyasını seç'**
  String get txtImportPickerDialogTitle;

  /// Seçilen TXT dosyası okunamadığında gösterilen bilgi mesajı
  ///
  /// In tr, this message translates to:
  /// **'TXT dosyası okunamadı'**
  String get txtImportReadFailedMessage;

  /// Seçilen TXT dosyasının içeriği boş olduğunda gösterilen bilgi mesajı
  ///
  /// In tr, this message translates to:
  /// **'TXT dosyası boş'**
  String get txtImportEmptyFileMessage;

  /// TXT dosyası başarıyla içe aktarıldığında gösterilen bilgi mesajı
  ///
  /// In tr, this message translates to:
  /// **'TXT içe aktarıldı'**
  String get txtImportSuccessMessage;

  /// Not üzerindeki ek özellikler menüsünde TXT dosyası içe aktarma seçeneği
  ///
  /// In tr, this message translates to:
  /// **'İçe Aktar (txt)'**
  String get txtImportMenuItemLabel;

  /// Not üzerindeki ek özellikler menüsünde dışa aktarma alt menüsünü açan seçenek
  ///
  /// In tr, this message translates to:
  /// **'Dışa Aktar'**
  String get exportMenuItemLabel;

  /// Not düzenleyici üst çubuğunda geri alma düğmesinin ipucu metni
  ///
  /// In tr, this message translates to:
  /// **'Geri Al'**
  String get editorUndoTooltip;

  /// Not düzenleyici üst çubuğunda ileri alma (yinele) düğmesinin ipucu metni
  ///
  /// In tr, this message translates to:
  /// **'İleri Al'**
  String get editorRedoTooltip;

  /// Not kaydedildiğinde gösterilen bilgi çubuğu mesajı
  ///
  /// In tr, this message translates to:
  /// **'Not kaydedildi'**
  String get noteSavedMessage;

  /// Nota tarih atamak için açılan takvim seçicinin yardım metni
  ///
  /// In tr, this message translates to:
  /// **'Notu bir güne ata'**
  String get dateAssignPickerHelpText;

  /// Nota zaten atanmış tarih üzerine uzun basıldığında açılan menüde tarihi değiştirme seçeneği
  ///
  /// In tr, this message translates to:
  /// **'Tarihi değiştir'**
  String get dateAssignChangeOption;

  /// Nota zaten atanmış tarih üzerine uzun basıldığında açılan menüde tarih atamasını kaldırma seçeneği
  ///
  /// In tr, this message translates to:
  /// **'Atamayı kaldır'**
  String get dateAssignRemoveOption;

  /// Metin biçimlendirme araç çubuğundaki alt araç çubuklarını (liste, stil, renk, yazı boyutu) kapatan düğmenin ipucu metni
  ///
  /// In tr, this message translates to:
  /// **'Kapat'**
  String get editorSubToolbarCloseTooltip;

  /// Not başlığı giriş alanının ipucu (placeholder) metni
  ///
  /// In tr, this message translates to:
  /// **'Başlık'**
  String get titleFieldHint;

  /// Boş metin bloğu için gösterilen ipucu (placeholder) metni
  ///
  /// In tr, this message translates to:
  /// **'Notunuzu buraya yazın...'**
  String get textBlockHint;

  /// Not üzerindeki ek özellikler menüsünde çizim panosu bloğu ekleme seçeneği
  ///
  /// In tr, this message translates to:
  /// **'Çizim Panosu'**
  String get drawingBoardMenuItemLabel;

  /// Ses kaydından metne çevirme özelliği metin dışı bir not türünde kullanılmaya çalışıldığında gösterilen bilgi mesajı
  ///
  /// In tr, this message translates to:
  /// **'Sesi yazıya çevirme yalnızca metin notlarında kullanılabilir'**
  String get voiceToTextTextNotesOnlyMessage;

  /// Not listesi seçim modunda, seçimi iptal edip normal görünüme dönen (X) düğmesinin ipucu metni
  ///
  /// In tr, this message translates to:
  /// **'Seçimi İptal Et'**
  String get selectionModeCancelTooltip;

  /// Not listesi seçim modunda üst çubukta seçili not sayısını gösteren başlık
  ///
  /// In tr, this message translates to:
  /// **'{count} seçildi'**
  String selectionModeSelectedCountTitle(int count);

  /// Not listesi seçim modunda seçili notları silen düğmenin ipucu metni
  ///
  /// In tr, this message translates to:
  /// **'Sil'**
  String get selectionModeDeleteTooltip;

  /// Not listesi seçim modunda seçili notları arşivleyen düğmenin ipucu metni
  ///
  /// In tr, this message translates to:
  /// **'Arşiv'**
  String get selectionModeArchiveTooltip;

  /// Not listesi seçim modunda seçili notları bir klasöre taşıma diyaloğunu açan düğmenin ipucu metni
  ///
  /// In tr, this message translates to:
  /// **'Klasör'**
  String get selectionModeFolderTooltip;

  /// Not listesi üst çubuğunda arama modu açıldığında arama kutusunda gösterilen ipucu (placeholder) metni
  ///
  /// In tr, this message translates to:
  /// **'Notlarda ara...'**
  String get searchFieldHint;

  /// Çöp ekranındaki '...' menüsünde çöpü boşaltma seçeneğinin etiketi ve tıklanınca açılan onay diyaloğunun başlığı (aynı metin her iki yerde de kullanılır)
  ///
  /// In tr, this message translates to:
  /// **'Çöpü Boşalt'**
  String get emptyTrashDialogTitle;

  /// Çöpü boşaltma onay diyaloğunda gösterilen uyarı/açıklama metni
  ///
  /// In tr, this message translates to:
  /// **'Tüm silinen notlar kalıcı olarak silinecek. Emin misiniz?'**
  String get emptyTrashDialogConfirmMessage;

  /// Çöpü boşaltma onay diyaloğunda işlemi iptal edip diyaloğu kapatan düğme
  ///
  /// In tr, this message translates to:
  /// **'İptal'**
  String get emptyTrashDialogCancelButton;

  /// Çöp ekranındaki '...' menüsünde çöpteki tüm notları geri yükleme seçeneğinin etiketi
  ///
  /// In tr, this message translates to:
  /// **'Hepsini Geri Yükle'**
  String get restoreAllMenuItemLabel;

  /// Not listesi üst çubuğunda sıralama menüsünü açan düğmenin ipucu metni
  ///
  /// In tr, this message translates to:
  /// **'Notları Sırala'**
  String get sortMenuTooltip;

  /// Sıralama menüsünde notları artan (A-Z) düzende sıralama seçeneği
  ///
  /// In tr, this message translates to:
  /// **'Düzen: Artan (A-Z)'**
  String get sortMenuAscendingLabel;

  /// Sıralama menüsünde notları azalan (Z-A) düzende sıralama seçeneği
  ///
  /// In tr, this message translates to:
  /// **'Düzen: Azalan (Z-A)'**
  String get sortMenuDescendingLabel;

  /// Sıralama menüsünde notları başlığa göre sıralama ölçütü seçeneği
  ///
  /// In tr, this message translates to:
  /// **'Sırala: Başlık'**
  String get sortMenuByTitleLabel;

  /// Sıralama menüsünde notları son düzenleme tarihine göre sıralama ölçütü seçeneği
  ///
  /// In tr, this message translates to:
  /// **'Sırala: Son Düzenleme'**
  String get sortMenuByModifiedDateLabel;

  /// Sıralama menüsünde notları oluşturulma tarihine göre sıralama ölçütü seçeneği
  ///
  /// In tr, this message translates to:
  /// **'Sırala: Oluşturulma'**
  String get sortMenuByCreatedDateLabel;

  /// Sıralama menüsünde notları klasöre (kategoriye) göre sıralama ölçütü seçeneği
  ///
  /// In tr, this message translates to:
  /// **'Sırala: Klasör'**
  String get sortMenuByFolderLabel;

  /// Liste görünümündeyken ızgara görünümüne geçiş düğmesinin ipucu metni (o an liste görünümü aktifken gösterilir)
  ///
  /// In tr, this message translates to:
  /// **'Izgara Görünümü'**
  String get viewToggleGridTooltip;

  /// Izgara görünümündeyken liste görünümüne geçiş düğmesinin ipucu metni (o an ızgara görünümü aktifken gösterilir)
  ///
  /// In tr, this message translates to:
  /// **'Liste Görünümü'**
  String get viewToggleListTooltip;

  /// Çekmece (drawer) menüsünün üst başlık alanında uygulama adının altında gösterilen alt başlık metni
  ///
  /// In tr, this message translates to:
  /// **'Kişisel Not Defteriniz'**
  String get drawerHeaderSubtitle;

  /// Çekmece menüsünde Notlar/Favori/Gündem/Hatırlatıcı/Kilitli/Arşiv/Çöp satırlarının üstünde yer alan bölüm başlığı
  ///
  /// In tr, this message translates to:
  /// **'NOTLAR'**
  String get drawerNotesSectionHeader;

  /// Çekmece menüsünde tüm notları gösteren satırın etiketi
  ///
  /// In tr, this message translates to:
  /// **'Notlar'**
  String get drawerAllNotesLabel;

  /// Çekmece menüsünde favori notları gösteren satırın etiketi
  ///
  /// In tr, this message translates to:
  /// **'Favori'**
  String get drawerFavoritesLabel;

  /// Çekmece menüsünde Gündem ekranını açan satırın etiketi
  ///
  /// In tr, this message translates to:
  /// **'Ajanda'**
  String get drawerAgendaLabel;

  /// Çekmece menüsünde hatırlatıcılı notları gösteren satırın etiketi
  ///
  /// In tr, this message translates to:
  /// **'Hatırlatıcı'**
  String get drawerRemindersLabel;

  /// Çekmece menüsünde kilitli notları gösteren satırın etiketi
  ///
  /// In tr, this message translates to:
  /// **'Kilitli'**
  String get drawerLockedLabel;

  /// Çekmece menüsünde çöp (silinen notlar) ekranını gösteren satırın etiketi
  ///
  /// In tr, this message translates to:
  /// **'Çöp'**
  String get drawerTrashLabel;

  /// Çekmece menüsünde klasör listesinin üstünde yer alan bölüm başlığı
  ///
  /// In tr, this message translates to:
  /// **'KLASÖRLER'**
  String get drawerFoldersSectionHeader;

  /// Çekmece menüsünde tüm alt klasörleri daraltılmışken hepsini birden açan düğmenin etiketi
  ///
  /// In tr, this message translates to:
  /// **'Genişlet'**
  String get drawerExpandLabel;

  /// Çekmece menüsünde alt klasörü olan kategorilerin en az biri açıkken hepsini birden kapatan düğmenin etiketi
  ///
  /// In tr, this message translates to:
  /// **'Daralt'**
  String get drawerCollapseLabel;

  /// Çekmece menüsünde klasör listesinin altında yeni klasör ekleme diyaloğunu açan satırın etiketi
  ///
  /// In tr, this message translates to:
  /// **'Klasör Ekle'**
  String get drawerAddFolderLabel;

  /// Çekmece menüsünde Takvim/Ayarlar/Yedekle/Pro/Destek/Geri Bildirim/Hakkında satırlarının üstünde yer alan bölüm başlığı
  ///
  /// In tr, this message translates to:
  /// **'UYGULAMA'**
  String get drawerAppSectionHeader;

  /// Çekmece menüsünde Takvim ekranını açan satırın etiketi
  ///
  /// In tr, this message translates to:
  /// **'Takvim'**
  String get drawerCalendarLabel;

  /// Çekmece menüsünde Ayarlar ekranını açan satırın etiketi
  ///
  /// In tr, this message translates to:
  /// **'Ayarlar'**
  String get drawerSettingsLabel;

  /// Çekmece menüsünde yedekleme/geri yükleme ekranını açan satırın etiketi
  ///
  /// In tr, this message translates to:
  /// **'Yedekle & Geri Yükle'**
  String get drawerBackupRestoreLabel;

  /// Çekmece menüsünde Pro sürümüne yükseltme satırının etiketi
  ///
  /// In tr, this message translates to:
  /// **'Pro\'ya Yükselt'**
  String get drawerUpgradeToProLabel;

  /// Çekmece menüsünde Pro'ya Yükselt satırının yanında gösterilen küçük PRO rozeti metni
  ///
  /// In tr, this message translates to:
  /// **'PRO'**
  String get drawerProBadgeLabel;

  /// Çekmece menüsünde geliştiriciye destek olma satırının etiketi
  ///
  /// In tr, this message translates to:
  /// **'Geliştirme Desteği'**
  String get drawerSupportDevelopmentLabel;

  /// Çekmece menüsünde geri bildirim gönderme satırının etiketi
  ///
  /// In tr, this message translates to:
  /// **'Geri Bildirim'**
  String get drawerFeedbackLabel;

  /// Çekmece menüsünde uygulama hakkında bilgi ekranını açan satırın etiketi
  ///
  /// In tr, this message translates to:
  /// **'Hakkında'**
  String get drawerAboutLabel;

  /// Not listesi (arama sonucu dahil) boş olduğunda listenin ortasında gösterilen mesaj
  ///
  /// In tr, this message translates to:
  /// **'Not bulunamadı.'**
  String get noNotesFoundMessage;

  /// Çöp ekranında bir nota basılı tutulunca açılan alt menüde notu geri yükleme düğmesinin etiketi (liste ve ızgara görünümünde ortak)
  ///
  /// In tr, this message translates to:
  /// **'Geri Yükle'**
  String get trashRestoreButtonLabel;

  /// Çöp ekranında bir nota basılı tutulunca açılan alt menüde notu kalıcı olarak silme düğmesinin etiketi (liste ve ızgara görünümünde ortak)
  ///
  /// In tr, this message translates to:
  /// **'Kalıcı Sil'**
  String get trashPermanentDeleteButtonLabel;

  /// Bir etiket yeniden adlandırıldığında gösterilen bilgi çubuğu mesajı
  ///
  /// In tr, this message translates to:
  /// **'Etiket yeniden adlandırıldı'**
  String get tagRenamedInfoMessage;

  /// Bir etiket silindiğinde gösterilen bilgi çubuğu mesajı
  ///
  /// In tr, this message translates to:
  /// **'Etiket silindi'**
  String get tagDeletedInfoMessage;

  /// Etikete basılı tutunca açılan seçenek sheet'indeki yeniden adlandırma öğesi
  ///
  /// In tr, this message translates to:
  /// **'Yeniden Adlandır'**
  String get tagOptionsRenameLabel;

  /// Etikete basılı tutunca açılan seçenek sheet'indeki silme öğesi
  ///
  /// In tr, this message translates to:
  /// **'Sil'**
  String get tagOptionsDeleteLabel;

  /// Etiket yeniden adlandırma diyaloğunun başlığı
  ///
  /// In tr, this message translates to:
  /// **'Etiketi Yeniden Adlandır'**
  String get renameTagDialogTitle;

  /// Etiket yeniden adlandırma diyaloğundaki metin alanının hint'i
  ///
  /// In tr, this message translates to:
  /// **'Yeni etiket adı'**
  String get renameTagDialogHint;

  /// Etiket yeniden adlandırma diyaloğunu kapatıp işlemi iptal eden düğme
  ///
  /// In tr, this message translates to:
  /// **'İptal'**
  String get renameTagDialogCancelButton;

  /// Etiket yeniden adlandırma diyaloğunda yeni adı kaydeden düğme
  ///
  /// In tr, this message translates to:
  /// **'Kaydet'**
  String get renameTagDialogSaveButton;

  /// Etiket silme onay diyaloğunda, etiket en az bir notta kullanılıyorsa gösterilen mesaj
  ///
  /// In tr, this message translates to:
  /// **'\"{tag}\" etiketi {affectedCount} nottan kaldırılacak. Devam edilsin mi?'**
  String deleteTagDialogMessageWithCount(String tag, int affectedCount);

  /// Etiket silme onay diyaloğunda, etiket hiçbir notta kullanılmıyorsa gösterilen mesaj
  ///
  /// In tr, this message translates to:
  /// **'\"{tag}\" etiketi silinsin mi?'**
  String deleteTagDialogMessage(String tag);

  /// Etiket silme onay diyaloğunun başlığı
  ///
  /// In tr, this message translates to:
  /// **'Etiketi Sil'**
  String get deleteTagDialogTitle;

  /// Etiket silme onay diyaloğunu kapatıp işlemi iptal eden düğme
  ///
  /// In tr, this message translates to:
  /// **'İptal'**
  String get deleteTagDialogCancelButton;

  /// Etiket silme onay diyaloğunda silme işlemini onaylayan düğme
  ///
  /// In tr, this message translates to:
  /// **'Sil'**
  String get deleteTagDialogConfirmButton;

  /// Not diyaloğundaki üç nokta menüsünden açılan etiketler sheet'inin başlığı
  ///
  /// In tr, this message translates to:
  /// **'Etiketler'**
  String get tagsSheetTitle;

  /// Etiketler sheet'inde, notta hiç etiket yokken gösterilen boş durum metni
  ///
  /// In tr, this message translates to:
  /// **'Bu notta henüz etiket yok.'**
  String get tagsSheetEmptyMessage;

  /// Etiketler sheet'indeki yeni etiket ekleme alanının hint'i
  ///
  /// In tr, this message translates to:
  /// **'Yeni etiket yaz...'**
  String get tagsSheetInputHint;

  /// Etiketler sheet'inde, girilen metinle eşleşen mevcut etiket önerilerinin üstündeki başlık
  ///
  /// In tr, this message translates to:
  /// **'Mevcut etiketler'**
  String get tagsSheetSuggestionsLabel;

  /// Bir not silindiğinde (çöp kutusuna taşındığında) gösterilen bilgi çubuğu mesajı
  ///
  /// In tr, this message translates to:
  /// **'Not silindi'**
  String get noteDeletedInfoMessage;

  /// Not silindi bilgi çubuğunda, silme işlemini geri alan eylem düğmesinin etiketi
  ///
  /// In tr, this message translates to:
  /// **'Geri Getir'**
  String get noteDeletedUndoActionLabel;

  /// Not listesinden (düzenleyici açılmadan) uzun basma menüsüyle bir nota hatırlatıcı ayarlandığında gösterilen bilgi çubuğu mesajı
  ///
  /// In tr, this message translates to:
  /// **'Hatırlatıcı ayarlandı'**
  String get reminderSetInfoMessage;

  /// Not listesinden (düzenleyici açılmadan) uzun basma menüsüyle bir notun hatırlatıcısı kaldırıldığında gösterilen bilgi çubuğu mesajı
  ///
  /// In tr, this message translates to:
  /// **'Hatırlatıcı kaldırıldı'**
  String get reminderRemovedInfoMessage;

  /// Bir notun kopyası oluşturulduğunda gösterilen bilgi çubuğu mesajı
  ///
  /// In tr, this message translates to:
  /// **'Kopya oluşturuldu'**
  String get noteDuplicatedInfoMessage;

  /// Not düzenleyicisi kapalıyken (kart üzerinde uzun basarak) sesli çevrilen metin notun sonuna eklendiğinde gösterilen bilgi çubuğu mesajı
  ///
  /// In tr, this message translates to:
  /// **'Metin nota eklendi'**
  String get speechTextAppendedInfoMessage;

  /// Not PDF olarak dışa aktarılırken, dosya hazırlanırken gösterilen bilgi çubuğu mesajı
  ///
  /// In tr, this message translates to:
  /// **'PDF hazırlanıyor…'**
  String get pdfPreparingInfoMessage;

  /// Not PDF olarak başarıyla kaydedildiğinde gösterilen bilgi çubuğu mesajı
  ///
  /// In tr, this message translates to:
  /// **'PDF kaydedildi'**
  String get pdfSavedInfoMessage;

  /// Not JPG olarak dışa aktarılırken, görsel hazırlanırken gösterilen bilgi çubuğu mesajı
  ///
  /// In tr, this message translates to:
  /// **'JPG hazırlanıyor…'**
  String get jpgPreparingInfoMessage;

  /// Not JPG olarak başarıyla kaydedildiğinde gösterilen bilgi çubuğu mesajı
  ///
  /// In tr, this message translates to:
  /// **'JPG kaydedildi'**
  String get jpgSavedInfoMessage;

  /// Not JPG'e dönüştürülürken bir hata oluştuğunda gösterilen bilgi çubuğu mesajı
  ///
  /// In tr, this message translates to:
  /// **'JPG oluşturulamadı'**
  String get jpgFailedInfoMessage;

  /// Not TXT olarak dışa aktarılırken, dosya hazırlanırken gösterilen bilgi çubuğu mesajı
  ///
  /// In tr, this message translates to:
  /// **'TXT hazırlanıyor…'**
  String get txtPreparingInfoMessage;

  /// Not TXT olarak başarıyla kaydedildiğinde gösterilen bilgi çubuğu mesajı
  ///
  /// In tr, this message translates to:
  /// **'TXT kaydedildi'**
  String get txtSavedInfoMessage;

  /// Not TXT'e dönüştürülürken bir hata oluştuğunda gösterilen bilgi çubuğu mesajı
  ///
  /// In tr, this message translates to:
  /// **'TXT oluşturulamadı'**
  String get txtFailedInfoMessage;

  /// PDF/JPG/TXT dışa aktarma bilgi çubuğunda, kaydedilen dosyayı doğrudan açan eylem düğmesinin etiketi (üç dışa aktarma biçiminde de ortak kullanılır)
  ///
  /// In tr, this message translates to:
  /// **'Aç'**
  String get exportOpenActionLabel;

  /// Kilitli klasöre girerken yanlış parola girildiğinde gösterilen bilgi çubuğu mesajı
  ///
  /// In tr, this message translates to:
  /// **'Parola yanlış.'**
  String get wrongPasswordInfoMessage;

  /// Bir not arşive taşındığında gösterilen bilgi çubuğu mesajı
  ///
  /// In tr, this message translates to:
  /// **'Not arşivlendi'**
  String get noteArchivedInfoMessage;

  /// Bir not arşivden çıkarıldığında gösterilen bilgi çubuğu mesajı
  ///
  /// In tr, this message translates to:
  /// **'Arşivden çıkarıldı'**
  String get noteUnarchivedInfoMessage;

  /// Bir notun kilidi kaldırıldığında gösterilen bilgi çubuğu mesajı
  ///
  /// In tr, this message translates to:
  /// **'Kilidi kaldırıldı'**
  String get noteUnlockedInfoMessage;

  /// Bir not kilitlendiğinde gösterilen bilgi çubuğu mesajı
  ///
  /// In tr, this message translates to:
  /// **'Not kilitlendi'**
  String get noteLockedInfoMessage;

  /// Bir notun bildirim panelindeki sabitlemesi kaldırıldığında gösterilen bilgi çubuğu mesajı
  ///
  /// In tr, this message translates to:
  /// **'Sabitleme kaldırıldı'**
  String get notificationUnpinnedInfoMessage;

  /// Başlığı ve içeriği boş bir not bildirim paneline sabitlenmeye çalışıldığında gösterilen uyarı mesajı
  ///
  /// In tr, this message translates to:
  /// **'Boş not sabitlenemez.'**
  String get emptyNotePinBlockedInfoMessage;

  /// Bir not bildirim paneline sabitlendiğinde gösterilen bilgi çubuğu mesajı
  ///
  /// In tr, this message translates to:
  /// **'Bildirim paneline sabitlendi'**
  String get notificationPinnedInfoMessage;

  /// Başlığı ve içeriği boş bir not için Yüksek Sesle Oku eylemi seçildiğinde gösterilen bilgi çubuğu mesajı
  ///
  /// In tr, this message translates to:
  /// **'Okunacak bir içerik yok'**
  String get noContentToReadInfoMessage;

  /// Ana ekranda geri tuşuna ilk kez basıldığında, uygulamadan çıkmak için tekrar basılması gerektiğini bildiren bilgi çubuğu mesajı
  ///
  /// In tr, this message translates to:
  /// **'Çıkmak için tekrar geri tuşuna basın'**
  String get backPressExitInfoMessage;

  /// Android bildirim kanalı adı — not hatırlatıcı bildirimleri için (sistem ayarlarında görünür)
  ///
  /// In tr, this message translates to:
  /// **'Not Hatırlatıcıları'**
  String get reminderChannelName;

  /// Android bildirim kanalı açıklaması — not hatırlatıcı bildirimleri için (sistem ayarlarında görünür)
  ///
  /// In tr, this message translates to:
  /// **'Layout uygulamasındaki not hatırlatıcıları'**
  String get reminderChannelDescription;

  /// Android bildirim kanalı adı — bildirim paneline sabitlenmiş notlar için (sistem ayarlarında görünür)
  ///
  /// In tr, this message translates to:
  /// **'Sabitlenmiş Notlar'**
  String get pinnedChannelName;

  /// Android bildirim kanalı açıklaması — bildirim paneline sabitlenmiş notlar için (sistem ayarlarında görünür)
  ///
  /// In tr, this message translates to:
  /// **'Bildirim paneline sabitlenen Layout notları'**
  String get pinnedChannelDescription;

  /// Bildirim paneline sabitlenmiş bir notun bildirimindeki aksiyon butonunun etiketi; dokunulduğunda sabitleme kaldırılır
  ///
  /// In tr, this message translates to:
  /// **'Kaldır'**
  String get notificationUnpinActionLabel;

  /// Notun başlığı boşsa, hatırlatıcı bildiriminde başlık yerine kullanılan varsayılan metin
  ///
  /// In tr, this message translates to:
  /// **'Hatırlatıcı'**
  String get reminderDefaultTitle;

  /// Kontrol listesi tipindeki bir notun hatırlatıcı bildiriminde gösterilen sabit gövde metni
  ///
  /// In tr, this message translates to:
  /// **'Kontrol listeni kontrol etmeyi unutma'**
  String get reminderChecklistBodyFallback;

  /// Metin tipindeki bir notun içeriği boşsa, hatırlatıcı bildiriminde gövde yerine kullanılan varsayılan metin
  ///
  /// In tr, this message translates to:
  /// **'Notunu kontrol etmeyi unutma'**
  String get reminderTextBodyFallback;

  /// Not PDF'e dönüştürüldükten sonra, kayıt konumunu seçmek için açılan native (sistem) dosya kaydetme diyaloğunun başlığı
  ///
  /// In tr, this message translates to:
  /// **'PDF olarak kaydet'**
  String get pdfSaveDialogTitle;

  /// Not JPG'e dönüştürüldükten sonra, kayıt konumunu seçmek için açılan native (sistem) dosya kaydetme diyaloğunun başlığı
  ///
  /// In tr, this message translates to:
  /// **'JPG olarak kaydet'**
  String get jpgSaveDialogTitle;

  /// Not TXT'e dönüştürüldükten sonra, kayıt konumunu seçmek için açılan native (sistem) dosya kaydetme diyaloğunun başlığı
  ///
  /// In tr, this message translates to:
  /// **'TXT olarak kaydet'**
  String get txtSaveDialogTitle;

  /// Not için yazı boyutu ayarlama alt menüsünün (bottom sheet) başlığı
  ///
  /// In tr, this message translates to:
  /// **'Metin Boyutu'**
  String get textSizeSheetTitle;

  /// Yazı boyutu alt menüsünde, kaydırıcıyla seçilen boyutu önizlemek için gösterilen örnek metin
  ///
  /// In tr, this message translates to:
  /// **'Örnek metin'**
  String get textSizeSamplePreview;

  /// Yazı boyutu alt menüsünde, değişikliği uygulamadan menüyü kapatan düğme
  ///
  /// In tr, this message translates to:
  /// **'İptal'**
  String get textSizeCancelButton;

  /// Yazı boyutu alt menüsünde, seçilen yazı boyutunu nota uygulayıp kaydeden düğme
  ///
  /// In tr, this message translates to:
  /// **'Uygula'**
  String get textSizeApplyButton;

  /// Not kilitleme için henüz parola belirlenmemişken açılan 'yeni parola oluştur' diyaloğunun başlığı
  ///
  /// In tr, this message translates to:
  /// **'Şifre Oluştur'**
  String get createPasswordDialogTitle;

  /// Şifre oluştur diyaloğunda yeni parolanın girildiği alanın hint metni
  ///
  /// In tr, this message translates to:
  /// **'Yeni şifre'**
  String get createPasswordNewPasswordHint;

  /// Şifre oluştur diyaloğunda parolanın doğrulama amacıyla tekrar girildiği alanın hint metni
  ///
  /// In tr, this message translates to:
  /// **'Şifreyi tekrar gir'**
  String get createPasswordConfirmHint;

  /// Şifre oluştur diyaloğunda güvenlik sorusu alanının üstünde gösterilen açıklama metni
  ///
  /// In tr, this message translates to:
  /// **'Şifrenizi unutursanız diye bir güvenlik sorusu belirleyin (zorunlu değildir).'**
  String get createPasswordHintQuestionDescription;

  /// Şifre oluştur diyaloğunda güvenlik sorusu seçimi için açılır menünün (dropdown) hint metni
  ///
  /// In tr, this message translates to:
  /// **'Güvenlik sorusu seçin'**
  String get createPasswordHintQuestionHint;

  /// Şifre oluştur diyaloğunda güvenlik sorusunun cevabının girildiği alanın hint metni
  ///
  /// In tr, this message translates to:
  /// **'Cevabınız'**
  String get createPasswordHintAnswerHint;

  /// Şifre oluştur diyaloğunu kapatıp işlemi iptal eden düğme
  ///
  /// In tr, this message translates to:
  /// **'İptal'**
  String get createPasswordCancelButton;

  /// Şifre oluştur diyaloğunda girilen parolayı ve güvenlik sorusunu kaydeden düğme
  ///
  /// In tr, this message translates to:
  /// **'Kaydet'**
  String get createPasswordSaveButton;

  /// Şifre oluştur diyaloğunda iki parola alanı birbiriyle eşleşmediğinde gösterilen snackbar mesajı
  ///
  /// In tr, this message translates to:
  /// **'Şifreler eşleşmiyor!'**
  String get passwordMismatchMessage;

  /// Kilitli bir not/klasör açılmaya çalışıldığında parola girişini isteyen diyaloğun başlığı
  ///
  /// In tr, this message translates to:
  /// **'Şifre Gerekiyor'**
  String get passwordRequiredDialogTitle;

  /// Parola doğrulama diyaloğunda parolanın girildiği alanın hint metni
  ///
  /// In tr, this message translates to:
  /// **'Şifreyi girin'**
  String get passwordRequiredHint;

  /// Parola doğrulama diyaloğunda, güvenlik sorusu akışını başlatan bağlantı tarzı düğme
  ///
  /// In tr, this message translates to:
  /// **'Şifremi unuttum'**
  String get forgotPasswordButtonLabel;

  /// Parola doğrulama diyaloğunu kapatıp işlemi iptal eden düğme
  ///
  /// In tr, this message translates to:
  /// **'İptal'**
  String get passwordRequiredCancelButton;

  /// Parola doğrulama diyaloğunda girilen parolayı kontrol eden düğme
  ///
  /// In tr, this message translates to:
  /// **'Doğrula'**
  String get passwordRequiredConfirmButton;

  /// 'Şifremi unuttum' akışında güvenlik sorusunun sorulduğu diyaloğun başlığı
  ///
  /// In tr, this message translates to:
  /// **'Güvenlik Sorusu'**
  String get securityQuestionDialogTitle;

  /// 'Şifremi unuttum' diyaloğunda güvenlik sorusu cevabının girildiği alanın hint metni
  ///
  /// In tr, this message translates to:
  /// **'Cevabınız'**
  String get securityQuestionAnswerHint;

  /// 'Şifremi unuttum' diyaloğunu kapatıp işlemi iptal eden düğme
  ///
  /// In tr, this message translates to:
  /// **'İptal'**
  String get securityQuestionCancelButton;

  /// 'Şifremi unuttum' diyaloğunda girilen cevabı kontrol eden düğme
  ///
  /// In tr, this message translates to:
  /// **'Onayla'**
  String get securityQuestionConfirmButton;

  /// 'Şifremi unuttum' diyaloğunda girilen güvenlik sorusu cevabı yanlış olduğunda alanın altında gösterilen hata metni
  ///
  /// In tr, this message translates to:
  /// **'Cevap yanlış. Tekrar deneyin.'**
  String get securityQuestionWrongAnswerMessage;

  /// Güvenlik sorusu doğrulandıktan sonra kayıtlı parolanın gösterildiği diyaloğun başlığı
  ///
  /// In tr, this message translates to:
  /// **'Şifreniz'**
  String get revealedPasswordDialogTitle;

  /// Şifre gösterme diyaloğunda gösterilen parolanın üstündeki açıklama etiketi
  ///
  /// In tr, this message translates to:
  /// **'Not şifreniz:'**
  String get revealedPasswordLabel;

  /// Şifre gösterme diyaloğunu kapatan düğme
  ///
  /// In tr, this message translates to:
  /// **'Tamam'**
  String get revealedPasswordOkButton;

  /// Sabit güvenlik sorusu listesindeki seçeneklerden biri (şifre oluştur / şifremi unuttum diyaloglarında kullanılır)
  ///
  /// In tr, this message translates to:
  /// **'İlk evcil hayvanınızın adı nedir?'**
  String get securityQuestionPetName;

  /// Sabit güvenlik sorusu listesindeki seçeneklerden biri (şifre oluştur / şifremi unuttum diyaloglarında kullanılır)
  ///
  /// In tr, this message translates to:
  /// **'En sevdiğiniz öğretmeninizin adı nedir?'**
  String get securityQuestionFavoriteTeacher;

  /// Sabit güvenlik sorusu listesindeki seçeneklerden biri (şifre oluştur / şifremi unuttum diyaloglarında kullanılır)
  ///
  /// In tr, this message translates to:
  /// **'Doğduğunuz şehir nedir?'**
  String get securityQuestionBirthCity;

  /// Sabit güvenlik sorusu listesindeki seçeneklerden biri (şifre oluştur / şifremi unuttum diyaloglarında kullanılır)
  ///
  /// In tr, this message translates to:
  /// **'En sevdiğiniz yemek nedir?'**
  String get securityQuestionFavoriteFood;

  /// Sabit güvenlik sorusu listesindeki seçeneklerden biri (şifre oluştur / şifremi unuttum diyaloglarında kullanılır)
  ///
  /// In tr, this message translates to:
  /// **'Annenizin kızlık soyadı nedir?'**
  String get securityQuestionMotherMaidenName;

  /// Sabit güvenlik sorusu listesindeki seçeneklerden biri (şifre oluştur / şifremi unuttum diyaloglarında kullanılır)
  ///
  /// In tr, this message translates to:
  /// **'İlk okuduğunuz okulun adı nedir?'**
  String get securityQuestionFirstSchool;

  /// Sabit güvenlik sorusu listesindeki seçeneklerden biri (şifre oluştur / şifremi unuttum diyaloglarında kullanılır)
  ///
  /// In tr, this message translates to:
  /// **'En sevdiğiniz renk nedir?'**
  String get securityQuestionFavoriteColor;

  /// Mevcut bir klasör/alt klasör düzenlenirken açılan diyaloğun başlığı
  ///
  /// In tr, this message translates to:
  /// **'Klasörü Düzenle'**
  String get editFolderDialogTitle;

  /// Bir üst klasörün altına yeni alt klasör eklenirken açılan diyaloğun başlığı
  ///
  /// In tr, this message translates to:
  /// **'Yeni Alt Klasör'**
  String get newSubfolderDialogTitle;

  /// Yeni bir üst düzey klasör eklenirken açılan diyaloğun başlığı
  ///
  /// In tr, this message translates to:
  /// **'Klasör Ekle'**
  String get addFolderDialogTitle;

  /// Yeni alt klasör diyaloğunda, alt klasörün hangi üst klasörün içinde oluşturulacağını belirten bilgi metni
  ///
  /// In tr, this message translates to:
  /// **'\"{parentCategory}\" içinde oluşturulacak'**
  String subfolderParentInfoMessage(String parentCategory);

  /// Alt klasör diyaloğunda klasör adının girildiği alanın etiketi
  ///
  /// In tr, this message translates to:
  /// **'Alt klasör adı'**
  String get subfolderNameFieldLabel;

  /// Üst düzey klasör diyaloğunda klasör adının girildiği alanın etiketi
  ///
  /// In tr, this message translates to:
  /// **'Klasör adı'**
  String get folderNameFieldLabel;

  /// Klasör ekle/düzenle diyaloğunda renk paletinin üstünde gösterilen etiket
  ///
  /// In tr, this message translates to:
  /// **'Renk'**
  String get folderColorLabel;

  /// Klasör ekle/düzenle diyaloğunu kapatıp işlemi iptal eden düğme
  ///
  /// In tr, this message translates to:
  /// **'İptal'**
  String get folderDialogCancelButton;

  /// Klasör düzenleme modunda, yapılan değişiklikleri kaydeden düğme
  ///
  /// In tr, this message translates to:
  /// **'Kaydet'**
  String get folderDialogSaveButton;

  /// Yeni klasör/alt klasör ekleme modunda, klasörü oluşturan düğme
  ///
  /// In tr, this message translates to:
  /// **'Ekle'**
  String get folderDialogAddButton;

  /// Bir notu bir klasöre atamak için açılan alt menünün (bottom sheet) başlığı
  ///
  /// In tr, this message translates to:
  /// **'Klasör Seç'**
  String get selectFolderSheetTitle;

  /// Klasör seç alt menüsünde, yeni klasör oluşturma diyaloğunu açan liste öğesinin etiketi
  ///
  /// In tr, this message translates to:
  /// **'Klasör Ekle'**
  String get selectFolderAddOptionLabel;

  /// Klasör seç alt menüsünde, notun mevcut klasör atamasını kaldıran (klasörsüz bırakan) liste öğesinin etiketi
  ///
  /// In tr, this message translates to:
  /// **'Mevcut Klasörü Kaldır'**
  String get removeCurrentFolderLabel;

  /// Bir notun oluşturulma/düzenlenme tarihi, karakter ve kelime sayısını gösteren ayrıntılar diyaloğunun başlığı
  ///
  /// In tr, this message translates to:
  /// **'Ayrıntılar'**
  String get noteDetailsDialogTitle;

  /// Not ayrıntıları diyaloğunda oluşturulma tarihi satırının etiketi
  ///
  /// In tr, this message translates to:
  /// **'Oluşturulma'**
  String get noteDetailsCreatedLabel;

  /// Not ayrıntıları diyaloğunda son düzenlenme tarihi satırının etiketi
  ///
  /// In tr, this message translates to:
  /// **'Son Düzenleme'**
  String get noteDetailsModifiedLabel;

  /// Not ayrıntıları diyaloğunda karakter sayısı satırının etiketi
  ///
  /// In tr, this message translates to:
  /// **'Karakter Sayısı'**
  String get noteDetailsCharCountLabel;

  /// Not ayrıntıları diyaloğunda karakter sayısı satırının değeri
  ///
  /// In tr, this message translates to:
  /// **'{count} karakter'**
  String noteDetailsCharCountValue(int count);

  /// Not ayrıntıları diyaloğunda kelime sayısı satırının etiketi
  ///
  /// In tr, this message translates to:
  /// **'Kelime Sayısı'**
  String get noteDetailsWordCountLabel;

  /// Not ayrıntıları diyaloğunda kelime sayısı satırının değeri
  ///
  /// In tr, this message translates to:
  /// **'{count} kelime'**
  String noteDetailsWordCountValue(int count);

  /// Not ayrıntıları diyaloğunu kapatan düğme
  ///
  /// In tr, this message translates to:
  /// **'Tamam'**
  String get noteDetailsOkButton;

  /// Not ayrıntıları diyaloğunda oluşturulma/düzenlenme tarihi kayıtlı değilse gösterilen yer tutucu metin
  ///
  /// In tr, this message translates to:
  /// **'Bilinmiyor'**
  String get noteDetailsUnknownDateLabel;

  /// Not düzenleyicisinde '+' butonuna basınca açılan ek ekleme alt menüsünün başlığı
  ///
  /// In tr, this message translates to:
  /// **'Ekle'**
  String get addAttachmentSheetTitle;

  /// Ek ekleme alt menüsünde galeriden görsel seçme seçeneğinin etiketi
  ///
  /// In tr, this message translates to:
  /// **'Görsel Ekle'**
  String get addAttachmentImageOption;

  /// Ek ekleme alt menüsünde kamerayla fotoğraf çekme seçeneğinin etiketi
  ///
  /// In tr, this message translates to:
  /// **'Kamera'**
  String get addAttachmentCameraOption;

  /// Ek ekleme alt menüsünde cihazdan dosya seçme seçeneğinin etiketi
  ///
  /// In tr, this message translates to:
  /// **'Dosya Ekle'**
  String get addAttachmentFileOption;

  /// Ek ekleme alt menüsünde ses kaydı başlatma seçeneğinin etiketi
  ///
  /// In tr, this message translates to:
  /// **'Ses Kaydı'**
  String get addAttachmentVoiceOption;

  /// Ek ekleme alt menüsünde kamerayla video çekme seçeneğinin etiketi
  ///
  /// In tr, this message translates to:
  /// **'Video Çek'**
  String get addAttachmentVideoOption;

  /// Ek ekleme alt menüsünde belge tarama (doküman scanner) seçeneğinin etiketi
  ///
  /// In tr, this message translates to:
  /// **'Belge Tara'**
  String get addAttachmentScanOption;

  /// Bir not üzerindeki tüm eylemleri (arşivle, kilitle, sil, paylaş vb.) listeleyen büyük aksiyon panelinin başlığı
  ///
  /// In tr, this message translates to:
  /// **'Eylem Seç'**
  String get noteActionsSheetTitle;

  /// Eylem panelinde, notta henüz hatırlatıcı yokken gösterilen 'Hatırlatıcı ekle' eyleminin etiketi
  ///
  /// In tr, this message translates to:
  /// **'Hatırlatıcı'**
  String get noteActionReminderLabel;

  /// Eylem panelinde, notta zaten bir hatırlatıcı varken gösterilen eylemin etiketi
  ///
  /// In tr, this message translates to:
  /// **'Hatırlatıcıyı Düzenle'**
  String get noteActionEditReminderLabel;

  /// Eylem panelinde, konuşmayı metne çeviren eylemin etiketi
  ///
  /// In tr, this message translates to:
  /// **'Sesi Yazıya Çevir'**
  String get noteActionSpeechToTextLabel;

  /// Eylem panelinde, notu arşivleyen eylemin etiketi (not henüz arşivde değilken)
  ///
  /// In tr, this message translates to:
  /// **'Arşiv'**
  String get noteActionArchiveLabel;

  /// Eylem panelinde, arşivdeki notu arşivden çıkaran eylemin etiketi
  ///
  /// In tr, this message translates to:
  /// **'Arşivden Çıkar'**
  String get noteActionUnarchiveLabel;

  /// Eylem panelinde, notu parolayla kilitleyen eylemin etiketi (not henüz kilitli değilken)
  ///
  /// In tr, this message translates to:
  /// **'Kilitle'**
  String get noteActionLockLabel;

  /// Eylem panelinde, kilitli notun kilidini kaldıran eylemin etiketi
  ///
  /// In tr, this message translates to:
  /// **'Kilidi Kaldır'**
  String get noteActionUnlockLabel;

  /// Eylem panelinde, notu favorilere ekleyen eylemin etiketi (not henüz favori değilken)
  ///
  /// In tr, this message translates to:
  /// **'Favori'**
  String get noteActionFavoriteLabel;

  /// Eylem panelinde, favorideki notu favorilerden çıkaran eylemin etiketi
  ///
  /// In tr, this message translates to:
  /// **'Favoriden Çıkar'**
  String get noteActionUnfavoriteLabel;

  /// Eylem panelinde, notun klasörünü değiştiren eylemin etiketi
  ///
  /// In tr, this message translates to:
  /// **'Klasör Seç'**
  String get noteActionClassifyLabel;

  /// Eylem panelinde, notu çöp kutusuna taşıyan eylemin etiketi
  ///
  /// In tr, this message translates to:
  /// **'Sil'**
  String get noteActionDeleteLabel;

  /// Eylem panelinde, notu bildirim paneline sabitleyen eylemin etiketi (not henüz sabitlenmemişken)
  ///
  /// In tr, this message translates to:
  /// **'Bildirim Paneline Sabitle'**
  String get noteActionPinToNotificationLabel;

  /// Eylem panelinde, bildirim panelindeki notun sabitlemesini kaldıran eylemin etiketi
  ///
  /// In tr, this message translates to:
  /// **'Sabitlemeyi Kaldır'**
  String get noteActionUnpinFromNotificationLabel;

  /// Eylem panelinde, notu sistem paylaşım menüsüyle paylaşan eylemin etiketi
  ///
  /// In tr, this message translates to:
  /// **'Paylaş'**
  String get noteActionShareLabel;

  /// Eylem panelinde, notun bir kopyasını oluşturan eylemin etiketi
  ///
  /// In tr, this message translates to:
  /// **'Kopya Oluştur'**
  String get noteActionDuplicateLabel;

  /// Eylem panelinde, not içeriğini panoya kopyalayan eylemin etiketi
  ///
  /// In tr, this message translates to:
  /// **'İçeriği Kopyala'**
  String get noteActionCopyContentLabel;

  /// Eylem panelinde, not içeriğini sesli okuyan (text-to-speech) eylemin etiketi
  ///
  /// In tr, this message translates to:
  /// **'Yüksek Sesle Oku'**
  String get noteActionTtsLabel;

  /// Eylem panelinde, yazı boyutu ayarlama alt menüsünü açan eylemin etiketi
  ///
  /// In tr, this message translates to:
  /// **'Metin Boyutu'**
  String get noteActionTextSizeLabel;

  /// Eylem panelinde, not ayrıntıları diyaloğunu açan eylemin etiketi
  ///
  /// In tr, this message translates to:
  /// **'Ayrıntılar'**
  String get noteActionDetailsLabel;

  /// Eylem panelinde, yalnızca not düzenleyicisinden çağrıldığında gösterilen, kaydedilmemiş değişiklikleri yok sayıp düzenleyiciyi kapatan eylemin etiketi
  ///
  /// In tr, this message translates to:
  /// **'Değişiklikleri Yok Say'**
  String get noteActionDiscardChangesLabel;

  /// Eylem panelinde, yalnızca not listesinden uzun basmayla çağrıldığında gösterilen, çoklu seçim modunu açan eylemin etiketi
  ///
  /// In tr, this message translates to:
  /// **'Seç'**
  String get noteActionSelectLabel;

  /// Notta zaten hatırlatıcı varken 'Hatırlatıcıyı Düzenle' eylemine basılınca açılan alt seçim sheet'indeki 'düzenle' seçeneğinin etiketi
  ///
  /// In tr, this message translates to:
  /// **'Hatırlatıcıyı değiştir'**
  String get reminderEditOptionLabel;

  /// Notta zaten hatırlatıcı varken 'Hatırlatıcıyı Düzenle' eylemine basılınca açılan alt seçim sheet'indeki 'kaldır' seçeneğinin etiketi
  ///
  /// In tr, this message translates to:
  /// **'Hatırlatıcıyı kaldır'**
  String get reminderRemoveOptionLabel;

  /// Not düzenleyicisinde kaydedilmemiş değişiklikleri yok sayma onay diyaloğunun başlığı
  ///
  /// In tr, this message translates to:
  /// **'Değişiklikleri Yok Say'**
  String get discardChangesDialogTitle;

  /// Değişiklikleri yok sayma onay diyaloğunun içerik metni
  ///
  /// In tr, this message translates to:
  /// **'Bu nottaki kaydedilmemiş değişiklikler kaybolacak. Yok saymak istediğinize emin misiniz?'**
  String get discardChangesDialogMessage;

  /// Değişiklikleri yok sayma onay diyaloğunda işlemi iptal edip düzenleyicide kalmayı sağlayan düğme
  ///
  /// In tr, this message translates to:
  /// **'Vazgeç'**
  String get discardChangesCancelButton;

  /// Değişiklikleri yok sayma onay diyaloğunda kaydedilmemiş değişiklikleri onaylayarak yok sayan düğme
  ///
  /// In tr, this message translates to:
  /// **'Yok Say'**
  String get discardChangesConfirmButton;

  /// Bir not bildirim paneline sabitlenirken, notun başlığı boşsa bildirimde kullanılan varsayılan başlık
  ///
  /// In tr, this message translates to:
  /// **'Not'**
  String get pinnedNotificationDefaultTitle;

  /// Not PDF'e dönüştürülürken bir hata oluştuğunda gösterilen bilgi çubuğu mesajı
  ///
  /// In tr, this message translates to:
  /// **'PDF oluşturulamadı'**
  String get pdfFailedInfoMessage;

  /// Tam ekran çizim sayfasının AppBar başlığı; çizim tek başına PDF/JPG olarak dışa aktarılırken not başlığı olarak da kullanılır
  ///
  /// In tr, this message translates to:
  /// **'Çizim'**
  String get drawingScreenTitle;

  /// Tam ekran çizim sayfasında, gömülü önizlemeye geri dönen (sayfayı kapatan) düğmenin ipucu metni
  ///
  /// In tr, this message translates to:
  /// **'Küçült'**
  String get drawingMinimizeTooltip;

  /// Çizim tuvali boşken dışa aktar menüsüne basılırsa gösterilen bilgi çubuğu mesajı
  ///
  /// In tr, this message translates to:
  /// **'Önce bir çizim yapın'**
  String get drawingEmptyExportWarningMessage;

  /// Silgi aracı seçiliyken görünen mod anahtarında, silginin yalnızca dokunulan noktaları kaldırdığı (piksel bazlı) modun etiketi
  ///
  /// In tr, this message translates to:
  /// **'Kısmi'**
  String get drawingEraserPartialModeLabel;

  /// Silgi aracı seçiliyken görünen mod anahtarında, silginin dokunulan stroke'un tamamını sildiği modun etiketi
  ///
  /// In tr, this message translates to:
  /// **'Tam'**
  String get drawingEraserFullModeLabel;

  /// Çizim araç çubuğunda, tuvaldeki tüm stroke'ları silen düğmenin ipucu metni
  ///
  /// In tr, this message translates to:
  /// **'Temizle'**
  String get drawingClearTooltip;

  /// Çizim araç çubuğunda, tuvali uzaklaştıran (zoom out) düğmenin ipucu metni
  ///
  /// In tr, this message translates to:
  /// **'Uzaklaştır'**
  String get drawingZoomOutTooltip;

  /// Çizim araç çubuğunda, tuvali yakınlaştıran (zoom in) düğmenin ipucu metni
  ///
  /// In tr, this message translates to:
  /// **'Yakınlaştır'**
  String get drawingZoomInTooltip;

  /// Gömülü çizim önizlemesinde uzun basınca çıkan katmanda, bloğun tamamını kaldıran çöp kutusu ikonunun ipucu metni
  ///
  /// In tr, this message translates to:
  /// **'Sil'**
  String get drawingDeleteTooltip;

  /// Gömülü çizim önizlemesi boşken, tuvalin ortasında gösterilen ipucu metni
  ///
  /// In tr, this message translates to:
  /// **'Çizmek için dokunun'**
  String get drawingEmptyPreviewHint;

  /// Ayarlar sayfasının AppBar başlığı
  ///
  /// In tr, this message translates to:
  /// **'Ayarlar'**
  String get settingsPageTitle;

  /// Ayarlar sayfasında Genel bölümünün başlığı
  ///
  /// In tr, this message translates to:
  /// **'Genel'**
  String get settingsSectionGeneral;

  /// Ayarlar sayfasında Güvenlik bölümünün başlığı
  ///
  /// In tr, this message translates to:
  /// **'Güvenlik'**
  String get settingsSectionSecurity;

  /// Ayarlar sayfasında Tema bölümünün başlığı
  ///
  /// In tr, this message translates to:
  /// **'Tema'**
  String get settingsSectionTheme;

  /// Ayarlar sayfasında Kişiselleştirme bölümünün başlığı
  ///
  /// In tr, this message translates to:
  /// **'Kişiselleştirme'**
  String get settingsSectionPersonalization;

  /// Ayarlar sayfasında Widget bölümünün başlığı
  ///
  /// In tr, this message translates to:
  /// **'Widget'**
  String get settingsSectionWidget;

  /// Ayarlar sayfasında Hakkında bölümünün başlığı
  ///
  /// In tr, this message translates to:
  /// **'Hakkında'**
  String get settingsSectionAbout;

  /// Güvenlik sorusu seçeneklerinden biri
  ///
  /// In tr, this message translates to:
  /// **'İlk evcil hayvanınızın adı nedir?'**
  String get settingsHintQuestionPet;

  /// Güvenlik sorusu seçeneklerinden biri
  ///
  /// In tr, this message translates to:
  /// **'En sevdiğiniz öğretmeninizin adı nedir?'**
  String get settingsHintQuestionTeacher;

  /// Güvenlik sorusu seçeneklerinden biri
  ///
  /// In tr, this message translates to:
  /// **'Doğduğunuz şehir nedir?'**
  String get settingsHintQuestionBirthCity;

  /// Güvenlik sorusu seçeneklerinden biri
  ///
  /// In tr, this message translates to:
  /// **'En sevdiğiniz yemek nedir?'**
  String get settingsHintQuestionFavoriteFood;

  /// Güvenlik sorusu seçeneklerinden biri
  ///
  /// In tr, this message translates to:
  /// **'Annenizin kızlık soyadı nedir?'**
  String get settingsHintQuestionMotherMaidenName;

  /// Güvenlik sorusu seçeneklerinden biri
  ///
  /// In tr, this message translates to:
  /// **'İlk okuduğunuz okulun adı nedir?'**
  String get settingsHintQuestionFirstSchool;

  /// Güvenlik sorusu seçeneklerinden biri
  ///
  /// In tr, this message translates to:
  /// **'En sevdiğiniz renk nedir?'**
  String get settingsHintQuestionFavoriteColor;

  /// Güvenlik sorusu belirleme diyaloğunun başlığı
  ///
  /// In tr, this message translates to:
  /// **'Güvenlik Sorusu'**
  String get settingsSecurityQuestionDialogTitle;

  /// Güvenlik sorusu diyaloğundaki açıklama metni
  ///
  /// In tr, this message translates to:
  /// **'Şifrenizi unutursanız, bu soruyu doğru cevaplayarak şifrenizi hatırlayabilirsiniz.'**
  String get settingsSecurityQuestionDialogDesc;

  /// Güvenlik sorusu açılır menüsünün ipucu (placeholder) metni
  ///
  /// In tr, this message translates to:
  /// **'Güvenlik sorusu seçin'**
  String get settingsSecurityQuestionDropdownHint;

  /// Güvenlik sorusu cevabı giriş alanının ipucu metni
  ///
  /// In tr, this message translates to:
  /// **'Cevabınız'**
  String get settingsSecurityQuestionAnswerHint;

  /// Güvenlik sorusu diyaloğunda iptal düğmesi
  ///
  /// In tr, this message translates to:
  /// **'İptal'**
  String get settingsSecurityQuestionCancelButton;

  /// Güvenlik sorusu veya cevabı boş bırakılıp kaydedilmeye çalışıldığında gösterilen uyarı
  ///
  /// In tr, this message translates to:
  /// **'Soru ve cevap boş olamaz!'**
  String get settingsSecurityQuestionEmptyWarning;

  /// Güvenlik sorusu diyaloğunda kaydet düğmesi
  ///
  /// In tr, this message translates to:
  /// **'Kaydet'**
  String get settingsSecurityQuestionSaveButton;

  /// Yeni not şifresi oluşturma diyaloğunun başlığı
  ///
  /// In tr, this message translates to:
  /// **'Şifre Oluştur'**
  String get settingsCreatePasswordTitle;

  /// Mevcut şifreyi doğrulama/kaldırma diyaloğunun başlığı
  ///
  /// In tr, this message translates to:
  /// **'Şifre Gerekiyor'**
  String get settingsPasswordRequiredTitle;

  /// Mevcut şifre giriş alanının ipucu metni
  ///
  /// In tr, this message translates to:
  /// **'Şifreyi girin'**
  String get settingsPasswordEnterHint;

  /// Şifre doğrulama diyaloğunda, güvenlik sorusuyla şifre kurtarma akışını açan düğme
  ///
  /// In tr, this message translates to:
  /// **'Şifremi unuttum'**
  String get settingsForgotPasswordButton;

  /// Yeni şifre giriş alanının ipucu metni
  ///
  /// In tr, this message translates to:
  /// **'Yeni şifre'**
  String get settingsNewPasswordHint;

  /// Yeni şifre tekrar giriş alanının ipucu metni
  ///
  /// In tr, this message translates to:
  /// **'Şifreyi tekrar gir'**
  String get settingsConfirmPasswordHint;

  /// Yeni şifre oluşturma diyaloğunda güvenlik sorusu bölümünün açıklama metni
  ///
  /// In tr, this message translates to:
  /// **'Şifrenizi unutursanız diye bir güvenlik sorusu belirleyin (zorunlu değildir).'**
  String get settingsSecurityQuestionOptionalDesc;

  /// Şifre oluşturma/doğrulama diyaloğunda iptal düğmesi
  ///
  /// In tr, this message translates to:
  /// **'İptal'**
  String get settingsPasswordDialogCancelButton;

  /// Yeni şifre ve tekrarı birbiriyle eşleşmediğinde gösterilen uyarı
  ///
  /// In tr, this message translates to:
  /// **'Şifreler eşleşmiyor!'**
  String get settingsPasswordMismatchWarning;

  /// Şifre kaldırma sırasında yanlış şifre girildiğinde gösterilen uyarı
  ///
  /// In tr, this message translates to:
  /// **'Yanlış şifre!'**
  String get settingsWrongPasswordWarning;

  /// Yeni şifre oluşturma diyaloğunda kaydet düğmesi
  ///
  /// In tr, this message translates to:
  /// **'Kaydet'**
  String get settingsPasswordSaveButton;

  /// Mevcut şifreyi kaldırma diyaloğunda kaldır düğmesi
  ///
  /// In tr, this message translates to:
  /// **'Kaldır'**
  String get settingsPasswordRemoveButton;

  /// Güvenlik bölümünde not şifresi ayarı satırının başlığı
  ///
  /// In tr, this message translates to:
  /// **'Not Şifresi'**
  String get settingsNotePasswordTitle;

  /// Not şifresi satırında, şifre ayarlıyken gösterilen alt metin
  ///
  /// In tr, this message translates to:
  /// **'Şifre ayarlandı ✓'**
  String get settingsPasswordSetSubtitle;

  /// Not şifresi satırında, şifre ayarlı değilken gösterilen alt metin
  ///
  /// In tr, this message translates to:
  /// **'Şifre ayarlanmadı'**
  String get settingsPasswordNotSetSubtitle;

  /// Güvenlik bölümünde güvenlik sorusu satırının başlığı
  ///
  /// In tr, this message translates to:
  /// **'Güvenlik Sorusu'**
  String get settingsSecurityQuestionTileTitle;

  /// Güvenlik sorusu satırında, soru belirlenmişken gösterilen alt metin
  ///
  /// In tr, this message translates to:
  /// **'Belirlendi ✓ — şifreyi unutursanız kullanılır'**
  String get settingsSecurityQuestionSetSubtitle;

  /// Güvenlik sorusu satırında, soru belirlenmemişken gösterilen alt metin
  ///
  /// In tr, this message translates to:
  /// **'Belirlenmedi — şifrenizi kaybederseniz kurtaramazsınız'**
  String get settingsSecurityQuestionNotSetSubtitle;

  /// Tema seçim diyaloğunun başlığı
  ///
  /// In tr, this message translates to:
  /// **'Tema Seçin'**
  String get settingsThemeDialogTitle;

  /// Tema seçim diyaloğunda sistem temasını izleme seçeneği
  ///
  /// In tr, this message translates to:
  /// **'Sistem Varsayılanı'**
  String get settingsThemeSystemDefault;

  /// Tema seçim diyaloğunda açık tema seçeneği
  ///
  /// In tr, this message translates to:
  /// **'Açık Tema'**
  String get settingsThemeLightOption;

  /// Tema seçim diyaloğunda koyu tema seçeneği
  ///
  /// In tr, this message translates to:
  /// **'Koyu Tema'**
  String get settingsThemeDarkOption;

  /// Dil seçim diyaloğunun başlığı
  ///
  /// In tr, this message translates to:
  /// **'Dil Seçin'**
  String get settingsLanguageDialogTitle;

  /// Dil seçim diyaloğunda sistem dilini izleme seçeneği
  ///
  /// In tr, this message translates to:
  /// **'Sistem'**
  String get settingsLanguageSystemOption;

  /// Vurgu rengi seçim diyaloğunun başlığı
  ///
  /// In tr, this message translates to:
  /// **'Vurgu Rengini Seçin'**
  String get settingsAccentColorDialogTitle;

  /// Tema bölümünde tema değiştirme satırının başlığı
  ///
  /// In tr, this message translates to:
  /// **'Tema Değiştir'**
  String get settingsThemeChangeTileTitle;

  /// Tema değiştir satırında, açık tema seçiliyken gösterilen kısa etiket
  ///
  /// In tr, this message translates to:
  /// **'Açık'**
  String get settingsThemeLightLabel;

  /// Tema değiştir satırında, koyu tema seçiliyken gösterilen kısa etiket
  ///
  /// In tr, this message translates to:
  /// **'Koyu'**
  String get settingsThemeDarkLabel;

  /// Tema değiştir satırında, sistem teması seçiliyken gösterilen kısa etiket
  ///
  /// In tr, this message translates to:
  /// **'Sistem'**
  String get settingsThemeSystemLabel;

  /// Tema bölümünde dil değiştirme satırının başlığı
  ///
  /// In tr, this message translates to:
  /// **'Dil'**
  String get settingsLanguageTileTitle;

  /// Tema bölümünde vurgu rengi satırının başlığı
  ///
  /// In tr, this message translates to:
  /// **'Vurgu Rengi'**
  String get settingsAccentColorTileTitle;

  /// Vurgu rengi satırının alt metni
  ///
  /// In tr, this message translates to:
  /// **'AppBar, buton ve anahtarlarda kullanılan renk'**
  String get settingsAccentColorTileSubtitle;

  /// Tema bölümünde değişken not renkleri anahtarının başlığı
  ///
  /// In tr, this message translates to:
  /// **'Değişken Not Renkleri'**
  String get settingsColorfulNotesTitle;

  /// Değişken not renkleri anahtarının alt metni
  ///
  /// In tr, this message translates to:
  /// **'Her not kartı farklı renk tonu alır.'**
  String get settingsColorfulNotesSubtitle;

  /// Not içerik metni rengi seçim panelinin başlığı
  ///
  /// In tr, this message translates to:
  /// **'Yazı Rengi'**
  String get settingsTextColorSheetTitle;

  /// Yazı rengi seçim panelindeki açıklama metni
  ///
  /// In tr, this message translates to:
  /// **'Not içerik metninin rengini belirler.'**
  String get settingsTextColorSheetDesc;

  /// Yazı rengi seçim panelini kapatan Tamam düğmesi
  ///
  /// In tr, this message translates to:
  /// **'Tamam'**
  String get settingsTextColorOkButton;

  /// Kişiselleştirme bölümünde yazı rengi satırının başlığı
  ///
  /// In tr, this message translates to:
  /// **'Yazı Rengi'**
  String get settingsTextColorTileTitle;

  /// Yazı rengi satırının alt metni
  ///
  /// In tr, this message translates to:
  /// **'Not içerik metni için renk.'**
  String get settingsTextColorTileSubtitle;

  /// Widget yazı boyutu seçim panelinin başlığı ve Widget bölümündeki ilgili satırın başlığı
  ///
  /// In tr, this message translates to:
  /// **'Widget Yazı Boyutu'**
  String get settingsWidgetFontSizeLabel;

  /// Widget yazı boyutu seçim panelinde seçilen boyutu gösteren örnek metin
  ///
  /// In tr, this message translates to:
  /// **'Örnek başlık - {size} pt'**
  String settingsWidgetFontSizeSample(int size);

  /// Widget yazı boyutu panelinde iptal düğmesi
  ///
  /// In tr, this message translates to:
  /// **'İptal'**
  String get settingsWidgetFontSizeCancelButton;

  /// Widget yazı boyutu panelinde uygula düğmesi
  ///
  /// In tr, this message translates to:
  /// **'Uygula'**
  String get settingsWidgetFontSizeApplyButton;

  /// Widget arka plan saydamlığı seçim panelinin başlığı ve Widget bölümündeki ilgili satırın başlığı
  ///
  /// In tr, this message translates to:
  /// **'Arka Plan Saydamlığı'**
  String get settingsWidgetOpacityLabel;

  /// Widget saydamlık panelinde seçilen yüzdeyi gösteren metin
  ///
  /// In tr, this message translates to:
  /// **'%{percent} saydamlık'**
  String settingsWidgetOpacityValue(int percent);

  /// Widget saydamlık panelinde iptal düğmesi
  ///
  /// In tr, this message translates to:
  /// **'İptal'**
  String get settingsWidgetOpacityCancelButton;

  /// Widget saydamlık panelinde uygula düğmesi
  ///
  /// In tr, this message translates to:
  /// **'Uygula'**
  String get settingsWidgetOpacityApplyButton;

  /// Widget bölümünde koyu widget anahtarının başlığı
  ///
  /// In tr, this message translates to:
  /// **'Koyu Widget'**
  String get settingsWidgetDarkModeTitle;

  /// Koyu widget anahtarının alt metni
  ///
  /// In tr, this message translates to:
  /// **'Widget için koyu renk şeması.'**
  String get settingsWidgetDarkModeDesc;

  /// Hakkında bölümünde uygulama sürümü satırının başlığı
  ///
  /// In tr, this message translates to:
  /// **'Uygulama Sürümü'**
  String get settingsAboutVersionTitle;

  /// Hakkında ekranında sürüm bilgisi henüz yüklenirken gösterilen geçici metin
  ///
  /// In tr, this message translates to:
  /// **'Sürüm bilgisi yükleniyor…'**
  String get settingsAboutVersionLoading;

  /// Hakkında ekranında Geliştirici bölümünün başlığı
  ///
  /// In tr, this message translates to:
  /// **'Geri Bildirim'**
  String get aboutSectionDeveloper;

  /// Hakkında ekranında geliştirici adı satırının başlığı
  ///
  /// In tr, this message translates to:
  /// **'Geliştirici'**
  String get aboutDeveloperTitle;

  /// Hakkında ekranında iletişim (e-posta) satırının başlığı
  ///
  /// In tr, this message translates to:
  /// **'İletişim'**
  String get aboutContactTitle;

  /// Hakkında ekranında web sitesi satırının başlığı
  ///
  /// In tr, this message translates to:
  /// **'Web Sitesi'**
  String get aboutWebsiteTitle;

  /// Hakkında ekranında GitHub satırının başlığı
  ///
  /// In tr, this message translates to:
  /// **'GitHub'**
  String get aboutGithubTitle;

  /// Hakkında ekranında Yasal bölümünün başlığı
  ///
  /// In tr, this message translates to:
  /// **'Yasal'**
  String get aboutSectionLegal;

  /// Hakkında ekranında Gizlilik Politikası satırının başlığı
  ///
  /// In tr, this message translates to:
  /// **'Gizlilik Politikası'**
  String get aboutPrivacyPolicyTitle;

  /// Hakkında ekranında Kullanım Koşulları satırının başlığı
  ///
  /// In tr, this message translates to:
  /// **'Kullanım Koşulları'**
  String get aboutTermsTitle;

  /// Hakkında ekranında Açık Kaynak Lisansları satırının başlığı
  ///
  /// In tr, this message translates to:
  /// **'Açık Kaynak Lisansları'**
  String get aboutLicensesTitle;

  /// Hakkında ekranında Destek bölümünün başlığı
  ///
  /// In tr, this message translates to:
  /// **'Değerlendir'**
  String get aboutSectionSupport;

  /// Hakkında ekranında Uygulamayı Değerlendir satırının başlığı
  ///
  /// In tr, this message translates to:
  /// **'Uygulamayı Değerlendir'**
  String get aboutRateAppTitle;

  /// Bir bağlantı (URL/e-posta) açılamadığında gösterilen hata mesajı
  ///
  /// In tr, this message translates to:
  /// **'Bağlantı açılamadı.'**
  String get aboutLinkOpenError;

  /// Kişiselleştirme bölümündeki yazı tipi satırının başlığı ve yazı tipi seçim sheet'inin başlığı
  ///
  /// In tr, this message translates to:
  /// **'Yazı Tipi'**
  String get settingsFontFamilyTileTitle;

  /// Yazı tipi seçim listesindeki varsayılan yazı tipi seçeneğinin adı
  ///
  /// In tr, this message translates to:
  /// **'Varsayılan'**
  String get settingsFontFamilyDefaultLabel;

  /// Kişiselleştirme bölümündeki yazı boyutu satırının başlığı ve yazı boyutu seçim sheet'inin başlığı
  ///
  /// In tr, this message translates to:
  /// **'Yazı Boyutu'**
  String get settingsGlobalFontSizeTileTitle;

  /// Yazı boyutu satırının alt metni; geçerli genel yazı boyutunu gösterir
  ///
  /// In tr, this message translates to:
  /// **'{size} pt — tüm notlara uygulanır.'**
  String settingsGlobalFontSizeTileSubtitle(int size);

  /// Yazı boyutu seçim sheet'inde seçilen boyutu gösteren örnek metin
  ///
  /// In tr, this message translates to:
  /// **'Örnek metin - {size} pt'**
  String settingsGlobalFontSizeSamplePreview(int size);

  /// Yazı boyutu seçim sheet'inde iptal düğmesi
  ///
  /// In tr, this message translates to:
  /// **'İptal'**
  String get settingsGlobalFontSizeCancelButton;

  /// Yazı boyutu seçim sheet'inde uygula düğmesi
  ///
  /// In tr, this message translates to:
  /// **'Uygula'**
  String get settingsGlobalFontSizeApplyButton;

  /// Kişiselleştirme bölümündeki not önizleme satırı ayarının başlığı ve seçim sheet'inin başlığı
  ///
  /// In tr, this message translates to:
  /// **'Not Önizleme Satırı'**
  String get settingsPreviewLinesTileTitle;

  /// Not önizleme satırı ayarının alt metni
  ///
  /// In tr, this message translates to:
  /// **'En fazla {lines} satır göster. Not daha kısaysa gerçek satır sayısı görünür.'**
  String settingsPreviewLinesTileSubtitle(int lines);

  /// Not önizleme satırı seçim sheet'inde geçerli değeri gösteren etiket
  ///
  /// In tr, this message translates to:
  /// **'Şu an: {lines} satır'**
  String settingsPreviewLinesCurrentLabel(int lines);

  /// Not önizleme satırı seçim sheet'inde kaydırıcının altında gösterilen açıklama metni
  ///
  /// In tr, this message translates to:
  /// **'Maksimum önizlenecek satır sayısını belirler. Not daha az satıra sahipse gerçek satır sayısı gösterilir.'**
  String get settingsPreviewLinesDescription;

  /// Not önizleme satırı seçim sheet'inde iptal düğmesi
  ///
  /// In tr, this message translates to:
  /// **'İptal'**
  String get settingsPreviewLinesCancelButton;

  /// Not önizleme satırı seçim sheet'inde uygula düğmesi
  ///
  /// In tr, this message translates to:
  /// **'Uygula'**
  String get settingsPreviewLinesApplyButton;

  /// Yedekle & Geri Yükle ekranındaki diyaloglarda ortak vazgeç düğmesi
  ///
  /// In tr, this message translates to:
  /// **'Vazgeç'**
  String get backupCancelButton;

  /// Google Drive'a bağlanma diyaloglarında ve durum kartında ortak bağlan düğmesi
  ///
  /// In tr, this message translates to:
  /// **'Bağlan'**
  String get backupConnectButton;

  /// Google Drive bağlantısını kesme diyaloğunda ve durum kartında ortak düğme
  ///
  /// In tr, this message translates to:
  /// **'Bağlantıyı Kes'**
  String get backupDisconnectButton;

  /// Büyük Yedek uyarı diyaloğunda devam et düğmesi
  ///
  /// In tr, this message translates to:
  /// **'Devam Et'**
  String get backupContinueButton;

  /// Yedek Hazır diyaloğunda kapat düğmesi
  ///
  /// In tr, this message translates to:
  /// **'Kapat'**
  String get backupCloseButton;

  /// Yedek Hazır diyaloğunda paylaş düğmesi
  ///
  /// In tr, this message translates to:
  /// **'Paylaş'**
  String get backupShareButton;

  /// Geri yükleme onay diyaloğunda ve Yedek Geçmişi kartında ortak geri yükle düğmesi
  ///
  /// In tr, this message translates to:
  /// **'Geri Yükle'**
  String get backupRestoreButton;

  /// Otomatik Yedekleme durum kartındaki ayarla düğmesi
  ///
  /// In tr, this message translates to:
  /// **'Ayarla'**
  String get backupConfigureButton;

  /// Yedek tarihi okunamadığında gösterilen yer tutucu metin
  ///
  /// In tr, this message translates to:
  /// **'Bilinmiyor'**
  String get backupUnknownDateLabel;

  /// İşlem sürerken gösterilen meşgul göstergesinin varsayılan (özel etiket yoksa) metni
  ///
  /// In tr, this message translates to:
  /// **'İşleniyor...'**
  String get backupProcessingDefaultLabel;

  /// Depolama izni istenen diyaloğun başlığı
  ///
  /// In tr, this message translates to:
  /// **'Depolama İzni Gerekli'**
  String get backupPermissionRequiredTitle;

  /// Depolama izni kalıcı olarak reddedildiğinde gösterilen diyalog gövde metni
  ///
  /// In tr, this message translates to:
  /// **'Bu Android sürümünde yedekleme/geri yükleme için depolama izni gereklidir. İzin kalıcı olarak reddedildiğinden, lütfen uygulama ayarlarından izni elle etkinleştirin.'**
  String get backupPermissionRequiredBodyPermanent;

  /// Depolama izni henüz kalıcı olarak reddedilmemişken gösterilen diyalog gövde metni
  ///
  /// In tr, this message translates to:
  /// **'Bu Android sürümünde yedekleme/geri yükleme için depolama izni gereklidir. Devam edebilmek için lütfen izni verin.'**
  String get backupPermissionRequiredBodyNormal;

  /// Depolama izni kalıcı olarak reddedildiğinde kullanıcıyı uygulama ayarlarına yönlendiren düğme
  ///
  /// In tr, this message translates to:
  /// **'Ayarlara Git'**
  String get backupGoToSettingsButton;

  /// Depolama izni diyaloğunda ve hata SnackBar'larında ortak tekrar dene düğmesi
  ///
  /// In tr, this message translates to:
  /// **'Tekrar Dene'**
  String get backupRetryButton;

  /// Google Drive'a bağlanma sırasında gösterilen meşgul göstergesi metni
  ///
  /// In tr, this message translates to:
  /// **'Google hesabına bağlanılıyor...'**
  String get backupDriveConnectingLabel;

  /// Google Drive'a başarıyla bağlanıldığında, hesap e-postası biliniyorsa gösterilen mesaj
  ///
  /// In tr, this message translates to:
  /// **'Google Drive hesabına bağlanıldı: {email}'**
  String backupDriveConnectedWithEmailMessage(String email);

  /// Google Drive'a başarıyla bağlanıldığında, hesap e-postası bilinmiyorsa gösterilen mesaj
  ///
  /// In tr, this message translates to:
  /// **'Google Drive hesabına bağlanıldı.'**
  String get backupDriveConnectedMessage;

  /// Google Drive'a bağlanma başarısız olduğunda veya kullanıcı iptal ettiğinde gösterilen hata mesajı
  ///
  /// In tr, this message translates to:
  /// **'Google hesabına bağlanılamadı veya işlem iptal edildi.'**
  String get backupDriveConnectFailedMessage;

  /// Google Drive bağlantısını kesme onay diyaloğunun başlığı
  ///
  /// In tr, this message translates to:
  /// **'Google Drive Bağlantısını Kes'**
  String get backupDriveDisconnectTitle;

  /// Google Drive bağlantısını kesme onay diyaloğunun gövde metni
  ///
  /// In tr, this message translates to:
  /// **'Bağlantı kesilirse Drive\'a manuel veya otomatik yedekleme yapılamaz. Drive\'da halihazırda duran yedekleriniz silinmez, yalnızca bu cihazdan erişim kaldırılır.'**
  String get backupDriveDisconnectBody;

  /// Google Drive bağlantısı başarıyla kesildiğinde gösterilen mesaj
  ///
  /// In tr, this message translates to:
  /// **'Google Drive bağlantısı kesildi.'**
  String get backupDriveDisconnectedMessage;

  /// Drive işlemi için önce hesaba bağlanılması gerektiğinde gösterilen diyaloğun başlığı
  ///
  /// In tr, this message translates to:
  /// **'Google Hesabı Gerekli'**
  String get backupDriveRequiredTitle;

  /// Drive işlemi için önce hesaba bağlanılması gerektiğinde gösterilen diyaloğun gövde metni
  ///
  /// In tr, this message translates to:
  /// **'Bu işlem için Google hesabınızla bağlanmanız gerekiyor. Şimdi bağlanmak ister misiniz?'**
  String get backupDriveRequiredBody;

  /// Drive durum kartında, hesap e-postası biliniyorken gösterilen bağlı durumu metni
  ///
  /// In tr, this message translates to:
  /// **'Google Drive: bağlı ({email})'**
  String backupDriveStatusConnectedWithEmail(String email);

  /// Drive durum kartında, hesap e-postası bilinmiyorken gösterilen bağlı durumu metni
  ///
  /// In tr, this message translates to:
  /// **'Google Drive: bağlı'**
  String get backupDriveStatusConnected;

  /// Drive durum kartında gösterilen bağlı değil durumu metni
  ///
  /// In tr, this message translates to:
  /// **'Google Drive: bağlı değil'**
  String get backupDriveStatusDisconnected;

  /// Drive'a yükleme/indirme işlemi başlarken, oturum doğrulanırken gösterilen ilerleme metni
  ///
  /// In tr, this message translates to:
  /// **'Google hesabı doğrulanıyor...'**
  String get backupDriveAuthenticatingLabel;

  /// Drive işlemi (yükleme/listeleme/indirme/silme) sırasında oturum açılmamışsa fırlatılan hatanın mesajı
  ///
  /// In tr, this message translates to:
  /// **'Google Drive\'a bağlı değilsiniz. Lütfen önce Google hesabınızla giriş yapın.'**
  String get backupDriveNotSignedInMessage;

  /// Yedek dosyası Drive'a yüklenirken gösterilen ilerleme metni
  ///
  /// In tr, this message translates to:
  /// **'Yedek Drive\'a yükleniyor...'**
  String get backupDriveUploadingLabel;

  /// Drive'a yükleme isteği 120 saniye içinde sunucudan yanıt alamadığında fırlatılan hatanın mesajı
  ///
  /// In tr, this message translates to:
  /// **'Google Drive\'a yükleme 120 saniye içinde tamamlanamadı (sunucudan yanıt gelmedi). Lütfen bağlantınızı kontrol edip tekrar deneyin.'**
  String get backupDriveUploadTimeoutMessage;

  /// Drive'a yükleme veya Drive'dan indirme işlemi tamamlandığında gösterilen ilerleme metni (%100)
  ///
  /// In tr, this message translates to:
  /// **'Tamamlandı'**
  String get backupDriveOperationCompletedLabel;

  /// Büyük Yedek uyarı diyaloğunda, Drive'a yedekleme işlemi için kullanılan işlem adı
  ///
  /// In tr, this message translates to:
  /// **'Drive\'a yedekleme'**
  String get backupToDriveActionLabel;

  /// Büyük Yedek uyarı diyaloğunda, cihaza yedekleme işlemi için kullanılan işlem adı
  ///
  /// In tr, this message translates to:
  /// **'yedekleme'**
  String get backupToDeviceActionLabel;

  /// Yedek oluşturulurken gösterilen meşgul göstergesi metni
  ///
  /// In tr, this message translates to:
  /// **'Yedek oluşturuluyor...'**
  String get backupCreatingLabel;

  /// Yedek oluşturma başarısız olduğunda gösterilen hata mesajı
  ///
  /// In tr, this message translates to:
  /// **'Yedek oluşturulamadı: {error}'**
  String backupCreateFailedMessage(String error);

  /// Yedeğin Google Drive'a yüklenmesi başarısız olduğunda gösterilen hata mesajı
  ///
  /// In tr, this message translates to:
  /// **'Google Drive\'a yükleme başarısız: {error}'**
  String backupDriveUploadFailedMessage(String error);

  /// Yedek Google Drive'a başarıyla yüklendiğinde gösterilen mesaj
  ///
  /// In tr, this message translates to:
  /// **'Yedek Google Drive\'a başarıyla yüklendi.'**
  String get backupDriveUploadSuccessMessage;

  /// Yedek cihaza başarıyla oluşturulduğunda gösterilen mesaj
  ///
  /// In tr, this message translates to:
  /// **'Yedek oluşturuldu: {fileName} ({size})'**
  String backupCreatedMessage(String fileName, String size);

  /// Yedek oluşturulduktan sonra paylaşım teklif eden diyaloğun başlığı
  ///
  /// In tr, this message translates to:
  /// **'Yedek Hazır'**
  String get backupOfferShareTitle;

  /// Yedek oluşturulduktan sonra paylaşım teklif eden diyaloğun gövde metni
  ///
  /// In tr, this message translates to:
  /// **'Yedek dosyanız cihazınıza kaydedildi. Dosyayı şimdi paylaşmak (örn. bulut depolama, e-posta, başka bir cihaz) ister misiniz?'**
  String get backupOfferShareBody;

  /// Yedek dosyası paylaşılırken sistem paylaşım sayfasında gösterilen açıklama metni
  ///
  /// In tr, this message translates to:
  /// **'layout yedek dosyası'**
  String get backupShareFileText;

  /// Yedek dosyası paylaşımı başlatılamadığında gösterilen hata mesajı
  ///
  /// In tr, this message translates to:
  /// **'Paylaşım başlatılamadı: {error}'**
  String backupShareFailedMessage(String error);

  /// Boyut eşiği aşıldığında gösterilen uyarı diyaloğunun başlığı
  ///
  /// In tr, this message translates to:
  /// **'Büyük Yedek'**
  String get backupLargeOperationTitle;

  /// Boyut eşiği aşıldığında gösterilen uyarı diyaloğunun gövde metni
  ///
  /// In tr, this message translates to:
  /// **'İşlenecek veri boyutu yaklaşık {sizeText}. Bu boyuttaki bir {actionLabel} işlemi cihazınıza bağlı olarak biraz zaman alabilir. İşlem sürerken uygulamadan çıkmamanız yeterlidir, devam etmek ister misiniz?'**
  String backupLargeOperationBody(String sizeText, String actionLabel);

  /// Büyük Yedek uyarı diyaloğunda, geri yükleme işlemi için kullanılan işlem adı
  ///
  /// In tr, this message translates to:
  /// **'geri yükleme'**
  String get backupRestoreActionLabel;

  /// Drive'daki yedekler listelenirken gösterilen meşgul göstergesi metni
  ///
  /// In tr, this message translates to:
  /// **'Drive yedekleri listeleniyor...'**
  String get backupDriveListingLabel;

  /// Drive'daki yedekler listelenemediğinde gösterilen hata mesajı
  ///
  /// In tr, this message translates to:
  /// **'Yedekler listelenemedi: {error}'**
  String backupDriveListFailedMessage(String error);

  /// Drive'da hiç yedek bulunamadığında gösterilen mesaj
  ///
  /// In tr, this message translates to:
  /// **'Google Drive\'da henüz bir yedek bulunmuyor.'**
  String get backupDriveNoBackupsMessage;

  /// Drive'daki yedeklerin listelendiği seçim diyaloğunun başlığı
  ///
  /// In tr, this message translates to:
  /// **'Drive\'dan Yedek Seç'**
  String get backupDrivePickTitle;

  /// Seçilen yedek Drive'dan indirilirken gösterilen meşgul göstergesi metni
  ///
  /// In tr, this message translates to:
  /// **'Yedek Drive\'dan indiriliyor...'**
  String get backupDriveDownloadingLabel;

  /// Drive'dan indirme sırasında, indirilen ve toplam dosya boyutuyla birlikte gösterilen ilerleme metni
  ///
  /// In tr, this message translates to:
  /// **'Yedek Drive\'dan indiriliyor... ({downloaded} / {total})'**
  String backupDriveDownloadingWithSizeLabel(String downloaded, String total);

  /// Drive'dan indirilen dosya cihaza yazılırken gösterilen ilerleme metni
  ///
  /// In tr, this message translates to:
  /// **'Dosya cihaza kaydediliyor...'**
  String get backupDriveSavingToDeviceLabel;

  /// Drive'daki yedek dosyasının adı API'den gelmemişse kullanılan yedek (fallback) dosya adı
  ///
  /// In tr, this message translates to:
  /// **'bilinmeyen_yedek.zip'**
  String get backupDriveUnknownBackupFileName;

  /// Drive işlemi sırasında depolama kotası aşıldığında fırlatılan hatanın mesajı
  ///
  /// In tr, this message translates to:
  /// **'Google Drive depolama alanınız dolu. Lütfen Drive\'da yer açıp tekrar deneyin.'**
  String get backupDriveStorageFullMessage;

  /// Drive işlemi sırasında ağ/bağlantı hatası oluştuğunda fırlatılan hatanın mesajı
  ///
  /// In tr, this message translates to:
  /// **'İnternet bağlantısı sağlanamadı. Lütfen bağlantınızı kontrol edip tekrar deneyin.'**
  String get backupDriveNetworkErrorMessage;

  /// Belirtilen yedek dosyası Drive'da (404) bulunamadığında fırlatılan hatanın mesajı
  ///
  /// In tr, this message translates to:
  /// **'Belirtilen yedek dosyası Drive\'da bulunamadı. Silinmiş olabilir.'**
  String get backupDriveBackupNotFoundMessage;

  /// Drive işlemi sırasında sınıflandırılamayan bir hata oluştuğunda fırlatılan hatanın mesajı
  ///
  /// In tr, this message translates to:
  /// **'Google Drive işlemi sırasında beklenmeyen bir hata oluştu: {error}'**
  String backupDriveUnknownErrorMessage(String error);

  /// Yedek Drive'dan indirilemediğinde gösterilen hata mesajı
  ///
  /// In tr, this message translates to:
  /// **'İndirme başarısız: {error}'**
  String backupDriveDownloadFailedMessage(String error);

  /// Cihazdan yedek dosyası seçilirken hata oluştuğunda gösterilen mesaj
  ///
  /// In tr, this message translates to:
  /// **'Dosya seçilemedi: {error}'**
  String backupPickFileFailedMessage(String error);

  /// Seçilen dosyanın yolu alınamadığında gösterilen mesaj
  ///
  /// In tr, this message translates to:
  /// **'Seçilen dosyaya erişilemedi.'**
  String get backupPickedFileUnreachableMessage;

  /// Seçilen yedek dosyası doğrulanırken gösterilen meşgul göstergesi metni
  ///
  /// In tr, this message translates to:
  /// **'Yedek kontrol ediliyor...'**
  String get backupCheckingLabel;

  /// Yedek dosyası okunamadığında gösterilen hata mesajı
  ///
  /// In tr, this message translates to:
  /// **'Yedek dosyası okunamadı: {error}'**
  String backupReadFailedMessage(String error);

  /// Geri yükleme onay diyaloğunun başlığı
  ///
  /// In tr, this message translates to:
  /// **'Yedeği Geri Yükle'**
  String get backupRestoreConfirmTitle;

  /// Geri yükleme onay diyaloğunda önizleme bölümünün üst başlığı
  ///
  /// In tr, this message translates to:
  /// **'Seçilen yedeğin içeriği:'**
  String get backupPreviewContentsHeader;

  /// Önizlemede not sayısı satırının etiketi
  ///
  /// In tr, this message translates to:
  /// **'Not sayısı'**
  String get backupPreviewNoteCountLabel;

  /// Önizlemede çöp kutusundaki not sayısı satırının etiketi
  ///
  /// In tr, this message translates to:
  /// **'Çöp kutusundaki not'**
  String get backupPreviewTrashCountLabel;

  /// Önizlemede kategori sayısı satırının etiketi
  ///
  /// In tr, this message translates to:
  /// **'Kategori sayısı'**
  String get backupPreviewCategoryCountLabel;

  /// Önizlemede ek dosya satırının etiketi
  ///
  /// In tr, this message translates to:
  /// **'Ek dosya'**
  String get backupPreviewAttachmentLabel;

  /// Önizlemede hiç ek dosya yoksa gösterilen değer
  ///
  /// In tr, this message translates to:
  /// **'Yok'**
  String get backupPreviewAttachmentNoneValue;

  /// Önizlemede ek dosya sayısı ve toplam boyutu gösteren değer
  ///
  /// In tr, this message translates to:
  /// **'{count} dosya ({size})'**
  String backupPreviewAttachmentCountValue(int count, String size);

  /// Önizlemede yedeğin oluşturulma tarihi satırının etiketi
  ///
  /// In tr, this message translates to:
  /// **'Oluşturulma tarihi'**
  String get backupPreviewCreatedAtLabel;

  /// Seçilen yedek tamamen boş olduğunda gösterilen uyarı kutusunun başlığı
  ///
  /// In tr, this message translates to:
  /// **'Bu yedek boş görünüyor'**
  String get backupEmptyPreviewTitle;

  /// Seçilen yedek tamamen boş olduğunda gösterilen uyarı kutusunun gövde metni
  ///
  /// In tr, this message translates to:
  /// **'Seçilen dosyada not, kategori veya ek dosya bulunamadı. Yine de devam ederseniz mevcut verileriniz silinip yerine bu boş yedek yazılır.'**
  String get backupEmptyPreviewBody;

  /// Yedekte eksik ek dosya olduğunda gösterilen uyarı kutusunun başlığı
  ///
  /// In tr, this message translates to:
  /// **'{count} ek dosya yedekte bulunamadı'**
  String backupMissingAttachmentsTitle(int count);

  /// Yedekte eksik ek dosya olduğunda gösterilen uyarı kutusunun gövde metni
  ///
  /// In tr, this message translates to:
  /// **'Bu dosyalara sahip notlar geri yüklenecek, ancak ek dosyalar olmadan (yedek alınırken eksik ya da bozuk kalmış olabilirler): {names}'**
  String backupMissingAttachmentsBody(String names);

  /// Eksik ek dosya adları listesi uzun olduğunda gösterilen kısaltılmış özet
  ///
  /// In tr, this message translates to:
  /// **'{shown} ve {remaining} tane daha'**
  String backupMissingAttachmentsMoreSuffix(String shown, int remaining);

  /// Geri yükleme onay diyaloğunda, işlemin geri alınamayacağını belirten uyarı metni
  ///
  /// In tr, this message translates to:
  /// **'Bu işlem; mevcut tüm notlarınızın, çöp kutunuzun, kategorilerinizin, ayarlarınızın ve eklerinizin YERİNE yukarıdaki yedekteki verileri yazacaktır. Mevcut veriler kalıcı olarak kaybolur ve bu işlem geri alınamaz.'**
  String get backupRestoreConfirmBody;

  /// Geri yükleme işlemi sürerken gösterilen meşgul göstergesi metni
  ///
  /// In tr, this message translates to:
  /// **'Yedek geri yükleniyor...'**
  String get backupRestoringLabel;

  /// Geri yükleme, eksik ek dosyalarla birlikte başarıyla tamamlandığında gösterilen mesaj
  ///
  /// In tr, this message translates to:
  /// **'Yedek geri yüklendi. Ancak {count} ek dosya yedekte bulunamadığı için geri yüklenemedi. Değişikliklerin tam yansıması için uygulamayı yeniden başlatmanız önerilir.'**
  String backupRestoreSuccessWithMissingMessage(int count);

  /// Geri yükleme, eksik ek dosya olmadan başarıyla tamamlandığında gösterilen mesaj
  ///
  /// In tr, this message translates to:
  /// **'Yedek başarıyla geri yüklendi. Değişikliklerin tam olarak yansıması için uygulamayı yeniden başlatmanız önerilir.'**
  String get backupRestoreSuccessMessage;

  /// Geri yükleme sırasında hata oluştuğunda gösterilen mesaj
  ///
  /// In tr, this message translates to:
  /// **'Geri yükleme sırasında hata oluştu: {error}'**
  String backupRestoreFailedMessage(String error);

  /// Yedekle & Geri Yükle ekranının AppBar başlığı
  ///
  /// In tr, this message translates to:
  /// **'Yedekle & Geri Yükle'**
  String get backupScreenTitle;

  /// İşlem (yedekleme/geri yükleme) sürerken kullanıcı ekrandan çıkmaya çalıştığında gösterilen snackbar uyarı mesajı
  ///
  /// In tr, this message translates to:
  /// **'İşlem sürüyor, lütfen tamamlanmasını bekleyin.'**
  String get backupBlockedExitWarningMessage;

  /// İşlem sürerken AppBar'daki devre dışı geri düğmesinin ipucu metni
  ///
  /// In tr, this message translates to:
  /// **'İşlem sürüyor'**
  String get backupBusyBackTooltip;

  /// Ekranın en üstünde, durum kartlarının altında gösterilen açıklama metni
  ///
  /// In tr, this message translates to:
  /// **'Notlarınızı, kategorilerinizi, ayarlarınızı ve eklerinizi tek bir .zip dosyası olarak yedekleyebilir veya daha önce aldığınız bir yedeği geri yükleyebilirsiniz.'**
  String get backupIntroText;

  /// Google Drive'a manuel yedekleme action card'ının başlığı
  ///
  /// In tr, this message translates to:
  /// **'Google Drive\'a Yedekle'**
  String get backupDriveCardTitle;

  /// Google Drive'a manuel yedekleme action card'ının açıklama metni
  ///
  /// In tr, this message translates to:
  /// **'Yeni bir yedek oluşturup doğrudan Google Drive\'ınızın gizli alanına yükleyin.'**
  String get backupDriveCardSubtitle;

  /// Google Drive'a manuel yedekleme action card'ının buton etiketi
  ///
  /// In tr, this message translates to:
  /// **'Drive\'a Yedekle'**
  String get backupDriveCardButtonLabel;

  /// Cihaza yedekleme action card'ının başlığı
  ///
  /// In tr, this message translates to:
  /// **'Cihaza Yedekle'**
  String get backupDeviceCardTitle;

  /// Cihaza yedekleme action card'ının açıklama metni
  ///
  /// In tr, this message translates to:
  /// **'Tüm verilerinizi tek bir .zip dosyası olarak cihaza kaydedin ve isterseniz paylaşın.'**
  String get backupDeviceCardSubtitle;

  /// Cihaza yedekleme action card'ının buton etiketi
  ///
  /// In tr, this message translates to:
  /// **'Cihaza Yedekle'**
  String get backupDeviceCardButtonLabel;

  /// Yedek Geçmişi action card'ının başlığı
  ///
  /// In tr, this message translates to:
  /// **'Yedek Geçmişi'**
  String get backupHistoryCardTitle;

  /// Yedek Geçmişi action card'ının açıklama metni
  ///
  /// In tr, this message translates to:
  /// **'Cihazda kayıtlı tüm yedekleri tarih ve boyutlarıyla görüntüleyin; buradan doğrudan paylaşabilir, geri yükleyebilir veya silebilirsiniz.'**
  String get backupHistoryCardSubtitle;

  /// Yedek Geçmişi ekranındaki cihaz sekmesinin etiketi
  ///
  /// In tr, this message translates to:
  /// **'Cihaz'**
  String get backupHistoryTabDevice;

  /// Yedek Geçmişi ekranındaki Google Drive sekmesinin etiketi
  ///
  /// In tr, this message translates to:
  /// **'Google Drive'**
  String get backupHistoryTabDrive;

  /// Cihazdaki bir yedeği silme onay diyaloğunun başlığı
  ///
  /// In tr, this message translates to:
  /// **'Yedeği Sil'**
  String get backupHistoryDeleteDialogTitle;

  /// Cihazdaki bir yedeği silme onay diyaloğunun içeriği
  ///
  /// In tr, this message translates to:
  /// **'\"{fileName}\" adlı yedek dosyasını kalıcı olarak silmek istediğinize emin misiniz? Bu işlem geri alınamaz.'**
  String backupHistoryDeleteDialogBody(String fileName);

  /// Cihazdaki bir yedek başarıyla silindiğinde gösterilen mesaj
  ///
  /// In tr, this message translates to:
  /// **'Yedek silindi.'**
  String get backupHistoryDeviceDeletedMessage;

  /// Google Drive'daki bir yedeği silme onay diyaloğunun başlığı
  ///
  /// In tr, this message translates to:
  /// **'Drive Yedeğini Sil'**
  String get backupHistoryDriveDeleteDialogTitle;

  /// Google Drive'daki bir yedeği silme onay diyaloğunun içeriği
  ///
  /// In tr, this message translates to:
  /// **'\"{fileName}\" adlı yedeği Google Drive\'dan kalıcı olarak silmek istediğinize emin misiniz? Bu işlem geri alınamaz ve dosya çöp kutusuna taşınmaz.'**
  String backupHistoryDriveDeleteDialogBody(String fileName);

  /// Google Drive'daki bir yedek başarıyla silindiğinde gösterilen mesaj
  ///
  /// In tr, this message translates to:
  /// **'Drive yedeği silindi.'**
  String get backupHistoryDriveDeletedMessage;

  /// Google Drive'daki bir yedek silinemediğinde gösterilen hata mesajı
  ///
  /// In tr, this message translates to:
  /// **'Silinemedi: {error}'**
  String backupHistoryDriveDeleteFailedMessage(String error);

  /// Cihaz sekmesinde hiç yedek olmadığında gösterilen başlık
  ///
  /// In tr, this message translates to:
  /// **'Henüz cihazda kayıtlı bir yedek yok.'**
  String get backupHistoryDeviceEmptyTitle;

  /// Cihaz sekmesinde hiç yedek olmadığında gösterilen alt metin
  ///
  /// In tr, this message translates to:
  /// **'\"Yedek Oluştur\" ile ilk yedeğinizi alabilirsiniz.'**
  String get backupHistoryDeviceEmptySubtitle;

  /// Drive sekmesinde hiç yedek olmadığında gösterilen alt metin
  ///
  /// In tr, this message translates to:
  /// **'\"Google Drive\'a Yedekle\" ile ilk bulut yedeğinizi oluşturabilirsiniz.'**
  String get backupHistoryDriveEmptySubtitle;

  /// Google hesabı bağlı değilken Drive sekmesinde gösterilen davet metni
  ///
  /// In tr, this message translates to:
  /// **'Drive yedeklerinizi görmek için Google hesabınızla bağlanın.'**
  String get backupHistoryDriveSignInPrompt;

  /// Google hesabına bağlanma butonunun etiketi
  ///
  /// In tr, this message translates to:
  /// **'Google ile Bağlan'**
  String get backupHistoryConnectGoogleButton;

  /// Google hesabı bağlıyken e-posta bilgisi alınamadığında gösterilen yedek metin
  ///
  /// In tr, this message translates to:
  /// **'Bağlı'**
  String get backupHistoryDriveConnectedFallback;

  /// Drive yedekleri listelenirken hata mesajı alınamadığında gösterilen yedek metin
  ///
  /// In tr, this message translates to:
  /// **'Bilinmeyen bir hata oluştu.'**
  String get backupHistoryUnknownErrorFallback;

  /// Drive'dan yedek indirme işlemi başlarken gösterilen ilerleme etiketi
  ///
  /// In tr, this message translates to:
  /// **'Başlıyor...'**
  String get backupHistoryDownloadStartingLabel;

  /// Otomatik yedekleme durum kartında, otomatik yedekleme açıkken gösterilen metin
  ///
  /// In tr, this message translates to:
  /// **'Otomatik Yedekleme: açık'**
  String get backupAutoBackupEnabledLabel;

  /// Otomatik yedekleme durum kartında, otomatik yedekleme kapalıyken gösterilen metin
  ///
  /// In tr, this message translates to:
  /// **'Otomatik Yedekleme: kapalı'**
  String get backupAutoBackupDisabledLabel;

  /// İşlem sürerken gösterilen meşgul overlay'inde, ilerleme göstergesinin altındaki uyarı metni
  ///
  /// In tr, this message translates to:
  /// **'Lütfen bekleyin, işlem tamamlanmadan uygulamadan çıkmayın.'**
  String get backupOverlayWarningMessage;

  /// PDF dışa aktarımında, notun başlığı boşsa kullanılan yedek başlık
  ///
  /// In tr, this message translates to:
  /// **'Başlıksız Not'**
  String get pdfExportUntitledNoteLabel;

  /// PDF dışa aktarımında, ekin dosya adı yoksa placeholder kutucuğunda kullanılan yedek isim
  ///
  /// In tr, this message translates to:
  /// **'Ek dosya'**
  String get pdfExportDefaultAttachmentName;

  /// PDF dışa aktarımında 'Farklı Kaydet' diyaloğunda, notun başlığı boşsa dosya adı olarak kullanılan yedek kelime (uzantısız)
  ///
  /// In tr, this message translates to:
  /// **'not'**
  String get pdfExportDefaultFileName;

  /// Not JPG olarak dışa aktarılırken RepaintBoundary bulunamadığında fırlatılan hatanın mesajı
  ///
  /// In tr, this message translates to:
  /// **'Ekran görüntüsü alınamadı (boundary bulunamadı)'**
  String get screenshotExportBoundaryNotFoundMessage;

  /// Not JPG olarak dışa aktarılırken görüntü byte verisi (byteData) null döndüğünde fırlatılan hatanın mesajı
  ///
  /// In tr, this message translates to:
  /// **'Ekran görüntüsü verisi oluşturulamadı'**
  String get screenshotExportByteDataNullMessage;

  /// Not JPG olarak dışa aktarılırken ara PNG verisi çözümlenemediğinde fırlatılan hatanın mesajı
  ///
  /// In tr, this message translates to:
  /// **'Görüntü işlenemedi (PNG çözümlenemedi)'**
  String get screenshotExportPngDecodeFailedMessage;

  /// Not ekran görüntüsü (JPG) dışa aktarımında, hesap tablosu bloğunun toplam satırındaki etiket
  ///
  /// In tr, this message translates to:
  /// **'Toplam'**
  String get screenshotCalcTableTotalLabel;

  /// Gündem ekranında bir satıra basılı tutulunca çıkan menüdeki 'kaldır' seçeneği
  ///
  /// In tr, this message translates to:
  /// **'Gündemden kaldır'**
  String get gundemMenuRemoveFromAgenda;

  /// Gündem ekranında bir satıra basılı tutulunca çıkan menüdeki 'sil' seçeneği
  ///
  /// In tr, this message translates to:
  /// **'Notu sil'**
  String get gundemMenuDeleteNote;

  /// Gündem ekranında, tarihi geçmiş notları içeren bölümün başlığı
  ///
  /// In tr, this message translates to:
  /// **'Gecikmiş'**
  String get gundemSectionOverdue;

  /// Gündem ekranında bugüne ait notları içeren bölümün başlığı
  ///
  /// In tr, this message translates to:
  /// **'Bugün'**
  String get gundemSectionToday;

  /// Gündem ekranında yarına ait notları içeren bölümün başlığı
  ///
  /// In tr, this message translates to:
  /// **'Yarın'**
  String get gundemSectionTomorrow;

  /// Gündem ekranında, bugünden itibaren 7-13 gün sonrasına denk gelen notları içeren bölümün başlığı
  ///
  /// In tr, this message translates to:
  /// **'Gelecek Hafta'**
  String get gundemSectionNextWeek;

  /// Gündem ekranında, bugünden itibaren 14 gün ve sonrasına denk gelen notları içeren bölümün başlığı
  ///
  /// In tr, this message translates to:
  /// **'Daha İleri'**
  String get gundemSectionFurther;

  /// Gündem ekranında, bu haftanın kalan günlerinden birinin bölüm başlığı olarak kullanılan gün adı
  ///
  /// In tr, this message translates to:
  /// **'Pazartesi'**
  String get gundemWeekdayMonday;

  /// Gündem ekranında, bu haftanın kalan günlerinden birinin bölüm başlığı olarak kullanılan gün adı
  ///
  /// In tr, this message translates to:
  /// **'Salı'**
  String get gundemWeekdayTuesday;

  /// Gündem ekranında, bu haftanın kalan günlerinden birinin bölüm başlığı olarak kullanılan gün adı
  ///
  /// In tr, this message translates to:
  /// **'Çarşamba'**
  String get gundemWeekdayWednesday;

  /// Gündem ekranında, bu haftanın kalan günlerinden birinin bölüm başlığı olarak kullanılan gün adı
  ///
  /// In tr, this message translates to:
  /// **'Perşembe'**
  String get gundemWeekdayThursday;

  /// Gündem ekranında, bu haftanın kalan günlerinden birinin bölüm başlığı olarak kullanılan gün adı
  ///
  /// In tr, this message translates to:
  /// **'Cuma'**
  String get gundemWeekdayFriday;

  /// Gündem ekranında, bu haftanın kalan günlerinden birinin bölüm başlığı olarak kullanılan gün adı
  ///
  /// In tr, this message translates to:
  /// **'Cumartesi'**
  String get gundemWeekdaySaturday;

  /// Gündem ekranında, bu haftanın kalan günlerinden birinin bölüm başlığı olarak kullanılan gün adı
  ///
  /// In tr, this message translates to:
  /// **'Pazar'**
  String get gundemWeekdaySunday;

  /// Gündem ekranının üst bar (AppBar) başlığı
  ///
  /// In tr, this message translates to:
  /// **'Ajanda'**
  String get gundemAppBarTitle;

  /// Gündem ekranının üst barındaki takvim ikonunun tooltip'i
  ///
  /// In tr, this message translates to:
  /// **'Takvim'**
  String get gundemCalendarTooltip;

  /// Gündem ekranında hiç satır yokken gösterilen boş durum başlığı
  ///
  /// In tr, this message translates to:
  /// **'Ajandanda bir şey yok'**
  String get gundemEmptyTitle;

  /// Gündem ekranında hiç satır yokken başlığın altında gösterilen açıklama metni
  ///
  /// In tr, this message translates to:
  /// **'Hatırlatıcı eklediğin veya tarih atadığın notlar burada listelenir.'**
  String get gundemEmptySubtitle;

  /// Gündem satırında, notun ne başlığı ne de içerik önizlemesi varsa gösterilen yedek metin
  ///
  /// In tr, this message translates to:
  /// **'Adsız not'**
  String get gundemUntitledNote;

  /// Gündem satırında, hatırlatıcının tekrar sıklığı 'saatlik' olduğunda gösterilen etiket
  ///
  /// In tr, this message translates to:
  /// **'Her saat'**
  String get gundemRepeatHourly;

  /// Gündem satırında, hatırlatıcının tekrar sıklığı 'günlük' olduğunda gösterilen etiket
  ///
  /// In tr, this message translates to:
  /// **'Her gün'**
  String get gundemRepeatDaily;

  /// Gündem satırında, hatırlatıcının tekrar sıklığı 'haftalık' olduğunda gösterilen etiket
  ///
  /// In tr, this message translates to:
  /// **'Her hafta'**
  String get gundemRepeatWeekly;

  /// Gündem satırında, hatırlatıcının tekrar sıklığı 'aylık' olduğunda gösterilen etiket
  ///
  /// In tr, this message translates to:
  /// **'Her ay'**
  String get gundemRepeatMonthly;

  /// Gündem satırında, hatırlatıcının tekrar sıklığı 'yıllık' olduğunda gösterilen etiket
  ///
  /// In tr, this message translates to:
  /// **'Her yıl'**
  String get gundemRepeatYearly;

  /// Gündem satırında, başlıksız bir notun içerik önizlemesinde hesap tablosu bloğu için gösterilen yer tutucu
  ///
  /// In tr, this message translates to:
  /// **'[Hesap Listesi]'**
  String get gundemPreviewCalcTableLabel;

  /// Gündem satırında, başlıksız bir notun içerik önizlemesinde çizim bloğu için gösterilen yer tutucu
  ///
  /// In tr, this message translates to:
  /// **'[Çizim]'**
  String get gundemPreviewDrawingLabel;

  /// Gündem satırında, başlıksız bir notun içerik önizlemesinde görsel bloğu için gösterilen yer tutucu
  ///
  /// In tr, this message translates to:
  /// **'[Görsel]'**
  String get gundemPreviewImageLabel;

  /// Gündem ekranında 'Bugün'/'Yarın' başlığının yanındaki kısa tarih etiketinde (örn. '9 Ağu') kullanılan kısaltılmış ay adı
  ///
  /// In tr, this message translates to:
  /// **'Oca'**
  String get gundemMonthShortJan;

  /// Gündem ekranındaki kısa tarih etiketinde kullanılan kısaltılmış ay adı
  ///
  /// In tr, this message translates to:
  /// **'Şub'**
  String get gundemMonthShortFeb;

  /// Gündem ekranındaki kısa tarih etiketinde kullanılan kısaltılmış ay adı
  ///
  /// In tr, this message translates to:
  /// **'Mar'**
  String get gundemMonthShortMar;

  /// Gündem ekranındaki kısa tarih etiketinde kullanılan kısaltılmış ay adı
  ///
  /// In tr, this message translates to:
  /// **'Nis'**
  String get gundemMonthShortApr;

  /// Gündem ekranındaki kısa tarih etiketinde kullanılan kısaltılmış ay adı
  ///
  /// In tr, this message translates to:
  /// **'May'**
  String get gundemMonthShortMay;

  /// Gündem ekranındaki kısa tarih etiketinde kullanılan kısaltılmış ay adı
  ///
  /// In tr, this message translates to:
  /// **'Haz'**
  String get gundemMonthShortJun;

  /// Gündem ekranındaki kısa tarih etiketinde kullanılan kısaltılmış ay adı
  ///
  /// In tr, this message translates to:
  /// **'Tem'**
  String get gundemMonthShortJul;

  /// Gündem ekranındaki kısa tarih etiketinde kullanılan kısaltılmış ay adı
  ///
  /// In tr, this message translates to:
  /// **'Ağu'**
  String get gundemMonthShortAug;

  /// Gündem ekranındaki kısa tarih etiketinde kullanılan kısaltılmış ay adı
  ///
  /// In tr, this message translates to:
  /// **'Eyl'**
  String get gundemMonthShortSep;

  /// Gündem ekranındaki kısa tarih etiketinde kullanılan kısaltılmış ay adı
  ///
  /// In tr, this message translates to:
  /// **'Eki'**
  String get gundemMonthShortOct;

  /// Gündem ekranındaki kısa tarih etiketinde kullanılan kısaltılmış ay adı
  ///
  /// In tr, this message translates to:
  /// **'Kas'**
  String get gundemMonthShortNov;

  /// Gündem ekranındaki kısa tarih etiketinde kullanılan kısaltılmış ay adı
  ///
  /// In tr, this message translates to:
  /// **'Ara'**
  String get gundemMonthShortDec;

  /// Takvim ekranının AppBar başlığı
  ///
  /// In tr, this message translates to:
  /// **'Takvim'**
  String get calendarAppBarTitle;

  /// Takvim ekranında AppBar'da, görünümü bugünün ayına ve gününe döndüren buton
  ///
  /// In tr, this message translates to:
  /// **'Bugün'**
  String get calendarTodayButton;

  /// Takvim ekranındaki lejantta, sarı noktanın anlamını açıklayan etiket
  ///
  /// In tr, this message translates to:
  /// **'Not'**
  String get calendarLegendNoteLabel;

  /// Takvim ekranındaki lejantta, mavi noktanın anlamını açıklayan etiket
  ///
  /// In tr, this message translates to:
  /// **'Hatırlatıcı'**
  String get calendarLegendReminderLabel;

  /// Takvim ekranında seçili gün panelinde, seçili gün bugünse tarihin altında gösterilen küçük rozet
  ///
  /// In tr, this message translates to:
  /// **'Bugün'**
  String get calendarTodayBadge;

  /// Takvim ekranında seçili günün not/hatırlatıcı listesi boşken gösterilen mesaj
  ///
  /// In tr, this message translates to:
  /// **'Bu güne ait not veya hatırlatıcı yok.'**
  String get calendarEmptyDayMessage;

  /// Takvim ekranında, seçili gün listesinde saatlik tekrar eden bir hatırlatıcı için sabit saat yerine gösterilen etiket
  ///
  /// In tr, this message translates to:
  /// **'Her saat'**
  String get calendarReminderHourlyLabel;

  /// Takvim ekranındaki ay başlığında ve seçili gün panelinde kullanılan tam ay adı
  ///
  /// In tr, this message translates to:
  /// **'Ocak'**
  String get calendarMonthJan;

  /// Takvim ekranındaki ay başlığında ve seçili gün panelinde kullanılan tam ay adı
  ///
  /// In tr, this message translates to:
  /// **'Şubat'**
  String get calendarMonthFeb;

  /// Takvim ekranındaki ay başlığında ve seçili gün panelinde kullanılan tam ay adı
  ///
  /// In tr, this message translates to:
  /// **'Mart'**
  String get calendarMonthMar;

  /// Takvim ekranındaki ay başlığında ve seçili gün panelinde kullanılan tam ay adı
  ///
  /// In tr, this message translates to:
  /// **'Nisan'**
  String get calendarMonthApr;

  /// Takvim ekranındaki ay başlığında ve seçili gün panelinde kullanılan tam ay adı
  ///
  /// In tr, this message translates to:
  /// **'Mayıs'**
  String get calendarMonthMay;

  /// Takvim ekranındaki ay başlığında ve seçili gün panelinde kullanılan tam ay adı
  ///
  /// In tr, this message translates to:
  /// **'Haziran'**
  String get calendarMonthJun;

  /// Takvim ekranındaki ay başlığında ve seçili gün panelinde kullanılan tam ay adı
  ///
  /// In tr, this message translates to:
  /// **'Temmuz'**
  String get calendarMonthJul;

  /// Takvim ekranındaki ay başlığında ve seçili gün panelinde kullanılan tam ay adı
  ///
  /// In tr, this message translates to:
  /// **'Ağustos'**
  String get calendarMonthAug;

  /// Takvim ekranındaki ay başlığında ve seçili gün panelinde kullanılan tam ay adı
  ///
  /// In tr, this message translates to:
  /// **'Eylül'**
  String get calendarMonthSep;

  /// Takvim ekranındaki ay başlığında ve seçili gün panelinde kullanılan tam ay adı
  ///
  /// In tr, this message translates to:
  /// **'Ekim'**
  String get calendarMonthOct;

  /// Takvim ekranındaki ay başlığında ve seçili gün panelinde kullanılan tam ay adı
  ///
  /// In tr, this message translates to:
  /// **'Kasım'**
  String get calendarMonthNov;

  /// Takvim ekranındaki ay başlığında ve seçili gün panelinde kullanılan tam ay adı
  ///
  /// In tr, this message translates to:
  /// **'Aralık'**
  String get calendarMonthDec;

  /// Takvim ekranındaki hafta günleri başlığında kullanılan kısaltılmış gün adı
  ///
  /// In tr, this message translates to:
  /// **'Pzt'**
  String get calendarWeekdayShortMon;

  /// Takvim ekranındaki hafta günleri başlığında kullanılan kısaltılmış gün adı
  ///
  /// In tr, this message translates to:
  /// **'Sal'**
  String get calendarWeekdayShortTue;

  /// Takvim ekranındaki hafta günleri başlığında kullanılan kısaltılmış gün adı
  ///
  /// In tr, this message translates to:
  /// **'Çar'**
  String get calendarWeekdayShortWed;

  /// Takvim ekranındaki hafta günleri başlığında kullanılan kısaltılmış gün adı
  ///
  /// In tr, this message translates to:
  /// **'Per'**
  String get calendarWeekdayShortThu;

  /// Takvim ekranındaki hafta günleri başlığında kullanılan kısaltılmış gün adı
  ///
  /// In tr, this message translates to:
  /// **'Cum'**
  String get calendarWeekdayShortFri;

  /// Takvim ekranındaki hafta günleri başlığında kullanılan kısaltılmış gün adı
  ///
  /// In tr, this message translates to:
  /// **'Cmt'**
  String get calendarWeekdayShortSat;

  /// Takvim ekranındaki hafta günleri başlığında kullanılan kısaltılmış gün adı
  ///
  /// In tr, this message translates to:
  /// **'Paz'**
  String get calendarWeekdayShortSun;

  /// Takvim ekranındaki seçili gün panelinde kullanılan tam gün adı
  ///
  /// In tr, this message translates to:
  /// **'Pazartesi'**
  String get calendarWeekdayFullMonday;

  /// Takvim ekranındaki seçili gün panelinde kullanılan tam gün adı
  ///
  /// In tr, this message translates to:
  /// **'Salı'**
  String get calendarWeekdayFullTuesday;

  /// Takvim ekranındaki seçili gün panelinde kullanılan tam gün adı
  ///
  /// In tr, this message translates to:
  /// **'Çarşamba'**
  String get calendarWeekdayFullWednesday;

  /// Takvim ekranındaki seçili gün panelinde kullanılan tam gün adı
  ///
  /// In tr, this message translates to:
  /// **'Perşembe'**
  String get calendarWeekdayFullThursday;

  /// Takvim ekranındaki seçili gün panelinde kullanılan tam gün adı
  ///
  /// In tr, this message translates to:
  /// **'Cuma'**
  String get calendarWeekdayFullFriday;

  /// Takvim ekranındaki seçili gün panelinde kullanılan tam gün adı
  ///
  /// In tr, this message translates to:
  /// **'Cumartesi'**
  String get calendarWeekdayFullSaturday;

  /// Takvim ekranındaki seçili gün panelinde kullanılan tam gün adı
  ///
  /// In tr, this message translates to:
  /// **'Pazar'**
  String get calendarWeekdayFullSunday;

  /// Kategori/klasör kilidi için yanlış parola girildiğinde gösterilen uyarı diyaloğunun başlığı
  ///
  /// In tr, this message translates to:
  /// **'Hatalı Parola'**
  String get wrongPasswordDialogTitle;

  /// Kategori/klasör kilidi için yanlış parola girildiğinde gösterilen uyarı diyaloğunun içerik metni
  ///
  /// In tr, this message translates to:
  /// **'Girdiğiniz parola yanlış.'**
  String get wrongPasswordDialogMessage;

  /// Genel amaçlı onay/kapatma butonu metni (birden fazla diyalogda ortak kullanılır)
  ///
  /// In tr, this message translates to:
  /// **'Tamam'**
  String get commonOkButton;

  /// Kategori/klasör seçenekleri menüsünde, kilitli bir klasörün kilidini kaldırma seçeneği
  ///
  /// In tr, this message translates to:
  /// **'Kilidi Kaldır'**
  String get unlockCategoryAction;

  /// Kategori/klasör seçenekleri menüsünde, kilitli olmayan bir klasörü kilitleme seçeneği
  ///
  /// In tr, this message translates to:
  /// **'Kilitle'**
  String get lockCategoryAction;

  /// Bir klasörün kilidi kaldırıldığında gösterilen kısa bilgi mesajı (info bar)
  ///
  /// In tr, this message translates to:
  /// **'Kilit kaldırıldı'**
  String get categoryUnlockedMessage;

  /// Bir klasör kilitlendiğinde gösterilen kısa bilgi mesajı (info bar)
  ///
  /// In tr, this message translates to:
  /// **'Klasör kilitlendi'**
  String get categoryLockedMessage;

  /// Kategori/klasör seçenekleri alt menüsünde, klasörü silme seçeneğinin etiketi
  ///
  /// In tr, this message translates to:
  /// **'Klasörü Sil'**
  String get deleteFolderMenuItemLabel;

  /// Klasör silme onay diyaloğunun başlığı
  ///
  /// In tr, this message translates to:
  /// **'Klasörü Sil'**
  String get deleteFolderDialogTitle;

  /// Alt klasörleri olan bir üst düzey klasör silinirken gösterilen onay mesajı
  ///
  /// In tr, this message translates to:
  /// **'\"{category}\" klasörünü ve içindeki tüm alt klasörleri silmek istediğinize emin misiniz? Bu klasörlerdeki notlar klasörsüz kalacak.'**
  String deleteFolderDialogMessageWithSubfolders(String category);

  /// Alt klasörü olmayan bir klasör (veya bir alt klasör) silinirken gösterilen onay mesajı
  ///
  /// In tr, this message translates to:
  /// **'\"{category}\" klasörünü silmek istediğinize emin misiniz? Bu klasördeki notlar klasörsüz kalacak.'**
  String deleteFolderDialogMessage(String category);

  /// Klasör silme onay diyaloğundaki iptal butonu
  ///
  /// In tr, this message translates to:
  /// **'İptal'**
  String get deleteFolderDialogCancelButton;

  /// Klasör silme onay diyaloğundaki, silmeyi onaylayan buton
  ///
  /// In tr, this message translates to:
  /// **'Sil'**
  String get deleteFolderDialogConfirmButton;

  /// Kategori/klasör seçenekleri menüsünde, klasörün adını ve rengini düzenleme seçeneğinin etiketi
  ///
  /// In tr, this message translates to:
  /// **'Adını Düzenle / Renk'**
  String get editCategoryNameColorMenuItemLabel;

  /// Kategori/klasör seçenekleri menüsünde, yalnızca üst seviye klasörlerde gösterilen alt klasör oluşturma seçeneğinin etiketi
  ///
  /// In tr, this message translates to:
  /// **'Alt Klasör Oluştur'**
  String get addSubfolderMenuItemLabel;

  /// Kategori/klasör seçenekleri menüsünde, daraltılmış alt klasörleri genişletme seçeneğinin etiketi
  ///
  /// In tr, this message translates to:
  /// **'Alt Klasörleri Genişlet'**
  String get expandSubfoldersMenuItemLabel;

  /// Kategori/klasör seçenekleri menüsünde, genişletilmiş alt klasörleri daraltma seçeneğinin etiketi
  ///
  /// In tr, this message translates to:
  /// **'Alt Klasörleri Daralt'**
  String get collapseSubfoldersMenuItemLabel;

  /// Veriler veritabanına kaydedilirken bir hata oluştuğunda kullanıcıya gösterilen bilgi çubuğu mesajı
  ///
  /// In tr, this message translates to:
  /// **'Kayıt hatası: {error}'**
  String saveErrorInfoMessage(String error);

  /// Uygulama ilk kez açıldığında otomatik eklenen örnek hoş geldin notunun başlığı
  ///
  /// In tr, this message translates to:
  /// **'Layout\'a Hoş Geldiniz! 🚀'**
  String get welcomeNoteTitle;

  /// Uygulama ilk kez açıldığında otomatik eklenen örnek hoş geldin notunun içeriği
  ///
  /// In tr, this message translates to:
  /// **'Yeni özellikler eklendi!'**
  String get welcomeNoteContent;

  /// Not listesinde, tarihe göre sıralamada bugüne ait notların üstünde gösterilen grup başlığı
  ///
  /// In tr, this message translates to:
  /// **'Bugün'**
  String get noteListDateGroupToday;

  /// Not listesinde, tarihe göre sıralamada düne ait notların üstünde gösterilen grup başlığı
  ///
  /// In tr, this message translates to:
  /// **'Dün'**
  String get noteListDateGroupYesterday;

  /// Not listesinde, son 7 gün içindeki (bugün/dün hariç) notların üstünde gösterilen grup başlığı
  ///
  /// In tr, this message translates to:
  /// **'Son 7 Gün'**
  String get noteListDateGroupLast7Days;

  /// Not listesinde, son 30 gün içindeki notların üstünde gösterilen grup başlığı
  ///
  /// In tr, this message translates to:
  /// **'Son 30 Gün'**
  String get noteListDateGroupLast30Days;

  /// Hatırlatıcı tekrar seçeneği 'yok' olduğunda gösterilen etiket
  ///
  /// In tr, this message translates to:
  /// **'Tekrar yok'**
  String get reminderRepeatNoneLabel;

  /// Ses kaydı sheet'inde, kayıt henüz başlamadan (mikrofon hazırlanırken) gösterilen geçici süre etiketi
  ///
  /// In tr, this message translates to:
  /// **'Hazırlanıyor…'**
  String get voiceRecorderPreparingLabel;

  /// Ses kaydı sheet'inde kaydı iptal edip yarım kalan dosyayı silen buton
  ///
  /// In tr, this message translates to:
  /// **'İptal'**
  String get voiceRecorderCancelButton;

  /// Ses kaydı sheet'inde kaydı bitirip dosyayı not ekine ekleyen buton
  ///
  /// In tr, this message translates to:
  /// **'Durdur ve Ekle'**
  String get voiceRecorderStopAddButton;

  /// Sesi yazıya çevir sheet'inde mikrofon izni verilmediğinde gösterilen hata mesajı
  ///
  /// In tr, this message translates to:
  /// **'Mikrofon izni verilmedi.'**
  String get speechToTextMicPermissionDeniedMessage;

  /// Sesi yazıya çevir sheet'inde cihaz ses tanımayı desteklemediğinde gösterilen hata mesajı
  ///
  /// In tr, this message translates to:
  /// **'Bu cihazda ses tanıma özelliği kullanılamıyor.'**
  String get speechToTextUnavailableMessage;

  /// Sesi yazıya çevir sheet'inde dinleme henüz başlamadan gösterilen durum etiketi
  ///
  /// In tr, this message translates to:
  /// **'Hazırlanıyor…'**
  String get speechToTextPreparingLabel;

  /// Sesi yazıya çevir sheet'inde aktif olarak dinlenirken gösterilen durum etiketi
  ///
  /// In tr, this message translates to:
  /// **'Dinleniyor…'**
  String get speechToTextListeningLabel;

  /// Sesi yazıya çevir sheet'inde henüz hiçbir kelime tanınmamışken gösterilen yer tutucu metin
  ///
  /// In tr, this message translates to:
  /// **'Konuşmaya başlayın…'**
  String get speechToTextStartSpeakingPlaceholder;

  /// Sesi yazıya çevir sheet'inde dinlemeyi iptal edip metni atan buton
  ///
  /// In tr, this message translates to:
  /// **'İptal'**
  String get speechToTextCancelButton;

  /// Sesi yazıya çevir sheet'inde dinlemeyi bitirip tanınan metni not içeriğine ekleyen buton
  ///
  /// In tr, this message translates to:
  /// **'Durdur ve Ekle'**
  String get speechToTextStopAddButton;

  /// Sesli okuma sheet'i açıldığında okunacak metin boş olduğunda gösterilen hata mesajı
  ///
  /// In tr, this message translates to:
  /// **'Okunacak bir içerik yok.'**
  String get textToSpeechNoContentMessage;

  /// Sesli okuma sheet'inde okuma motoru hata bildirdiğinde gösterilen hata mesajı
  ///
  /// In tr, this message translates to:
  /// **'Okuma sırasında bir hata oluştu.'**
  String get textToSpeechReadErrorMessage;

  /// Sesli okuma sheet'inde cihaz sesli okumayı başlatamadığında gösterilen hata mesajı
  ///
  /// In tr, this message translates to:
  /// **'Bu cihazda sesli okuma özelliği kullanılamıyor.'**
  String get textToSpeechUnavailableMessage;

  /// Sesli okuma sheet'inde okuma motoru henüz hazırlanırken gösterilen durum etiketi
  ///
  /// In tr, this message translates to:
  /// **'Hazırlanıyor…'**
  String get textToSpeechPreparingLabel;

  /// Sesli okuma sheet'inde okuma duraklatıldığında gösterilen durum etiketi
  ///
  /// In tr, this message translates to:
  /// **'Duraklatıldı'**
  String get textToSpeechPausedLabel;

  /// Sesli okuma sheet'inde metnin tamamı okunduğunda gösterilen durum etiketi
  ///
  /// In tr, this message translates to:
  /// **'Okuma tamamlandı'**
  String get textToSpeechFinishedLabel;

  /// Sesli okuma sheet'inde okuma aktif olarak devam ederken gösterilen durum etiketi
  ///
  /// In tr, this message translates to:
  /// **'Okunuyor…'**
  String get textToSpeechReadingLabel;

  /// Sesli okuma sheet'inde hata durumunda sheet'i kapatan buton
  ///
  /// In tr, this message translates to:
  /// **'Kapat'**
  String get textToSpeechCloseErrorButton;

  /// Sesli okuma sheet'inde okuma bittiğinde metni baştan tekrar okutan buton
  ///
  /// In tr, this message translates to:
  /// **'Tekrar Oku'**
  String get textToSpeechReplayButton;

  /// Sesli okuma sheet'inde okuma bittiğinde sheet'i kapatan buton
  ///
  /// In tr, this message translates to:
  /// **'Kapat'**
  String get textToSpeechCloseFinishedButton;

  /// Sesli okuma sheet'inde okuma devam ederken duraklatan buton
  ///
  /// In tr, this message translates to:
  /// **'Duraklat'**
  String get textToSpeechPauseButton;

  /// Sesli okuma sheet'inde okuma duraklatılmışken devam ettiren buton
  ///
  /// In tr, this message translates to:
  /// **'Devam Et'**
  String get textToSpeechResumeButton;

  /// Sesli okuma sheet'inde okumayı durdurup sheet'i kapatan buton
  ///
  /// In tr, this message translates to:
  /// **'Durdur'**
  String get textToSpeechStopButton;

  /// Sesli okuma sheet'inde okuma hızını yavaş olarak seçen hız çipi
  ///
  /// In tr, this message translates to:
  /// **'Yavaş'**
  String get textToSpeechSpeedSlow;

  /// Sesli okuma sheet'inde okuma hızını normal olarak seçen hız çipi
  ///
  /// In tr, this message translates to:
  /// **'Normal'**
  String get textToSpeechSpeedNormal;

  /// Sesli okuma sheet'inde okuma hızını hızlı olarak seçen hız çipi
  ///
  /// In tr, this message translates to:
  /// **'Hızlı'**
  String get textToSpeechSpeedFast;

  /// Takvim tarih seçici dialogunda vazgeç butonu (hem sistem hem özel versiyon)
  ///
  /// In tr, this message translates to:
  /// **'Vazgeç'**
  String get calendarPickerCancelButton;

  /// Takvim tarih seçici dialogunda seçilen tarihi onaylayan buton (hem sistem hem özel versiyon)
  ///
  /// In tr, this message translates to:
  /// **'Seç'**
  String get calendarPickerConfirmButton;

  /// Özel takvim dialogunda (showClearOption:true), zaten atanmış bir tarihi kaldırmak için kullanılan buton
  ///
  /// In tr, this message translates to:
  /// **'İptal'**
  String get calendarPickerClearButton;

  /// Hatırlatıcı ekleme/düzenleme dialogunun başlığı
  ///
  /// In tr, this message translates to:
  /// **'Hatırlatıcı ekle'**
  String get reminderPickerDialogTitle;

  /// Hatırlatıcı dialogunda tarih seçimi açılır menüsündeki 'bugün' seçeneği
  ///
  /// In tr, this message translates to:
  /// **'Bugün'**
  String get reminderPickerDateTodayOption;

  /// Hatırlatıcı dialogunda tarih seçimi açılır menüsündeki 'yarın' seçeneği
  ///
  /// In tr, this message translates to:
  /// **'Yarın'**
  String get reminderPickerDateTomorrowOption;

  /// Hatırlatıcı dialogunda tarih seçimi açılır menüsündeki 'takvimden seç' seçeneği
  ///
  /// In tr, this message translates to:
  /// **'Tarih seç'**
  String get reminderPickerDatePickOption;

  /// Hatırlatıcı dialogunda tekrar seçimi açılır menüsündeki 'her saat' seçeneği
  ///
  /// In tr, this message translates to:
  /// **'Her saat'**
  String get reminderRepeatHourlyLabel;

  /// Hatırlatıcı dialogunda tekrar seçimi açılır menüsündeki 'her gün' seçeneği
  ///
  /// In tr, this message translates to:
  /// **'Her gün'**
  String get reminderRepeatDailyLabel;

  /// Hatırlatıcı dialogunda tekrar seçimi açılır menüsündeki 'her hafta' seçeneği
  ///
  /// In tr, this message translates to:
  /// **'Her hafta'**
  String get reminderRepeatWeeklyLabel;

  /// Hatırlatıcı dialogunda tekrar seçimi açılır menüsündeki 'her ay' seçeneği
  ///
  /// In tr, this message translates to:
  /// **'Her ay'**
  String get reminderRepeatMonthlyLabel;

  /// Hatırlatıcı dialogunda tekrar seçimi açılır menüsündeki 'her yıl' seçeneği
  ///
  /// In tr, this message translates to:
  /// **'Her yıl'**
  String get reminderRepeatYearlyLabel;

  /// Hatırlatıcı dialogunda 'Tarih seç' seçilince açılan takvim dialogunun başlık metni (helpText)
  ///
  /// In tr, this message translates to:
  /// **'Hatırlatma tarihi seç'**
  String get reminderPickerCalendarHelpText;

  /// Hatırlatıcı ekleme dialogunun alt kısmındaki vazgeç butonu
  ///
  /// In tr, this message translates to:
  /// **'İPTAL'**
  String get reminderPickerCancelButton;

  /// Hatırlatıcı ekleme dialogunun alt kısmındaki kaydet butonu
  ///
  /// In tr, this message translates to:
  /// **'KAYDET'**
  String get reminderPickerSaveButton;

  /// Hatırlatıcı tekrar seçeneği yokken geçmiş bir tarih/saat seçilip kaydedilmeye çalışıldığında gösterilen snackbar hata mesajı
  ///
  /// In tr, this message translates to:
  /// **'Geçmiş bir zaman seçilemez'**
  String get reminderPickerPastTimeErrorMessage;

  /// Hesap tablosu bloğunun toplam satırının; arama, kopyalama, paylaşma ve önizleme metinlerinde gösterilen etiketi
  ///
  /// In tr, this message translates to:
  /// **'Toplam: {amount}'**
  String calcTableTotalLabel(String amount);

  /// Yedek oluşturma işlemi başladığında gösterilen ilerleme mesajı
  ///
  /// In tr, this message translates to:
  /// **'Veriler hazırlanıyor...'**
  String get backupCreatePreparingDataLabel;

  /// Yedek oluşturma sırasında not ve kategori verileri paketlenirken gösterilen ilerleme mesajı
  ///
  /// In tr, this message translates to:
  /// **'Notlar ve kategoriler paketleniyor...'**
  String get backupCreatePackagingNotesLabel;

  /// Yedek oluşturma sırasında ek dosyalar okunmaya başlarken gösterilen ilerleme mesajı
  ///
  /// In tr, this message translates to:
  /// **'Ek dosyalar okunuyor...'**
  String get backupCreateReadingAttachmentsLabel;

  /// Yedek oluşturma sırasında ek dosyalar tek tek okunurken gösterilen sayaçlı ilerleme mesajı
  ///
  /// In tr, this message translates to:
  /// **'Ek dosyalar okunuyor... ({current}/{total})'**
  String backupCreateReadingAttachmentsProgressLabel(int current, int total);

  /// Yedek oluşturma sırasında veriler zip dosyasına sıkıştırılırken gösterilen ilerleme mesajı
  ///
  /// In tr, this message translates to:
  /// **'Zip dosyası sıkıştırılıyor...'**
  String get backupCreateCompressingLabel;

  /// Yedek oluşturma sırasında zip dosyası cihaza kaydedilirken gösterilen ilerleme mesajı
  ///
  /// In tr, this message translates to:
  /// **'Dosya kaydediliyor...'**
  String get backupCreateSavingFileLabel;

  /// Yedek geri yükleme işlemi başladığında gösterilen ilerleme mesajı
  ///
  /// In tr, this message translates to:
  /// **'Yedek doğrulanıyor...'**
  String get backupRestoreValidatingLabel;

  /// Yedek dosyası doğrulandıktan sonra, verilerin yazılmasına başlanmadan önce gösterilen ilerleme mesajı
  ///
  /// In tr, this message translates to:
  /// **'Yedek doğrulandı, veriler hazırlanıyor...'**
  String get backupRestoreValidatedPreparingDataLabel;

  /// Geri yükleme sırasında notlar veritabanına yazılırken gösterilen ilerleme mesajı
  ///
  /// In tr, this message translates to:
  /// **'Notlar yazılıyor...'**
  String get backupRestoreWritingNotesLabel;

  /// Geri yükleme sırasında çöp kutusundaki (silinmiş) notlar veritabanına yazılırken gösterilen ilerleme mesajı
  ///
  /// In tr, this message translates to:
  /// **'Çöp kutusu yazılıyor...'**
  String get backupRestoreWritingTrashLabel;

  /// Geri yükleme sırasında çöp kutusu yazma işlemi tamamlandığında gösterilen ilerleme mesajı
  ///
  /// In tr, this message translates to:
  /// **'Çöp kutusu yazıldı'**
  String get backupRestoreTrashWrittenLabel;

  /// Geri yükleme sırasında kategoriler ve renkleri veritabanına yazılırken gösterilen ilerleme mesajı
  ///
  /// In tr, this message translates to:
  /// **'Kategoriler yazılıyor...'**
  String get backupRestoreWritingCategoriesLabel;

  /// Geri yükleme sırasında kategori yazma işlemi tamamlandığında gösterilen ilerleme mesajı
  ///
  /// In tr, this message translates to:
  /// **'Kategoriler yazıldı'**
  String get backupRestoreCategoriesWrittenLabel;

  /// Geri yükleme sırasında uygulama ayarları veritabanına yazılırken gösterilen ilerleme mesajı
  ///
  /// In tr, this message translates to:
  /// **'Ayarlar yazılıyor...'**
  String get backupRestoreWritingSettingsLabel;

  /// Geri yükleme sırasında ayar yazma işlemi tamamlandığında gösterilen ilerleme mesajı
  ///
  /// In tr, this message translates to:
  /// **'Ayarlar yazıldı'**
  String get backupRestoreSettingsWrittenLabel;

  /// Geri yükleme sırasında, yeni ekler yazılmadan önce cihazdaki eski ek dosyalar silinirken gösterilen ilerleme mesajı
  ///
  /// In tr, this message translates to:
  /// **'Eski ek dosyalar temizleniyor...'**
  String get backupRestoreCleaningOldAttachmentsLabel;

  /// Geri yüklenen yedekte hiç ek dosya yoksa, işlem tamamlanmadan hemen önce gösterilen ilerleme mesajı
  ///
  /// In tr, this message translates to:
  /// **'Ek dosya bulunmuyor, tamamlanıyor...'**
  String get backupRestoreNoAttachmentsFinishingLabel;

  /// Geri yükleme sırasında ek dosyalar tek tek diske yazılırken gösterilen sayaçlı ilerleme mesajı
  ///
  /// In tr, this message translates to:
  /// **'Ekler geri yükleniyor... ({current}/{total})'**
  String backupRestoreAttachmentsProgressLabel(int current, int total);

  /// Yedek geri yükleme işlemi tamamen bittiğinde gösterilen son ilerleme mesajı
  ///
  /// In tr, this message translates to:
  /// **'Tamamlandı'**
  String get backupRestoreCompletedLabel;

  /// Seçilen zip dosyası açılamadığında (bozuk arşiv) gösterilen hata mesajı
  ///
  /// In tr, this message translates to:
  /// **'Dosya bozuk veya geçerli bir yedek dosyası değil.'**
  String get backupValidationCorruptedFileMessage;

  /// Zip arşivi içinde backup_data.json dosyası bulunamadığında gösterilen hata mesajı
  ///
  /// In tr, this message translates to:
  /// **'Yedek dosyası içinde veri bulunamadı (backup_data.json eksik).'**
  String get backupValidationMissingDataMessage;

  /// backup_data.json içeriği geçerli JSON olarak çözümlenemediğinde gösterilen hata mesajı
  ///
  /// In tr, this message translates to:
  /// **'Yedek verisi okunamadı (bozuk JSON).'**
  String get backupValidationInvalidJsonMessage;

  /// Yedek verisindeki appName alanı 'layout' değilse gösterilen hata mesajı
  ///
  /// In tr, this message translates to:
  /// **'Bu dosya layout uygulamasına ait bir yedek değil.'**
  String get backupValidationNotDnoteBackupMessage;

  /// Yedek verisindeki formatVersion alanı sayı olarak okunamadığında gösterilen hata mesajı
  ///
  /// In tr, this message translates to:
  /// **'Yedek dosyasının sürüm bilgisi okunamadı.'**
  String get backupValidationVersionUnreadableMessage;

  /// Yedeğin formatVersion değeri uygulamanın desteklediği en yüksek sürümden büyükse gösterilen hata mesajı
  ///
  /// In tr, this message translates to:
  /// **'Bu yedek, uygulamanın şu anki sürümünün desteklemediği daha yeni bir formatta. Lütfen uygulamayı güncelleyin.'**
  String get backupValidationIncompatibleVersionMessage;

  /// Yedeğin formatVersion değeri 1'den küçükse (geçersiz) gösterilen hata mesajı
  ///
  /// In tr, this message translates to:
  /// **'Yedek dosyasının sürüm bilgisi geçersiz.'**
  String get backupValidationInvalidVersionMessage;

  /// Yedek verisindeki notes alanı liste değilse gösterilen hata mesajı
  ///
  /// In tr, this message translates to:
  /// **'Yedek verisi beklenen formatta değil (notlar alanı eksik).'**
  String get backupValidationMissingNotesFieldMessage;

  /// Yedek verisindeki deletedNotes (çöp kutusu) alanı liste değilse gösterilen hata mesajı
  ///
  /// In tr, this message translates to:
  /// **'Yedek verisi beklenen formatta değil (çöp kutusu alanı eksik).'**
  String get backupValidationMissingTrashFieldMessage;

  /// Yedek verisindeki categories alanı geçerli bir string listesi değilse gösterilen hata mesajı
  ///
  /// In tr, this message translates to:
  /// **'Yedek verisi beklenen formatta değil (kategori listesi geçersiz).'**
  String get backupValidationInvalidCategoriesFieldMessage;

  /// Yedek verisindeki settings alanı dolu ama Map değilse gösterilen hata mesajı
  ///
  /// In tr, this message translates to:
  /// **'Yedek verisi beklenen formatta değil (ayarlar alanı geçersiz).'**
  String get backupValidationInvalidSettingsFieldMessage;

  /// notes veya deletedNotes listesindeki bir öğe Map (obje) değilse gösterilen hata mesajı
  ///
  /// In tr, this message translates to:
  /// **'Yedek verisi beklenen formatta değil (bir not kaydı geçersiz).'**
  String get backupValidationInvalidNoteRecordMessage;

  /// Bir not kaydının id alanı boş veya eksikse gösterilen hata mesajı
  ///
  /// In tr, this message translates to:
  /// **'Yedek verisi beklenen formatta değil (kimliksiz bir not kaydı bulundu).'**
  String get backupValidationMissingNoteIdMessage;

  /// Geri yüklenmek istenen zip dosyası cihazda bulunamadığında gösterilen hata mesajı
  ///
  /// In tr, this message translates to:
  /// **'Yedek dosyası bulunamadı.'**
  String get backupValidationFileNotFoundMessage;

  /// Yedekleme/geri yükleme sırasında cihazda disk alanı yetersiz kaldığında gösterilen hata mesajı
  ///
  /// In tr, this message translates to:
  /// **'Cihazda yeterli boş depolama alanı yok. Lütfen yer açıp tekrar deneyin.'**
  String get backupErrorInsufficientStorageMessage;

  /// Dosya sistemi işlemi izin hatasıyla (permission denied) başarısız olduğunda gösterilen hata mesajı
  ///
  /// In tr, this message translates to:
  /// **'Dosya erişim izni reddedildi. Lütfen uygulama izinlerini kontrol edip tekrar deneyin.'**
  String get backupErrorPermissionDeniedMessage;

  /// Beklenmeyen bir FileSystemException oluştuğunda, sistem hatasının detayıyla birlikte gösterilen mesaj
  ///
  /// In tr, this message translates to:
  /// **'Dosya işlemi sırasında bir hata oluştu: {detail}'**
  String backupErrorFileOperationMessage(String detail);

  /// Yedekleme/geri yükleme sırasında sınıflandırılamayan bir hata oluştuğunda gösterilen genel mesaj
  ///
  /// In tr, this message translates to:
  /// **'Beklenmeyen bir hata oluştu: {detail}'**
  String backupErrorUnexpectedMessage(String detail);

  /// Yedek oluşturulurken zip kodlama işlemi beklenmedik şekilde null döndürdüğünde gösterilen hata mesajı
  ///
  /// In tr, this message translates to:
  /// **'Zip arşivi oluşturulamadı (ZipEncoder null döndürdü).'**
  String get backupErrorZipEncodeFailedMessage;

  /// No description provided for @calcTableMenuItemLabel.
  ///
  /// In tr, this message translates to:
  /// **'Hesap Listesi'**
  String get calcTableMenuItemLabel;

  /// No description provided for @tagsMenuItemLabel.
  ///
  /// In tr, this message translates to:
  /// **'Etiketler'**
  String get tagsMenuItemLabel;

  /// No description provided for @linkDialogUrlHint.
  ///
  /// In tr, this message translates to:
  /// **'https://ornek.com'**
  String get linkDialogUrlHint;

  /// Checklist bloğunda bir maddenin metin alanı boşken gösterilen hint metni
  ///
  /// In tr, this message translates to:
  /// **'Madde ekle...'**
  String get checklistItemHint;

  /// No description provided for @toolbarHighlightTooltip.
  ///
  /// In tr, this message translates to:
  /// **'Vurgula'**
  String get toolbarHighlightTooltip;

  /// No description provided for @toolbarListTooltip.
  ///
  /// In tr, this message translates to:
  /// **'Liste'**
  String get toolbarListTooltip;

  /// No description provided for @toolbarHideKeyboardTooltip.
  ///
  /// In tr, this message translates to:
  /// **'Klavyeyi Gizle'**
  String get toolbarHideKeyboardTooltip;

  /// Arka plan otomatik yedekleme görevinde yerel yedekleme başarıyla tamamlandığında durum mesajına eklenen metin
  ///
  /// In tr, this message translates to:
  /// **'Yerel yedekleme başarılı.'**
  String get autoBackupLocalSuccessMessage;

  /// Arka plan otomatik yedekleme görevinde yerel yedekleme başarısız olduğunda, hatanın detayıyla birlikte durum mesajına eklenen metin
  ///
  /// In tr, this message translates to:
  /// **'Yerel yedekleme başarısız: {detail}'**
  String autoBackupLocalFailedMessage(String detail);

  /// Arka plan otomatik yedekleme görevinde Google hesabı sessiz oturum açma ile bağlanamadığında durum mesajına eklenen metin
  ///
  /// In tr, this message translates to:
  /// **'Drive yedeklemesi atlandı: Google hesabı bağlı değil veya oturum süresi dolmuş. Lütfen uygulamayı açıp tekrar bağlanın.'**
  String get autoBackupDriveSkippedNotConnectedMessage;

  /// Arka plan otomatik yedekleme görevinde Drive yedeklemesi başarıyla tamamlandığında durum mesajına eklenen metin
  ///
  /// In tr, this message translates to:
  /// **'Drive yedeklemesi başarılı.'**
  String get autoBackupDriveSuccessMessage;

  /// Arka plan otomatik yedekleme görevinde Drive yedeklemesi başarısız olduğunda, hatanın detayıyla birlikte durum mesajına eklenen metin
  ///
  /// In tr, this message translates to:
  /// **'Drive yedeklemesi başarısız: {detail}'**
  String autoBackupDriveFailedMessage(String detail);

  /// Ana ekran widget'ında hiç görünür not yokken gösterilen placeholder başlık
  ///
  /// In tr, this message translates to:
  /// **'Henüz not yok'**
  String get noteWidgetNoNotesPlaceholder;

  /// Widget önizleme metninde hesap tablosu bloğunun toplamı gösterilirken kullanılan etiket
  ///
  /// In tr, this message translates to:
  /// **'Toplam: {total}'**
  String noteWidgetPreviewTotalLabel(String total);

  /// Widget önizleme metninde çizim bloğu varsa gösterilen etiket
  ///
  /// In tr, this message translates to:
  /// **'✏️ Çizim'**
  String get noteWidgetPreviewDrawingLabel;

  /// Otomatik yedekleme ayarları ekranının AppBar başlığı
  ///
  /// In tr, this message translates to:
  /// **'Otomatik Yedekleme Ayarları'**
  String get autoBackupSettingsAppBarTitle;

  /// Otomatik yedeklemeyi açıp kapatan ana anahtarın başlığı
  ///
  /// In tr, this message translates to:
  /// **'Otomatik Yedeklemeyi Aktif Et'**
  String get autoBackupSettingsMainSwitchTitle;

  /// Ana açma/kapatma anahtarının altında gösterilen açıklama metni
  ///
  /// In tr, this message translates to:
  /// **'Notlarınız arka planda periyodik olarak güvenle yedeklenir.'**
  String get autoBackupSettingsMainSwitchSubtitle;

  /// Yedekleme hedefi (Yerel/Drive/Her İkisi) seçim bölümünün başlığı
  ///
  /// In tr, this message translates to:
  /// **'Yedekleme Hedefi'**
  String get autoBackupSettingsTargetTitle;

  /// Yedekleme hedefi seçim bölümünün alt açıklaması
  ///
  /// In tr, this message translates to:
  /// **'Yedeklerin nereye kaydedileceğini seçin.'**
  String get autoBackupSettingsTargetSubtitle;

  /// Yedekleme hedefi segment butonunda 'Yerel' seçeneği etiketi
  ///
  /// In tr, this message translates to:
  /// **'Yerel'**
  String get autoBackupSettingsTargetLocalOption;

  /// Yedekleme hedefi segment butonunda 'Google Drive' seçeneği etiketi
  ///
  /// In tr, this message translates to:
  /// **'Google Drive'**
  String get autoBackupSettingsTargetDriveOption;

  /// Yedekleme hedefi segment butonunda 'Her İkisi' seçeneği etiketi
  ///
  /// In tr, this message translates to:
  /// **'Her İkisi'**
  String get autoBackupSettingsTargetBothOption;

  /// Google Drive bağlı değilken segment butonunun altında gösterilen açıklama notu
  ///
  /// In tr, this message translates to:
  /// **'Google Drive seçeneklerini kullanmak için önce hesabınızı bağlayın.'**
  String get autoBackupSettingsDriveNotConnectedNote;

  /// Google Drive hesabına bağlanmayı başlatan düğmenin metni
  ///
  /// In tr, this message translates to:
  /// **'Bağlan'**
  String get autoBackupSettingsConnectButton;

  /// Yedekleme sıklığı seçim bölümünün başlığı
  ///
  /// In tr, this message translates to:
  /// **'Yedekleme Sıklığı'**
  String get autoBackupSettingsFrequencyTitle;

  /// Seçili sıklığı gösteren alt açıklama metni
  ///
  /// In tr, this message translates to:
  /// **'Her {hours} saatte bir yedek alınır.'**
  String autoBackupSettingsFrequencySubtitle(int hours);

  /// Sıklık dropdown menüsünde 6 saatlik seçenek
  ///
  /// In tr, this message translates to:
  /// **'6 Saat'**
  String get autoBackupSettingsFrequency6h;

  /// Sıklık dropdown menüsünde 12 saatlik seçenek
  ///
  /// In tr, this message translates to:
  /// **'12 Saat'**
  String get autoBackupSettingsFrequency12h;

  /// Sıklık dropdown menüsünde 24 saatlik (günlük) seçenek
  ///
  /// In tr, this message translates to:
  /// **'24 Saat (Günlük)'**
  String get autoBackupSettingsFrequency24h;

  /// Sıklık dropdown menüsünde 48 saatlik (2 günlük) seçenek
  ///
  /// In tr, this message translates to:
  /// **'48 Saat (2 Gün)'**
  String get autoBackupSettingsFrequency48h;

  /// Sıklık dropdown menüsünde 168 saatlik (haftalık) seçenek
  ///
  /// In tr, this message translates to:
  /// **'168 Saat (Haftalık)'**
  String get autoBackupSettingsFrequency168h;

  /// Bulut yüklemesinin yalnızca Wi-Fi bağlantısında yapılmasını sağlayan anahtarın başlığı
  ///
  /// In tr, this message translates to:
  /// **'Sadece Wi-Fi Kullan'**
  String get autoBackupSettingsWifiOnlySwitchTitle;

  /// Sadece Wi-Fi anahtarının altında gösterilen açıklama metni
  ///
  /// In tr, this message translates to:
  /// **'Bulut yüklemesi yalnızca Wi-Fi bağlıyken yapılır mobil veriniz korunur.'**
  String get autoBackupSettingsWifiOnlySwitchSubtitle;

  /// Son otomatik yedekleme çalışmasını gösteren durum kartının başlığı
  ///
  /// In tr, this message translates to:
  /// **'Sistem Durumu'**
  String get autoBackupSettingsStatusCardTitle;

  /// Otomatik yedekleme hiç çalışmadıysa durum kartında gösterilen metin
  ///
  /// In tr, this message translates to:
  /// **'Henüz otomatik yedekleme çalışmadı.'**
  String get autoBackupSettingsNeverRunMessage;

  /// Durum kartında son otomatik yedekleme çalışmasının tarih, saat, durum ve mesajını gösteren metin
  ///
  /// In tr, this message translates to:
  /// **'Son Çalışma: {date} {time} ({status})\nMesaj: {message}'**
  String autoBackupSettingsLastRunInfo(
    String date,
    String time,
    String status,
    String message,
  );

  /// Son çalışma başarılıysa durum metninde kullanılan etiket
  ///
  /// In tr, this message translates to:
  /// **'Başarılı'**
  String get autoBackupSettingsStatusSuccessLabel;

  /// Son çalışma başarısızsa durum metninde kullanılan etiket
  ///
  /// In tr, this message translates to:
  /// **'Hatalı'**
  String get autoBackupSettingsStatusFailedLabel;

  /// Google Drive bağlantısı başarısız olduğunda gösterilen snackbar mesajı
  ///
  /// In tr, this message translates to:
  /// **'Google hesabına bağlanılamadı.'**
  String get autoBackupSettingsDriveConnectFailedSnackbar;

  /// Ayarlar kaydedildiğinde gösterilen snackbar mesajı
  ///
  /// In tr, this message translates to:
  /// **'Otomatik yedekleme ayarları güncellendi.'**
  String get autoBackupSettingsSavedSnackbar;

  /// Not listesi çoklu seçim modunda, seçili notlar toplu olarak silindiğinde gösterilen bilgi çubuğu mesajı
  ///
  /// In tr, this message translates to:
  /// **'{count} not silindi'**
  String selectionModeDeletedMessage(int count);

  /// Not listesi çoklu seçim modunda, seçili notlar toplu olarak arşivlendiğinde gösterilen bilgi çubuğu mesajı
  ///
  /// In tr, this message translates to:
  /// **'Arşivlendi'**
  String get selectionModeArchivedMessage;

  /// Çoklu seçimdeki notlara toplu kategori atamak için açılan alt menünün (bottom sheet) başlığı
  ///
  /// In tr, this message translates to:
  /// **'{count} not için kategori seç'**
  String selectionModeClassifySheetTitle(int count);

  /// Çoklu seçim kategori atama sheet'inde yeni kategori oluşturma seçeneğinin etiketi
  ///
  /// In tr, this message translates to:
  /// **'Kategori Ekle'**
  String get selectionModeAddCategoryOption;

  /// Çoklu seçim kategori atama sheet'inde, seçili notlardan kategori atamasını kaldıran seçeneğin etiketi
  ///
  /// In tr, this message translates to:
  /// **'Kategoriyi Kaldır'**
  String get selectionModeRemoveCategoryOption;

  /// Hesap tablosu bloğunda bir satırın 'Kalem' (etiket) alanı boşken gösterilen hint metni
  ///
  /// In tr, this message translates to:
  /// **'Kalem...'**
  String get calcTableItemHint;

  /// Hesap tablosu bloğunun gömülü not düzenleyicisindeki toplam satırının etiketi
  ///
  /// In tr, this message translates to:
  /// **'Toplam'**
  String get calcTableTotalRowLabel;

  /// Özel metin seçim menüsünde seçili metni paylaşma düğmesinin etiketi
  ///
  /// In tr, this message translates to:
  /// **'Paylaş'**
  String get textSelectionMenuShareButton;

  /// Özel metin seçim menüsünde seçili metni Google Çeviri'de açma düğmesinin etiketi
  ///
  /// In tr, this message translates to:
  /// **'Çevir'**
  String get textSelectionMenuTranslateButton;

  /// Seçili metin paylaşımı başlatılamadığında gösterilen snackbar mesajı
  ///
  /// In tr, this message translates to:
  /// **'Paylaşım başlatılamadı.'**
  String get textSelectionMenuShareFailedSnackbar;

  /// Seçili metin için çeviri sayfası açılamadığında gösterilen snackbar mesajı
  ///
  /// In tr, this message translates to:
  /// **'Çeviri açılamadı.'**
  String get textSelectionMenuTranslateFailedSnackbar;

  /// Son yedekleme bilgisi widget'ında, yedek bugün alınmışsa saatin önüne eklenen önek
  ///
  /// In tr, this message translates to:
  /// **'Bugün {time}'**
  String lastBackupInfoTodayFormat(String time);

  /// Son yedekleme bilgisi widget'ında, yedek bugün alınmamışsa gösterilen tarih ve saat formatı
  ///
  /// In tr, this message translates to:
  /// **'{day}.{month}.{year} {time}'**
  String lastBackupInfoDateFormat(
    String day,
    String month,
    int year,
    String time,
  );

  /// Son yedekleme bilgisi widget'ında, en az bir yedek varsa gösterilen ana metin
  ///
  /// In tr, this message translates to:
  /// **'Son yedekleme: {date}'**
  String lastBackupInfoLabel(String date);

  /// Son yedekleme bilgisi widget'ında hiç yedek alınmamışsa gösterilen metin
  ///
  /// In tr, this message translates to:
  /// **'Henüz hiç yedek alınmadı.'**
  String get lastBackupInfoNoBackupMessage;

  /// No description provided for @backupFileNameLabel.
  ///
  /// In tr, this message translates to:
  /// **'Yedek'**
  String get backupFileNameLabel;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'ar',
    'cs',
    'da',
    'de',
    'en',
    'es',
    'fi',
    'fr',
    'he',
    'hi',
    'id',
    'it',
    'ja',
    'ko',
    'nl',
    'no',
    'pl',
    'pt',
    'ro',
    'ru',
    'sv',
    'th',
    'tr',
    'uk',
    'vi',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'cs':
      return AppLocalizationsCs();
    case 'da':
      return AppLocalizationsDa();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fi':
      return AppLocalizationsFi();
    case 'fr':
      return AppLocalizationsFr();
    case 'he':
      return AppLocalizationsHe();
    case 'hi':
      return AppLocalizationsHi();
    case 'id':
      return AppLocalizationsId();
    case 'it':
      return AppLocalizationsIt();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'nl':
      return AppLocalizationsNl();
    case 'no':
      return AppLocalizationsNo();
    case 'pl':
      return AppLocalizationsPl();
    case 'pt':
      return AppLocalizationsPt();
    case 'ro':
      return AppLocalizationsRo();
    case 'ru':
      return AppLocalizationsRu();
    case 'sv':
      return AppLocalizationsSv();
    case 'th':
      return AppLocalizationsTh();
    case 'tr':
      return AppLocalizationsTr();
    case 'uk':
      return AppLocalizationsUk();
    case 'vi':
      return AppLocalizationsVi();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
