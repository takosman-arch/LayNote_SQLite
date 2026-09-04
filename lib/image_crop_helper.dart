part of 'main.dart';

// ════════════════════════════════════════════════════════════════════════
// FOTOĞRAF KIRPMA YARDIMCISI (ImageCropHelper)
// image_cropper paketini tek bir yerden sarmalar; galeriden/kameradan
// seçilen fotoğraflar eklenmeden önce burada kırpılır. Diğer picker
// akışlarını (pickAttachments, video, belge tarama) etkilemez — sadece
// resim dosyaları için çağrılır.
// ════════════════════════════════════════════════════════════════════════
class ImageCropHelper {
  // Tek bir fotoğrafı kırpar. Kullanıcı kırpma ekranını iptal ederse
  // orijinal (kırpılmamış) yolu döndürür — akış hiç kesilmez.
  static Future<String> cropSingle({
    required BuildContext context,
    required String sourcePath,
  }) async {
    final cropped = await ImageCropper().cropImage(
      sourcePath: sourcePath,
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 92,
      uiSettings: [
        AndroidUiSettings(
          // NOT: Projende bu metin için bir AppLocalizations anahtarı
          // varsa (ör. imageCropToolbarTitle), sabit metin yerine onu
          // kullanabilirsin.
          toolbarTitle: 'Kırp',
          toolbarColor: Theme.of(context).scaffoldBackgroundColor,
          toolbarWidgetColor: dNoteTextColor(context),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          activeControlsWidgetColor: appAccentColor.value,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
          aspectRatioPresets: const [
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9,
          ],
        ),
        IOSUiSettings(
          title: 'Kırp',
          aspectRatioPresets: const [
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9,
          ],
        ),
      ],
    );
    return cropped?.path ?? sourcePath;
  }

  // Birden fazla fotoğrafı sırayla kırpar (galeriden çoklu seçimde
  // kullanılır). Her biri için ayrı ayrı kırpma ekranı açılır; bir tanesi
  // atlanırsa (iptal) o dosyanın orijinali korunur, akış diğerlerine devam
  // eder.
  static Future<List<XFile>> cropMultiple({
    required BuildContext context,
    required List<XFile> sources,
  }) async {
    final results = <XFile>[];
    for (final source in sources) {
      if (!context.mounted) {
        results.add(source);
        continue;
      }
      final croppedPath = await cropSingle(
        context: context,
        sourcePath: source.path,
      );
      results.add(XFile(croppedPath, name: source.name));
    }
    return results;
  }
}
