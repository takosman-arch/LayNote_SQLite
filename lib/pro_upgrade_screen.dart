part of 'main.dart';

// Uygulama tamamen ücretsiz olduğu için Pro satın alma ekranı kaldırıldı.
// appIsPro her zaman true olduğundan bu ekrana giden yönlendirmeler
// (if (!appIsPro.value) ...) hiçbir zaman çalışmaz; sınıf yalnızca
// mevcut çağrı yerleri derlenmeye devam etsin diye boş bir iskelet olarak
// bırakıldı. İleride bu çağrı yerleri temizlenince dosya silinebilir.
class ProUpgradeScreen extends StatelessWidget {
  const ProUpgradeScreen({super.key});

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
