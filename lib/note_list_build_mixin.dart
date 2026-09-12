part of 'main.dart';

// ignore_for_file: unused_element

mixin NoteListBuildMixin on State<NoteListScreen> {
  // Arama modundaki "Türler" şeridinde seçili olan tür filtresi (ör.
  // 'checklist', 'drawing', 'table', 'image', 'audio', 'video', 'document',
  // 'reminder'). null ise tür filtresi uygulanmaz. Etiket filtresinden
  // (_searchQuery) tamamen bağımsızdır; ikisi aynı anda aktif olabilir
  // (VE mantığıyla birleşirler). Sadece arama modunda anlamlıdır, bu
  // yüzden arama kapatılınca (_isSearching -> false olan üç noktada)
  // sıfırlanır.
  String? _activeTypeFilter;

  // Arama modundaki bayrak (flama) filtresi. Seçili bir hex renk
  // ('#RRGGBB') ya da null (filtre yok) tutar. _activeTypeFilter ile aynı
  // tek-seçimli mantık: bir renk seçilince öncekinin seçimi otomatik
  // kalkar (bkz. _FlagFilterChip onSelected). Etiket (_searchQuery) ve tür
  // (_activeTypeFilter) filtrelerinden tamamen bağımsızdır; üçü de VE
  // mantığıyla birleşir (bkz. build() içindeki filteredNotes hesaplaması).
  // Arama kapatılınca (_isSearching -> false olan üç noktada) sıfırlanır.
  String? _activeFlagFilter;

  // Klasör sıralama alt sayfasında (_showFolderSortSheet) o an seçili olan
  // kriter ('name' veya 'count') ve yön (artan/azalan). Sayfa her
  // açıldığında sıfırlanmaz, oturum boyunca son seçim hatırlanır — ama
  // diskte kalıcı değildir (kalıcı olan tek şey, bu seçime göre yeniden
  // dizilmiş _categories listesinin kendisidir, bkz. _saveData çağrıları).
  String _folderSortCriterion = 'name';
  bool _folderSortAscending = true;


  // Bir notun eklerini (attachments) tekil bir liste olarak döndürür.
  // note['attachments'] üst seviyede tam ek nesnelerini (id, isImage,
  // isVideo, isAudio, storedName, fileName vb.) doğrudan taşır — bkz.
  // _firstImageAttachment/_previewImages'daki aynı alan kullanımı.
  List<Map<String, dynamic>> _attachmentsOfNote(Map<String, dynamic> note) {
    final atts = note['attachments'];
    if (atts is List) {
      return atts
          .whereType<Map>()
          .map((a) => Map<String, dynamic>.from(a))
          .toList();
    }
    return [];
  }

  // Bir notun, verilen tür filtresi anahtarına (`filterKey`) uyup uymadığını
  // döndürür. `content_blocks.dart`'taki blok tipleri (text, attachments,
  // calc_table, drawing, divider, checklist, table) ve not eklerindeki
  // isImage/isVideo/isAudio bayrakları temel alınır.
  bool _noteMatchesTypeFilter(Map<String, dynamic> note, String filterKey) {
    switch (filterKey) {
      case 'checklist':
        final blocks = ContentBlocks.parse(note['content'] as String?);
        return blocks.any((b) => b['type'] == 'checklist');
      case 'drawing':
        final blocks = ContentBlocks.parse(note['content'] as String?);
        return blocks.any((b) => b['type'] == 'drawing');
      case 'table':
        final blocks = ContentBlocks.parse(note['content'] as String?);
        return blocks.any(
          (b) => b['type'] == 'table' || b['type'] == 'calc_table',
        );
      case 'image':
        return _attachmentsOfNote(note).any((a) => a['isImage'] == true);
      case 'video':
        return _attachmentsOfNote(note).any((a) => a['isVideo'] == true);
      case 'audio':
        return _attachmentsOfNote(note).any((a) => a['isAudio'] == true);
      case 'document':
        // Resim/video/ses olmayan diğer tüm ekler (pdf, xlsx, vb.).
        return _attachmentsOfNote(note).any(
          (a) =>
              a['isImage'] != true &&
              a['isVideo'] != true &&
              a['isAudio'] != true,
        );
      case 'reminder':
        return _hasActiveReminder(note);
      default:
        return true;
    }
  }

  // Arama modundaki "Türler" şeridinde her zaman gösterilen sabit ikon
  // sırası: checklist, hatırlatıcı, foto, belge, tablo, çizim, ses, kamera.
  static const List<String> _kAllTypeFilterKeys = [
    'checklist',
    'reminder',
    'image',
    'document',
    'table',
    'drawing',
    'audio',
    'video',
  ];

  List<String> _availableTypeFilters(List<Map<String, dynamic>> notes) {
    return _kAllTypeFilterKeys
        .where((key) => notes.any((n) => _noteMatchesTypeFilter(n, key)))
        .toList();
  }

  // Arama modundaki etiket VE bayrak filtre şeritlerinin hangi notlardan
  // besleneceğini belirler. Ana `build` içindeki kategori filtreleme
  // dallarıyla (bkz. aşağıdaki `filteredNotes` hesaplaması) aynı mantığı,
  // arama sorgusu olmadan uygular — amaç sadece "bu bölümde hangi
  // etiketler/bayrak renkleri var" sorusunu yanıtlamak. "Tümü"/"Notlar"
  // bölümü dahil HER bölümde arşiv ve kilitli notlar kapsam dışı bırakılır
  // — çünkü asıl not listesi (`filteredNotes`) bu bölümlerde zaten
  // !isArchived && !isLocked koşuluyla filtreleniyor; aksi halde şeritte
  // yalnızca arşiv/kilitli bir nota ait bir etiket/renk görünüp ona
  // tıklandığında hiçbir sonuç gelmemesine yol açardı (önceden etiketler
  // için kasıtlı olarak istisna vardı, bayrakla tutarsızlık yaratıp aynı
  // sorunu üretiyordu — bu yüzden kaldırıldı).
  List<Map<String, dynamic>> _notesForActiveTagScope(bool isTrash) {
    if (isTrash) return _deletedNotes;
    return _notes.where((note) {
      final isArchived = note['isArchived'] == true;
      final isFavorite = note['isFavorite'] == true;
      final isLocked = note['isLocked'] == true;
      if (_activeCategory == '__favorites__') {
        return isFavorite && !isArchived && !isLocked;
      } else if (_activeCategory == '__locked__') {
        return isLocked && !isArchived;
      } else if (_activeCategory == '__archive__') {
        return isArchived && !isLocked;
      } else if (_activeCategory == '__reminders__') {
        return _hasActiveReminder(note) && !isArchived && !isLocked;
      } else if (_activeCategory == 'Tümü' || _activeCategory == 'Notlar') {
        return !isArchived && !isLocked;
      } else {
        return !isArchived && !isLocked && note['category'] == _activeCategory;
      }
    }).toList();
  }

  // Arama modundaki bayrak filtre şeridinin hangi renklerden oluşacağını
  // belirler. `collectAllKnownTags` ile aynı amaca hizmet eder: verilen not
  // kümesinde (bkz. _notesForActiveTagScope — etiket şeridiyle artık aynı
  // kapsam) fiilen kullanılan 'flagColor' değerleri, NoteFlagMixin._flagPalette
  // sırasına göre (rastgele/ekleniş sırasına göre değil) döndürülür — bayrak
  // seçim panelindeki (_showFlagColorPicker) sıralamayla tutarlı olsun diye.
  // Notlarda geçen ama palette'te olmayan bir renk (teorik olarak, eski
  // veri) yok sayılır.
  List<String> _availableFlagColors(List<Map<String, dynamic>> notes) {
    final usedColors = notes
        .map((n) => n['flagColor'])
        .whereType<String>()
        .toSet();
    return NoteFlagMixin._flagPalette
        .where((hex) => usedColors.contains(hex))
        .toList();
  }

  // Klasörler (üst kategoriler) ve alt klasörlerini, drawer'daki
  // hiyerarşiyi bozmadan verilen kritere göre yeniden sıralar:
  // - Üst klasörler kendi aralarında `criterion`'a göre sıralanır.
  // - Her üst klasörün alt klasörleri de kendi aralarında aynı kritere
  //   göre sıralanıp, üst klasörün hemen ardına eklenir (üst+alt grubu
  //   tek blok olarak yer değiştirir, birbirine karışmaz).
  // `_categories` listesinin kendisini bu yeni sırayla değiştirir; bu
  // yüzden değişiklik kalıcıdır ve `_categories`'in okunduğu her yerde
  // (drawer, "Sınıflandır" alt sayfası vb.) geçerli olur.
  //
  // criterion: 'name' (isme göre, Türkçe küçük/büyük harf duyarsız) veya
  // 'count' (o klasördeki not sayısına göre, bkz. _getCountForCategory).
  //
  // scopeParent verilirse (bir üst klasörün adı): sıralama SADECE o üst
  // klasörün doğrudan alt klasörleriyle sınırlı kalır — üst klasörlerin
  // kendi aralarındaki sırası ve alt klasörlerin _categories içindeki
  // konumları (hangi indekste oldukları) değişmez, sadece o indekslere
  // hangi alt klasörün yerleştirileceği yeniden hesaplanır. Bu, drawer'da
  // bir alt klasöre basılı tutulduğunda açılan sınırlı kapsamlı sıralama
  // için kullanılır (bkz. _showFolderSortSheet(scopeParent: ...)).
  void _sortCategories(String criterion, {required bool ascending, String? scopeParent}) {
    _categories = _computeSortedCategories(
      criterion,
      ascending: ascending,
      scopeParent: scopeParent,
    );
  }

  // _sortCategories'in saf (side-effect'siz) hesaplama kısmı: `_categories`'i
  // DEĞİŞTİRMEDEN, verilen kritere göre sıralanmış halinin ne olacağını
  // döndürür. İki yerde kullanılır:
  // 1) _sortCategories burada dönen sonucu doğrudan `_categories`'e atar.
  // 2) _categoriesMatchSortCriterion, mevcut `_categories` sırasını bu
  //    sonuçla karşılaştırıp hâlâ o kritere uygun mu diye bakar (bkz. orada).
  List<String> _computeSortedCategories(
    String criterion, {
    required bool ascending,
    String? scopeParent,
  }) {
    int compare(String a, String b) {
      final result = criterion == 'count'
          ? _getCountForCategory(a).compareTo(_getCountForCategory(b))
          : a.toLowerCase().compareTo(b.toLowerCase());
      return ascending ? result : -result;
    }

    if (scopeParent != null) {
      final result = List<String>.from(_categories);
      final indices = <int>[];
      for (var i = 0; i < result.length; i++) {
        if (_categoryParents[result[i]] == scopeParent) indices.add(i);
      }
      final sortedChildren = indices.map((i) => result[i]).toList()
        ..sort(compare);
      for (var k = 0; k < indices.length; k++) {
        result[indices[k]] = sortedChildren[k];
      }
      return result;
    }

    final parents = _categories
        .where((c) => _categoryParents[c] == null)
        .toList()
      ..sort(compare);

    final ordered = <String>[];
    for (final parent in parents) {
      ordered.add(parent);
      final children = _categories
          .where((c) => _categoryParents[c] == parent)
          .toList()
        ..sort(compare);
      ordered.addAll(children);
    }

    // Güvenlik payı: üst klasörü artık `_categories` içinde bulunmayan
    // "yetim" alt klasörler (teorik olarak, üst klasör silinmiş ama
    // referans kalmışsa) yukarıdaki döngüde dahil edilmemiş olabilir;
    // bunlar listenin sonuna, kendi aralarında aynı kritere göre
    // sıralanmış olarak eklenir — hiçbir kategori sessizce kaybolmaz.
    final missing = _categories.where((c) => !ordered.contains(c)).toList()
      ..sort(compare);
    ordered.addAll(missing);

    return ordered;
  }

  // Mevcut `_categories` sırası, kayıtlı kriter+yöne (_folderSortCriterion /
  // _folderSortAscending) göre sıralanmış haliyle BİREBİR aynı mı?
  //
  // Neden gerekli: Kullanıcı önce "İsme göre" sıralasın, sonra yeni bir
  // klasör eklesin (_showAddCategoryDialog yeni klasörü listenin SONUNA
  // ekler, otomatik yeniden sıralama yapmaz). Bu noktada `_categories`
  // artık gerçekten isme göre sıralı DEĞİLDİR, ama `_folderSortCriterion`
  // hâlâ 'name' olduğu için sheet tekrar açıldığında segmented button
  // yanıltıcı biçimde "İsim" seçili görünürdü. Bu fonksiyon, sheet
  // açılırken (bkz. _showFolderSortSheet) gerçek sırayı kayıtlı kriterle
  // karşılaştırıp uyuşmuyorsa `manuallyReordered` bayrağını true
  // başlatmak için kullanılır — böylece hiçbir segment seçili görünmez
  // (manuel taşıma sonrasıyla aynı görsel davranış).
  bool _categoriesMatchSortCriterion({String? scopeParent}) {
    final expected = _computeSortedCategories(
      _folderSortCriterion,
      ascending: _folderSortAscending,
      scopeParent: scopeParent,
    );
    if (expected.length != _categories.length) return false;
    for (var i = 0; i < expected.length; i++) {
      if (expected[i] != _categories[i]) return false;
    }
    return true;
  }

  // Klasörleri, drawer'daki hiyerarşiyi koruyan "taşınabilir bloklar"a
  // ayırır: her üst klasör + kendi alt klasörleri tek bir grup olur, bu
  // sayede manuel sıralama (_showFolderSortSheet'in alt bölümü) bir grubu
  // bütün olarak komşusuyla yer değiştirebilir. Üst klasörü artık
  // `_categories` içinde bulunmayan "yetim" alt klasörler (bkz.
  // _sortCategories'teki aynı güvenlik payı) tek elemanlı kendi grupları
  // olarak eklenir; hiçbir kategori sessizce kaybolmaz.
  List<List<String>> _folderGroups() {
    final groups = <List<String>>[];
    final consumed = <String>{};
    for (final cat in _categories) {
      if (consumed.contains(cat) || _categoryParents[cat] != null) continue;
      final children = _categories
          .where((c) => _categoryParents[c] == cat)
          .toList();
      groups.add([cat, ...children]);
      consumed.add(cat);
      consumed.addAll(children);
    }
    for (final cat in _categories) {
      if (!consumed.contains(cat)) {
        groups.add([cat]);
        consumed.add(cat);
      }
    }
    return groups;
  }

  // Belirli bir üst klasörün doğrudan alt klasörlerini, _categories
  // içindeki mevcut sırayla döndürür. Alt klasöre basılı tutulduğunda
  // açılan sınırlı kapsamlı sıralama sayfası (_showFolderSortSheet'in
  // scopeParent modu) bunu kullanır.
  List<String> _childrenOf(String parent) {
    return _categories.where((c) => _categoryParents[c] == parent).toList();
  }

  // İki KARDEŞ alt klasörün (aynı üst klasöre ait) yerini _categories
  // içinde değiştirir. _swapFolderGroups'tan farkı: orada tüm grup
  // (üst+alt) tek blok olarak taşınırken, burada tek tek iki alt klasör
  // kendi aralarında yer değiştirir — üst klasörlerin veya diğer
  // grupların sırası/konumu etkilenmez.
  void _swapSiblings(String parent, int a, int b) {
    final result = List<String>.from(_categories);
    final indices = <int>[];
    for (var i = 0; i < result.length; i++) {
      if (_categoryParents[result[i]] == parent) indices.add(i);
    }
    final tmp = result[indices[a]];
    result[indices[a]] = result[indices[b]];
    result[indices[b]] = tmp;
    _categories = result;
  }

  // İki grubun (üst+alt klasör bloğunun) yerini değiştirip `_categories`'i
  // yeni düzleştirilmiş sırayla günceller.
  void _swapFolderGroups(List<List<String>> groups, int a, int b) {
    final tmp = groups[a];
    groups[a] = groups[b];
    groups[b] = tmp;
    _categories = groups.expand((g) => g).toList();
  }

  // Klasörleri sıralamak için açılan alt sayfa (bottom sheet). Diğer
  // sheet'lerle (bkz. yukarıdaki showModalBottomSheet çağrıları) aynı
  // görsel desende: kart rengi arka plan, üstte yuvarlatılmış köşeler,
  // SafeArea + 16px iç boşluk.
  //
  // NOT: Bu, sadece giriş noktasını (drawer'daki Icons.sort ikonu) açan
  // iskelet sürümdür. Otomatik sıralama seçenekleri (kriter + artan/azalan)
  // ve manuel taşıma listesi sonraki aşamalarda bu builder'ın içine
  // eklenecek.
  // NOT: `scopeParent` null ise (drawer'daki eski genel giriş noktasıyla
  // aynı davranış) tüm üst klasörler + alt klasör grupları sıralanır.
  // `scopeParent` bir üst klasör adı verilirse, sıralama SADECE o üst
  // klasörün doğrudan alt klasörleriyle sınırlanır (hem otomatik
  // kriter/yön sıralaması hem de manuel ▲▼ taşıma bu kapsamda kalır) —
  // bkz. _showCategoryOptions'taki "Sırala" menü öğesi: üst klasöre
  // basılı tutulunca scopeParent: null (tüm klasörler), bir alt klasöre
  // basılı tutulunca scopeParent: <kendi üst klasörü> (yalnızca kardeşleri)
  // ile çağrılır.
  void _showFolderSortSheet({String? scopeParent}) {
    // Manuel bölümde seçili grup (scopeParent == null: üst klasör + alt
    // klasörleri; scopeParent != null: tek bir alt klasör) indeksi. Sheet
    // kapanana kadar bu closure değişkeninde tutulur; her setSheetState
    // çağrısında builder yeniden çalışsa da değer korunur.
    int? selectedGroupIndex;
    // Kullanıcı manuel ▲▼ ile bir grubu taşıdığında true olur; bu andan
    // itibaren mevcut sıra artık "isme göre" veya "sayıya göre" kriterinin
    // sonucuyla birebir uyuşmayabilir. Segmented kontrolde hâlâ bir kriter
    // seçili görünmesi yanıltıcı olduğundan, manuel taşıma sonrası her iki
    // segment de pasif (seçimsiz) gösterilir. Kriter veya yön chip'ine
    // tekrar dokunulursa (applySort) otomatik sıralama devreye girer ve bu
    // bayrak tekrar false'a döner.
    //
    // Başlangıç değeri de aynı mantıkla hesaplanır: sheet en son "İsme
    // göre" (veya "Sayıya göre") ile kapatılmış olsa bile, o kapanıştan
    // sonra yeni bir klasör eklenmiş olabilir (_showAddCategoryDialog yeni
    // klasörü listenin SONUNA ekler, otomatik sıralamayı tetiklemez). Bu
    // durumda mevcut `_categories` artık kayıtlı kriterle uyuşmuyordur;
    // bkz. _categoriesMatchSortCriterion. Uyuşmuyorsa sheet açılır
    // açılmaz segment'ler seçimsiz gösterilir — kullanıcı "isme göre"
    // sanıp yanılmasın.
    bool manuallyReordered = !_categoriesMatchSortCriterion(
      scopeParent: scopeParent,
    );

    showModalBottomSheet(
      context: context,
      // Sheet içeriği (başlık + chip'ler + manuel liste) ekranın
      // varsayılan yarım-yükseklik sınırını aşabildiği için, sheet'in
      // gerektiğinde tam ekran yüksekliğine kadar büyüyebilmesi gerekiyor.
      // Aksi halde küçük ekranlarda / klavye açıkken "bottom overflowed"
      // hatası oluşuyordu.
      isScrollControlled: true,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => StatefulBuilder(
        builder: (sheetContext, setSheetState) {
          // Kriter veya yön değiştiğinde: 1. aşamadaki saf sıralama
          // fonksiyonu çağrılıp _categories güncellenir, kalıcı hale
          // getirilir (dış setState + _saveData) ve sheet'teki chip'lerin
          // seçili görünümü tazelenir (iç setSheetState).
          void applySort() {
            setState(() {
              _sortCategories(
                _folderSortCriterion,
                ascending: _folderSortAscending,
                scopeParent: scopeParent,
              );
            });
            _saveData();
            setSheetState(() {
              manuallyReordered = false;
            });
          }

          // Manuel bölüm her rebuild'de güncel `_categories`'ten yeniden
          // hesaplanır (otomatik sıralama chip'leri de _categories'i
          // değiştirdiğinde bu liste senkron kalsın diye).
          // scopeParent == null: eskisi gibi üst+alt grupları.
          // scopeParent != null: sadece o üst klasörün alt klasörleri,
          // her biri tek elemanlı bir "grup" olarak (aşağıdaki liste
          // görünümü ve group.first/group.skip(1) mantığı aynen
          // çalışabilsin diye) — ama taşıma (moveSelected) alt klasörleri
          // grup olarak değil, tek tek kardeş olarak kaydırır.
          final groups = scopeParent == null
              ? _folderGroups()
              : _childrenOf(scopeParent).map((c) => [c]).toList();
          if (selectedGroupIndex != null &&
              selectedGroupIndex! >= groups.length) {
            selectedGroupIndex = null;
          }

          void moveSelected(int delta) {
            final index = selectedGroupIndex;
            if (index == null) return;
            final target = index + delta;
            if (target < 0 || target >= groups.length) return;
            setState(() {
              if (scopeParent == null) {
                _swapFolderGroups(groups, index, target);
              } else {
                _swapSiblings(scopeParent, index, target);
              }
            });
            _saveData();
            setSheetState(() {
              selectedGroupIndex = target;
              manuallyReordered = true;
            });
          }

          // Sheet'in alabileceği azami yükseklik: ekranın %85'i, klavye
          // açıksa klavye kadar daha az. Böylece başlık/chip/divider gibi
          // sabit yükseklikli bölümler + manuel liste toplamı bu sınırı
          // aşarsa, taşma yerine liste kendi içinde scroll olur (aşağıdaki
          // Flexible+ListView).
          final mediaQuery = MediaQuery.of(sheetContext);
          final maxSheetHeight =
              mediaQuery.size.height * 0.85 - mediaQuery.viewInsets.bottom;

          return SafeArea(
            child: Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: 16 + mediaQuery.viewInsets.bottom,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: maxSheetHeight > 0 ? maxSheetHeight : 400,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        scopeParent == null
                            ? AppLocalizations.of(context)!.reorderFoldersSheetTitle
                            : '${AppLocalizations.of(context)!.reorderFoldersSheetTitle} · ${_getCategoryDisplayName(scopeParent)}',
                        // "Blokları Sırala" sheet'indeki başlık stiliyle
                        // aynı: 16px, kalın, vurgu (accent) renginde.
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: appAccentColor.value,
                        ),
                      ),
                      IconButton(
                        tooltip: AppLocalizations.of(context)!.reorderFoldersCloseTooltip,
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(sheetContext),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Kriter seçimi (isim / not sayısı) tek bir segmented
                  // kontrol olarak; yön ise tek bir ikon butonuyla
                  // (tıklandıkça artan/azalan arası geçiş yapar) yanına
                  // eklenir. Eskiden 4 ayrı ChoiceChip vardı, kalabalık
                  // görünüyordu — artık tek satırda, tek kapsül + tek ikon.
                  Row(
                    children: [
                      Expanded(
                        child: SegmentedButton<String>(
                          segments: [
                            ButtonSegment(
                              value: 'name',
                              label: Text(
                                AppLocalizations.of(context)!.reorderFoldersCriterionNameLabel,
                              ),
                            ),
                            ButtonSegment(
                              value: 'count',
                              label: Text(
                                AppLocalizations.of(context)!.reorderFoldersCriterionCountLabel,
                              ),
                            ),
                          ],
                          selected: manuallyReordered
                              ? const <String>{}
                              : {_folderSortCriterion},
                          emptySelectionAllowed: true,
                          onSelectionChanged: (selection) {
                            _folderSortCriterion = selection.first;
                            applySort();
                          },
                          style: SegmentedButton.styleFrom(
                            visualDensity: VisualDensity.compact,
                            selectedBackgroundColor:
                                appAccentColor.value.withOpacity(0.3),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        tooltip: _folderSortAscending
                            ? AppLocalizations.of(context)!.reorderFoldersAscendingLabel
                            : AppLocalizations.of(context)!.reorderFoldersDescendingLabel,
                        icon: Icon(
                          _folderSortAscending
                              ? Icons.arrow_upward
                              : Icons.arrow_downward,
                          color: Theme.of(context).primaryColor,
                        ),
                        onPressed: () {
                          _folderSortAscending = !_folderSortAscending;
                          applySort();
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Divider(color: Theme.of(context).dividerColor, height: 1),
                  const SizedBox(height: 8),
                  // Manuel taşıma bölüm başlığı + ▲▼ kontrolleri. Kontroller
                  // her zaman görünür ama bir grup seçili değilken veya
                  // seçili grup zaten en uçtaysa (ilk/son) devre dışı kalır.
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.reorderFoldersManualSectionTitle,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            tooltip: AppLocalizations.of(context)!.reorderFoldersMoveUpTooltip,
                            // "Blokları Sırala" sheet'indeki ok tasarımıyla
                            // aynı: keyboard_arrow ikonu + etkinken accent,
                            // pasifken gri renk (bkz.
                            // note_list_note_dialog_mixin.dart ->
                            // showBlockReorderSheet).
                            icon: Icon(
                              Icons.keyboard_arrow_up,
                              color:
                                  selectedGroupIndex != null &&
                                      selectedGroupIndex! > 0
                                  ? appAccentColor.value
                                  : Colors.grey,
                            ),
                            onPressed:
                                selectedGroupIndex != null &&
                                    selectedGroupIndex! > 0
                                ? () => moveSelected(-1)
                                : null,
                          ),
                          IconButton(
                            tooltip: AppLocalizations.of(context)!.reorderFoldersMoveDownTooltip,
                            icon: Icon(
                              Icons.keyboard_arrow_down,
                              color:
                                  selectedGroupIndex != null &&
                                      selectedGroupIndex! < groups.length - 1
                                  ? appAccentColor.value
                                  : Colors.grey,
                            ),
                            onPressed:
                                selectedGroupIndex != null &&
                                    selectedGroupIndex! < groups.length - 1
                                ? () => moveSelected(1)
                                : null,
                          ),
                        ],
                      ),
                    ],
                  ),
                  Text(
                    AppLocalizations.of(context)!.reorderFoldersManualSectionDescription,
                    style: TextStyle(
                      fontSize: 12,
                      color: dNoteIsDark(context)
                          ? Colors.grey
                          : Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Not: Eskiden burada sabit `maxHeight: 260` vardı; küçük
                  // ekranlarda/klavye açıkken üstteki bölümlerle toplam
                  // yükseklik sheet'e sığmayıp "bottom overflowed" hatası
                  // veriyordu. `Flexible` ile liste, dıştaki
                  // ConstrainedBox(maxHeight: maxSheetHeight) tarafından
                  // belirlenen kalan alanı kullanır; sığmayan kısım listenin
                  // kendi scroll'una düşer, Column asla taşmaz.
                  Flexible(
                    child: ListView.builder(
                      shrinkWrap: true,
                      // "Blokları Sırala" listesiyle aynı dış boşluk.
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      itemCount: groups.length,
                      itemBuilder: (context, i) {
                        final group = groups[i];
                        final isSelected = selectedGroupIndex == i;
                        // Önceden burada elle çizilmiş bir Padding+Column
                        // vardı; ListTile'ın varsayılan minimum yüksekliği
                        // (~56dp) ve iç boşluğunu vermediği için "Blokları
                        // Sırala"daki (gerçek ListTile kullanan) satırlara
                        // kıyasla daha dar/sıkışık görünüyordu. Artık
                        // gerçek bir ListTile kullanılıyor — satır
                        // yüksekliği, iç boşluk ve başlık yazı stili
                        // birebir aynı desende.
                        return Material(
                          color: isSelected
                              ? appAccentColor.value.withOpacity(0.15)
                              : Colors.transparent,
                          child: ListTile(
                            // Drawer'daki klasör satırlarıyla (bkz.
                            // _buildCategoryDrawerTile) aynı renk mantığı:
                            // her klasörün kendi rengi (_getCategoryColor)
                            // kullanılır, sabit vurgu rengi değil.
                            leading: Icon(
                              Icons.folder_outlined,
                              color: _getCategoryColor(group.first),
                            ),
                            title: Text(
                              group.first,
                              style: const TextStyle(fontSize: 16),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Normal klasör (drawer) görünümündeki
                                // sayaçla birebir aynı stil — bkz.
                                // _buildCategoryDrawerTile.
                                Text(
                                  _getCountForCategory(group.first).toString(),
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                if (isSelected) ...[
                                  const SizedBox(width: 8),
                                  Icon(
                                    Icons.check_circle,
                                    color: appAccentColor.value,
                                  ),
                                ],
                              ],
                            ),
                            onTap: () => setSheetState(() {
                              selectedGroupIndex = isSelected ? null : i;
                            }),
                          ),
                        );
                      },
                    ),
                  ),
                ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ---- Diğer mixin'lerde tanımlı, burada kullanılan üyeler ----
  String get _activeCategory;
  set _activeCategory(String value);
  Future<void> _appendSpeechTranscriptToNote(int noteIndex, String text);
  void _archiveSelectedNotes();
  String? get _attachmentsDirPath;
  set _attachmentsDirPath(String? value);
  Widget _buildCategoryDrawerTile(String cat, {bool isSubfolder = false});
  List<dynamic> _buildDateGroupedItems(List<Map<String, dynamic>> notes);
  // note_flag_mixin.dart -> bayrak rozetini (dolu, sabit, tıklanamaz)
  // kart önizlemesinde çizen widget.
  Widget _buildFlagBadge({required String flagColor, double size = 14});
  String _capitalizeFirstLetterTr(String text);
  List<String> get _categories;
  set _categories(List<String> value);
  List<Color> get _categoryPalette;
  Map<String, String?> get _categoryParents;
  set _categoryParents(Map<String, String?> value);
  void _cleanupAttachmentFiles(Map<String, dynamic> note);
  Set<String> get _collapsedCategories;
  set _collapsedCategories(Set<String> value);
  Set<String> get _collapsedDateGroups;
  set _collapsedDateGroups(Set<String> value);
  bool get _colorfulNotes;
  set _colorfulNotes(bool value);
  void _deleteSelectedNotes();
  List<Map<String, dynamic>> get _deletedNotes;
  set _deletedNotes(List<Map<String, dynamic>> value);
  void _exitSelectionMode();
  String _folderTagLabel(String category);
  String _formatDateTimeShortTr(DateTime dt);
  Color _getCategoryColor(String? category);
  String _getCategoryDisplayName(String category);
  int _getCountForCategory(String category);
  String get _fontFamily;
  double get _globalFontSize;
  set _globalFontSize(double value);
  Future<bool> _handleBackPress();
  bool get _isAscending;
  set _isAscending(bool value);
  bool get _isListView;
  set _isListView(bool value);
  bool get _isSearching;
  set _isSearching(bool value);
  bool get _isSelectionMode;
  set _isSelectionMode(bool value);
  String _noteKey(Map<String, dynamic> note);
  List<Map<String, dynamic>> get _notes;
  set _notes(List<Map<String, dynamic>> value);
  Future<void> _openLockedFolder();
  Future<void> _openNoteWithPasswordCheck(int index, {bool openInstantly = false});
  void _openSettings();
  int get _previewLines;
  set _previewLines(int value);
  void _rescheduleNoteReminder(Map<String, dynamic> note);
  Future<void> _saveData();
  GlobalKey<ScaffoldState> get _scaffoldKey;
  TextEditingController get _searchController;
  String get _searchQuery;
  set _searchQuery(String value);
  Set<String> get _selectedNoteKeys;
  set _selectedNoteKeys(Set<String> value);
  void _showAddCategoryDialog({ void Function(String)? onAdded, String? editingCategory, String? parentCategory, });
  void _showClassifyDialogForSelection();
  // note_list_actions_mixin.dart -> _showInfoBar: etiket yeniden
  // adlandırma/silme sonrası kısa bilgi barı göstermek için burada da
  // kullanılıyor (bkz. _handleTagLongPress ve altındaki yardımcılar).
  void _showInfoBar(
    String message, {
    IconData icon,
    String? actionLabel,
    VoidCallback? onAction,
    Color backgroundColor,
  });
  void _showNoteActions( BuildContext ctx, int noteIndex, bool isTrash, { DateTime? editorReminder, String? editorReminderRepeat, void Function(DateTime? reminder, String? repeat)? onReminderChanged, VoidCallback? onDiscard, void Function(String text)? onInsertText, void Function(String? category)? onCategoryChanged, bool showSelectAction = false, });
  Future<void> _showNoteDialog({ int? index, String type = 'text', String? initialText, DateTime? initialAssignedDate, bool openInstantly = false, });
  String get _sortCriteria;
  set _sortCriteria(String value);
  Color? get _textColor;
  set _textColor(Color? value);
  void _toggleNoteSelection(Map<String, dynamic> note);

  // ════════════════════════════════════════════════════════════════════
  // Kart köşesindeki rozetler: yıldız (favori), kilit, bayrak.
  // Hem ızgara hem liste kartında AYNI mantıkla, ortak bir Stack
  // (kartın tüm alanını kaplayan) içine Positioned olarak eklenir:
  //   - Yıldız varsa HER ZAMAN sağ üstte durur (top: 8, right: 8).
  //   - Kilit varsa: yıldız da varsa yıldızın SOLUNA değil ALTINA gelir
  //     (top: 8+22, right: 8 — aynı sütun, bir alt satır); yıldız yoksa
  //     yıldızın yerine geçer (top: 8, right: 8).
  //   - Bayrak, yıldız/kilit'ten TAMAMEN BAĞIMSIZ, tek bir sabit noktada
  //     durur (top: 0, right: 8+22) — kilit dikeyde alta indiği için
  //     yatayda ekstra yer kaplamaz, bu yüzden bayrağın konumu yıldız/
  //     kilit'in var/yok olmasından hiç etkilenmez.
  //   - Sabitlenmiş (pin) rozeti, sağdaki hiçbir rozetle çakışmasın diye
  //     kartın SOL üst köşesinde (top: 8, left: 8), sabit gri renkte
  //     gösterilir. Bkz. db_helper.dart'ta eklenmesi gereken 'isPinned'
  //     sütunu ve not_list_actions_mixin.dart > _saveNoteIfValid.
  List<Widget> _buildNoteCornerBadges({
    required bool isFavorite,
    required bool isLocked,
    required String? flagColor,
    required bool isPinned,
  }) {
    const double slot = 22; // bir rozetin kapladığı dikey/yatay pay (18 ikon + 4 boşluk)
    const double edge = 8; // kartın kenarından iç boşluk
    return [
      if (isFavorite)
        Positioned(
          top: edge,
          right: edge,
          child: Icon(Icons.star, color: appAccentColor.value, size: 18),
        ),
      if (isLocked)
        Positioned(
          top: edge + (isFavorite ? slot : 0),
          right: edge,
          child: const Icon(Icons.lock, color: Colors.grey, size: 16),
        ),
      if (flagColor != null)
        Positioned(
          top: 0,
          right: edge + slot,
          child: _buildFlagBadge(flagColor: flagColor, size: 16),
        ),
      if (isPinned)
        Positioned(
          top: edge - 4,
          left: edge,
          // Sola yatık (döndürülmüş) görünüm: Google Keep'teki eğik iğne
          // ikonuyla benzer bir izlenim vermesi için saat yönünün TERSİNE
          // (negatif radyan) hafifçe döndürülür.
          child: Transform.rotate(
            angle: -0.5,
            child: const Icon(Icons.push_pin, color: Colors.grey, size: 18),
          ),
        ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredNotes;
    SystemChrome.setSystemUIOverlayStyle(
      dNoteSystemBarsStyle(
        context,
        // Not düzenleyicisi açıkken bu build tekrar tetiklenirse (ör. bir
        // setState nedeniyle), gezinme çubuğunu düzenleyicinin ayarladığı
        // renge (#EDEDED) geri döndürüyoruz; aksi halde varsayılan
        // (#F5F5F5) rengine sıfırlanıp düzenleyicinin rengini eziyordu.
        // Yalnızca açık temada uygulanır; koyu tema davranışı değişmez.
        navigationBarColor: (!dNoteIsDark(context) && dNoteNoteEditorOpen.value)
            ? const Color(0xFFEDEDED)
            : null,
      ),
    );
    bool isTrash = _activeCategory == '__trash__';
    // Arama modundaki etiket şeridi için: aktif bölümde (Tümü/Notlar,
    // Favoriler, klasör, vb.) hangi etiketlerin bulunduğu build başında bir
    // kez hesaplanır. Liste boşsa aşağıda `bottom` tamamen null bırakılır —
    // sadece içeriği boş bir widget döndürmek yeterli değil, çünkü
    // PreferredSize'ın yüksekliği (44) her durumda ayrılan alanı belirler;
    // bu da etiket olmasa bile boş bir şeridin açılmasına yol açardı.
    final tagStripScopeNotes = _notesForActiveTagScope(isTrash);
    final tagStripTags = collectAllKnownTags(tagStripScopeNotes);
    // Etiket şeridinin başında gösterilecek bayrak renkleri — aynı kapsam
    // (tagStripScopeNotes), aynı "sadece o bölümde fiilen görünenler"
    // mantığı (bkz. _notesForActiveTagScope yorumu).
    final tagStripFlagColors = _availableFlagColors(tagStripScopeNotes);
    // Etiket şeridinden bağımsız "Türler" şeridi: içerik olsun ya da olmasın
    // (kullanıcı isteği üzerine) her zaman sabit 7 ikon gösterilir — etiket
    // şeridinin aksine, o an hangi türden not olduğuna bakılmaz.
    final typeStripTypes = _kAllTypeFilterKeys;

    if (isTrash) {
      filteredNotes = _deletedNotes.where((note) {
        final title = (note['title'] ?? '').toString().toLowerCase();
        final content = ContentBlocks.plainText(
          note['content'] as String?,
          totalLabelBuilder: (amount) =>
              AppLocalizations.of(context)!.calcTableTotalLabel(amount),
        ).toLowerCase();
        final query = _searchQuery.toLowerCase();
        // Etiketler de arama kapsamına dahil: notun etiketlerinden biri
        // sorguyu içeriyorsa da not sonuçta gösterilir (başlık/içerik ile
        // aynı mantık — kısmi eşleşme yeterli).
        final tagsRaw = note['tags'];
        final matchesTags = tagsRaw is List &&
            tagsRaw.any((t) => t.toString().toLowerCase().contains(query));
        final matchesSearch =
            title.contains(query) || content.contains(query) || matchesTags;
        final matchesType = _activeTypeFilter == null ||
            _noteMatchesTypeFilter(note, _activeTypeFilter!);
        final matchesFlag = _activeFlagFilter == null ||
            note['flagColor'] == _activeFlagFilter;
        return matchesSearch && matchesType && matchesFlag;
      }).toList();
    } else {
      filteredNotes = _notes.where((note) {
        final title = (note['title'] ?? '').toString().toLowerCase();
        final content = ContentBlocks.plainText(
          note['content'] as String?,
          totalLabelBuilder: (amount) =>
              AppLocalizations.of(context)!.calcTableTotalLabel(amount),
        ).toLowerCase();
        final query = _searchQuery.toLowerCase();
        final tagsRaw = note['tags'];
        final matchesTags = tagsRaw is List &&
            tagsRaw.any((t) => t.toString().toLowerCase().contains(query));
        final matchesSearch =
            title.contains(query) || content.contains(query) || matchesTags;
        final matchesType = _activeTypeFilter == null ||
            _noteMatchesTypeFilter(note, _activeTypeFilter!);
        final matchesFlag = _activeFlagFilter == null ||
            note['flagColor'] == _activeFlagFilter;
        final isArchived = note['isArchived'] == true;
        final isFavorite = note['isFavorite'] == true;
        final isLocked = note['isLocked'] == true;

        if (_activeCategory == 'Tümü' || _activeCategory == 'Notlar') {
          return matchesSearch &&
              matchesType &&
              matchesFlag &&
              !isArchived &&
              !isLocked;
        } else if (_activeCategory == '__favorites__') {
          return matchesSearch &&
              matchesType &&
              matchesFlag &&
              isFavorite &&
              !isArchived &&
              !isLocked;
        } else if (_activeCategory == '__locked__') {
          return matchesSearch &&
              matchesType &&
              matchesFlag &&
              isLocked &&
              !isArchived;
        } else if (_activeCategory == '__archive__') {
          return matchesSearch &&
              matchesType &&
              matchesFlag &&
              isArchived &&
              !isLocked;
        } else if (_activeCategory == '__reminders__') {
          return matchesSearch &&
              matchesType &&
              matchesFlag &&
              _hasActiveReminder(note) &&
              !isArchived &&
              !isLocked;
        } else {
          return matchesSearch &&
              matchesType &&
              matchesFlag &&
              !isArchived &&
              !isLocked &&
              note['category'] == _activeCategory;
        }
      }).toList();
    }

    if (_activeCategory == '__reminders__') {
      filteredNotes.sort((a, b) {
        final aDate =
            DateTime.tryParse((a['reminderDate'] ?? '').toString()) ??
            DateTime(9999);
        final bDate =
            DateTime.tryParse((b['reminderDate'] ?? '').toString()) ??
            DateTime(9999);
        return aDate.compareTo(bDate);
      });
    } else {
      filteredNotes.sort((a, b) {
        // Sabitlenmiş (pin) notlar, seçili sıralama kriterinden bağımsız
        // olarak HER ZAMAN en başta gösterilir. İki not da sabitli ya da
        // ikisi de değilse aradaki fark 0 kalır ve aşağıdaki normal
        // kritere göre sıralanmaya devam edilir; NOT: bu, "Son Düzenleme"
        // ya da "Oluşturulma" kriterinde tarih başlıklarıyla gruplanan
        // görünümde (_buildDateGroupedItems), sabitlenmiş bir notun
        // kendi tarihinden kopup üste taşınması yüzünden aynı tarih
        // etiketinin listede iki kez belirmesine yol açabilir — bu bilinen
        // ve kabul edilen bir görsel istisnadır.
        final aPinned = a['isPinned'] == true;
        final bPinned = b['isPinned'] == true;
        if (aPinned != bPinned) return aPinned ? -1 : 1;

        int compareResult = 0;
        switch (_sortCriteria) {
          case "Başlık":
            // DÜZELTME 1: compareTo büyük/küçük harf duyarlıydı (kod
            // noktası karşılaştırması), bu yüzden büyük harfle başlayan
            // başlıklar her zaman küçük harfle başlayanlardan önce
            // geliyordu (ör. "Zebra" < "elma"), gerçek alfabetik sırayla
            // uyuşmuyordu. toLowerCase() ile büyük/küçük harf farkı
            // ortadan kaldırılır.
            //
            // DÜZELTME 2: Başlığı olmayan (boş string) notlar, boş
            // string'in alfabetik olarak en küçük değer sayılması
            // yüzünden her zaman "Artan" sıralamada en başa yığılıyordu.
            // Artık başlıksız notlar, sıralama yönünden (Artan/Azalan)
            // bağımsız olarak HER ZAMAN listenin sonunda kalıyor — bu
            // switch'in sonucu aşağıda `_isAscending ? compareResult :
            // -compareResult` ile ters çevrildiğinden, o ters çevirmeyi
            // burada önceden telafi ediyoruz.
            final aTitle = (a['title'] ?? '').toString();
            final bTitle = (b['title'] ?? '').toString();
            final aTitleEmpty = aTitle.isEmpty;
            final bTitleEmpty = bTitle.isEmpty;
            if (aTitleEmpty != bTitleEmpty) {
              compareResult =
                  (aTitleEmpty ? 1 : -1) * (_isAscending ? 1 : -1);
            } else {
              compareResult = aTitle.toLowerCase().compareTo(
                bTitle.toLowerCase(),
              );
            }
            break;
          case "Kategori":
            // Başlık sıralamasıyla aynı mantık: büyük/küçük harf
            // duyarsız karşılaştırma ve klasörsüz (kategori boş) notlar
            // sıralama yönünden bağımsız olarak her zaman en sonda.
            final aCategory = (a['category'] ?? '').toString();
            final bCategory = (b['category'] ?? '').toString();
            final aCategoryEmpty = aCategory.isEmpty;
            final bCategoryEmpty = bCategory.isEmpty;
            if (aCategoryEmpty != bCategoryEmpty) {
              compareResult =
                  (aCategoryEmpty ? 1 : -1) * (_isAscending ? 1 : -1);
            } else {
              compareResult = aCategory.toLowerCase().compareTo(
                bCategory.toLowerCase(),
              );
            }
            break;
          case "Renk":
            compareResult = (a['color'] ?? '').toString().compareTo(
              (b['color'] ?? '').toString(),
            );
            break;
          case "Son Düzenleme":
            compareResult = (a['modifiedDate'] ?? '').toString().compareTo(
              (b['modifiedDate'] ?? '').toString(),
            );
            break;
          case "Oluşturulma":
          default:
            compareResult = (a['createdDate'] ?? '').toString().compareTo(
              (b['createdDate'] ?? '').toString(),
            );
            break;
        }
        return _isAscending ? compareResult : -compareResult;
      });
    }

    final bool showDateGroups =
        _isListView &&
        !isTrash &&
        _activeCategory != '__reminders__' &&
        (_sortCriteria == 'Son Düzenleme' || _sortCriteria == 'Oluşturulma');
    final List<dynamic> rawListItems = showDateGroups
        ? _buildDateGroupedItems(filteredNotes)
        : filteredNotes;
    // Daraltılmış (kapalı) tarih gruplarının altındaki not kartlarını
    // görünümden çıkarır; grup başlığının (String) kendisi her zaman
    // görünür kalır, sadece bir sonraki başlığa kadar olan notlar
    // (Map<String, dynamic>) gizlenir. Tarih grupları kapalıyken bile
    // sırayla işlendiği için birden fazla grup aynı anda bağımsız
    // şekilde daraltılmış/açık olabilir.
    final List<dynamic> listItems = showDateGroups
        ? (() {
            final List<dynamic> filtered = [];
            String? currentLabel;
            for (final item in rawListItems) {
              if (item is String) {
                currentLabel = item;
                filtered.add(item);
              } else if (currentLabel == null ||
                  !_collapsedDateGroups.contains(currentLabel)) {
                filtered.add(item);
              }
            }
            return filtered;
          })()
        : rawListItems;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        if (_scaffoldKey.currentState?.isDrawerOpen == true) {
          _scaffoldKey.currentState?.closeDrawer();
          return;
        }
        if (_isSearching) {
          setState(() {
            _isSearching = false;
            _searchQuery = "";
            _searchController.clear();
            _activeTypeFilter = null;
            _activeFlagFilter = null;
          });
          FocusScope.of(context).unfocus();
          return;
        }

        if (_activeCategory != 'Tümü' && _activeCategory != 'Notlar') {
          setState(() {
            _activeCategory = 'Tümü';
          });
          _saveData();
          return;
        }

        await _handleBackPress();
      },
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: true,
        // Menü (Drawer) önceden tüm ekran genişliğinden kaydırılarak
        // açılabiliyordu; bu da not içeriği üzerinde (özellikle yatay
        // kaydırma gerektiren yerlerde) istenmeden menünün açılmasına yol
        // açıyordu. Sadece ekranın sol kenarındaki dar bir şeritten
        // kaydırınca açılsın diye standart bir kenar genişliğine
        // (24 mantıksal piksel) düşürüldü.
        drawerEdgeDragWidth: 24.0,
        // Menü (Drawer) açıldığında Flutter'ın varsayılan siyah yarı saydam
        // scrim'i arka planı koyulaştırıyor. Koyu temada zaten koyu bir zemin
        // üzerine bindiği için fark edilmiyordu; açık temada ise FAB gibi alt
        // bar öğelerini soluklaştırıyordu. Scrim'i kaldırarak her iki temada
        // da tutarlı, koyu temadaki gibi "silikleşmeyen" bir görünüm sağlanır.
        drawerScrimColor: Colors.transparent,
        appBar: AppBar(
          // Üst çubuktaki ikon ve başlık rengi: artık vurgu rengi (appAccentColor)
          // yerine, not düzenleyicisindeki üst çubukla aynı yumuşak nötr ton
          // kullanılıyor — koyu temada beyaza yakın gri, açık temada siyaha
          // yakın gri (bkz. dNoteListAppBarColor, main.dart).
          leading: _isSelectionMode
              ? IconButton(
                  icon: Icon(Icons.close, color: dNoteListAppBarColor(context)),
                  tooltip: AppLocalizations.of(context)!.selectionModeCancelTooltip,
                  onPressed: _exitSelectionMode,
                )
              : null,
          title: _isSelectionMode
              ? Text(
                  AppLocalizations.of(context)!.selectionModeSelectedCountTitle(
                    _selectedNoteKeys.length,
                  ),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: dNoteListAppBarColor(context),
                    fontSize: 18,
                  ),
                )
              : _isSearching
              ? TextField(
                  selectionWidthStyle: ui.BoxWidthStyle.tight,
                  controller: _searchController,
                  autofocus: true,
                  contextMenuBuilder: buildCustomContextMenu,
                  selectionHeightStyle: ui.BoxHeightStyle.max,
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.searchFieldHint,
                    border: InputBorder.none,
                    hintStyle: const TextStyle(color: Colors.grey),
                  ),
                  style: const TextStyle(fontSize: 18),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                )
              : Text(
                  _getCategoryDisplayName(_activeCategory),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: dNoteListAppBarColor(context),
                    fontSize: 18,
                  ),
                ),
          elevation: 0,
          centerTitle: false,
          titleSpacing: 0,
          iconTheme: IconThemeData(color: dNoteListAppBarColor(context)),
          actions: _isSelectionMode
              ? [
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    tooltip: AppLocalizations.of(context)!.selectionModeDeleteTooltip,
                    onPressed: _deleteSelectedNotes,
                  ),
                  IconButton(
                    icon: Icon(Icons.archive_outlined, color: dNoteListAppBarColor(context)),
                    tooltip: AppLocalizations.of(context)!.selectionModeArchiveTooltip,
                    onPressed: _archiveSelectedNotes,
                  ),
                  IconButton(
                    icon: Icon(Icons.folder_outlined, color: dNoteListAppBarColor(context)),
                    tooltip: AppLocalizations.of(context)!.selectionModeFolderTooltip,
                    onPressed: _showClassifyDialogForSelection,
                  ),
                ]
              : [
            IconButton(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              icon: Icon(
                _isSearching ? Icons.close : Icons.search,
                color: dNoteListAppBarColor(context),
              ),
              onPressed: () {
                setState(() {
                  _isSearching = !_isSearching;
                  if (!_isSearching) {
                    _searchQuery = "";
                    _searchController.clear();
                    _activeTypeFilter = null;
                    _activeFlagFilter = null;
                  }
                });
              },
            ),
            if (isTrash)
              PopupMenuButton<String>(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                icon: Icon(Icons.more_vert, color: dNoteListAppBarColor(context)),
                onSelected: (String choice) {
                  if (choice == 'empty') {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(
                          AppLocalizations.of(context)!.emptyTrashDialogTitle,
                          style: TextStyle(color: appAccentColor.value),
                        ),
                        content: Text(
                          AppLocalizations.of(context)!
                              .emptyTrashDialogConfirmMessage,
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              AppLocalizations.of(context)!
                                  .emptyTrashDialogCancelButton,
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                            onPressed: () {
                              for (final n in _deletedNotes) {
                                _cleanupAttachmentFiles(n);
                              }
                              setState(() {
                                _deletedNotes.clear();
                              });
                              _saveData();
                              Navigator.pop(context);
                            },
                            child: Text(
                              AppLocalizations.of(context)!
                                  .selectionModeDeleteTooltip,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    );
                  } else if (choice == 'restore_all') {
                    final restored = List<Map<String, dynamic>>.from(
                      _deletedNotes,
                    );
                    setState(() {
                      for (var n in _deletedNotes) {
                        n['createdDate'] = DateTime.now().toString();
                        n['modifiedDate'] = DateTime.now().toString();
                      }
                      _notes.insertAll(0, _deletedNotes);
                      _deletedNotes.clear();
                    });
                    _saveData();
                    for (final n in restored) {
                      _rescheduleNoteReminder(n);
                    }
                  }
                },
                itemBuilder: (BuildContext context) {
                  return [
                    PopupMenuItem(
                      value: 'empty',
                      child: Text(
                        AppLocalizations.of(context)!.emptyTrashDialogTitle,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                    PopupMenuItem(
                      value: 'restore_all',
                      child: Text(
                        AppLocalizations.of(context)!.restoreAllMenuItemLabel,
                        style: TextStyle(color: appAccentColor.value),
                      ),
                    ),
                  ];
                },
              )
            else
              PopupMenuButton<String>(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                icon: Icon(Icons.sort, color: dNoteListAppBarColor(context)),
                tooltip: AppLocalizations.of(context)!.sortMenuTooltip,
                onSelected: (String choice) {
                  setState(() {
                    if (choice == "Artan") {
                      _isAscending = true;
                    } else if (choice == "Azalan") {
                      _isAscending = false;
                    } else {
                      _sortCriteria = choice;
                    }
                  });
                  _saveData();
                },
                itemBuilder: (BuildContext context) {
                  return [
                    CheckedPopupMenuItem<String>(
                      value: 'Artan',
                      checked: _isAscending,
                      child: Text(
                        AppLocalizations.of(context)!.sortMenuAscendingLabel,
                      ),
                    ),
                    CheckedPopupMenuItem<String>(
                      value: 'Azalan',
                      checked: !_isAscending,
                      child: Text(
                        AppLocalizations.of(context)!.sortMenuDescendingLabel,
                      ),
                    ),
                    const PopupMenuDivider(),
                    CheckedPopupMenuItem<String>(
                      value: 'Başlık',
                      checked: _sortCriteria == 'Başlık',
                      child: Text(
                        AppLocalizations.of(context)!.sortMenuByTitleLabel,
                      ),
                    ),
                    CheckedPopupMenuItem<String>(
                      value: 'Son Düzenleme',
                      checked: _sortCriteria == 'Son Düzenleme',
                      child: Text(
                        AppLocalizations.of(context)!
                            .sortMenuByModifiedDateLabel,
                      ),
                    ),
                    CheckedPopupMenuItem<String>(
                      value: 'Oluşturulma',
                      checked: _sortCriteria == 'Oluşturulma',
                      child: Text(
                        AppLocalizations.of(context)!
                            .sortMenuByCreatedDateLabel,
                      ),
                    ),
                    CheckedPopupMenuItem<String>(
                      value: 'Kategori',
                      checked: _sortCriteria == 'Kategori',
                      child: Text(
                        AppLocalizations.of(context)!.sortMenuByFolderLabel,
                      ),
                    ),
                  ];
                },
              ),
            IconButton(
              icon: Icon(
                _isListView ? Icons.grid_view : Icons.view_list,
                color: dNoteListAppBarColor(context),
              ),
              tooltip: _isListView
                  ? AppLocalizations.of(context)!.viewToggleGridTooltip
                  : AppLocalizations.of(context)!.viewToggleListTooltip,
              onPressed: () {
                setState(() {
                  _isListView = !_isListView;
                });
                _saveData();
              },
            ),
          ],
          // NOT: Etiket şeridi artık AppBar'ın `bottom` alanında değil,
          // body'nin en üstünde (bkz. aşağıdaki `_TagFilterStrip` kullanımı)
          // gösteriliyor. Sebebi: AppBar'ın kendi yüksekliği (preferredSize)
          // build başına sabit bir değerdir ve Flutter bunu kare kare
          // animasyonlamaz; `bottom` null'dan bir widget'a geçtiğinde alan
          // aniden 44px büyüyordu, içerideki kayma/solma animasyonu da bu
          // sabit kutunun içinde neredeyse fark edilmiyordu. Body içindeki
          // `AnimatedSize` ise gerçek bir yükseklik animasyonu sağladığı
          // için şerit gerçekten yukarıdan kayarak/büyüyerek açılıyor.
        ),
        drawer: Drawer(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: SafeArea(
            top: false,
            child: Container(
              color: Theme.of(context).cardColor,
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                    decoration: BoxDecoration(color: dNoteHeaderColor(context)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Layout',
                          style: TextStyle(
                            color: appAccentColor.value,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          AppLocalizations.of(context)!.drawerHeaderSubtitle,
                          style: TextStyle(
                            color: dNoteIsDark(context)
                                ? Colors.grey
                                : Colors.grey[700],
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(left: 16, top: 6, bottom: 4),
                    child: Text(
                      AppLocalizations.of(context)!.drawerNotesSectionHeader,
                      style: TextStyle(
                        color: dNoteIsDark(context)
                            ? Colors.grey
                            : Colors.grey[700],
                        fontSize: 12,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  Container(
                    color:
                        (_activeCategory == 'Tümü' ||
                            _activeCategory == 'Notlar')
                        ? dNoteHighlight(context)
                        : Colors.transparent,
                    child: ListTile(
                      contentPadding: const EdgeInsets.only(
                        left: 16,
                        right: 20,
                      ),
                      leading: Icon(Icons.notes, color: appAccentColor.value),
                      title: Text(
                        AppLocalizations.of(context)!.drawerAllNotesLabel,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      trailing: Text(
                        _getCountForCategory('Tümü').toString(),
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      onTap: () {
                        setState(() => _activeCategory = 'Tümü');
                        _saveData();
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Container(
                    color: _activeCategory == '__favorites__'
                        ? dNoteHighlight(context)
                        : Colors.transparent,
                    child: ListTile(
                      contentPadding: const EdgeInsets.only(
                        left: 16,
                        right: 20,
                      ),
                      leading: Icon(
                        Icons.star_outline,
                        color: appAccentColor.value,
                      ),
                      title: Text(
                        AppLocalizations.of(context)!.drawerFavoritesLabel,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      trailing: Text(
                        _getCountForCategory('__favorites__').toString(),
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      onTap: () {
                        setState(() => _activeCategory = '__favorites__');
                        _saveData();
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  ListTile(
                    contentPadding: const EdgeInsets.only(
                      left: 16,
                      right: 20,
                    ),
                    leading: Icon(
                      Icons.event_note_outlined,
                      color: appAccentColor.value,
                    ),
                    title: Text(
                      AppLocalizations.of(context)!.drawerAgendaLabel,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: Text(
                      _gundemNoteCount(_notes).toString(),
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => _buildGundemScreen()),
                      );
                    },
                  ),
                  Builder(
                    builder: (context) {
                      final remindersCount = _getCountForCategory(
                        '__reminders__',
                      );
                      return Container(
                        color: _activeCategory == '__reminders__'
                            ? dNoteHighlight(context)
                            : Colors.transparent,
                        child: ListTile(
                          contentPadding: const EdgeInsets.only(
                            left: 16,
                            right: 20,
                          ),
                          leading: Icon(
                            remindersCount > 0
                                ? Icons.notifications_active_outlined
                                : Icons.notifications_outlined,
                            color: appAccentColor.value,
                          ),
                          title: Text(
                            AppLocalizations.of(context)!.drawerRemindersLabel,
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          trailing: Text(
                            remindersCount.toString(),
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          onTap: () {
                            setState(() => _activeCategory = '__reminders__');
                            _saveData();
                            Navigator.pop(context);
                          },
                        ),
                      );
                    },
                  ),
                  Container(
                    color: _activeCategory == '__locked__'
                        ? dNoteHighlight(context)
                        : Colors.transparent,
                    child: ListTile(
                      contentPadding: const EdgeInsets.only(
                        left: 16,
                        right: 20,
                      ),
                      leading: Icon(
                        Icons.lock_outline,
                        color: appAccentColor.value,
                      ),
                      title: Text(
                        AppLocalizations.of(context)!.drawerLockedLabel,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      trailing: Text(
                        _getCountForCategory('__locked__').toString(),
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      onTap: () => _openLockedFolder(),
                    ),
                  ),
                  Container(
                    color: _activeCategory == '__archive__'
                        ? dNoteHighlight(context)
                        : Colors.transparent,
                    child: ListTile(
                      contentPadding: const EdgeInsets.only(
                        left: 16,
                        right: 20,
                      ),
                      leading: Icon(
                        Icons.archive_outlined,
                        color: appAccentColor.value,
                      ),
                      title: Text(
                        AppLocalizations.of(context)!.selectionModeArchiveTooltip,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      trailing: Text(
                        _getCountForCategory('__archive__').toString(),
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      onTap: () {
                        setState(() => _activeCategory = '__archive__');
                        _saveData();
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Container(
                    color: _activeCategory == '__trash__'
                        ? dNoteHighlight(context)
                        : Colors.transparent,
                    child: ListTile(
                      contentPadding: const EdgeInsets.only(
                        left: 16,
                        right: 20,
                      ),
                      leading: Icon(
                        Icons.delete_outline,
                        color: appAccentColor.value,
                      ),
                      title: Text(
                        AppLocalizations.of(context)!.drawerTrashLabel,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      trailing: Text(
                        _deletedNotes.length.toString(),
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      onTap: () {
                        setState(() => _activeCategory = '__trash__');
                        _saveData();
                        Navigator.pop(context);
                      },
                    ),
                  ),

                  Divider(
                    color: Theme.of(context).dividerColor,
                    thickness: 1,
                    height: 18,
                  ),
                  ListTile(
                    contentPadding: const EdgeInsets.only(
                      left: 16,
                      right: 20,
                    ),
                    leading: Icon(
                      Icons.calendar_month,
                      color: appAccentColor.value,
                    ),
                    title: Text(
                      AppLocalizations.of(context)!.drawerCalendarLabel,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => _buildCalendarScreen()),
                      );
                    },
                  ),
                  Divider(
                    color: Theme.of(context).dividerColor,
                    thickness: 1,
                    height: 18,
                  ),
                  Builder(
                    builder: (context) {
                      // Alt klasörü olan üst kategorilerin listesi.
                      final parentsWithChildren = _categories
                          .where((cat) => _categoryParents[cat] == null)
                          .where(
                            (cat) => _categories.any(
                              (c) => _categoryParents[c] == cat,
                            ),
                          )
                          .toList();
                      final hasAnySubfolder = parentsWithChildren.isNotEmpty;
                      // Hepsi zaten daraltılmışsa başlıktaki yazı
                      // "Genişlet" olur; aksi halde "Daralt" gösterilir.
                      final allCollapsed =
                          hasAnySubfolder &&
                          parentsWithChildren.every(
                            (cat) => _collapsedCategories.contains(cat),
                          );
                      return Padding(
                        padding: const EdgeInsets.only(
                          left: 16,
                          right: 16,
                          top: 4,
                          bottom: 4,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.drawerFoldersSectionHeader,
                              style: TextStyle(
                                color: dNoteIsDark(context)
                                    ? Colors.grey
                                    : Colors.grey[700],
                                fontSize: 12,
                                letterSpacing: 1.2,
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // NOT: Klasörleri sıralama girişi artık
                                // burada değil — bir klasöre/alt klasöre
                                // basılı tutulunca açılan menüdeki "Sırala"
                                // seçeneğine taşındı (bkz.
                                // note_list_data_category_mixin.dart ->
                                // _showCategoryOptions). Böylece alt
                                // klasöre basılı tutulduğunda sıralama
                                // sadece o alt klasörün kardeşleriyle
                                // sınırlı (scopeParent) açılabiliyor; tek
                                // bir genel ikonla bu ayrım yapılamazdı.
                                if (hasAnySubfolder)
                                  Padding(
                                    padding: const EdgeInsets.only(left: 4),
                                    child: GestureDetector(
                                      behavior: HitTestBehavior.opaque,
                                      onTap: () {
                                        setState(() {
                                          if (allCollapsed) {
                                            // Hepsini genişlet.
                                            _collapsedCategories.removeAll(
                                              parentsWithChildren,
                                            );
                                          } else {
                                            // Hepsini daralt.
                                            _collapsedCategories.addAll(
                                              parentsWithChildren,
                                            );
                                          }
                                        });
                                        // DÜZELTME: Genişlet/daralt durumu
                                        // kaydedilmediği için uygulamadan
                                        // çıkıp girince unutuluyordu — diğer
                                        // tüm durum değişikliklerinde olduğu
                                        // gibi burada da kalıcı hale
                                        // getiriliyor.
                                        _saveData();
                                      },
                                      child: Text(
                                        allCollapsed
                                            ? AppLocalizations.of(context)!.drawerExpandLabel
                                            : AppLocalizations.of(context)!.drawerCollapseLabel,
                                        style: TextStyle(
                                          color: appAccentColor.value,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 1.0,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  // Üst seviye kategoriler, hemen altlarında (varsa) girintili
                  // olarak kendi alt klasörleriyle birlikte listelenir. Her
                  // üst kategorinin alt klasörlerini gösterip gizlemesi
                  // kendi bağımsız daralt/genişlet durumuna bağlıdır.
                  ..._categories
                      .where((cat) => _categoryParents[cat] == null)
                      .expand((cat) {
                        final children = _categories
                            .where((c) => _categoryParents[c] == cat)
                            .toList();
                        final isCollapsed = _collapsedCategories.contains(
                          cat,
                        );
                        return [
                          _buildCategoryDrawerTile(cat),
                          if (!isCollapsed)
                            ...children.map(
                              (child) => _buildCategoryDrawerTile(
                                child,
                                isSubfolder: true,
                              ),
                            ),
                        ];
                      }),
                  ListTile(
                    leading: Icon(
                      Icons.add_circle_outline,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    title: Text(
                      AppLocalizations.of(context)!.drawerAddFolderLabel,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      _showAddCategoryDialog();
                    },
                  ),

                  Divider(
                    color: Theme.of(context).dividerColor,
                    thickness: 1,
                    height: 18,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16, top: 4, bottom: 4),
                    child: Text(
                      AppLocalizations.of(context)!.drawerAppSectionHeader,
                      style: TextStyle(
                        color: dNoteIsDark(context)
                            ? Colors.grey
                            : Colors.grey[700],
                        fontSize: 12,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.settings_outlined,
                      color: appAccentColor.value,
                    ),
                    title: Text(
                      AppLocalizations.of(context)!.drawerSettingsLabel,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onTap: _openSettings,
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.backup_outlined,
                      color: appAccentColor.value,
                    ),
                    title: Text(
                      AppLocalizations.of(context)!.drawerBackupRestoreLabel,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const BackupRestoreScreen(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.workspace_premium_outlined,
                      color: appAccentColor.value,
                    ),
                    title: Text(
                      AppLocalizations.of(context)!.drawerUpgradeToProLabel,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: appAccentColor.value,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.drawerProBadgeLabel,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    onTap: () => Navigator.pop(context),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.volunteer_activism_outlined,
                      color: appAccentColor.value,
                    ),
                    title: Text(
                      AppLocalizations.of(context)!.drawerSupportDevelopmentLabel,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onTap: () => Navigator.pop(context),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.rate_review_outlined,
                      color: appAccentColor.value,
                    ),
                    title: Text(
                      AppLocalizations.of(context)!.drawerFeedbackLabel,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onTap: () async {
                      Navigator.pop(context);
                      final uri = Uri(scheme: 'mailto', path: kLayoutContactEmail);
                      try {
                        await launchUrl(uri);
                      } catch (_) {
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              AppLocalizations.of(context)!.aboutLinkOpenError,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.star_outline,
                      color: appAccentColor.value,
                    ),
                    title: Text(
                      AppLocalizations.of(context)!.drawerRateAppLabel,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onTap: () async {
                      Navigator.pop(context);
                      final uri = Uri.parse(
                        'https://play.google.com/store/apps/details?id=$kLayoutPlayStorePackageId',
                      );
                      try {
                        await launchUrl(uri, mode: LaunchMode.externalApplication);
                      } catch (_) {
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              AppLocalizations.of(context)!.aboutLinkOpenError,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        body: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            if (_isSearching) {
              setState(() {
                _isSearching = false;
                _searchQuery = "";
                _searchController.clear();
                _activeTypeFilter = null;
                _activeFlagFilter = null;
              });
              FocusScope.of(context).unfocus();
            } else {
              FocusScope.of(context).unfocus();
            }
          },
          child: Padding(
            padding: EdgeInsets.only(
              left: 8.0,
              right: 8.0,
              bottom: MediaQuery.of(context).padding.bottom,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Arama modundayken listenin üstünde, o an aktif olan
                // bölümdeki (Tümü/Notlar, Favoriler, bir klasör, vb.)
                // notlara ait etiketleri yan yana (yatay kaydırmalı)
                // listeleyen bir şerit gösterilir. Bir etikete dokunmak,
                // arama kutusuna o etiketi yazmışçasına filtreler; aynı
                // etikete tekrar dokunmak filtreyi kaldırır. Hiç etiket
                // yoksa (ör. Arşiv'de) şerit hiç yer kaplamaz.
                //
                // `AnimatedSize` gerçek bir yükseklik animasyonu sağladığı
                // için şerit, alanı olmayan bir AppBar altlığı yerine
                // burada gerçekten yukarıdan büyüyerek/kayarak açılıyor.
                //
                // Üstteki boşluk (12), aşağıdaki not listesinin/ızgaranın
                // zaten sahip olduğu top:12 padding'iyle eşleşecek şekilde
                // seçildi — böylece şeridin üstündeki ve altındaki boşluk
                // eşit oluyor (altta ayrıca kendi payı eklenmiyor, listenin
                // mevcut üst boşluğuna güveniliyor).
                // Etiketlerden bağımsız "Türler" şeridi: not türüne (çizim,
                // checklist, resim, belge, hatırlatıcı, ses, video) göre
                // tek seçimli filtreleme. Etiket şeridiyle aynı mantıkla
                // (AnimatedSize) açılıp kapanır, ayrı bir şerit olarak.
                AnimatedSize(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOutCubic,
                  alignment: Alignment.topCenter,
                  child: _isSearching
                      ? Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: _TypeFilterStrip(
                            allTypes: typeStripTypes,
                            selectedType: _activeTypeFilter,
                            textColor: _textColor,
                            onTypeSelected: (typeKey, selected) {
                              setState(() {
                                _activeTypeFilter = selected ? typeKey : null;
                              });
                            },
                          ),
                        )
                      : const SizedBox(width: double.infinity, height: 0),
                ),
                AnimatedSize(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOutCubic,
                  alignment: Alignment.topCenter,
                  child: (_isSearching &&
                          (tagStripTags.isNotEmpty ||
                              tagStripFlagColors.isNotEmpty))
                      ? Padding(
                          padding: const EdgeInsets.only(top: 12, bottom: 12),
                          child: _TagFilterStrip(
                            allTags: tagStripTags,
                            searchQuery: _searchQuery,
                            textColor: _textColor,
                            onTagSelected: (tag, selected) {
                              setState(() {
                                _searchQuery = selected ? tag : "";
                                _searchController.text = _searchQuery;
                              });
                            },
                            onTagLongPress: (tag) =>
                                _handleTagLongPress(tag, isTrash),
                            availableFlagColors: tagStripFlagColors,
                            selectedFlagColor: _activeFlagFilter,
                            onFlagSelected: (flagColor, selected) {
                              setState(() {
                                _activeFlagFilter =
                                    selected ? flagColor : null;
                              });
                            },
                          ),
                        )
                      : const SizedBox(width: double.infinity, height: 0),
                ),
                Expanded(
                  child: filteredNotes.isEmpty
                ? Center(
                    child: isTrash
                        ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 32),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.trashEmptyTitle,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  AppLocalizations.of(context)!.trashEmptySubtitle,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Text(
                            AppLocalizations.of(context)!.noNotesFoundMessage,
                            style: const TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                  )
                : _isListView
                ? AnimatedPadding(
                    // Etiket şeridini büyüten AnimatedSize ile birebir aynı
                    // süre/eğri: böylece üstteki toplam boşluk (şerit
                    // yüksekliği + bu padding) her an tutarlı kalır ve
                    // yumuşakça 12 -> şerit yüksekliği arasında geçiş yapar.
                    // Önceden padding anında (animasyonsuz) 12'den 0'a
                    // düşüyordu; şerit ise 0'dan büyümeye yeni başlıyordu.
                    // Bu ikisi arasındaki an'lık boşluk kaybı, notların
                    // önce yukarı zıplayıp sonra (şerit büyüdükçe) tekrar
                    // aşağı inmesine yol açıyordu.
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeOutCubic,
                    padding: EdgeInsets.only(
                      top: (_isSearching &&
                          (tagStripTags.isNotEmpty ||
                              tagStripFlagColors.isNotEmpty))
                          ? 0.0
                          : 12.0,
                    ),
                    child: ListView.builder(
                    itemCount: listItems.length,
                    itemBuilder: (context, index) {
                      final listItem = listItems[index];
                      if (listItem is String) {
                        // İlk öğe bir tarih başlığıysa (ör. "Bugün"), üstteki
                        // ListView padding'i (12) ile bu başlığın kendi üst
                        // boşluğu (18) üst üste binip gereksiz büyük bir boşluk
                        // oluşturuyordu (Izgara görünümünde böyle bir başlık
                        // olmadığından bu fazlalık orada yoktu). Sadece en
                        // baştaki başlık için üst boşluğu küçültüyoruz; sonraki
                        // gruplar arasındaki ayraç boşluğu aynı kalıyor.
                        final bool isDateGroupCollapsed =
                            _collapsedDateGroups.contains(listItem);
                        return Padding(
                          padding: EdgeInsets.fromLTRB(
                            14,
                            index == 0 ? 4 : 18,
                            14,
                            6,
                          ),
                          // Başlığın tamamına dokununca (metin + ikon) bu
                          // tarih grubunun altındaki not kartları
                          // gizlenir/tekrar gösterilir; durum kalıcıdır
                          // (bkz. note_list_data_category_mixin.dart ->
                          // _loadData / _saveData, 'collapsed_date_groups').
                          child: InkWell(
                            borderRadius: BorderRadius.circular(6),
                            onTap: () {
                              setState(() {
                                if (isDateGroupCollapsed) {
                                  _collapsedDateGroups.remove(listItem);
                                } else {
                                  _collapsedDateGroups.add(listItem);
                                }
                              });
                              _saveData();
                            },
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    listItem,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: dNoteIsDark(context)
                                          ? Colors.grey[400]
                                          : Colors.grey[700],
                                    ),
                                  ),
                                ),
                                Icon(
                                  isDateGroupCollapsed
                                      ? Icons.chevron_right
                                      : Icons.expand_more,
                                  size: 22,
                                  color: dNoteIsDark(context)
                                      ? Colors.grey[400]
                                      : Colors.grey[700],
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      final note = listItem as Map<String, dynamic>;
                      final originalIndex = isTrash
                          ? _deletedNotes.indexWhere(
                              (n) =>
                                  n['id'] == note['id'] &&
                                  n['createdDate'] == note['createdDate'],
                            )
                          : _notes.indexWhere(
                              (n) =>
                                  n['id'] == note['id'] &&
                                  n['createdDate'] == note['createdDate'],
                            );
                      final hasTitle = (note['title'] ?? '')
                          .toString()
                          .isNotEmpty;
                      final isChecklist = note['type'] == 'checklist';
                      final isFavorite = note['isFavorite'] == true;
                      final isSelected =
                          _isSelectionMode &&
                          _selectedNoteKeys.contains(_noteKey(note));
                      // Not Kapağı: kullanıcı üç nokta menüsünden ("Kapak
                      // Rengi", bkz. NoteListNoteDialogMixin >
                      // showBgColorSheet) bu not için sabit bir renk
                      // seçmişse, kart HER ZAMAN o renkle gösterilir;
                      // aksi halde (eskisi gibi) colorfulNotes/kategori
                      // rengi mantığı geçerli olur.
                      final noteOwnBgColor = note['bgColor'] as int?;
                      final baseNoteCardColor = noteOwnBgColor != null
                          ? Color(noteOwnBgColor).withValues(alpha: 0.75)
                          : (_colorfulNotes
                                ? _categoryPalette[(originalIndex < 0
                                              ? 0
                                              : originalIndex) %
                                          _categoryPalette.length]
                                      .withValues(alpha: 0.75)
                                : (dNoteIsDark(context)
                                      ? const Color(0xFF2D2D2D)
                                      : Theme.of(context).cardColor));
                      // Seçili notlar, dokununca beliren parlaklık efektiyle
                      // aynı tonda (amber) sürekli vurgulanır.
                      final noteCardColor = isSelected
                          ? Color.alphaBlend(
                              appAccentColor.value.withValues(alpha: 0.30),
                              baseNoteCardColor,
                            )
                          : baseNoteCardColor;
                      final fontScale = _previewFontScale(note);
                      final previewImage = _firstImageAttachment(note);
                      final previewDrawingStrokes = previewImage == null
                          ? _firstDrawingStrokes(note)
                          : null;
                      // Eski (legacy) checklist notları ve yeni blok tabanlı
                      // checklist içeren notlar için karışık önizleme kullanılır.
                      final _noteBlocks = ContentBlocks.parse(note['content'] as String?);
                      final _hasChecklistBlock = _noteBlocks.any((b) => b['type'] == 'checklist');
                      final showMixedPreview = isChecklist || _hasChecklistBlock;
                      // previewContentText, ContentBlocks.plainText() ile
                      // BİREBİR AYNI metni üretir (metin karakterleri hiç
                      // değişmedi) — previewContentSpans ise o metindeki
                      // kalın/italik/renk/link/vurgu aralıklarını taşır,
                      // aşağıda RichText + buildStaticTextSpan ile çizilsin
                      // diye eklendi.
                      final previewTextData = showMixedPreview
                          ? const ('', <Map<String, dynamic>>[])
                          : ContentBlocks.previewTextWithSpans(
                              note['content'] as String?,
                              totalLabelBuilder: (amount) =>
                                  AppLocalizations.of(context)!
                                      .calcTableTotalLabel(amount),
                            );
                      final previewContentText = previewTextData.$1;
                      final previewContentSpans = previewTextData.$2;
                      final previewChecklistItems = showMixedPreview
                          ? _previewLineItems(note)
                          : const [];
                      final previewReminderText = _formattedReminderText(
                        note,
                      );
                      final previewCategoryText = (note['category'] ?? '')
                          .toString();
                      // Not sadece bir görselden oluşuyorsa (başlık, metin,
                      // kontrol listesi öğesi, hatırlatıcı, kategori veya
                      // yıldız rozeti yoksa) altta boş bir satır bırakmamak
                      // için gövde bölümü (Padding) hiç çizilmez.
                      final previewShowFavoriteAlone =
                          isFavorite && !hasTitle && !isChecklist &&
                          previewContentText.isEmpty;
                      final previewHasBody = hasTitle ||
                          previewChecklistItems.isNotEmpty ||
                          previewContentText.isNotEmpty ||
                          previewReminderText != null ||
                          previewCategoryText.isNotEmpty ||
                          previewShowFavoriteAlone;

                      return GestureDetector(
                        onLongPress: isTrash
                            ? () {
                                showModalBottomSheet(
                                  context: context,
                                  backgroundColor: Theme.of(context).cardColor,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(20),
                                    ),
                                  ),
                                  builder: (_) => SafeArea(
                                    child: Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          ElevatedButton.icon(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: appAccentColor.value,
                                            ),
                                            icon: const Icon(
                                              Icons.restore_outlined,
                                              color: Colors.black,
                                            ),
                                            label: Text(
                                              AppLocalizations.of(context)!.trashRestoreButtonLabel,
                                              style: TextStyle(
                                                color: Colors.black,
                                              ),
                                            ),
                                            onPressed: () {
                                              final restoredNote =
                                                  _deletedNotes[originalIndex];
                                              setState(() {
                                                _notes.insert(
                                                  0,
                                                  _deletedNotes[originalIndex],
                                                );
                                                _deletedNotes.removeAt(
                                                  originalIndex,
                                                );
                                              });
                                              _saveData();
                                              _rescheduleNoteReminder(
                                                restoredNote,
                                              );
                                              Navigator.pop(context);
                                            },
                                          ),
                                          ElevatedButton.icon(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.red,
                                            ),
                                            icon: const Icon(
                                              Icons.delete_forever,
                                              color: Colors.white,
                                            ),
                                            label: Text(
                                              AppLocalizations.of(context)!.trashPermanentDeleteButtonLabel,
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                            onPressed: () {
                                              _cleanupAttachmentFiles(_deletedNotes[originalIndex]);
                                            setState(() {
                                              _deletedNotes.removeAt(originalIndex);
                                            });
                                              _saveData();
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }
                            : (_isSelectionMode
                                  ? () => _toggleNoteSelection(note)
                                  : () => _showNoteActions(
                                      context,
                                      originalIndex,
                                      false,
                                      showSelectAction: true,
                                      onInsertText: (text) =>
                                          _appendSpeechTranscriptToNote(
                                            originalIndex,
                                            text,
                                          ),
                                    )),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Card(
                            margin: EdgeInsets.zero,
                            color: noteCardColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: isSelected
                                  ? BorderSide(
                                      color: appAccentColor.value,
                                      width: 2,
                                    )
                                  : BorderSide.none,
                            ),
                            // Bayrak rozeti artık burada (Card'ın en dış
                            // Stack'i içinde) sabit bir Positioned olarak
                            // çizilir — böylece hem kartın en üst kenarına
                            // değer (top: 0) hem de isFavorite'e bakılmaksızın
                            // (yıldız olsun/olmasın) hep aynı sağ üst köşede
                            // sabit kalır; ızgara kartındaki (_buildGridNoteCard)
                            // aynı mantıkla tutarlı.
                            child: Stack(
                              children: [
                                InkWell(
                                  onTap: isTrash
                                  ? () {
                                      showModalBottomSheet(
                                        context: context,
                                        backgroundColor: Theme.of(context).cardColor,
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(20),
                                          ),
                                        ),
                                        builder: (_) => SafeArea(
                                          child: Padding(
                                            padding: const EdgeInsets.all(16),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                ElevatedButton.icon(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                        backgroundColor:
                                                            appAccentColor.value,
                                                      ),
                                                  icon: const Icon(
                                                    Icons.restore_outlined,
                                                    color: Colors.black,
                                                  ),
                                                  label: Text(
                                                    AppLocalizations.of(context)!.trashRestoreButtonLabel,
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    final restoredNote =
                                                        _deletedNotes[originalIndex];
                                                    setState(() {
                                                      _deletedNotes[originalIndex]['createdDate'] =
                                                          DateTime.now()
                                                              .toString();
                                                      _deletedNotes[originalIndex]['modifiedDate'] =
                                                          DateTime.now()
                                                              .toString();
                                                      _notes.insert(
                                                        0,
                                                        _deletedNotes[originalIndex],
                                                      );
                                                      _deletedNotes.removeAt(
                                                        originalIndex,
                                                      );
                                                    });
                                                    _saveData();
                                                    _rescheduleNoteReminder(
                                                      restoredNote,
                                                    );
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                                ElevatedButton.icon(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                        backgroundColor:
                                                            Colors.red,
                                                      ),
                                                  icon: const Icon(
                                                    Icons.delete_forever,
                                                    color: Colors.white,
                                                  ),
                                                  label: Text(
                                                    AppLocalizations.of(context)!.trashPermanentDeleteButtonLabel,
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    _cleanupAttachmentFiles(_deletedNotes[originalIndex]);
                                            setState(() {
                                              _deletedNotes.removeAt(originalIndex);
                                            });
                                                    _saveData();
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                  : (_isSelectionMode
                                        ? () => _toggleNoteSelection(note)
                                        : () => _openNoteWithPasswordCheck(
                                            originalIndex,
                                          )),
                              borderRadius: BorderRadius.circular(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (previewImage != null &&
                                      _attachmentsDirPath != null)
                                    ClipRRect(
                                      borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(12),
                                      ),
                                      child: AspectRatio(
                                        aspectRatio: _kGridPreviewAspectRatio,
                                        child: Image.file(
                                          File(
                                            p.join(
                                              _attachmentsDirPath!,
                                              previewImage['storedName']
                                                  .toString(),
                                            ),
                                          ),
                                          fit: BoxFit.cover,
                                          errorBuilder: (_, __, ___) =>
                                              Container(
                                                color: dNoteSurfaceVariant(
                                                  context,
                                                ),
                                                child: const Icon(
                                                  Icons
                                                      .broken_image_outlined,
                                                  color: Colors.grey,
                                                  size: 20,
                                                ),
                                              ),
                                        ),
                                      ),
                                    )
                                  else if (previewDrawingStrokes != null)
                                    ClipRRect(
                                      borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(12),
                                      ),
                                      child: AspectRatio(
                                        aspectRatio: _kGridPreviewAspectRatio,
                                        child: _gridPreviewDrawingTile(
                                          previewDrawingStrokes,
                                        ),
                                      ),
                                    ),
                                  if (previewHasBody)
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (hasTitle) ...[
                                      Row(
                                        children: [
                                          Expanded(
                                            child: RichText(
                                              // Aşama 5: bkz. grid karttaki
                                              // aynı isimli açıklama —
                                              // maxLines/overflow eskiden de
                                              // yoktu, davranış değişmedi.
                                              text: buildStaticTextSpan(
                                                _capitalizeFirstLetterTr(
                                                  (note['title'] ?? '')
                                                      .toString(),
                                                ),
                                                note['titleSpans'] as List?,
                                                TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  // Başlık, notun kendi (veya
                                                  // Ayarlar > Metin Boyutu'ndan
                                                  // gelen) yazı boyutunun 2
                                                  // birim fazlası. fontScale =
                                                  // noteFontSize/16 olduğundan
                                                  // noteFontSize = 16*fontScale.
                                                  fontSize: (16 * fontScale) + 2,
                                                  color: dNoteEffectiveTextColor(context, _textColor),
                                                  fontFamily: dNoteFontFamilyValue(_fontFamily),
                                                ),
                                                isDark: dNoteIsDark(context),
                                              ),
                                            ),
                                          ),
                                          // Yıldız, kilit ve bayrak artık
                                          // başlığın yanında değil, kartın
                                          // köşesindeki sabit rozetlerde
                                          // gösteriliyor (bkz. Card'ı saran
                                          // Stack + _buildNoteCornerBadges).
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                    ],
                                    if (previewChecklistItems.isNotEmpty)
                                      ...(previewChecklistItems
                                          .take(_previewLines)
                                          .map<Widget>((item) {
                                            final isItemChecklist =
                                                item['checklist'] == true;
                                            final isChecked =
                                                item['checked'] == true;
                                            final textWidget = Text(
                                              (item['text'] ?? '').toString(),
                                              style: TextStyle(
                                                color:
                                                    isItemChecklist &&
                                                        isChecked
                                                    ? dNoteEffectiveTextColor(context, _textColor)
                                                          ?.withOpacity(0.5)
                                                    : (dNoteEffectiveTextColor(context, _textColor)),
                                                decoration:
                                                    isItemChecklist &&
                                                        isChecked
                                                    ? TextDecoration
                                                          .lineThrough
                                                    : null,
                                                decorationColor:
                                                    isItemChecklist &&
                                                        isChecked
                                                    ? Colors.grey[700]
                                                    : null,
                                                decorationStyle:
                                                    TextDecorationStyle.solid,
                                                fontSize:
                                                    (note['fontSize'] as num?)
                                                        ?.toDouble() ??
                                                    _globalFontSize,
                                                fontFamily: dNoteFontFamilyValue(_fontFamily),
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            );
                                            if (!isItemChecklist) {
                                              return textWidget;
                                            }
                                            return Row(
                                              children: [
                                                Icon(
                                                  isChecked
                                                      ? Icons.check_box_rounded
                                                      : Icons
                                                            .check_box_outline_blank_rounded,
                                                  color: appAccentColor.value,
                                                  size: 16,
                                                ),
                                                const SizedBox(width: 6),
                                                Expanded(child: textWidget),
                                              ],
                                            );
                                          })
                                          .toList())
                                    else if (previewContentText.isNotEmpty ||
                                        previewShowFavoriteAlone)
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Text.rich(
                                              // DÜZELTME: RichText, Text'in
                                              // aksine çevredeki
                                              // DefaultTextStyle'ı (ve metin
                                              // ölçekleme ayarlarını)
                                              // otomatik miras almıyor —
                                              // bu yüzden önceki Text(...)
                                              // widget'ının GÖRÜNÜMÜNÜ birebir
                                              // korumak için RichText yerine
                                              // Text.rich kullanılıyor
                                              // (Text.rich, Text ile aynı
                                              // DefaultTextStyle birleştirme
                                              // mantığını kullanır). TextStyle/
                                              // maxLines/overflow öncekiyle
                                              // birebir aynı korunuyor,
                                              // sadece kalın/italik/renk/
                                              // link/vurgu artık görünüyor.
                                              buildStaticTextSpan(
                                                previewContentText,
                                                previewContentSpans,
                                                TextStyle(
                                                  color: dNoteEffectiveTextColor(context, _textColor),
                                                  fontSize:
                                                      (note['fontSize'] as num?)
                                                          ?.toDouble() ??
                                                      _globalFontSize,
                                                  fontFamily: dNoteFontFamilyValue(_fontFamily),
                                                ),
                                                isDark: dNoteIsDark(context),
                                              ),
                                              maxLines: _previewLines,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          // Yıldız ve bayrak artık kartın
                                          // köşesindeki sabit rozetlerde
                                          // gösteriliyor (bkz. Card'ı saran
                                          // Stack + _buildNoteCornerBadges).
                                        ],
                                      ),
                                    if (_formattedReminderText(note) !=
                                        null) ...[
                                      const SizedBox(height: 8),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            note['reminderRepeat'] == null
                                                ? Icons.notifications
                                                : Icons.repeat,
                                            color: Colors.lightBlueAccent,
                                            size: 16,
                                          ),
                                          const SizedBox(width: 4),
                                          Flexible(
                                            child: Text(
                                              _formattedReminderText(note)!,
                                              style: TextStyle(
                                                color: dNoteEffectiveTextColor(
                                                  context,
                                                  _textColor,
                                                ),
                                                fontSize:
                                                    ((note['fontSize'] as num?)
                                                        ?.toDouble() ??
                                                    _globalFontSize) -
                                                    1,
                                                fontFamily: dNoteFontFamilyValue(
                                                  _fontFamily,
                                                ),
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                    if (_showsGundemBadge(note)) ...[
                                      const SizedBox(height: 8),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.today_outlined,
                                            color: appAccentColor.value,
                                            size: 16,
                                          ),
                                          const SizedBox(width: 4),
                                          Flexible(
                                            child: Text(
                                              _gundemBadgeDateLabel(context, note)!,
                                              style: TextStyle(
                                                color: dNoteEffectiveTextColor(
                                                  context,
                                                  _textColor,
                                                ),
                                                fontSize:
                                                    ((note['fontSize'] as num?)
                                                        ?.toDouble() ??
                                                    _globalFontSize) -
                                                    1,
                                                fontFamily: dNoteFontFamilyValue(
                                                  _fontFamily,
                                                ),
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                    if ((note['category'] ?? '')
                                        .toString()
                                        .isNotEmpty) ...[
                                      const SizedBox(height: 6),
                                      Align(
                                        alignment: Alignment.bottomLeft,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.folder_outlined,
                                              color: _getCategoryColor(
                                                note['category'] as String,
                                              ),
                                              size: 16,
                                            ),
                                            const SizedBox(width: 4),
                                            Flexible(
                                              child: Text(
                                                _folderTagLabel(
                                                  note['category'] as String,
                                                ),
                                                style: TextStyle(
                                                  color:
                                                      dNoteEffectiveTextColor(
                                                    context,
                                                    _textColor,
                                                  ),
                                                  fontSize:
                                                      ((note['fontSize']
                                                              as num?)
                                                          ?.toDouble() ??
                                                      _globalFontSize) -
                                                      1,
                                                  fontFamily:
                                                      dNoteFontFamilyValue(
                                                    _fontFamily,
                                                  ),
                                                ),
                                                maxLines: 1,
                                                overflow:
                                                    TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                    _buildNoteTagChips(note),
                                  ],
                                ),
                                  ),
                                ],
                              ),
                            ),
                                ..._buildNoteCornerBadges(
                                  isFavorite: isFavorite,
                                  isLocked: note['isLocked'] == true,
                                  flagColor: note['flagColor'] as String?,
                                  isPinned: note['isPinned'] == true,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    ),
                  )
                : AnimatedPadding(
                    // Aynı gerekçe: ızgara görünümünde de üst boşluk,
                    // şeridin AnimatedSize'ı ile aynı süre/eğride
                    // animasyonlu geçmeli, aksi halde aynı yukarı-aşağı
                    // zıplama burada da oluşur.
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeOutCubic,
                    padding: EdgeInsets.only(
                      top: (_isSearching &&
                          (tagStripTags.isNotEmpty ||
                              tagStripFlagColors.isNotEmpty))
                          ? 0.0
                          : 12.0,
                    ),
                    child: SingleChildScrollView(
                      child: _buildGridView(
                        filteredNotes: filteredNotes,
                        isTrash: isTrash,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showNoteDialog(type: 'text'),
          backgroundColor: appAccentColor.value,
          child: const Icon(Icons.add, color: Colors.black, size: 30),
        ),
      ),
    );
  }

  // Izgara görünümü: kart yüksekliği sabit DEĞİLDİR, içerik kadar yer kaplar.
  // Üst sınır: Ayarlar > Not Önizleme Satırı (_previewLines) ile belirlenir.
  // 2 sütunlu "staggered" (Pinterest tarzı) düzen — sütunlar arasında en kısa
  // olana yeni kart eklenerek sütun yükseklikleri dengelenir.
  Widget _buildGridView({
    required List<Map<String, dynamic>> filteredNotes,
    required bool isTrash,
  }) {
    const int crossAxisCount = 2;
    const double spacing = 10;
    const double outerPadding = 0.0; // dış konteyner zaten 16px padding veriyor
    const double cardInnerPadding =
        16.0; // _buildGridNoteCard içindeki Padding değeri

    // Her sütunun gerçek genişliğini hesapla: ekran genişliğinden dış
    // padding'leri ve sütunlar arası boşluğu çıkar, crossAxisCount'a böl.
    final screenWidth = MediaQuery.of(context).size.width;
    final totalSpacing = (outerPadding * 2) + (spacing * (crossAxisCount - 1));
    final columnWidth = (screenWidth - totalSpacing) / crossAxisCount;
    // Kartın iç padding'ini çıkararak metnin gerçekte sarabileceği genişliği bul.
    final cardContentWidth = (columnWidth - (cardInnerPadding * 2)).clamp(
      0.0,
      columnWidth,
    );

    final List<List<Widget>> columnChildren = List.generate(
      crossAxisCount,
      (_) => <Widget>[],
    );
    final List<double> columnHeights = List.filled(crossAxisCount, 0.0);

    for (int index = 0; index < filteredNotes.length; index++) {
      final note = filteredNotes[index];
      final originalIndex = isTrash
          ? _deletedNotes.indexWhere(
              (n) =>
                  n['id'] == note['id'] &&
                  n['createdDate'] == note['createdDate'],
            )
          : _notes.indexWhere(
              (n) =>
                  n['id'] == note['id'] &&
                  n['createdDate'] == note['createdDate'],
            );

      // Kartı, şu anda en kısa olan sütuna ekle (sütun yüksekliklerini dengeler).
      int shortestColumn = 0;
      for (int c = 1; c < crossAxisCount; c++) {
        if (columnHeights[c] < columnHeights[shortestColumn]) {
          shortestColumn = c;
        }
      }

      final estimatedHeight = _estimateNoteHeight(note, cardContentWidth);
      columnHeights[shortestColumn] += estimatedHeight;

      columnChildren[shortestColumn].add(
        Padding(
          padding: EdgeInsets.only(bottom: spacing),
          child: SizedBox(
            width: double.infinity,
            child: _buildGridNoteCard(
              note: note,
              originalIndex: originalIndex,
              isTrash: isTrash,
            ),
          ),
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(crossAxisCount, (c) {
          return Expanded(
            child: Padding(
              padding: EdgeInsetsDirectional.only(
                start: c == 0 ? 0 : spacing / 2,
                end: c == crossAxisCount - 1 ? 0 : spacing / 2,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: columnChildren[c],
              ),
            ),
          );
        }),
      ),
    );
  }

  // Bir notun önizlemede kullanacağı yazı boyutu ölçek katsayısını döndürür.
  // Not kendi özel fontSize'ını taşıyorsa o değer, taşımıyorsa Ayarlar >
  // Kişiselleştirme > Metin Boyutu (_globalFontSize) baz alınır. 16.0
  // varsayılan/temel boyut olduğundan ölçek = seçilen boyut / 16.0 şeklinde
  // hesaplanır; bu sayede mevcut tüm fontSize değerleri (başlık, içerik,
  // checklist) orantılı şekilde büyür/küçülür.
  double _previewFontScale(Map<String, dynamic> note) {
    final noteFontSize =
        (note['fontSize'] as num?)?.toDouble() ?? _globalFontSize;
    return noteFontSize / 16.0;
  }

  // Kart önizlemesinde göstermek üzere, notun eklerinden ilk görseli bulur.
  Map<String, dynamic>? _firstImageAttachment(Map<String, dynamic> note) {
    final atts = note['attachments'];
    if (atts is List) {
      for (final a in atts) {
        if (a is Map &&
            a['isImage'] == true &&
            (a['storedName'] ?? '').toString().isNotEmpty) {
          return Map<String, dynamic>.from(a);
        }
      }
    }
    return null;
  }

  // Kart önizlemesinde göstermek üzere, notun eklerinden ilk `max` görseli
  // sırayla toplar. Birden fazla foto olsa bile önizlemede her zaman tek
  // foto gösterilsin diye varsayılan `max` değeri 1'dir (yan yana iki foto
  // gösterimi kaldırıldı; alttaki "images.length >= 2" dallarına artık hiç
  // girilmez, tek foto dalı her zaman kullanılır).
  List<Map<String, dynamic>> _previewImages(
    Map<String, dynamic> note, {
    int max = 1,
  }) {
    final atts = note['attachments'];
    final result = <Map<String, dynamic>>[];
    if (atts is List) {
      for (final a in atts) {
        if (a is Map &&
            a['isImage'] == true &&
            (a['storedName'] ?? '').toString().isNotEmpty) {
          result.add(Map<String, dynamic>.from(a));
          if (result.length >= max) break;
        }
      }
    }
    return result;
  }

  // Kart önizleme fotoğrafının en/boy oranı: 16:9 (geniş ekran oranı).
  // Kart/satır genişliği ne olursa olsun bu oran sabit kalır.
  final double _kGridPreviewAspectRatio = 16 / 9;

  // Yazısız (sadece foto/çizim) notlarda, IZGARA (kart) görünümündeki
  // önizleme kare olarak gösterilir — sadece bu özel mod için. Metinli
  // notlardaki üst şerit (16:9) ve liste görünümündeki önizlemeler bundan
  // etkilenmez, aynı kalır.
  final double _kGridPreviewSquareAspectRatio = 1.0;

  // Bir ek görselini kart önizlemesinde (BoxFit.cover) çizen ortak widget.
  Widget _gridPreviewImageTile(Map<String, dynamic> image) {
    if (_attachmentsDirPath == null) {
      return Container(color: dNoteSurfaceVariant(context));
    }
    return Image.file(
      File(p.join(_attachmentsDirPath!, image['storedName'].toString())),
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Container(
        color: dNoteSurfaceVariant(context),
        child: const Icon(Icons.broken_image_outlined, color: Colors.grey),
      ),
    );
  }

  // Kart önizlemesinde gösterilecek satır listesi. Hem eski (tüm not tek
  // checklist) hem de yeni blok tabanlı checklist içeren notlar için ortak
  // biçimde ({'checklist': bool, 'text': String, 'checked': bool}) döner;
  // böylece liste ve ızgara görünümündeki önizleme kodu aynı veriyi
  // kullanabilir.
  List<Map<String, dynamic>> _previewLineItems(Map<String, dynamic> note) {
    if (note['type'] == 'checklist') {
      return (note['checkItems'] as List? ?? [])
          .map<Map<String, dynamic>>(
            (it) => {
              'checklist': true,
              'text': (it['text'] ?? '').toString(),
              'checked': it['checked'] == true,
            },
          )
          .toList();
    }
    return ContentBlocks.previewLines(
      note['content'] as String?,
      totalLabelBuilder: (amount) =>
          AppLocalizations.of(context)!.calcTableTotalLabel(amount),
    );
  }

  // Kart önizlemesinde göstermek üzere, notun içeriğindeki ilk dolu çizim
  // bloğunun stroke'larını bulur. Sadece görsel eki YOKSA çağrılır (bir not
  // hem fotoğraf hem çizim içeriyorsa önizlemede fotoğraf önceliklidir,
  // tıpkı _firstImageAttachment gibi). Kontrol listesi notlarında blok
  // yapısı kullanılmadığından her zaman null döner.
  List<Map<String, dynamic>>? _firstDrawingStrokes(Map<String, dynamic> note) {
    if (note['type'] == 'checklist') return null;
    final blocks = ContentBlocks.parse(note['content'] as String?);
    for (final b in blocks) {
      if (b['type'] == 'drawing') {
        final strokes = List<Map<String, dynamic>>.from(
          (b['strokes'] as List? ?? const []).map(
            (s) => Map<String, dynamic>.from(s as Map),
          ),
        );
        if (strokes.isNotEmpty) return strokes;
      }
    }
    return null;
  }

  // Bir çizim bloğunu kart önizlemesinde (BoxFit.cover'a benzer şekilde,
  // FittedBox ile) çizen ortak widget. Çizim, düzenleyicideki gerçek tuval
  // boyutuyla (ekran genişliği - 40, kDrawingDefaultCanvasHeight) aynı
  // sabit boyutta çizilip önizleme alanına ölçeklenir — _DrawingPainter,
  // stroke noktalarını ham (ölçeksiz) piksel konumu olarak kullandığından
  // bu, düzenleyicideki görünümle orantıyı koruyan tek yöntemdir (bkz.
  // NoteScreenshotService'teki aynı yaklaşım).
  Widget _gridPreviewDrawingTile(List<Map<String, dynamic>> strokes) {
    final screenWidth = MediaQuery.of(context).size.width;
    const horizontalPadding = 20.0;
    final originalWidth = screenWidth - (horizontalPadding * 2);
    return Container(
      color: dNoteIsDark(context) ? Colors.black : Colors.white,
      child: FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          width: originalWidth,
          height: kDrawingDefaultCanvasHeight,
          child: CustomPaint(
            painter: _DrawingPainter(
              strokes: strokes,
              livePoints: null,
              liveColor: Colors.transparent,
              liveWidth: 0,
            ),
          ),
        ),
      ),
    );
  }

  // Verilen metnin, belirtilen genişlik ve yazı stiliyle gerçekte kaç satıra
  // SARACAĞINI ölçer (TextPainter ile). Basit "\n sayısı" tahmini, satır
  // kendiliğinden sardığında (özellikle metin boyutu büyütüldüğünde) yanlış
  // sonuç verip sütun dengesini bozduğu için bunun yerine gerçek ölçüm
  // kullanılır.
  int _measureWrappedLineCount(String text, double maxWidth, TextStyle style) {
    if (text.isEmpty) return 0;
    final painter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
      maxLines: null,
    )..layout(maxWidth: maxWidth);
    return painter.computeLineMetrics().length;
  }

  // Kartın gerçekte kaç piksel yükseklik kaplayacağını ölçer (sütun
  // dengelemesi için). Önceki sürüm sadece "satır sayısı" topluyordu; bu,
  // başlık/içerik/checklist satırlarının farklı font boyutlarına ve kartın
  // sabit iç boşluklarına (padding, SizedBox aralıkları) duyarsız kalıp
  // sütunlar arasında kümülatif sapmaya yol açıyordu (bazı notların hep
  // aynı sütuna yığılması). Gerçek piksel yüksekliği, kartın
  // _buildGridNoteCard içindeki gerçek yapısıyla (16px iç padding, başlık
  // sonrası 12px boşluk, kategori öncesi 8px boşluk, checklist öğeleri
  // arası 4px boşluk) bire bir eşleşecek şekilde hesaplanır.
  double _estimateNoteHeight(
    Map<String, dynamic> note,
    double cardContentWidth,
  ) {
    final hasTitle = (note['title'] ?? '').toString().isNotEmpty;
    final isChecklist = note['type'] == 'checklist';
    final _estimateBlocks = ContentBlocks.parse(note['content'] as String?);
    final _estimateHasChecklistBlock = _estimateBlocks.any((b) => b['type'] == 'checklist');
    final bool isMixedChecklist = isChecklist || _estimateHasChecklistBlock;
    final fontScale = _previewFontScale(note);
    // Kartın gerçek (padding'siz) genişliği; _buildGridView içindeki
    // cardInnerPadding (16.0) değeriyle bire bir eşleşmeli.
    const double cardInnerPadding = 16.0;
    final double columnWidth = cardContentWidth + (cardInnerPadding * 2);
    final images = _previewImages(note);
    // Yazısız (sadece foto) notlarda kart tamamen foto(lar)dan ibarettir;
    // checklist notlarda bu özel mod uygulanmaz (checklist her zaman
    // "yazılı" kabul edilir, mevcut davranış korunur).
    final bool hasText = isMixedChecklist
        ? true
        : ContentBlocks.plainText(
            note['content'] as String?,
            totalLabelBuilder: (amount) =>
                AppLocalizations.of(context)!.calcTableTotalLabel(amount),
          ).isNotEmpty;
    // Fotoğraf yoksa, notun ilk çizim bloğuna bakılır (bkz. _gridPreviewDrawingTile);
    // bir not hem fotoğraf hem çizim içeriyorsa fotoğraf önceliklidir.
    final drawingStrokes = images.isEmpty ? _firstDrawingStrokes(note) : null;
    final bool hasVisual = images.isNotEmpty || drawingStrokes != null;
    final bool photoOnlyMode = !isMixedChecklist && hasVisual && !hasText;

    if (photoOnlyMode) {
      // Kart sadece foto(lar)/çizimden ibaret: iç/dış boşluk, başlık,
      // kategori, hatırlatıcı — hiçbiri yok. Tek foto/çizim -> kare kart.
      // İki foto -> yan yana iki kare (kart oranı 2:1).
      return images.length >= 2
          ? (columnWidth / (_kGridPreviewSquareAspectRatio * 2))
          : (columnWidth / _kGridPreviewSquareAspectRatio);
    }

    double height = 32.0; // kartın iç padding'i: 16 üst + 16 alt

    if (images.isNotEmpty) {
      // Tek foto: 16:9 şerit. İki (veya daha fazla) foto: yan yana iki foto
      // (kart genişliği / (16:9 * 2) yükseklik).
      height += images.length >= 2
          ? (columnWidth / (_kGridPreviewAspectRatio * 2))
          : (columnWidth / _kGridPreviewAspectRatio);
    } else if (drawingStrokes != null) {
      // Fotoğraf yok ama çizim var: tek foto ile aynı 16:9 şerit yüksekliği.
      height += columnWidth / _kGridPreviewAspectRatio;
    }

    if (hasTitle) {
      height += ((16 * fontScale) + 2) * 1.2; // başlık satırı (tek satır, maxLines:1)
      height += 12.0; // başlık sonrası SizedBox
    }

    if (isMixedChecklist) {
      final items = _previewLineItems(note);
      final itemCount = items.length.clamp(0, _previewLines);
      // Her önizleme satırı (checklist maddesi ya da metin satırı) tek
      // satır + altında 4px boşluk.
      height += itemCount * ((12 * fontScale) * 1.3 + 4.0);
    } else {
      final content = ContentBlocks.plainText(
        note['content'] as String?,
        totalLabelBuilder: (amount) =>
            AppLocalizations.of(context)!.calcTableTotalLabel(amount),
      );
      if (content.isNotEmpty) {
        final noteFontSize =
            (note['fontSize'] as num?)?.toDouble() ?? _globalFontSize;
        final style = TextStyle(fontSize: noteFontSize, height: 1.3);
        int wrapped = 0;
        for (final paragraph in content.split('\n')) {
          wrapped += _measureWrappedLineCount(
            paragraph,
            cardContentWidth,
            style,
          ).clamp(0, 999);
          if (paragraph.isEmpty) wrapped += 1; // boş satır da yer kaplar
        }
        final cappedLines = wrapped.clamp(0, _previewLines);
        height += cappedLines * (noteFontSize * 1.3);
      }
    }

    if ((note['category'] ?? '').toString().isNotEmpty) {
      height += 8.0; // kategori öncesi SizedBox
      height += (11 * fontScale) * 1.2; // kategori satırı
    }

    return height < 1 ? 1 : height;
  }

  // Izgara görünümündeki tek bir not kartı. Yüksekliği içeriğe göre belirlenir;
  // başlık + içerik metni doğal yüksekliğini alır (Expanded YOK), maksimum
  // satır sayısı ayarlardaki _previewLines değeriyle sınırlandırılır.
  Widget _buildGridNoteCard({
    required Map<String, dynamic> note,
    required int originalIndex,
    required bool isTrash,
  }) {
    final hasTitle = (note['title'] ?? '').toString().isNotEmpty;
    final isChecklist = note['type'] == 'checklist';
    final isFavorite = note['isFavorite'] == true;
    final isSelected =
        _isSelectionMode && _selectedNoteKeys.contains(_noteKey(note));
    // Not Kapağı: bkz. liste görünümündeki aynı isimli açıklama — not
    // düzeyinde kayıtlı bir bgColor varsa grid kartı da HER ZAMAN onu
    // kullanır, aksi halde colorfulNotes/kategori mantığı geçerli olur.
    final noteOwnBgColor = note['bgColor'] as int?;
    final baseGridCardColor = noteOwnBgColor != null
        ? Color(noteOwnBgColor).withValues(alpha: 0.75)
        : (_colorfulNotes
              ? _categoryPalette[(originalIndex < 0 ? 0 : originalIndex) %
                        _categoryPalette.length]
                    .withValues(alpha: 0.75)
              : (dNoteIsDark(context)
                    ? const Color(0xFF2D2D2D)
                    : Theme.of(context).cardColor));
    // Seçili notlar, dokununca beliren parlaklık efektiyle aynı tonda
    // (amber) sürekli vurgulanır.
    final gridCardColor = isSelected
        ? Color.alphaBlend(
            appAccentColor.value.withValues(alpha: 0.30),
            baseGridCardColor,
          )
        : baseGridCardColor;
    final fontScale = _previewFontScale(note);
    final images = _previewImages(note);
    final _noteBlocks = ContentBlocks.parse(note['content'] as String?);
    final _hasChecklistBlock = _noteBlocks.any((b) => b['type'] == 'checklist');
    final showMixedPreview = isChecklist || _hasChecklistBlock;
    // Gövde önizlemesinin metni ve (kalın/italik/renk/link/vurgu) span'ları
    // — metin karakterleri ContentBlocks.plainText() ile birebir aynı,
    // tek fark RichText ile çizilebilmesi için span bilgisinin de burada
    // taşınması. showMixedPreview true iken (checklist notlar) bu alan
    // kullanılmıyor, boş bırakılıyor.
    final previewTextData = showMixedPreview
        ? const ('', <Map<String, dynamic>>[])
        : ContentBlocks.previewTextWithSpans(
            note['content'] as String?,
            totalLabelBuilder: (amount) =>
                AppLocalizations.of(context)!.calcTableTotalLabel(amount),
          );
    final previewContentText = previewTextData.$1;
    final previewContentSpans = previewTextData.$2;
    // Yazısız (sadece foto) notlarda kart tamamen foto(lar)dan ibarettir;
    // checklist notlar bu özel modun dışında tutulur.
    final bool hasText = showMixedPreview ? true : previewContentText.isNotEmpty;
    // Fotoğraf yoksa notun ilk çizim bloğuna bakılır; fotoğraf her zaman
    // önceliklidir (bkz. _gridPreviewDrawingTile).
    final previewDrawingStrokes =
        images.isEmpty ? _firstDrawingStrokes(note) : null;
    final bool hasVisual = images.isNotEmpty || previewDrawingStrokes != null;
    final bool photoOnlyMode = !showMixedPreview && hasVisual && !hasText;

    return GestureDetector(
      onLongPress: isTrash
          ? () {
              showModalBottomSheet(
                context: context,
                backgroundColor: Theme.of(context).cardColor,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (_) => SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: appAccentColor.value,
                          ),
                          icon: const Icon(
                            Icons.restore_outlined,
                            color: Colors.black,
                          ),
                          label: Text(
                            AppLocalizations.of(context)!.trashRestoreButtonLabel,
                            style: TextStyle(color: Colors.black),
                          ),
                          onPressed: () {
                            final restoredNote = _deletedNotes[originalIndex];
                            setState(() {
                              _deletedNotes[originalIndex]['createdDate'] =
                                  DateTime.now().toString();
                              _deletedNotes[originalIndex]['modifiedDate'] =
                                  DateTime.now().toString();
                              _notes.insert(0, _deletedNotes[originalIndex]);
                              _deletedNotes.removeAt(originalIndex);
                            });
                            _saveData();
                            _rescheduleNoteReminder(restoredNote);
                            Navigator.pop(context);
                          },
                        ),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          icon: const Icon(
                            Icons.delete_forever,
                            color: Colors.white,
                          ),
                          label: Text(
                            AppLocalizations.of(context)!.trashPermanentDeleteButtonLabel,
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            _cleanupAttachmentFiles(_deletedNotes[originalIndex]);
                                            setState(() {
                                              _deletedNotes.removeAt(originalIndex);
                                            });
                            _saveData();
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
          : (_isSelectionMode
                ? () => _toggleNoteSelection(note)
                : () => _showNoteActions(
                    context,
                    originalIndex,
                    false,
                    showSelectAction: true,
                    onInsertText: (text) =>
                        _appendSpeechTranscriptToNote(originalIndex, text),
                  )),
      child: Card(
        margin: EdgeInsets.zero,
        color: gridCardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: isSelected
              ? BorderSide(color: appAccentColor.value, width: 2)
              : BorderSide.none,
        ),
        child: InkWell(
          onTap: isTrash
              ? () {
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: Theme.of(context).cardColor,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    builder: (_) => SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: appAccentColor.value,
                              ),
                              icon: const Icon(
                                Icons.restore_outlined,
                                color: Colors.black,
                              ),
                              label: Text(
                                AppLocalizations.of(context)!.trashRestoreButtonLabel,
                                style: TextStyle(color: Colors.black),
                              ),
                              onPressed: () {
                                final restoredNote =
                                    _deletedNotes[originalIndex];
                                setState(() {
                                  _deletedNotes[originalIndex]['createdDate'] =
                                      DateTime.now().toString();
                                  _deletedNotes[originalIndex]['modifiedDate'] =
                                      DateTime.now().toString();
                                  _notes.insert(
                                    0,
                                    _deletedNotes[originalIndex],
                                  );
                                  _deletedNotes.removeAt(originalIndex);
                                });
                                _saveData();
                                _rescheduleNoteReminder(restoredNote);
                                Navigator.pop(context);
                              },
                            ),
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                              icon: const Icon(
                                Icons.delete_forever,
                                color: Colors.white,
                              ),
                              label: Text(
                                AppLocalizations.of(context)!.trashPermanentDeleteButtonLabel,
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () {
                                _cleanupAttachmentFiles(_deletedNotes[originalIndex]);
                                            setState(() {
                                              _deletedNotes.removeAt(originalIndex);
                                            });
                                _saveData();
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
              : (_isSelectionMode
                    ? () => _toggleNoteSelection(note)
                    : () => _openNoteWithPasswordCheck(originalIndex)),
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              if (photoOnlyMode)
                // ── Yazısız (sadece foto/çizim) not ────────────────────
                // Kart tamamen foto(lar)/çizimden ibaret: başlık/kategori/
                // hatırlatıcı yok, dış/iç boşluk yok. Bu özel modda önizleme
                // KARE gösterilir (yazılı notlardaki 16:9 şeritten farklı
                // olarak, sadece ızgara/kart görünümünde). Tek foto/çizim ->
                // kare kart. İki foto -> yan yana iki kare (kart oranı 2:1).
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: AspectRatio(
                    aspectRatio: images.length >= 2
                        ? (_kGridPreviewSquareAspectRatio * 2)
                        : _kGridPreviewSquareAspectRatio,
                    child: images.length >= 2
                        ? Row(
                            children: [
                              Expanded(
                                child: _gridPreviewImageTile(images[0]),
                              ),
                              const SizedBox(width: 2),
                              Expanded(
                                child: _gridPreviewImageTile(images[1]),
                              ),
                            ],
                          )
                        : (images.isNotEmpty
                              ? _gridPreviewImageTile(images[0])
                              : _gridPreviewDrawingTile(
                                  previewDrawingStrokes!,
                                )),
                  ),
                )
              else
                Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (images.isNotEmpty && _attachmentsDirPath != null)
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                      child: images.length >= 2
                          ? AspectRatio(
                              // İki foto yan yana -> toplam şerit oranı 32:9.
                              aspectRatio: _kGridPreviewAspectRatio * 2,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: _gridPreviewImageTile(images[0]),
                                  ),
                                  const SizedBox(width: 2),
                                  Expanded(
                                    child: _gridPreviewImageTile(images[1]),
                                  ),
                                ],
                              ),
                            )
                          : AspectRatio(
                              aspectRatio: _kGridPreviewAspectRatio,
                              child: _gridPreviewImageTile(images[0]),
                            ),
                    )
                  else if (previewDrawingStrokes != null)
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                      child: AspectRatio(
                        aspectRatio: _kGridPreviewAspectRatio,
                        child: _gridPreviewDrawingTile(previewDrawingStrokes),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (hasTitle)
                          RichText(
                            // Aşama 5: başlık artık kalın/italik/vurgu/link
                            // vb. span'larıyla birlikte çiziliyor (bkz.
                            // buildStaticTextSpan, rich_block_text_controller.dart).
                            // maxLines/overflow/textAlign/textDirection
                            // öncekiyle birebir aynı korunuyor.
                            text: buildStaticTextSpan(
                              _capitalizeFirstLetterTr(
                                (note['title'] ?? '').toString(),
                              ),
                              note['titleSpans'] as List?,
                              TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: (16 * fontScale) + 2,
                                color: dNoteEffectiveTextColor(context, _textColor),
                                fontFamily: dNoteFontFamilyValue(_fontFamily),
                              ),
                              isDark: dNoteIsDark(context),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.start,
                          ),
                        if (hasTitle) const SizedBox(height: 12),
                        showMixedPreview
                            ? Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: _previewLineItems(note)
                                    .take(_previewLines)
                                    .map<Widget>((item) {
                                      final isItemChecklist =
                                          item['checklist'] == true;
                                      final isChecked =
                                          item['checked'] == true;
                                      final textWidget = Text(
                                        (item['text'] ?? '').toString(),
                                        style: TextStyle(
                                          color: isItemChecklist && isChecked
                                              ? dNoteEffectiveTextColor(context, _textColor)?.withOpacity(0.5)
                                              : (dNoteEffectiveTextColor(context, _textColor)),
                                          decoration:
                                              isItemChecklist && isChecked
                                              ? TextDecoration.lineThrough
                                              : null,
                                          decorationColor:
                                              isItemChecklist && isChecked
                                              ? Colors.grey[700]
                                              : null,
                                          decorationStyle:
                                              TextDecorationStyle.solid,
                                          fontSize:
                                              (note['fontSize'] as num?)
                                                  ?.toDouble() ??
                                              _globalFontSize,
                                          fontFamily: dNoteFontFamilyValue(_fontFamily),
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.start,
                                      );
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 4,
                                        ),
                                        child: !isItemChecklist
                                            ? textWidget
                                            : Row(
                                                children: [
                                                  Icon(
                                                    isChecked
                                                        ? Icons.check_box_rounded
                                                        : Icons
                                                              .check_box_outline_blank_rounded,
                                                    color: appAccentColor.value,
                                                    size: 16,
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Expanded(child: textWidget),
                                                ],
                                              ),
                                      );
                                    })
                                    .toList(),
                              )
                            : Text.rich(
                                // DÜZELTME: RichText, DefaultTextStyle'ı
                                // otomatik miras almadığından, önceki
                                // Text(...) widget'ının görünümünü birebir
                                // korumak için Text.rich kullanılıyor (bkz.
                                // liste görünümündeki aynı isimli açıklama).
                                // TextStyle/maxLines/overflow/textAlign/
                                // textDirection öncekiyle birebir aynı
                                // korunuyor.
                                buildStaticTextSpan(
                                  previewContentText,
                                  previewContentSpans,
                                  TextStyle(
                                    color: dNoteEffectiveTextColor(context, _textColor),
                                    fontSize:
                                        (note['fontSize'] as num?)?.toDouble() ??
                                        _globalFontSize,
                                    fontFamily: dNoteFontFamilyValue(_fontFamily),
                                  ),
                                  isDark: dNoteIsDark(context),
                                ),
                                maxLines: _previewLines,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.start,
                              ),
                        if (_formattedReminderText(note) != null) ...[
                          const SizedBox(height: 8),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                note['reminderRepeat'] == null
                                    ? Icons.notifications
                                    : Icons.repeat,
                                color: Colors.lightBlueAccent,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  _formattedReminderText(note)!,
                                  style: TextStyle(
                                    color: dNoteEffectiveTextColor(
                                      context,
                                      _textColor,
                                    ),
                                    fontSize:
                                        ((note['fontSize'] as num?)
                                            ?.toDouble() ??
                                        _globalFontSize) -
                                        1,
                                    fontFamily: dNoteFontFamilyValue(
                                      _fontFamily,
                                    ),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                        if (_showsGundemBadge(note)) ...[
                          const SizedBox(height: 8),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.today_outlined,
                                color: appAccentColor.value,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  _gundemBadgeDateLabel(context, note)!,
                                  style: TextStyle(
                                    color: dNoteEffectiveTextColor(
                                      context,
                                      _textColor,
                                    ),
                                    fontSize:
                                        ((note['fontSize'] as num?)
                                            ?.toDouble() ??
                                        _globalFontSize) -
                                        1,
                                    fontFamily: dNoteFontFamilyValue(
                                      _fontFamily,
                                    ),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                        if ((note['category'] ?? '').toString().isNotEmpty) ...[
                          const SizedBox(height: 6),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.folder_outlined,
                                color: _getCategoryColor(
                                  note['category'] as String,
                                ),
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  _folderTagLabel(
                                    note['category'] as String,
                                  ),
                                  style: TextStyle(
                                    color: dNoteEffectiveTextColor(
                                      context,
                                      _textColor,
                                    ),
                                    fontSize:
                                        ((note['fontSize'] as num?)
                                            ?.toDouble() ??
                                        _globalFontSize) -
                                        1,
                                    fontFamily: dNoteFontFamilyValue(
                                      _fontFamily,
                                    ),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.start,
                                ),
                              ),
                            ],
                          ),
                        ],
                        _buildNoteTagChips(note),
                      ],
                    ),
                  ),
                ],
              ),
              ..._buildNoteCornerBadges(
                isFavorite: isFavorite,
                isLocked: note['isLocked'] == true,
                flagColor: note['flagColor'] as String?,
                isPinned: note['isPinned'] == true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Not kartında (liste/ızgara görünümü) kategori etiketinin altında
  // gösterilen etiket önizlemesi. Reminder/gündem/klasör rozetleriyle
  // birebir aynı stil: küçük gri ikon + tek satır metin (taşarsa "...").
  // Notun 'tags' listesi boşsa/yoksa boş bir widget (SizedBox.shrink())
  // döner ki çağıran taraf koşulsuz ekleyebilsin.
  Widget _buildNoteTagChips(Map<String, dynamic> note) {
    final rawTags = note['tags'];
    if (rawTags is! List || rawTags.isEmpty) return const SizedBox.shrink();
    final tags = rawTags.map((e) => e.toString()).toList();

    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.sell_outlined,
            color: Colors.grey,
            size: 16,
          ),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              tags.join(', '),
              style: TextStyle(
                color: dNoteEffectiveTextColor(context, _textColor),
                fontSize:
                    ((note['fontSize'] as num?)?.toDouble() ??
                        _globalFontSize) -
                    1,
                fontFamily: dNoteFontFamilyValue(_fontFamily),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // [oldTag]'ı, [target] listesindeki (çöp kutusu ya da aktif notlar) TÜM
  // notlarda kullanıcının gireceği yeni isimle değiştirir. Bir notta hem
  // eski etiket hem de (büyük/küçük harf duyarsız) yeni isimle eşleşen
  // başka bir etiket zaten varsa, kopya oluşmasın diye eski olan silinir
  // (yeni adında zaten var demektir) — bkz. note_tags_sheet.dart içindeki
  // addTag'in aynı çakışma mantığı. Vazgeçilirse ya da isim değişmediyse
  // null, başarıyla değiştirildiyse yeni ismi döner — çağıran taraf
  // (ör. showNoteTagsSheet'in onRenameTagGlobally'si) bu dönüş değerini
  // kendi yerel state'ini güncellemek için kullanır.
  Future<String?> _renameTagInList(
    String oldTag,
    List<Map<String, dynamic>> target,
  ) async {
    final newTag = await showRenameTagDialog(context, oldTag);
    if (newTag == null || newTag.isEmpty || newTag == oldTag) return null;

    setState(() {
      for (var i = 0; i < target.length; i++) {
        final rawTags = target[i]['tags'];
        if (rawTags is! List) continue;
        final tags = rawTags.map((e) => e.toString()).toList();
        final idx = tags.indexWhere(
          (t) => t.toLowerCase() == oldTag.toLowerCase(),
        );
        if (idx == -1) continue;
        final duplicateIdx = tags.indexWhere(
          (t) => t.toLowerCase() == newTag.toLowerCase(),
        );
        if (duplicateIdx != -1 && duplicateIdx != idx) {
          tags.removeAt(idx);
        } else {
          tags[idx] = newTag;
        }
        target[i] = {...target[i], 'tags': tags};
      }
      if (_searchQuery == oldTag) _searchQuery = newTag;
    });
    _saveData();
    _showInfoBar(AppLocalizations.of(context)!.tagRenamedInfoMessage, icon: Icons.edit_outlined);
    return newTag;
  }

  // [tag]'ı, [target] listesindeki (çöp kutusu ya da aktif notlar) tüm
  // notlardan siler. Etiket en az bir notta kullanılıyorsa önce kaç
  // nottan kaldırılacağını belirten bir onay diyaloğu gösterilir.
  // Silme gerçekleştiyse true, vazgeçildiyse false döner.
  Future<bool> _deleteTagInList(
    String tag,
    List<Map<String, dynamic>> target,
  ) async {
    final affectedCount = countNotesWithTag(target, tag);

    final confirmed = affectedCount > 0
        ? await showDeleteTagConfirmDialog(
            context,
            tag: tag,
            affectedCount: affectedCount,
          )
        : true;
    if (!confirmed) return false;

    setState(() {
      for (var i = 0; i < target.length; i++) {
        final rawTags = target[i]['tags'];
        if (rawTags is! List) continue;
        final tags = rawTags.map((e) => e.toString()).toList();
        final idx = tags.indexWhere(
          (t) => t.toLowerCase() == tag.toLowerCase(),
        );
        if (idx == -1) continue;
        tags.removeAt(idx);
        target[i] = {...target[i], 'tags': tags};
      }
      if (_searchQuery == tag) {
        _searchQuery = "";
        _searchController.text = "";
      }
    });
    _saveData();
    _showInfoBar(AppLocalizations.of(context)!.tagDeletedInfoMessage, icon: Icons.delete_outline);
    return true;
  }

  // Etiket şeridinde (arama modu) bir etikete basılı tutulunca çağrılır.
  // "Yeniden Adlandır / Sil" seçeneklerini gösterir; [isTrash] true ise
  // işlem çöp kutusundaki notlar üzerinde, değilse aktif not listesi
  // üzerinde uygulanır — şerit zaten hangi listeden besleniyorsa
  // (bkz. _notesForActiveTagScope) o kapsamla tutarlı kalması için.
  void _handleTagLongPress(String tag, bool isTrash) {
    showTagOptionsSheet(
      context,
      tag: tag,
      onRename: () => _renameTagEverywhere(tag, isTrash),
      onDelete: () => _deleteTagWithConfirmation(tag, isTrash),
    );
  }

  Future<void> _renameTagEverywhere(String oldTag, bool isTrash) async {
    await _renameTagInList(oldTag, isTrash ? _deletedNotes : _notes);
  }

  Future<void> _deleteTagWithConfirmation(String tag, bool isTrash) async {
    await _deleteTagInList(tag, isTrash ? _deletedNotes : _notes);
  }

  // Not düzenleme diyaloğundaki "Etiketler" sheet'i (showNoteTagsSheet)
  // için: o sheet her zaman aktif (çöp kutusu olmayan) notlar üzerinde
  // çalışır, bu yüzden isTrash parametresi almadan doğrudan _notes'u
  // hedefler. Sheet, bu iki metodu sırasıyla onRenameTagGlobally ve
  // onDeleteTagGlobally callback'leri olarak alır.
  Future<String?> _renameTagGlobally(String oldTag) =>
      _renameTagInList(oldTag, _notes);

  Future<bool> _deleteTagGlobally(String tag) =>
      _deleteTagInList(tag, _notes);

  // Notun gelecekte planlanmış bir hatırlatıcısı var mı?
  bool _hasActiveReminder(Map<String, dynamic> note) {
    final raw = note['reminderDate']?.toString();
    if (raw == null || raw.isEmpty) return false;
    final dt = DateTime.tryParse(raw);
    return dt != null && dt.isAfter(DateTime.now());
  }

  // Hatırlatıcı tarihini "gg.aa.yyyy ss:dd" biçiminde döndürür (kartlarda ve
  // not içinde gösterilir); yoksa null döner.
  // Hatırlatıcı rozeti (saat/ikon) zaten gösterilmiyorsa VE not, Gündem
  // ekranında bir satırla temsil ediliyorsa (hatırlatıcı VEYA atanmış
  // tarih üzerinden — bkz. gundem_screen.dart -> _gundemNoteCount ile
  // aynı mantık) true döner. Hatırlatıcı rozeti zaten varsa (kullanıcının
  // isteği üzerine) ayrıca gündem rozeti gösterilmez.
  bool _showsGundemBadge(Map<String, dynamic> note) {
    if (_formattedReminderText(note) != null) return false;
    if (note['isLocked'] == true || note['isArchived'] == true) return false;
    return _reminderAgendaDay(note) != null || _assignedAgendaDay(note) != null;
  }

  // Gündem rozetinin yanında gösterilecek tarih metni, "Ağu 9, Pazar"
  // biçiminde. Ay/gün adları AppLocalizations üzerinden lokalize edilir
  // (bkz. gundem_screen.dart -> _gundemShortDateLabel / weekDayFull, aynı
  // ARB anahtarları burada da kullanılıyor).
  // _showsGundemBadge true dönmüyorsa null döner.
  String? _gundemBadgeDateLabel(BuildContext context, Map<String, dynamic> note) {
    final day = _reminderAgendaDay(note) ?? _assignedAgendaDay(note);
    if (day == null) return null;
    final l10n = AppLocalizations.of(context)!;
    final monthNamesShort = [
      l10n.gundemMonthShortJan,
      l10n.gundemMonthShortFeb,
      l10n.gundemMonthShortMar,
      l10n.gundemMonthShortApr,
      l10n.gundemMonthShortMay,
      l10n.gundemMonthShortJun,
      l10n.gundemMonthShortJul,
      l10n.gundemMonthShortAug,
      l10n.gundemMonthShortSep,
      l10n.gundemMonthShortOct,
      l10n.gundemMonthShortNov,
      l10n.gundemMonthShortDec,
    ];
    final weekDayFull = [
      l10n.gundemWeekdayMonday,
      l10n.gundemWeekdayTuesday,
      l10n.gundemWeekdayWednesday,
      l10n.gundemWeekdayThursday,
      l10n.gundemWeekdayFriday,
      l10n.gundemWeekdaySaturday,
      l10n.gundemWeekdaySunday,
    ];
    return '${dNoteFormatShortDateParts(context, day: '${day.day}', month: monthNamesShort[day.month - 1])}, ${weekDayFull[day.weekday - 1]}';
  }

  String? _formattedReminderText(Map<String, dynamic> note) {
    if (!_hasActiveReminder(note)) return null;
    final dt = DateTime.parse(note['reminderDate'].toString());
    return _formatDateTimeShortTr(dt);
  }

  // Gündem ekranını tüm callback'leriyle birlikte kurar. Hem çekmece
  // menüsündeki "Gündem" satırından hem de Takvim ekranının üst barındaki
  // gündem ikonundan (onOpenGundem) çağrılır; böylece iki ekran arasında
  // gidiş-geliş için kod tekrarı yapılmaz.
  Widget _buildGundemScreen() {
    return GundemScreen(
      // ÖNEMLİ: kopya değil, _notes'un KENDİSİ veriliyor. Not düzenlenince
      // kaydetme kodu _notes[index]'i YENİ bir Map ile değiştiriyor (bkz.
      // note_list_actions_mixin.dart); Gündem ayrı bir kopya tutsaydı bu
      // değişikliği hiç göremezdi. Aynı referans paylaşıldığı için
      // Gündem'in kendi setState'i (onOpenNote'un await'i tamamlanınca)
      // artık güncel veriyi yeniden çizer.
      notes: _notes,
      globalFontSize: _globalFontSize,
      fontFamily: dNoteFontFamilyValue(_fontFamily),
      onOpenNote: (note) async {
        final tappedNoteId = note['id']?.toString();
        if (tappedNoteId == null) return;
        final index = _notes.indexWhere(
          (n) => n['id']?.toString() == tappedNoteId,
        );
        if (index != -1) {
          // Gündem, bu Future tamamlanana (yani not ekranından geri
          // dönülene) kadar bekleyip ardından kendi görünümünü yeniliyor.
          await _openNoteWithPasswordCheck(index);
        }
      },
      onRemoveFromAgenda: (note, isAssigned) {
        setState(() {
          if (isAssigned) {
            note.remove('assignedDate');
          } else {
            note.remove('reminderDate');
            note.remove('reminderRepeat');
          }
        });
        _rescheduleNoteReminder(note);
        _saveData();
      },
      onDeleteNote: (note) {
        final key = _noteKey(note);
        setState(() {
          _selectedNoteKeys = {key};
        });
        _deleteSelectedNotes();
      },
      // Üst bardaki takvim ikonu: Gündem'in üzerine Takvim'i push eder.
      onOpenCalendar: (ctx) {
        Navigator.push(
          ctx,
          MaterialPageRoute(builder: (_) => _buildCalendarScreen()),
        );
      },
    );
  }

  // Takvim ekranını tüm callback'leriyle birlikte kurar. Hem çekmece
  // menüsündeki "Takvim" satırından hem de Gündem ekranının üst barındaki
  // takvim ikonundan (onOpenCalendar) çağrılır.
  Widget _buildCalendarScreen() {
    return CalendarScreen(
      // Gündem'deki aynı düzeltme: kopya değil, _notes'un kendisi. Not
      // kaydedildiğinde _notes[index] YENİ bir Map ile değiştiriliyor;
      // Takvim ayrı bir kopya tutsaydı bu değişikliği göremezdi.
      notes: _notes,
      fontFamily: dNoteFontFamilyValue(_fontFamily),
      onNewNote: (date) async {
        await _showNoteDialog(
          type: 'text',
          initialAssignedDate: date,
        );
      },
      onOpenNote: (noteId) async {
        final index = _notes.indexWhere(
          (n) => n['id']?.toString() == noteId,
        );
        if (index != -1) {
          await _openNoteWithPasswordCheck(index);
        }
      },
      // Üst bardaki gündem ikonu: Takvim'in üzerine Gündem'i push eder.
      onOpenGundem: (ctx) {
        Navigator.push(
          ctx,
          MaterialPageRoute(builder: (_) => _buildGundemScreen()),
        );
      },
    );
  }
}

// NoteFlagMixin._flagColorFromHex ile aynı mantık: bir '#RRGGBB' hex
// dizesini Color'a çevirir. _TagFilterStrip bir instance metoduna
// (mixin state'ine) erişemediği için burada top-level olarak tekrarlanır —
// bkz. note_flag_mixin.dart'taki orijinali.
Color _colorFromFlagHex(String hex) {
  final cleaned = hex.replaceFirst('#', '');
  return Color(int.parse('FF$cleaned', radix: 16));
}

// ════════════════════════════════════════════════════════════════════════
// Arama modunda üst barın altında beliren etiket şeridi. `Builder` her
// _isSearching değişiminde bu widget'ı sıfırdan (yeni bir instance olarak)
// oluşturduğundan, initState'te başlattığımız giriş animasyonu her açılışta
// tekrar çalışır: şerit hafifçe yukarıdan kayarak ve belirerek iner. Kapanış
// ayrıca animasyonlu değildir (üst bar zaten anında geri daralıyor); istenen
// sadece açılışın yumuşatılmasıydı.
// ════════════════════════════════════════════════════════════════════════
class _TagFilterStrip extends StatefulWidget {
  const _TagFilterStrip({
    required this.allTags,
    required this.searchQuery,
    required this.textColor,
    required this.onTagSelected,
    required this.onTagLongPress,
    required this.availableFlagColors,
    required this.selectedFlagColor,
    required this.onFlagSelected,
  });

  final List<String> allTags;
  final String searchQuery;
  final Color? textColor;
  final void Function(String tag, bool selected) onTagSelected;
  // Bir etikete basılı tutulunca (yeniden adlandır/sil seçenekleri için)
  // çağrılır — bkz. NoteListBuildMixin._handleTagLongPress.
  final void Function(String tag) onTagLongPress;
  // Etiket şeridinin BAŞINDA gösterilen bayrak (flama) filtre seçenekleri —
  // bkz. NoteListBuildMixin._availableFlagColors. Etiketlerden bağımsız
  // ayrı bir şerit değil, aynı Wrap içinde en başta yer alır (kullanıcı
  // isteği: "arama kısmında etiket bölümünün başında görünecek").
  final List<String> availableFlagColors;
  // Şu an seçili bayrak rengi (hex) — null ise filtre yok. Tür filtresiyle
  // (_activeTypeFilter) aynı tek-seçimli mantık.
  final String? selectedFlagColor;
  final void Function(String flagColor, bool selected) onFlagSelected;

  @override
  State<_TagFilterStrip> createState() => _TagFilterStripState();
}

class _TagFilterStripState extends State<_TagFilterStrip>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slide;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );
    final curved = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
    _slide = Tween<Offset>(
      begin: const Offset(0, -0.25),
      end: Offset.zero,
    ).animate(curved);
    _fade = curved;
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slide,
      child: FadeTransition(
        opacity: _fade,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              // Bayrak (flama) filtre seçenekleri — etiketlerden ÖNCE,
              // şeridin en başında. Her chip _FlagShapePainter ile aynı
              // bayrak şeklini (dikey, dolu) kullanır — bkz.
              // note_flag_mixin.dart'taki kart rozeti/başlık ikonuyla
              // tutarlı görünüm. Uzun basma davranışı yok (yeniden
              // adlandırma/silme kavramı bayrak renkleri için geçerli
              // değil), bu yüzden etiket chip'lerindeki GestureDetector
              // sarmalayıcısı burada kullanılmaz.
              for (final flagColor in widget.availableFlagColors)
                ChoiceChip(
                  label: CustomPaint(
                    size: const Size(16, 16),
                    painter: _FlagShapePainter(
                      color: _colorFromFlagHex(flagColor),
                      filled: true,
                      vertical: true,
                    ),
                  ),
                  selected: widget.selectedFlagColor == flagColor,
                  onSelected: (selected) =>
                      widget.onFlagSelected(flagColor, selected),
                  selectedColor: appAccentColor.value.withOpacity(0.3),
                  backgroundColor: Colors.grey.withOpacity(0.15),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact,
                  labelPadding: const EdgeInsets.symmetric(horizontal: 2),
                ),
              for (final tag in widget.allTags)
                // GestureDetector, ChoiceChip'in kendi onSelected'ını
                // (tap) engellemeden üstüne basılı tutma (long press)
                // algılamak için sarmalayıcı olarak eklendi — chip'in
                // normal tıklama/seçim davranışı aynen çalışmaya devam
                // eder, sadece uzun basışta ek olarak yeniden
                // adlandır/sil sheet'i açılır.
                GestureDetector(
                  onLongPress: () => widget.onTagLongPress(tag),
                  child: ChoiceChip(
                    label: Text(tag),
                    selected: widget.searchQuery == tag,
                    onSelected: (selected) =>
                        widget.onTagSelected(tag, selected),
                    selectedColor: appAccentColor.value.withOpacity(0.3),
                    backgroundColor: Colors.grey.withOpacity(0.15),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                    labelStyle: TextStyle(
                      fontSize: 16,
                      color: dNoteEffectiveTextColor(
                        context,
                        widget.textColor,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════
// Arama modunda üst şeritte beliren, etiketlerden tamamen bağımsız "Türler"
// filtre şeridi (bkz. NoteListBuildMixin._noteMatchesTypeFilter). Etiket
// şeridi gibi tek seçimlidir: bir ikona basmak o türü seçer, tekrar basmak
// seçimi kaldırır. Görsel olarak ikon+etiket çiftleri, etiket şeridindeki
// ChoiceChip'lerle tutarlı bir stille (aynı vurgu/arka plan renkleri)
// gösterilir ama karışmasınlar diye ayrı bir widget/satır olarak tutulur.
// ════════════════════════════════════════════════════════════════════════
class _TypeFilterStrip extends StatefulWidget {
  const _TypeFilterStrip({
    required this.allTypes,
    required this.selectedType,
    required this.textColor,
    required this.onTypeSelected,
  });

  final List<String> allTypes;
  final String? selectedType;
  final Color? textColor;
  final void Function(String typeKey, bool selected) onTypeSelected;

  @override
  State<_TypeFilterStrip> createState() => _TypeFilterStripState();
}

class _TypeFilterStripState extends State<_TypeFilterStrip>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slide;
  late final Animation<double> _fade;

  // Tür anahtarından ikona eşleme. Artık etiket metni gösterilmiyor
  // (kullanıcı isteğiyle salt ikon), bu yüzden _labels haritası kaldırıldı.
  static const Map<String, IconData> _icons = {
    'drawing': Icons.edit_outlined,
    'checklist': Icons.checklist_outlined,
    'image': Icons.image_outlined,
    'table': Icons.border_all_rounded,
    'document': Icons.insert_drive_file_outlined,
    'reminder': Icons.alarm_outlined,
    'audio': Icons.mic_none_outlined,
    'video': Icons.videocam_outlined,
  };

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );
    final curved = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
    _slide = Tween<Offset>(
      begin: const Offset(0, -0.25),
      end: Offset.zero,
    ).animate(curved);
    _fade = curved;
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Salt ikon, satır etiketsiz: her ikon `Expanded` ile eşit paya bölünmüş
    // bir dilim alıyor (kaç ikon olursa olsun satır tam ekran genişliğine
    // sığar, yatay kaydırma yok) ama önceki sürümün aksine buton artık
    // `Center` ile küçük bir kutuya sıkıştırılmıyor — dilimin neredeyse
    // tamamını dolduruyor (yalnızca 4px yatay boşluk bırakılıyor). Böylece
    // ikonlar arası boşluk, etiket şeridindeki 8px'lik sabit boşlukla aynı
    // görünüme yaklaşıyor; önceki geniş boşluk sorunu buradan kaynaklanıyordu.
    return SlideTransition(
      position: _slide,
      child: FadeTransition(
        opacity: _fade,
        child: Row(
          children: [
            for (final typeKey in widget.allTypes)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: _TypeIconButton(
                    icon: _icons[typeKey] ?? Icons.circle_outlined,
                    selected: widget.selectedType == typeKey,
                    textColor: widget.textColor,
                    onTap: () => widget.onTypeSelected(
                      typeKey,
                      widget.selectedType != typeKey,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// Tek bir tür ikonu: seçiliyken vurgu (accent) rengiyle dolu, seçili
// değilken hafif gri bir kare (yuvarlatılmış köşeli) alan içinde gösterilir
// — ekran görüntüsündeki referans uygulamanın "Türler" satırıyla aynı
// köşeli (dairesel değil) görünüm. Renk mantığı etiket şeridiyle tutarlı
// (aynı `appAccentColor`/gri opaklık değerleri).
class _TypeIconButton extends StatelessWidget {
  const _TypeIconButton({
    required this.icon,
    required this.selected,
    required this.textColor,
    required this.onTap,
  });

  final IconData icon;
  final bool selected;
  final Color? textColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    );
    return SizedBox(
      width: double.infinity,
      child: Material(
        color: selected
            ? appAccentColor.value.withOpacity(0.3)
            : Colors.grey.withOpacity(0.15),
        shape: shape,
        child: InkWell(
          customBorder: shape,
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Center(
              child: Icon(
                icon,
                size: 20,
                color: dNoteEffectiveTextColor(context, textColor),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
