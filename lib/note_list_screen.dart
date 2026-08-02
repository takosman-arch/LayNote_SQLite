part of 'main.dart';

class NoteListScreen extends StatefulWidget {
  const NoteListScreen({super.key});

  @override
  State<NoteListScreen> createState() => _NoteListScreenState();
}


class _NoteListScreenState extends State<NoteListScreen>
    with
        NoteListSelectionMixin,
        NoteListLifecycleMixin,
        NoteListDataCategoryMixin,
        NoteListActionsMixin,
        NoteListAttachmentMixin,
        NoteListNoteDialogMixin,
	NoteListChecklistBlockMixin,
        NoteListBuildMixin {}

// ── Ek Dosya Kutucuğu ────────────────────────────────────────────────
// Not içeriğindeki resim/dosya eklerini gösteren ortak kutucuk widget'ı.
// Uzun basınca (onLongPress) silme ikonu belirir (showDelete); silme
// ikonuna basılırsa onRemove, kutucuğun kendisine basılırsa onOpen,
// silme modundayken başka bir yere dokunulursa onDismissDelete çağrılır.
class _AttachmentTile extends StatelessWidget {
  final double width;
  final double height;
  final Widget preview;
  final bool showDelete;
  final VoidCallback onOpen;
  final VoidCallback onRemove;
  final VoidCallback onLongPress;
  final VoidCallback onDismissDelete;

  const _AttachmentTile({
    required this.width,
    required this.height,
    required this.preview,
    required this.showDelete,
    required this.onOpen,
    required this.onRemove,
    required this.onLongPress,
    required this.onDismissDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: showDelete ? onDismissDelete : onOpen,
      onLongPress: onLongPress,
      child: SizedBox(
        width: width,
        height: height,
        child: Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: preview,
            ),
            if (showDelete)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.45),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.white),
                      onPressed: onRemove,
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


// ── Ses Kaydı Sheet'i ────────────────────────────────────────────────
// "+" menüsünden "Ses Kaydı" seçilince açılır. Sheet açılır açılmaz kayda
// otomatik başlar; ortada geçen süreyi ve kırmızı nabız animasyonunu
// gösterir. "Durdur" kaydı bitirip dosya yolunu Navigator.pop ile geri
// döndürür (recordVoiceNote bu yolu attachments'a ekler); "İptal" kaydı
// atıp yarım kalan dosyayı silerek null döner.
class _VoiceRecorderSheet extends StatefulWidget {
  const _VoiceRecorderSheet();

  @override
  State<_VoiceRecorderSheet> createState() => _VoiceRecorderSheetState();
}

class _VoiceRecorderSheetState extends State<_VoiceRecorderSheet> {
  final AudioRecorder _recorder = AudioRecorder();
  Timer? _timer;
  Duration _elapsed = Duration.zero;
  bool _starting = true;
  bool _stopping = false;
  String? _path;

  @override
  void initState() {
    super.initState();
    _start();
  }

