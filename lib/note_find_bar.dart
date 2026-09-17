part of 'main.dart';

// NOT: Bu dosya main.dart'a yeni bir part olarak eklenir. main.dart'taki
// diğer 'part' satırlarının yanına şu satırın eklenmesi gerekir:
//   part 'note_find_bar.dart';
// (Bu ekleme Aşama 6'da dialog mixin entegrasyonuyla birlikte yapılabilir;
// bu dosyanın kendisi tek başına derlenemez, main.dart'a bağlıdır.)
//
// NOT (l10n): Aşağıda kullanılan AppLocalizations anahtarları henüz
// mevcut .arb dosyalarında YOKTUR, eklenmesi gerekir (bkz. NoteChecklistBlock
// içindeki 'checklistItemHint' ile aynı desen):
//   findSearchHint            → "Ara" gibi bir yer tutucu.
//   findReplaceHint           → "Değiştir" alanı için yer tutucu.
//   findReplaceButton         → "Değiştir" buton etiketi.
//   findReplaceAllButton      → "Tümünü Değiştir" buton etiketi.
//   findPreviousTooltip       → "Önceki eşleşme" ipucu.
//   findNextTooltip           → "Sonraki eşleşme" ipucu.
//   findShowReplaceTooltip    → "Değiştir alanını göster" ipucu.
//   findHideReplaceTooltip    → "Değiştir alanını gizle" ipucu.
//   findCloseTooltip          → "Bul modunu kapat" ipucu.

/// Not editörü içi "Bul ve Değiştir" özelliğinin klavye-üstü sabit barı.
///
/// NoteChecklistBlock gibi saf sunumdan sorumludur: hiçbir arama/değiştirme
/// MANTIĞI içermez, NoteFindSession'ı (bkz. note_find_session.dart, Aşama 3)
/// hiç bilmez — sadece kendisine verilen [matchCount]/[activeIndex] gibi
/// anlık durumu çizer ve kullanıcı etkileşimlerini callback'ler üzerinden
/// dışarı iletir. Gerçek bağlanma (sorgu değiştiğinde NoteFindSession.
/// setQuery çağrılması, ↑/↓'de next()/previous(), vb.) Aşama 6'da dialog
/// mixin içinde kurulacak.
///
/// Konumlandırma (GÜNCEL — kullanıcı geri bildirimiyle değişti): bu widget
/// artık ekranın en alt kenarına bitişik DEĞİL; editör gövdesindeki body
/// Column'unun normal bir çocuğu olarak, zengin metin araç çubuğunun
/// (kalın/italik) kullandığı SLOTA — tarih/etiket barının hemen ÜSTÜNE —
/// yerleştirilir (bkz. note_list_note_dialog_mixin.dart, body: Column
/// içindeki ilgili if bloğu). Bu yüzden kendi başına klavye/güvenli-alan
/// boşluğu HESAPLAMAZ (eski AnimatedPadding kaldırıldı) — altındaki tarih
/// barı kendi SafeArea'sıyla, üstteki Scaffold da resizeToAvoidBottomInset:
/// true ile bunu zaten sağlıyor. Üst bar (AppBar, geri butonu, üç nokta
/// menüsü) bundan hiç etkilenmez.
///
/// [replaceExpanded] durumu bu widget'ta TUTULMAZ (Stateless) — "Değiştir"
/// alanının açık/kapalı olup olmadığına çağıran taraf karar verir ve
/// [onToggleReplaceExpanded] ile bildirilen tıklamalara göre kendi state'ini
/// günceller; NoteChecklistBlock'taki isItemRemoving deseniyle aynı fikir
/// (görünüm durumu dışarıdan enjekte edilir, widget'ın kendi state'i yok).
class NoteFindBar extends StatelessWidget {
  const NoteFindBar({
    super.key,
    required this.queryController,
    this.queryFocusNode,
    required this.replaceController,
    required this.matchCount,
    required this.activeIndex,
    required this.replaceExpanded,
    required this.onQueryChanged,
    required this.onNext,
    required this.onPrevious,
    required this.onClose,
    required this.onToggleReplaceExpanded,
    required this.onReplacePressed,
    required this.onReplaceAllPressed,
  });

  /// Arama kutusunun controller'ı. Bu widget onu OLUŞTURMAZ/dispose etmez
  /// — sahipliği çağıran tarafta (dialog mixin) kalır; böylece "Bul" modu
  /// kapanıp NoteFindBar ağaçtan kaldırılsa bile controller'ın yaşam
  /// döngüsü çağıranın elinde, tutarlı kalır.
  final TextEditingController queryController;

  /// Bar ilk açıldığında arama kutusuna otomatik odaklanmak için çağıran
  /// tarafça verilebilir (opsiyonel — null ise TextField kendi dahili
  /// FocusNode'unu kullanır, sadece "Bul" modu açılırken programatik
  /// requestFocus() çağrısına ihtiyaç yoksa yeterlidir).
  final FocusNode? queryFocusNode;

