part of 'main.dart';

// ═══════════════════════════════════════════════════════════════════
// PRO'YA YÜKSELT SAYFASI
// Gerçek satın alma akışına bağlıdır (bkz. pro_service.dart -> ProService).
//   - Plan kartları (Aylık / Ömür boyu): fiyat metni Play'den canlı gelir
//     (ProService.products), kullanıcının para biriminde hazırdır.
//   - "Devam Et" seçili planı satın alma akışına gönderir (ProService.buy).
//   - "Satın Almaları Geri Yükle" ProService.refreshEntitlement() çağırır.
//   - ProService.events akışındaki sonuçlar (başarı, bekleyen ödeme, iptal,
//     hata vb.) SnackBar olarak gösterilir.
//   - Pro zaten aktifse (appIsPro) plan kartları yerine "Pro aktif" kartı
//     gösterilir.
// Özellik listesi (_ProFeature) metinleri AppLocalizations üzerinden gelir
// (proFeature* anahtarları). Yeni özellik eklemek için ARB dosyalarına
// title/subtitle anahtarı ekleyip aşağıdaki _features listesine bir satır
// eklemen yeterli.
// ═══════════════════════════════════════════════════════════════════

class _ProFeature {
  final IconData icon;
  final String title;
  final String subtitle;
  const _ProFeature({
    required this.icon,
    required this.title,
    required this.subtitle,
  });
}

class ProUpgradeScreen extends StatefulWidget {
  const ProUpgradeScreen({super.key});

  @override
  State<ProUpgradeScreen> createState() => _ProUpgradeScreenState();
}

class _ProUpgradeScreenState extends State<ProUpgradeScreen> {
  final ProService _pro = ProService.instance;
  StreamSubscription<ProEventType>? _eventSub;

  // Kullanıcının seçtiği plan. Ürün bilgileri henüz gelmemişse ya da bu
  // ürün bulunamadıysa _effectiveSelectedId() geçerli bir plana düşer.
  String _selectedId = kProMonthlyProductId;

  @override
  void initState() {
    super.initState();
    _eventSub = _pro.events.listen(_onProEvent);
    _pro.loadProducts();
  }

  @override
  void dispose() {
    _eventSub?.cancel();
    super.dispose();
  }