  Future<void> _start() async {
    try {
      final dir = await getTemporaryDirectory();
      final path = p.join(
        dir.path,
        'ses_kaydi_${DateTime.now().microsecondsSinceEpoch}.m4a',
      );
      await _recorder.start(
        const RecordConfig(encoder: AudioEncoder.aacLc),
        path: path,
      );
      _path = path;
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (!mounted) return;
        setState(() => _elapsed += const Duration(seconds: 1));
      });
    } catch (_) {
      if (mounted) Navigator.pop(context, null);
      return;
    }
    if (mounted) setState(() => _starting = false);
  }

  Future<void> _stop({required bool save}) async {
    if (_stopping) return;
    _stopping = true;
    _timer?.cancel();
    final path = await _recorder.stop();
    if (!mounted) return;
    if (save && path != null) {
      Navigator.pop(context, path);
    } else {
      if (path != null) {
        try {
          await File(path).delete();
        } catch (_) {}
      }
      Navigator.pop(context, null);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _recorder.dispose();
    super.dispose();
  }

  String _formatElapsed(Duration d) {
    final m = d.inMinutes.toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, __) {
        if (!didPop) _stop(save: false);
      },
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[700],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.85, end: 1.0),
                duration: const Duration(milliseconds: 700),
                curve: Curves.easeInOut,
                builder: (context, scale, child) => Transform.scale(
                  scale: _starting ? 1.0 : scale,
                  child: child,
                ),
                onEnd: () {},
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: const BoxDecoration(
                    color: Colors.redAccent,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.mic, color: Colors.white, size: 34),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                _starting ? 'Hazırlanıyor…' : _formatElapsed(_elapsed),
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  fontFeatures: [FontFeature.tabularFigures()],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton.icon(
                    onPressed: _starting ? null : () => _stop(save: false),
                    icon: const Icon(Icons.close, color: Colors.grey),
                    label: const Text(
                      'İptal',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  const SizedBox(width: 16),
                  FilledButton.icon(
                    onPressed: _starting ? null : () => _stop(save: true),
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.amber,
                      foregroundColor: Colors.black,
                    ),
                    icon: const Icon(Icons.stop),
                    label: const Text('Durdur ve Ekle'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Sesi Yazıya Çevir Sheet'i ────────────────────────────────────────────
// "Eylem Seç" panelinden "Sesi Yazıya Çevir" seçilince açılır. Sheet
// açılır açılmaz cihazın konuşma tanıma servisini dinlemeye başlar ve
// tanınan kelimeleri anlık olarak ekranda gösterir.
//
// Android'in konuşma tanıyıcısı, konuşmacı birkaç saniye sessiz kaldığında
// kendiliğinden durur (bu, işletim sisteminin bir davranışıdır ve
// speech_to_text paketi bunu değiştiremez). Kullanıcı elle "Durdur ve
// Ekle"/"İptal" demediği sürece, bu durum algılanınca dinleme otomatik
// olarak yeniden başlatılır; böylece uzun cümleler kesilmeden tüm
// konuşma tek bir metinde birikir.
//
// "Durdur ve Ekle" o ana kadar tanınan metni Navigator.pop ile geri
// döndürür (_showNoteActions'daki 'speech_to_text' işleyicisi bu metni
// onInsertText callback'i ile not içeriğine ekler); "İptal" null döner.
class _SpeechToTextSheet extends StatefulWidget {
  const _SpeechToTextSheet();

  @override
  State<_SpeechToTextSheet> createState() => _SpeechToTextSheetState();
}

class _SpeechToTextSheetState extends State<_SpeechToTextSheet> {
  final stt.SpeechToText _speech = stt.SpeechToText();
  String _finalText = '';
  String _partialText = '';
  bool _starting = true;
  bool _stopping = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _start();
  }

  Future<void> _start() async {
    final micStatus = await Permission.microphone.request();
    if (!mounted) return;
    if (!micStatus.isGranted) {
      setState(() {
        _starting = false;
        _errorMessage = 'Mikrofon izni verilmedi.';
      });
      return;
    }
    bool available = false;
    try {
      available = await _speech.initialize(onStatus: _onStatus);
    } catch (_) {
      available = false;
    }
    if (!mounted) return;
    if (!available) {
      setState(() {
        _starting = false;
        _errorMessage = 'Bu cihazda ses tanıma özelliği kullanılamıyor.';
      });
      return;
    }
    setState(() => _starting = false);
    _listen();
  }

  // Tanıyıcı sessizlik sonrası kendiliğinden 'notListening'/'done' durumuna
  // geçtiğinde, kullanıcı elle durdurmadıysa dinlemeyi sessizce yeniden
  // başlatır. Geçici hata durumları (ör. kısa bir sessizlik zaman aşımı)
  // burada da aynı yoldan toparlanır; bu yüzden ayrı bir onError
  // dinleyicisi eklemiyoruz.
  void _onStatus(String status) {
    if (!mounted || _stopping || _starting) return;
    if (status == 'done' || status == 'notListening') {
      _listen();
    }
  }

  void _listen() {
    if (_stopping) return;
    _speech.listen(
      onResult: (result) {
        if (!mounted) return;
        setState(() {
          if (result.finalResult) {
            final piece = result.recognizedWords.trim();
            if (piece.isNotEmpty) {
              _finalText = _finalText.isEmpty
                  ? piece
                  : '$_finalText $piece';
            }
            _partialText = '';
          } else {
            _partialText = result.recognizedWords;
          }
        });
      },
      localeId: 'tr_TR',
      listenFor: const Duration(minutes: 5),
      pauseFor: const Duration(seconds: 10),
      listenOptions: stt.SpeechListenOptions(
        partialResults: true,
        cancelOnError: false,
        listenMode: stt.ListenMode.dictation,
      ),
    );
  }

  String get _combinedText => [
    _finalText,
    _partialText,
  ].map((s) => s.trim()).where((s) => s.isNotEmpty).join(' ');

  Future<void> _stop({required bool save}) async {
    if (_stopping) return;
    _stopping = true;
    try {
      await _speech.stop();
    } catch (_) {}
    if (!mounted) return;
    if (save) {
      final combined = _combinedText;
      Navigator.pop(context, combined.isEmpty ? null : combined);
    } else {
      Navigator.pop(context, null);
    }
  }

  @override
  void dispose() {
    _speech.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final displayText = _combinedText;
    final hasError = _errorMessage != null;
    final isListening = !_starting && !hasError;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, __) {
        if (!didPop) _stop(save: false);
      },
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[700],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 18),
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.85, end: 1.0),
                duration: const Duration(milliseconds: 700),
                curve: Curves.easeInOut,
                builder: (context, scale, child) => Transform.scale(
                  scale: isListening ? scale : 1.0,
                  child: child,
                ),
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: hasError ? Colors.grey : Colors.deepPurpleAccent,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    hasError ? Icons.mic_off : Icons.mic,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                _errorMessage ??
                    (_starting ? 'Hazırlanıyor…' : 'Dinleniyor…'),
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: hasError ? Colors.redAccent : null,
                ),
              ),
              const SizedBox(height: 14),
              Container(
                width: double.infinity,
                constraints: const BoxConstraints(
                  minHeight: 90,
                  maxHeight: 180,
                ),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: dNoteSurfaceVariant(context),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: SingleChildScrollView(
                    reverse: true,
                    child: Text(
                      displayText.isEmpty
                          ? 'Konuşmaya başlayın…'
                          : displayText,
                      style: TextStyle(
                        fontSize: 15,
                        color: displayText.isEmpty
                            ? Colors.grey
                            : dNoteTextColor(context),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton.icon(
                    onPressed: () => _stop(save: false),
                    icon: const Icon(Icons.close, color: Colors.grey),
                    label: const Text(
                      'İptal',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  const SizedBox(width: 16),
                  FilledButton.icon(
                    onPressed: displayText.trim().isEmpty
                        ? null
                        : () => _stop(save: true),
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.amber,
                      foregroundColor: Colors.black,
                    ),
                    icon: const Icon(Icons.check),
                    label: const Text('Durdur ve Ekle'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Yüksek Sesle Oku Sheet'i ─────────────────────────────────────────────
// "Eylem Seç" panelinden "Yüksek Sesle Oku" seçilince açılır. Sheet açılır
// açılmaz notun başlığı + düz metin içeriği cihazın metinden sese (TTS)
// motoruyla okunmaya başlar. Oynat/Duraklat, Durdur ve okuma hızı (Yavaş/
// Normal/Hızlı) kontrolleri sunulur.
//
// Not: Android'in TTS motoru duraklatmayı native olarak desteklemez;
// flutter_tts paketi bunu, duraklatılan noktanın kelime indeksini izleyip
// bir sonraki speak() çağrısında kalan metinden devam ederek çözer — bu
// yüzden "Devam Et" de aynı tam metinle speak() çağırır.
enum _TtsPlaybackState { preparing, playing, paused, finished, error }

class _TextToSpeechSheet extends StatefulWidget {
  final String title;
  final String content;
  const _TextToSpeechSheet({required this.title, required this.content});

  @override
  State<_TextToSpeechSheet> createState() => _TextToSpeechSheetState();
}

class _TextToSpeechSheetState extends State<_TextToSpeechSheet> {
  final FlutterTts _tts = FlutterTts();
  _TtsPlaybackState _state = _TtsPlaybackState.preparing;
  // flutter_tts konuşma hızı 0.0-1.0 aralığında; 0.5 platformun normal
  // okuma hızına karşılık gelir.
  double _speechRate = 0.5;
  String? _errorMessage;

  String get _fullText => [
    widget.title.trim(),
    widget.content.trim(),
  ].where((s) => s.isNotEmpty).join('. ');

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    if (_fullText.trim().isEmpty) {
      setState(() {
        _state = _TtsPlaybackState.error;
        _errorMessage = 'Okunacak bir içerik yok.';
      });
      return;
    }
    _tts.setCompletionHandler(() {
      if (!mounted) return;
      setState(() => _state = _TtsPlaybackState.finished);
    });
    _tts.setCancelHandler(() {
      if (!mounted || _state == _TtsPlaybackState.paused) return;
      setState(() => _state = _TtsPlaybackState.finished);
    });
    _tts.setErrorHandler((msg) {
      if (!mounted) return;
      setState(() {
        _state = _TtsPlaybackState.error;
        _errorMessage = 'Okuma sırasında bir hata oluştu.';
      });
    });
    try {
      await _tts.setLanguage('tr-TR');
      await _tts.setSpeechRate(_speechRate);
      await _tts.setPitch(1.0);
      await _tts.setVolume(1.0);
    } catch (_) {
      // Türkçe dil paketi kurulu değilse cihaz varsayılan dille okumaya
      // devam eder; bu durumda ayrıca hata gösterilmez.
    }
    _play();
  }

  Future<void> _play() async {
    if (!mounted) return;
    setState(() => _state = _TtsPlaybackState.playing);
    try {
      final result = await _tts.speak(_fullText);
      if (result != 1 && mounted) {
        setState(() {
          _state = _TtsPlaybackState.error;
          _errorMessage = 'Bu cihazda sesli okuma özelliği kullanılamıyor.';
        });
      }
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _state = _TtsPlaybackState.error;
        _errorMessage = 'Bu cihazda sesli okuma özelliği kullanılamıyor.';
      });
    }
  }

  Future<void> _pause() async {
    setState(() => _state = _TtsPlaybackState.paused);
    try {
      await _tts.pause();
    } catch (_) {}
  }

  Future<void> _resume() async {
    setState(() => _state = _TtsPlaybackState.playing);
    try {
      await _tts.speak(_fullText);
    } catch (_) {}
  }

  Future<void> _setRate(double rate) async {
    if (_speechRate == rate) return;
    setState(() => _speechRate = rate);
    try {
      await _tts.setSpeechRate(rate);
    } catch (_) {}
  }

  Future<void> _close() async {
    try {
      await _tts.stop();
    } catch (_) {}
    if (mounted) Navigator.pop(context);
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  Widget _rateChip(String label, double rate) {
    final selected = _speechRate == rate;
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => _setRate(rate),
    );
  }

  Widget _buildButtons() {
    if (_state == _TtsPlaybackState.error) {
      return SizedBox(
        width: double.infinity,
        child: FilledButton(onPressed: _close, child: const Text('Kapat')),
      );
    }
    if (_state == _TtsPlaybackState.finished) {
      return Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: _play,
              icon: const Icon(Icons.replay),
              label: const Text('Tekrar Oku'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: FilledButton.icon(
              onPressed: _close,
              icon: const Icon(Icons.check),
              label: const Text('Kapat'),
            ),
          ),
        ],
      );
    }
    if (_state == _TtsPlaybackState.preparing) {
      return const SizedBox(height: 48);
    }
    final isPlaying = _state == _TtsPlaybackState.playing;
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: isPlaying ? _pause : _resume,
            icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
            label: Text(isPlaying ? 'Duraklat' : 'Devam Et'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: FilledButton.icon(
            onPressed: _close,
            icon: const Icon(Icons.stop),
            label: const Text('Durdur'),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasError = _state == _TtsPlaybackState.error;
    final isPlaying = _state == _TtsPlaybackState.playing;
    final isPaused = _state == _TtsPlaybackState.paused;
    final isPreparing = _state == _TtsPlaybackState.preparing;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, __) {
        if (!didPop) _close();
      },
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[700],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 18),
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.85, end: 1.0),
                duration: const Duration(milliseconds: 700),
                curve: Curves.easeInOut,
                builder: (context, scale, child) => Transform.scale(
                  scale: isPlaying ? scale : 1.0,
                  child: child,
                ),
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: hasError ? Colors.grey : Colors.orange,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    hasError ? Icons.volume_off : Icons.volume_up,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                _errorMessage ??
                    (isPreparing
                        ? 'Hazırlanıyor…'
                        : isPaused
                        ? 'Duraklatıldı'
                        : _state == _TtsPlaybackState.finished
                        ? 'Okuma tamamlandı'
                        : 'Okunuyor…'),
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: hasError ? Colors.redAccent : null,
                ),
              ),
              if (!hasError && !isPreparing) ...[
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _rateChip('Yavaş', 0.35),
                    const SizedBox(width: 8),
                    _rateChip('Normal', 0.5),
                    const SizedBox(width: 8),
                    _rateChip('Hızlı', 0.75),
                  ],
                ),
              ],
              const SizedBox(height: 18),
              _buildButtons(),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Ses Kaydı Oynatıcı Sheet'i ──────────────────────────────────────────
