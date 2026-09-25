part of 'main.dart';

// ═══════════════════════════════════════════════════════════════════
// PRO SERVİSİ (Google Play Billing)
// Freemium modeli: iki plan vardır.
//   - Aylık Pro   -> abonelik (Play Console'da "Abonelikler" altında)
//   - Ömür boyu   -> tek seferlik ürün (Play Console'da "Uygulama içi
//                    ürünler" altında)
// Ürün kimlikleri Play Console'da BİREBİR bu sabitlerle tanımlanmalıdır.
//
// PRO DURUMUNUN KAYNAĞI: Google Play. DB'deki 'is_pro' (bkz.
// DBHelper.getIsPro/setIsPro) sadece önbellektir; uygulama her açılışta
// sessizce Play'e sorup (restorePurchases) durumu günceller:
//   - Play "bu hesapta geçerli Pro var" derse  -> Pro açılır.
//   - Play kesin olarak "yok" derse (abonelik bitti / iade edildi) -> Pro
//     kapanır.
//   - Play'e ulaşılamazsa (internet yok, zaman aşımı, hata) -> önbellekteki
//     durum aynen korunur; kullanıcı çevrimdışıyken Pro'sunu kaybetmez.
//
// DOĞRULAMA: Satın alma cihaz üzerinde, Play'in döndürdüğü bilgiye göre
// doğrulanır (sunucu tarafı doğrulama yok). Bu, bu tür bir uygulama için
// yaygın ve yeterli kabul edilir.
// ═══════════════════════════════════════════════════════════════════

const String kProMonthlyProductId = 'layout_pro_monthly';
const String kProLifetimeProductId = 'layout_pro_lifetime';
const Set<String> kProProductIds = {
  kProMonthlyProductId,
  kProLifetimeProductId,
};

/// UI'nin (SnackBar vb.) dinleyebileceği, kullanıcıya bildirilecek sonuçlar.
enum ProEventType {
  purchaseSuccess,
  restoreSuccess,
  restoreNothingFound,
  pending,
  canceled,
  error,
  storeUnavailable,
}

class ProService extends ChangeNotifier {
  ProService._();
  static final ProService instance = ProService._();

  final iap.InAppPurchase _store = iap.InAppPurchase.instance;
  StreamSubscription<List<iap.PurchaseDetails>>? _purchaseSub;
  final StreamController<ProEventType> _events =
      StreamController<ProEventType>.broadcast();

  Stream<ProEventType> get events => _events.stream;

  bool _initialized = false;

  /// Google Play faturalama servisine ulaşılabiliyor mu.
  bool storeAvailable = false;

  /// Ürün (fiyat) bilgileri yükleniyor mu / yüklenemedi mi.
  bool productsLoading = false;
  bool productsError = false;

  /// Play'den gelen ürün bilgileri (id -> ürün). Fiyat metni
  /// [iap.ProductDetails.price] içinde, kullanıcının para biriminde hazır gelir.
  Map<String, iap.ProductDetails> products = {};

  /// Kullanıcının başlattığı satın alma sürüyor mu.
  bool purchasing = false;

  /// Kullanıcının başlattığı (sessiz olmayan) geri yükleme sürüyor mu.
  bool restoring = false;

  // Geri yükleme (restorePurchases) isteği için iç durum. Play'in cevabı
  // purchaseStream üzerinden gelir; hangi cevabın bu isteğe ait olduğunu
  // bu bayraklarla ayırt ediyoruz.
  bool _restorePending = false;
  bool _restoreSilent = true;
  Completer<void>? _restoreDone;

  void _emit(ProEventType type) {
    if (!_events.isClosed) _events.add(type);
  }