  // ProService'ten gelen sonuçları kullanıcıya bildirir.
  void _onProEvent(ProEventType type) {
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;
    final message = switch (type) {
      ProEventType.purchaseSuccess => l10n.proPurchaseSuccessMessage,
      ProEventType.restoreSuccess => l10n.proRestoreSuccessMessage,
      ProEventType.restoreNothingFound => l10n.proRestoreNothingFoundMessage,
      ProEventType.pending => l10n.proPurchasePendingMessage,
      ProEventType.canceled => l10n.proPurchaseCanceledMessage,
      ProEventType.error => l10n.proPurchaseErrorMessage,
      ProEventType.storeUnavailable => l10n.proStoreUnavailableMessage,
    };
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  // Özellik listesi — metinler AppLocalizations'tan gelir. Bu yüzden liste
  // artık const değil; context/l10n her build'de okunur.
  List<_ProFeature> _features(AppLocalizations l10n) => [
        _ProFeature(
          icon: Icons.lock_outline,
          title: l10n.proFeatureFolderLockTitle,
          subtitle: l10n.proFeatureFolderLockSubtitle,
        ),
        _ProFeature(
          icon: Icons.account_tree_outlined,
          title: l10n.proFeatureSubfoldersTitle,
          subtitle: l10n.proFeatureSubfoldersSubtitle,
        ),
        _ProFeature(
          icon: Icons.palette_outlined,
          title: l10n.proFeatureAccentColorsTitle,
          subtitle: l10n.proFeatureAccentColorsSubtitle,
        ),
        _ProFeature(
          icon: Icons.alarm_outlined,
          title: l10n.proFeatureRecurringAlarmTitle,
          subtitle: l10n.proFeatureRecurringAlarmSubtitle,
        ),
        _ProFeature(
          icon: Icons.push_pin_outlined,
          title: l10n.proFeaturePinNotesTitle,
          subtitle: l10n.proFeaturePinNotesSubtitle,
        ),
        _ProFeature(
          icon: Icons.picture_as_pdf_outlined,
          title: l10n.proFeatureExportTitle,
          subtitle: l10n.proFeatureExportSubtitle,
        ),
        _ProFeature(
          icon: Icons.document_scanner_outlined,
          title: l10n.proFeatureDocumentScanTitle,
          subtitle: l10n.proFeatureDocumentScanSubtitle,
        ),
        _ProFeature(
          icon: Icons.mic_outlined,
          title: l10n.proFeatureSpeechToTextTitle,
          subtitle: l10n.proFeatureSpeechToTextSubtitle,
        ),
        _ProFeature(
          icon: Icons.perm_media_outlined,
          title: l10n.proFeatureUnlimitedAttachmentsTitle,
          subtitle: l10n.proFeatureUnlimitedAttachmentsSubtitle,
        ),
      ];

  // Play'den gelen planlar, ekranda gösterim sırasıyla (aylık, ömür boyu).
  List<iap.ProductDetails> _availablePlans() {
    final plans = <iap.ProductDetails>[];
    for (final id in const [kProMonthlyProductId, kProLifetimeProductId]) {
      final d = _pro.products[id];
      if (d != null) plans.add(d);
    }
    return plans;
  }

  String? _effectiveSelectedId(List<iap.ProductDetails> plans) {
    if (plans.isEmpty) return null;
    for (final p in plans) {
      if (p.id == _selectedId) return _selectedId;
    }
    return plans.first.id;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: dNoteCardColor(context),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: dNoteTextColor(context)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          l10n.drawerUpgradeToProLabel,
          style: TextStyle(
            color: dNoteTextColor(context),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: SafeArea(
        // Hem ProService (ürünler, satın alma/geri yükleme durumu) hem de
        // appIsPro değiştiğinde ekran yeniden çizilir.
        child: ListenableBuilder(
          listenable: Listenable.merge([_pro, appIsPro]),
          builder: (context, _) => _buildBody(context, l10n),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, AppLocalizations l10n) {
    final isPro = appIsPro.value;
    final features = _features(l10n);
    final plans = _availablePlans();
    final selectedId = _effectiveSelectedId(plans);
    final busy = _pro.purchasing || _pro.restoring;

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
            children: [
              Center(
                child: Icon(
                  Icons.workspace_premium_outlined,
                  size: 72,
                  color: appAccentColor.value,
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  l10n.proUpgradeHeadline,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: dNoteTextColor(context),
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              if (isPro)
                _buildActiveCard(context, l10n)
              else
                _buildPlans(context, l10n, plans, selectedId, busy),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: dNoteCardColor(context),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  children: [
                    for (var i = 0; i < features.length; i++) ...[
                      if (i > 0)
                        Divider(
                          height: 1,
                          indent: 56,
                          color: Theme.of(context).dividerColor,
                        ),
                      ListTile(
                        leading: Icon(
                          features[i].icon,
                          color: appAccentColor.value,
                        ),
                        title: Text(
                          features[i].title,
                          style: TextStyle(
                            color: dNoteTextColor(context),
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                        subtitle: Text(
                          features[i].subtitle,
                          style: TextStyle(
                            color: dNoteTextColor(context)
                                .withValues(alpha: 0.7),
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: TextButton(
                  onPressed: busy ? null : () => _pro.refreshEntitlement(),
                  child: _pro.restoring
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(
                          l10n.proRestorePurchasesButton,
                          style: TextStyle(color: appAccentColor.value),
                        ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                l10n.proSubscriptionNote,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: dNoteTextColor(context).withValues(alpha: 0.6),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        if (!isPro)
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: appAccentColor.value,
                  disabledBackgroundColor:
                      appAccentColor.value.withValues(alpha: 0.4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: (busy || selectedId == null)
                    ? null
                    : () => _pro.buy(selectedId),
                child: _pro.purchasing
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Colors.black,
                        ),
                      )
                    : Text(
                        l10n.proPurchaseButton,
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
              ),
            ),
          ),
      ],
    );
  }

  // Pro zaten aktifken plan kartlarının yerine gösterilir.
  Widget _buildActiveCard(BuildContext context, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: dNoteCardColor(context),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: appAccentColor.value, width: 2),
      ),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: appAccentColor.value, size: 32),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.proActiveTitle,
                  style: TextStyle(
                    color: dNoteTextColor(context),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  l10n.proActiveSubtitle,
                  style: TextStyle(
                    color: dNoteTextColor(context).withValues(alpha: 0.7),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlans(
    BuildContext context,
    AppLocalizations l10n,
    List<iap.ProductDetails> plans,
    String? selectedId,
    bool busy,
  ) {
    if (plans.isEmpty) {
      if (_pro.productsLoading) {
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 24),
          child: Center(child: CircularProgressIndicator()),
        );
      }
      // Fiyatlar yüklenemedi (Play'e ulaşılamadı ya da ürünler bulunamadı).
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: dNoteCardColor(context),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Text(
              l10n.proProductsLoadErrorMessage,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: dNoteTextColor(context).withValues(alpha: 0.8),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: _pro.loadProducts,
              child: Text(
                l10n.proRetryButton,
                style: TextStyle(color: appAccentColor.value),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        for (final d in plans)
          _buildPlanCard(
            context,
            l10n,
            d,
            selected: d.id == selectedId,
            enabled: !busy,
          ),
      ],
    );
  }

  Widget _buildPlanCard(
    BuildContext context,
    AppLocalizations l10n,
    iap.ProductDetails d, {
    required bool selected,
    required bool enabled,
  }) {
    final isMonthly = d.id == kProMonthlyProductId;
    final title =
        isMonthly ? l10n.proPlanMonthlyTitle : l10n.proPlanLifetimeTitle;
    final subtitle =
        isMonthly ? l10n.proPlanMonthlySubtitle : l10n.proPlanLifetimeSubtitle;
    final price = isMonthly
        ? l10n.proPlanMonthlyPrice(d.price)
        : l10n.proPlanLifetimePrice(d.price);
    final accent = appAccentColor.value;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: Ink(
          decoration: BoxDecoration(
            color: dNoteCardColor(context),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected ? accent : Colors.transparent,
              width: 2,
            ),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: enabled ? () => setState(() => _selectedId = d.id) : null,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(
                    selected
                        ? Icons.radio_button_checked
                        : Icons.radio_button_unchecked,
                    color: selected
                        ? accent
                        : dNoteTextColor(context).withValues(alpha: 0.5),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            color: dNoteTextColor(context),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          subtitle,
                          style: TextStyle(
                            color:
                                dNoteTextColor(context).withValues(alpha: 0.7),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    price,
                    style: TextStyle(
                      color: accent,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