// Ek listesinde bir ses kaydına dokununca açılır. Uygulama içinde (harici
// bir oynatıcıya çıkmadan) oynat/duraklat + ilerleme çubuğu sunar.
class _VoicePlayerSheet extends StatefulWidget {
  final String path;
  final String title;
  const _VoicePlayerSheet({required this.path, required this.title});

  @override
  State<_VoicePlayerSheet> createState() => _VoicePlayerSheetState();
}

class _VoicePlayerSheetState extends State<_VoicePlayerSheet> {
  final AudioPlayer _player = AudioPlayer();
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  bool _isPlaying = false;
  StreamSubscription<Duration>? _durSub;
  StreamSubscription<Duration>? _posSub;
  StreamSubscription<PlayerState>? _stateSub;

  @override
  void initState() {
    super.initState();
    _durSub = _player.onDurationChanged.listen((d) {
      if (mounted) setState(() => _duration = d);
    });
    _posSub = _player.onPositionChanged.listen((p) {
      if (mounted) setState(() => _position = p);
    });
    _stateSub = _player.onPlayerStateChanged.listen((s) {
      if (mounted) setState(() => _isPlaying = s == PlayerState.playing);
    });
    _player.setSourceDeviceFile(widget.path);
  }

  @override
  void dispose() {
    _durSub?.cancel();
    _posSub?.cancel();
    _stateSub?.cancel();
    _player.dispose();
    super.dispose();
  }