  /// "Değiştir" alanının controller'ı — sahipliği yine çağıran tarafta.
  final TextEditingController replaceController;

  /// O anki toplam eşleşme sayısı (NoteFindSession.matchCount).
  final int matchCount;

  /// O anki aktif eşleşmenin 0-bazlı indeksi (yoksa -1 —
  /// NoteFindSession.activeIndex ile birebir aynı sözleşme). Sayaç "3/8"
  /// gibi 1-bazlı gösterileceğinden burada +1 uygulanır.
  final int activeIndex;

  /// "Değiştir" satırının şu an açık mı kapalı mı olduğu (bkz. sınıf
  /// dokümanındaki not — bu widget'ta TUTULMAZ, dışarıdan verilir).
  final bool replaceExpanded;

  /// Arama kutusu her değiştiğinde (her tuş vuruşunda) çağrılır. Çağıran
  /// taraf bunu NoteFindSession.setQuery'ye bağlayacak — bkz. o metodun
  /// dokümanındaki "odak çalınmaz" notu: bu callback SADECE vurgu
  /// katmanını günceller, içerik alanına hiç odaklanma/kaydırma tetiklemez.
  final ValueChanged<String> onQueryChanged;

  /// Sonraki eşleşmeye geç (↓ butonu). NoteFindSession.next()'e bağlanır.
  final VoidCallback onNext;

  /// Önceki eşleşmeye geç (↑ butonu). NoteFindSession.previous()'a bağlanır.
  final VoidCallback onPrevious;

  /// Kapatma (X) butonu — "Bul" modundan tamamen çıkış. Çağıran taraf
  /// bunu hem NoteFindSession.clear()'a hem de barı ağaçtan kaldıran
  /// kendi findMode bayrağına bağlayacak (Aşama 6).
  final VoidCallback onClose;

  /// İkinci satırı (Değiştir alanı) aç/kapa. Bu widget kendi state'ini
  /// tutmadığından, çağıran taraf [replaceExpanded]'ı bu callback'e göre
  /// güncelleyip yeniden çizmelidir.
  final VoidCallback onToggleReplaceExpanded;

  /// "Değiştir" butonu — o an aktif eşleşmeyi replaceController.text ile
  /// değiştir. Metin, controller zaten paylaşıldığından ayrı bir parametre
  /// olarak taşınmaz; çağıran taraf NoteFindSession.replaceActive(
  /// replaceController.text) şeklinde okuyacaktır.
  final VoidCallback onReplacePressed;

  /// "Tümünü Değiştir" butonu — NoteFindSession.replaceAll(
  /// replaceController.text)'e bağlanır.
  final VoidCallback onReplaceAllPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasMatches = matchCount > 0;
    // 1-bazlı sayaç: eşleşme yokken "0/0" gösterilir (Google Docs/Gmail
    // arama kutularındaki alışılmış davranışla tutarlı).
    final counterText = hasMatches ? '${activeIndex + 1}/$matchCount' : '0/0';

