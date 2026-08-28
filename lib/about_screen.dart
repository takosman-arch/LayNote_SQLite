part of 'main.dart';

// ════════════════════════════════════════════════════════════════════════
// UYGULAMA HAKKINDA EKRANI (Ayarlar > Uygulama Hakkında)
// Sürüm/build numarası pubspec.yaml'dan package_info_plus ile OTOMATİK
// okunur (elle güncellemeye gerek yoktur — pubspec.yaml'daki `version:`
// satırını değiştirdiğinde burası da otomatik güncellenir).
//
// AŞAĞIDAKİ SABİTLERİ KENDİ BİLGİLERİNLE DOLDUR:
// Geliştirici adı, e-posta, web sitesi/GitHub ve mağaza linki gibi bilgiler
// projeye özel olduğu için burada placeholder bırakıldı. Boş ('') bırakılan
// bir satır ekranda otomatik olarak gizlenir.
// ════════════════════════════════════════════════════════════════════════

const String kLayoutDeveloperName = 'Tamer Akosman';
const String kLayoutContactEmail = 'layoutnote@gmail.com';
const String kLayoutWebsiteUrl = ''; // örn: 'https://siteniz.com'
const String kLayoutGithubUrl = ''; // örn: 'https://github.com/kullaniciadi/dnote'
const String kLayoutPrivacyPolicyUrl = 'https://layoutnote.github.io/Layout-Privacy-Policy/';
const String kLayoutTermsUrl = 'https://layoutnote.github.io/Terms-and-Conditions/';
// Play Store'da yayınlandığında paket adını gir (Android):
const String kLayoutPlayStorePackageId = 'com.layoutnote.app';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  PackageInfo? _packageInfo;

  @override
  void initState() {
    super.initState();
    _loadPackageInfo();
  }

  Future<void> _loadPackageInfo() async {
    try {
      final info = await PackageInfo.fromPlatform();
      if (mounted) setState(() => _packageInfo = info);
    } catch (_) {
      // Bilgi okunamazsa (ör. bazı platformlarda) sessizce yutulur;
      // sürüm satırı bu durumda gösterilmez.
    }
  }

  Future<void> _openUrl(String url) async {
    if (url.isEmpty) return;
    final uri = Uri.parse(url);
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.aboutLinkOpenError)),
      );
    }
  }

  Future<void> _sendEmail(String email) async {
    if (email.isEmpty) return;
    final uri = Uri(scheme: 'mailto', path: email);
    try {
      await launchUrl(uri);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.aboutLinkOpenError)),
      );
    }
  }

  Widget _sectionHeader(String title) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 24, 16, 6),
    child: Text(
      title.toUpperCase(),
      style: TextStyle(
        color: dNoteTextColor(context),
        fontSize: 11,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.4,
      ),
    ),
  );

  Widget _tile({
    required IconData icon,
    required Color iconColor,
    required String title,
    String? subtitle,
    VoidCallback? onTap,
  }) => ListTile(
    leading: Icon(icon, color: iconColor, size: 22),
    title: Text(
      title,
      style: TextStyle(color: dNoteTextColor(context), fontSize: 14),
    ),
    subtitle: subtitle != null
        ? Text(subtitle, style: TextStyle(color: Colors.grey[500], fontSize: 11))
        : null,
    trailing: onTap != null
        ? Icon(Icons.chevron_right, color: Colors.grey[500], size: 20)
        : null,
    onTap: onTap,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
  );

  Widget _card(List<Widget> children) => Container(
    margin: const EdgeInsets.symmetric(horizontal: 12),
    decoration: BoxDecoration(
      color: dNoteCardColor(context),
      borderRadius: BorderRadius.circular(14),
    ),
    child: Column(children: children),
  );

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final versionLabel = _packageInfo == null
        ? null
        : 'v${_packageInfo!.version} (${_packageInfo!.buildNumber})';

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsSectionAbout)),
      body: SafeArea(
        child: ListView(
          children: [
            const SizedBox(height: 24),

            // ── Geliştirici ──────────────────────────────────────────────
            _sectionHeader(l10n.aboutSectionDeveloper),
            _card([
              if (kLayoutContactEmail.isNotEmpty)
                _tile(
                  icon: Icons.email_outlined,
                  iconColor: Theme.of(context).primaryColor,
                  title: l10n.aboutContactTitle,
                  subtitle: kLayoutContactEmail,
                  onTap: () => _sendEmail(kLayoutContactEmail),
                ),
              if (kLayoutWebsiteUrl.isNotEmpty)
                _tile(
                  icon: Icons.language,
                  iconColor: Theme.of(context).primaryColor,
                  title: l10n.aboutWebsiteTitle,
                  subtitle: kLayoutWebsiteUrl,
                  onTap: () => _openUrl(kLayoutWebsiteUrl),
                ),
              if (kLayoutGithubUrl.isNotEmpty)
                _tile(
                  icon: Icons.code,
                  iconColor: Theme.of(context).primaryColor,
                  title: l10n.aboutGithubTitle,
                  subtitle: kLayoutGithubUrl,
                  onTap: () => _openUrl(kLayoutGithubUrl),
                ),
            ]),

            // ── Yasal ────────────────────────────────────────────────────
            _sectionHeader(l10n.aboutSectionLegal),
            _card([
              if (kLayoutPrivacyPolicyUrl.isNotEmpty)
                _tile(
                  icon: Icons.privacy_tip_outlined,
                  iconColor: Theme.of(context).primaryColor,
                  title: l10n.aboutPrivacyPolicyTitle,
                  onTap: () => _openUrl(kLayoutPrivacyPolicyUrl),
                ),
              if (kLayoutTermsUrl.isNotEmpty)
                _tile(
                  icon: Icons.description_outlined,
                  iconColor: Theme.of(context).primaryColor,
                  title: l10n.aboutTermsTitle,
                  onTap: () => _openUrl(kLayoutTermsUrl),
                ),
              _tile(
                icon: Icons.gavel_outlined,
                iconColor: Theme.of(context).primaryColor,
                title: l10n.aboutLicensesTitle,
                onTap: () {
                  final info = _packageInfo;
                  showLicensePage(
                    context: context,
                    applicationName: 'Layout',
                    applicationVersion: info != null
                        ? 'v${info.version} (${info.buildNumber})'
                        : null,
                    applicationIcon: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Icon(
                        Icons.sticky_note_2_outlined,
                        color: Theme.of(context).primaryColor,
                        size: 32,
                      ),
                    ),
                  );
                },
              ),
            ]),

            // ── Destek ───────────────────────────────────────────────────
            if (kLayoutPlayStorePackageId.isNotEmpty) ...[
              _sectionHeader(l10n.aboutSectionSupport),
              _card([
                _tile(
                  icon: Icons.star_outline,
                  iconColor: Theme.of(context).primaryColor,
                  title: l10n.aboutRateAppTitle,
                  onTap: () => _openUrl(
                    'https://play.google.com/store/apps/details?id=$kLayoutPlayStorePackageId',
                  ),
                ),
              ]),
            ],

            const SizedBox(height: 24),
            Center(
              child: Text(
                versionLabel ?? l10n.settingsAboutVersionLoading,
                style: TextStyle(color: Colors.grey[500], fontSize: 12),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