  Future<void> _togglePlay() async {
    if (_isPlaying) {
      await _player.pause();
    } else {
      await _player.resume();
    }
  }

  String _formatDuration(Duration d) {
    final m = d.inMinutes.toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final total = _duration.inMilliseconds > 0
        ? _duration.inMilliseconds.toDouble()
        : 1.0;
    final current = _position.inMilliseconds
        .clamp(0, total.toInt())
        .toDouble();
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[700],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                const Icon(Icons.mic, color: Colors.deepPurpleAccent),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Slider(
              value: current,
              max: total,
              activeColor: Colors.amber,
              onChanged: (v) {
                setState(() => _position = Duration(milliseconds: v.toInt()));
              },
              onChangeEnd: (v) {
                _player.seek(Duration(milliseconds: v.toInt()));
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatDuration(_position),
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Text(
                  _formatDuration(_duration),
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 8),
            IconButton(
              iconSize: 56,
              icon: Icon(
                _isPlaying
                    ? Icons.pause_circle_filled
                    : Icons.play_circle_filled,
                color: Colors.amber,
              ),
              onPressed: _togglePlay,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Video Oynatıcı Diyaloğu ──────────────────────────────────────────────
// Ek listesinde bir videoya dokununca açılır: tam ekran, siyah zeminde
// oynat/duraklat (video üzerine dokunarak) ve ilerleme çubuğu sunar.
class _VideoPlayerDialog extends StatefulWidget {
  final String path;
  const _VideoPlayerDialog({required this.path});

  @override
  State<_VideoPlayerDialog> createState() => _VideoPlayerDialogState();
}

class _VideoPlayerDialogState extends State<_VideoPlayerDialog> {
  late final VideoPlayerController _controller;
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(File(widget.path))
      ..initialize().then((_) {
        if (!mounted) return;
        setState(() => _ready = true);
        _controller.play();
      });
    _controller.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlay() {
    if (_controller.value.isPlaying) {
      _controller.pause();
    } else {
      _controller.play();
    }
  }

  String _formatDuration(Duration d) {
    final m = d.inMinutes.toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.black,
      insetPadding: const EdgeInsets.all(8),
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (_ready)
            GestureDetector(
              onTap: _togglePlay,
              child: AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              ),
            )
          else
            const SizedBox(
              height: 120,
              child: Center(
                child: CircularProgressIndicator(color: Colors.amber),
              ),
            ),
          if (_ready && !_controller.value.isPlaying)
            IconButton(
              iconSize: 64,
              icon: const Icon(
                Icons.play_circle_fill,
                color: Colors.white70,
              ),
              onPressed: _togglePlay,
            ),
          if (_ready)
            Positioned(
              left: 12,
              right: 12,
              bottom: 10,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  VideoProgressIndicator(
                    _controller,
                    allowScrubbing: true,
                    colors: const VideoProgressColors(
                      playedColor: Colors.amber,
                      bufferedColor: Colors.white30,
                      backgroundColor: Colors.white12,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _formatDuration(_controller.value.position),
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 11,
                        ),
                      ),
                      Text(
                        _formatDuration(_controller.value.duration),
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          Positioned(
            top: 8,
            right: 8,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}