    // DÜZELTME (kullanıcı geri bildirimi — konumlandırma değişti): bu bar
    // artık ekranın en alt çocuğu DEĞİL; editör gövdesindeki tarih/etiket
    // barının (SafeArea ile sarılı, her zaman en altta duran ayrı bir
    // Column çocuğu) ÜSTÜNDE, zengin metin araç çubuğunun (bkz.
    // note_list_note_dialog_mixin.dart'taki eşdeğer Material/SizedBox(
    // height: 44)) kullandığı SLOTU alıyor. O bar hiçbir klavye/güvenli-alan
    // boşluğu kendi başına HESAPLAMIYOR — çünkü altındaki tarih barı zaten
    // kendi SafeArea'sıyla klavyenin/sistem çubuğunun üstünde kalmayı
    // garantiliyor, üstteki Scaffold'un resizeToAvoidBottomInset:true'su da
    // gövdenin tamamını klavyeyle çakışmayacak şekilde zaten daraltıyor. Bu
    // yüzden burada da AYNI basitliğe geçildi: eskiden bu widget'ı saran
    // AnimatedPadding (viewInsets.bottom/safeArea tabanlı elle boşluk)
    // kaldırıldı — o mantık yalnızca bar GERÇEKTEN ekranın en alt kenarına
    // bitişikken gerekliydi; artık öyle değil, eklemesi tarih barıyla
    // arasında gereksiz bir boşluk bırakırdı.
    return Material(
      elevation: 8,
      color: theme.colorScheme.surface,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
            Container(height: 1, color: theme.dividerColor),
            // ── 1. satır: arama kutusu + sayaç + ↑/↓ + değiştir-aç/kapa + kapat ──
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 4, 4, 4),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: queryController,
                      focusNode: queryFocusNode,
                      autofocus: true,
                      textInputAction: TextInputAction.search,
                      contextMenuBuilder: buildCustomContextMenu,
                      style: TextStyle(fontSize: 17, color: theme.colorScheme.onSurface),
                      decoration: InputDecoration(
                        isDense: true,
                        border: InputBorder.none,
                        prefixIcon: const Icon(Icons.search_rounded, size: 22),
                        prefixIconConstraints:
                            const BoxConstraints(minWidth: 32, minHeight: 32),
                        hintText: AppLocalizations.of(context)!.findSearchHint,
                        hintStyle: const TextStyle(color: Colors.grey),
                      ),
                      onChanged: onQueryChanged,
                      // Enter/arama tuşu: mevcut eşleşme varsa bir sonrakine
                      // geç — masaüstü Bul araçlarındaki alışılmış davranış.
                      onSubmitted: (_) {
                        if (hasMatches) onNext();
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Text(
                      counterText,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: hasMatches ? null : Colors.grey,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: AppLocalizations.of(context)!.findPreviousTooltip,
                    icon: const Icon(Icons.keyboard_arrow_up_rounded),
                    iconSize: 24,
                    visualDensity: VisualDensity.compact,
                    onPressed: hasMatches ? onPrevious : null,
                  ),
                  IconButton(
                    tooltip: AppLocalizations.of(context)!.findNextTooltip,
                    icon: const Icon(Icons.keyboard_arrow_down_rounded),
                    iconSize: 24,
                    visualDensity: VisualDensity.compact,
                    onPressed: hasMatches ? onNext : null,
                  ),
                  // DÜZELTME (kullanıcı geri bildirimi): bu buton eskiden
                  // expand_more_rounded/expand_less_rounded (aşağı/yukarı
                  // OK) kullanıyordu — hemen solundaki "sonraki eşleşme"
                  // butonu da keyboard_arrow_down_rounded (aşağı OK)
                  // olduğundan, ikisi yan yana neredeyse AYNI ok şeklinde
                  // görünüp karışıyordu. Artık ok ailesinden tamamen farklı,
                  // anlamı doğrudan karşılayan bir ikon (arama+değiştir)
                  // kullanılıyor; açık/kapalı DURUMU ise ikonun ŞEKLİNİ
                  // değiştirerek değil (bu yine bir "hangi ikon" karışıklığı
                  // yaratırdı), arka plan/simge rengiyle vurgulanarak
                  // gösteriliyor — AppBar'daki Geri Al/İleri Al ikonlarının
                  // etkin/pasif renk deseniyle aynı yaklaşım.
                  IconButton(
                    tooltip: replaceExpanded
                        ? AppLocalizations.of(context)!.findHideReplaceTooltip
                        : AppLocalizations.of(context)!.findShowReplaceTooltip,
                    icon: const Icon(Icons.find_replace),
                    iconSize: 22,
                    visualDensity: VisualDensity.compact,
                    style: IconButton.styleFrom(
                      backgroundColor: replaceExpanded
                          ? theme.colorScheme.primary.withValues(alpha: 0.15)
                          : null,
                      foregroundColor: replaceExpanded
                          ? theme.colorScheme.primary
                          : null,
                    ),
                    onPressed: onToggleReplaceExpanded,
                  ),
                  IconButton(
                    tooltip: AppLocalizations.of(context)!.findCloseTooltip,
                    icon: const Icon(Icons.close_rounded),
                    iconSize: 22,
                    visualDensity: VisualDensity.compact,
                    onPressed: onClose,
                  ),
                ],
              ),
            ),
            // ── 2. satır: açılıp kapanan "Değiştir" alanı ──────────────────
            // AnimatedSize, NoteChecklistBlock'taki madde silme animasyonuyla
            // aynı yaklaşım: içerik değiştiğinde ani zıplama yerine yumuşak
            // yükseklik geçişi.
            AnimatedSize(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeInOut,
              alignment: Alignment.topCenter,
              child: replaceExpanded
                  ? _buildReplaceRow(context, hasMatches)
                  : const SizedBox(width: double.infinity, height: 0),
            ),
          ],
        ),
    );
  }

  Widget _buildReplaceRow(BuildContext context, bool hasMatches) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 4, 6),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: replaceController,
              textInputAction: TextInputAction.done,
              contextMenuBuilder: buildCustomContextMenu,
              style: TextStyle(fontSize: 17, color: theme.colorScheme.onSurface),
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                hintText: AppLocalizations.of(context)!.findReplaceHint,
                hintStyle: const TextStyle(color: Colors.grey),
              ),
              onSubmitted: (_) {
                if (hasMatches) onReplacePressed();
              },
            ),
          ),
          TextButton(
            style: TextButton.styleFrom(
              textStyle: const TextStyle(fontSize: 15),
            ),
            onPressed: hasMatches ? onReplacePressed : null,
            child: Text(AppLocalizations.of(context)!.findReplaceButton),
          ),
          TextButton(
            style: TextButton.styleFrom(
              textStyle: const TextStyle(fontSize: 15),
            ),
            onPressed: hasMatches ? onReplaceAllPressed : null,
            child: Text(AppLocalizations.of(context)!.findReplaceAllButton),
          ),
        ],
      ),
    );
  }
}