  // ── Başlatma ─────────────────────────────────────────────────────────
  /// Uygulama açılışında bir kez çağrılır (bkz. main.dart ->
  /// _initBackgroundServices). purchaseStream'e mümkün olan en erken
  /// abone olunur; böylece önceki oturumdan kalan bekleyen satın almalar da
  /// yakalanır. Ardından Pro durumu Play'e sorularak sessizce yenilenir.
  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;
    try {
      _purchaseSub = _store.purchaseStream.listen(
        _onPurchaseUpdates,
        onError: _onStreamError,
      );
      storeAvailable = await _store.isAvailable();
    } catch (_) {
      storeAvailable = false;
    }
    notifyListeners();
    if (storeAvailable) {
      await refreshEntitlement(silent: true);
    }
  }

  Future<bool> _ensureReady() async {
    if (!_initialized) {
      await init();
    } else if (!storeAvailable) {
      try {
        storeAvailable = await _store.isAvailable();
      } catch (_) {
        storeAvailable = false;
      }
      notifyListeners();
    }
    return storeAvailable;
  }

  // ── Ürün bilgileri ───────────────────────────────────────────────────
  Future<void> loadProducts() async {
    if (productsLoading) return;
    productsLoading = true;
    productsError = false;
    notifyListeners();
    try {
      if (!await _ensureReady()) {
        productsError = true;
        return;
      }
      final response = await _store.queryProductDetails(kProProductIds);
      products = {for (final d in response.productDetails) d.id: d};
      productsError = response.error != null || products.isEmpty;
    } catch (_) {
      productsError = true;
    } finally {
      productsLoading = false;
      notifyListeners();
    }
  }

  // ── Satın alma ───────────────────────────────────────────────────────
  /// [productId] için Play'in satın alma ekranını açar. Sonuç
  /// purchaseStream'den gelir (bkz. _onPurchaseUpdates).
  Future<void> buy(String productId) async {
    if (purchasing || restoring) return;
    final details = products[productId];
    if (details == null) {
      _emit(ProEventType.error);
      return;
    }
    if (!await _ensureReady()) {
      _emit(ProEventType.storeUnavailable);
      return;
    }
    purchasing = true;
    notifyListeners();
    try {
      // Hem abonelik hem ömür boyu ürün "tüketilmeyen" (non-consumable)
      // olarak satın alınır; completePurchase Android'de bunu onaylar
      // (acknowledge). Onaylanmayan satın almalar Play tarafından ~3 gün
      // içinde otomatik iade edilir.
      final started = await _store.buyNonConsumable(
        purchaseParam: iap.PurchaseParam(productDetails: details),
      );
      if (!started) {
        purchasing = false;
        notifyListeners();
        _emit(ProEventType.error);
      }
    } catch (_) {
      purchasing = false;
      notifyListeners();
      _emit(ProEventType.error);
    }
  }

  // ── Geri yükleme / durum yenileme ────────────────────────────────────
  /// Play'e "bu hesabın geçerli Pro'su var mı?" diye sorar.
  /// [silent] true ise (açılıştaki otomatik yenileme) kullanıcıya hiçbir
  /// mesaj gösterilmez ve arayüzde yükleniyor durumu çıkmaz.
  Future<void> refreshEntitlement({bool silent = false}) async {
    if (_restorePending) return;
    if (!await _ensureReady()) {
      if (!silent) _emit(ProEventType.storeUnavailable);
      return;
    }
    _restorePending = true;
    _restoreSilent = silent;
    restoring = !silent;
    final done = Completer<void>();
    _restoreDone = done;
    notifyListeners();
    try {
      await _store.restorePurchases();
      await done.future.timeout(const Duration(seconds: 12));
    } catch (_) {
      // Zaman aşımı veya hata: önbellekteki Pro durumu olduğu gibi kalır.
      if (!silent) _emit(ProEventType.error);
    } finally {
      _restorePending = false;
      _restoreDone = null;
      restoring = false;
      notifyListeners();
    }
  }

  // ── Play'den gelen satın alma güncellemeleri ────────────────────────
  Future<void> _onPurchaseUpdates(List<iap.PurchaseDetails> list) async {
    var granted = false;
    var newlyPurchased = false;
    var pending = false;
    var errored = false;
    var alreadyOwned = false;
    var canceled = false;

    for (final d in list) {
      if (!kProProductIds.contains(d.productID)) {
        // Bize ait olmayan bir ürün: sadece tamamlanmasını iste.
        await _completeIfNeeded(d);
        continue;
      }
      switch (d.status) {
        case iap.PurchaseStatus.pending:
          pending = true;
        case iap.PurchaseStatus.error:
          errored = true;
          if (_isAlreadyOwnedError(d.error)) alreadyOwned = true;
        case iap.PurchaseStatus.canceled:
          canceled = true;
        case iap.PurchaseStatus.purchased:
          granted = true;
          newlyPurchased = true;
        case iap.PurchaseStatus.restored:
          granted = true;
      }
      await _completeIfNeeded(d);
    }

    final wasRestore = _restorePending;

    if (granted) {
      await _setPro(true);
      if (newlyPurchased) {
        _emit(ProEventType.purchaseSuccess);
      } else if (wasRestore && !_restoreSilent) {
        _emit(ProEventType.restoreSuccess);
      }
    } else if (pending) {
      _emit(ProEventType.pending);
    } else if (alreadyOwned) {
      // "Bu ürüne zaten sahipsin": Play'de var ama yerelde Pro kapalı
      // kalmış demektir. Durumu Play'den çekip düzelt.
      unawaited(refreshEntitlement(silent: true));
    } else if (errored) {
      _emit(ProEventType.error);
    } else if (canceled) {
      _emit(ProEventType.canceled);
    } else if (wasRestore) {
      // Geri yükleme cevabı geldi ve geçerli hiçbir Pro satın alma yok:
      // Play'in KESİN cevabı budur (abonelik bitti / iade edildi / hiç
      // alınmadı). Önbellek buna göre güncellenir.
      await _setPro(false);
      if (!_restoreSilent) _emit(ProEventType.restoreNothingFound);
    }

    purchasing = false;
    final done = _restoreDone;
    if (wasRestore && done != null && !done.isCompleted) done.complete();
    notifyListeners();
  }

  void _onStreamError(Object error) {
    purchasing = false;
    final done = _restoreDone;
    if (done != null && !done.isCompleted) {
      // refreshEntitlement içindeki catch bunu yakalar ve gerekirse mesaj
      // gösterir; Pro durumu değiştirilmez.
      done.completeError(error);
    } else {
      _emit(ProEventType.error);
    }
    notifyListeners();
  }

  Future<void> _completeIfNeeded(iap.PurchaseDetails d) async {
    if (!d.pendingCompletePurchase) return;
    try {
      await _store.completePurchase(d);
    } catch (_) {
      // Onaylama başarısız olursa Play bir sonraki açılışta aynı satın
      // almayı tekrar iletir; burada sessizce geçmek güvenlidir.
    }
  }

  bool _isAlreadyOwnedError(iap.IAPError? e) {
    if (e == null) return false;
    final text = '${e.code} ${e.message} ${e.details}'.toLowerCase();
    return text.contains('alreadyowned') ||
        text.contains('already_owned') ||
        text.contains('already owned');
  }

  Future<void> _setPro(bool value) async {
    if (appIsPro.value != value) appIsPro.value = value;
    try {
      await DBHelper.instance.setIsPro(value);
    } catch (_) {
      // DB yazımı başarısız olsa bile bellekteki durum geçerli kalır;
      // bir sonraki açılışta Play'den yeniden belirlenir.
    }
  }
}
