part of 'main.dart';

/// Basit, tip bağımsız geri al / ileri al (undo/redo) yığını.
///
/// Her "checkpoint" T tipinde bağımsız bir durum kopyasıdır (ör. bir
/// Map<String, dynamic> anlık görüntüsü). Çağıran taraf bir değişiklik
/// yapmadan ÖNCE [push] ile mevcut durumu saklamalıdır; [undo]/[redo] ise
/// çağrıldığı andaki mevcut durumu diğer yığına atıp bir önceki/sonraki
/// durumu geri döndürür.
///
/// Bu sınıf UI'dan bağımsızdır: hangi alanların anlık görüntüye dahil
/// edileceğine ve durumun nasıl geri uygulanacağına (ör. controller'ların
/// yeniden kurulması) çağıran taraf karar verir.
class UndoRedoStack<T> {
  UndoRedoStack({this.maxDepth = 50});

  /// Bellek şişmesin diye saklanacak maksimum checkpoint sayısı.
  final int maxDepth;

  final List<T> _undoStack = [];
  final List<T> _redoStack = [];

  bool get canUndo => _undoStack.isNotEmpty;
  bool get canRedo => _redoStack.isNotEmpty;

  /// Yeni bir değişiklik uygulanmadan ÖNCE çağrılır: [current] durumu geri
  /// alma yığınına eklenir. Yeni bir dal açıldığı için önceki "ileri al"
  /// geçmişi artık geçersizdir ve temizlenir.
  void push(T current) {
    _undoStack.add(current);
    if (_undoStack.length > maxDepth) {
      _undoStack.removeAt(0);
    }
    _redoStack.clear();
  }

  /// [current] durumu ileri alma yığınına atar ve bir önceki durumu
  /// döndürür. Geri alınacak bir şey yoksa null döner.
  T? undo(T current) {
    if (_undoStack.isEmpty) return null;
    _redoStack.add(current);
    return _undoStack.removeLast();
  }

  /// [current] durumu geri alma yığınına atar ve bir sonraki durumu
  /// döndürür. İleri alınacak bir şey yoksa null döner.
  T? redo(T current) {
    if (_redoStack.isEmpty) return null;
    _undoStack.add(current);
    return _redoStack.removeLast();
  }

  void clear() {
    _undoStack.clear();
    _redoStack.clear();
  }
}
