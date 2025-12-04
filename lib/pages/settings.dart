// ignore_for_file: depend_on_referenced_packages, deprecated_member_use, use_build_context_synchronously, unused_label

import 'package:flutter/material.dart';
import 'package:buck/components/custom_appbar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:buck/themes/theme_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late bool _isBold;
  late bool _isItalic;
  late bool _isUnderline;

  @override
  void initState() {
    super.initState();
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    _isBold = themeProvider.isBold;
    _isItalic = themeProvider.isItalic;
    _isUnderline = themeProvider.isUnderline;
  }

  void _resetSettings() {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    setState(() {
      _isBold = false;
      _isItalic = false;
      _isUnderline = false;
    });
    themeProvider.setFontSize(16.0);
    themeProvider.setFontStyle(
      isBold: false,
      isItalic: false,
      isUnderline: false,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم إعادة تعيين الإعدادات بنجاح.')),
    );
  }

  Future<void> _clearTempData() async {
    try {
      final tempDir = await getTemporaryDirectory();
      if (tempDir.existsSync()) {
        tempDir.listSync().forEach((file) {
          file.deleteSync(recursive: true);
        });
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم مسح البيانات المؤقتة بنجاح.')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('فشل مسح البيانات المؤقتة.')),
        );
      }
    }
  }
Future<void> _shareApp() async {
  try {
    const url =
        'https://drive.google.com/uc?export=download&id=1i_inm8g9IyRvfJ-0DjslSmwGvs0N_mvn';

    await Share.share(
      '📲 جرّب تطبيق البخاري!\n\nحمّل التطبيق من هنا: $url',
      subject: 'تطبيق البخاري',
    );
  } catch (e) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تعذر مشاركة التطبيق.')),
      );
    }
  }
}


  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    try {
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        throw 'Could not launch $uri';
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('تعذر فتح الرابط $url')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'الإعدادات',
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            _buildSectionCard(
              context,
              title: 'تخصيص المظهر',
              children: [
                ListTile(
                  leading: const Icon(Icons.color_lens),
                  title: const Text('الوضع الداكن'),
                  trailing: Switch(
                    value: themeProvider.isDarkMode,
                    onChanged: (bool value) {
                      themeProvider.toggleTheme();
                    },
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.text_format),
                  title: const Text('حجم الخط'),
                  subtitle: Slider(
                    value: themeProvider.fontSize,
                    min: 12.0,
                    max: 32.0,
                    divisions: 20,
                    label: themeProvider.fontSize.round().toString(),
                    onChanged: (double value) {
                      themeProvider.setFontSize(value);
                    },
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.style),
                  title: const Text('نمط الخط'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildStyleButton(
                        icon: Icons.format_bold,
                        isActive: _isBold,
                        onTap: () {
                          setState(() {
                            _isBold = !_isBold;
                            if(_isBold){
                              backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1);
                            }
                            else{
                              backgroundColor: Colors.transparent;
                            }
                          });
                          themeProvider.setFontStyle(isBold: _isBold);
                        },
                      ),
                      _buildStyleButton(
                        icon: Icons.format_italic,
                        isActive: _isItalic,
                        onTap: () {
                          setState(() {
                            _isItalic = !_isItalic;
                            if(_isItalic){
                              backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1);
                            }
                            else{
                              backgroundColor: Colors.transparent;
                            }
                          });
                          themeProvider.setFontStyle(isItalic: _isItalic);
                        },
                      ),
                      _buildStyleButton(
                        icon: Icons.format_underline,
                        isActive: _isUnderline,
                        onTap: () {
                          setState(() {
                            _isUnderline = !_isUnderline;
                            if(_isUnderline){
                              backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1);
                            }
                            else{
                              backgroundColor: Colors.transparent;
                            }
                          });
                          themeProvider.setFontStyle(isUnderline: _isUnderline);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            _buildSectionCard(
              context,
              title: 'إدارة البيانات',
              children: [
                ListTile(
                  leading: const Icon(Icons.refresh),
                  title: const Text('إعادة تعيين الإعدادات'),
                  onTap: _resetSettings,
                ),
                ListTile(
                  leading: const Icon(Icons.delete_forever),
                  title: const Text('مسح البيانات المؤقتة'),
                  onTap: _clearTempData,
                ),
              ],
            ),
            const SizedBox(height: 16),

            _buildSectionCard(
              context,
              title: 'حول التطبيق',
              children: [
                const ListTile(
                  leading: Icon(Icons.info_outline),
                  title: Text('رقم الإصدار'),
                  subtitle: Text('1.2.1' , style: TextStyle(fontWeight: FontWeight.bold),),
                ),
                const ListTile(
                  leading: Icon(Icons.person),
                  title: Text('المطور'),
                  subtitle: Text('Mahmoud El-Soghayar'),
                ),
                ListTile(
                  leading: const Icon(Icons.share),
                  title: const Text('مشاركة التطبيق'),
                  onTap: _shareApp,
                ),
              ],
            ),
            const SizedBox(height: 16),

            _buildSectionCard(
              context,
              title: 'للتواصل والدعم',
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildSocialButton(Icons.facebook, () => _launchUrl('https://web.facebook.com/mahmoud.elsieghaiar')),
                    _buildSocialButton(FontAwesomeIcons.whatsapp, () => _launchUrl('https://wa.me/+201019593092')),
                    _buildSocialButton(FontAwesomeIcons.squareWhatsapp, () => _launchUrl('https://wa.me/+201101025358')),
                    _buildSocialButton(Icons.email, () => _launchUrl('mailto:alsighiar@gmail.com')),
                    _buildSocialButton(Icons.link, () => _launchUrl('https://m-el-soghayar.vercel.app/')),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard(BuildContext context,
      {required String title, required List<Widget> children}) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const Divider(),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildStyleButton({
    required IconData icon,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return IconButton(
      onPressed: onTap,
      icon: Icon(
        icon,
        color: isActive
            ? Theme.of(context).colorScheme.inversePrimary // لون مميز
            : Theme.of(context).colorScheme.inversePrimary.withOpacity(0.5), // اللون الافتراضي
      ),
      splashColor: Colors.blue.withOpacity(0.5),
      highlightColor: Colors.blue.withOpacity(0.5),
    );
  }

  Widget _buildSocialButton(IconData icon, VoidCallback onTap) {
    return IconButton(
      icon: Icon(icon, size: 28, color: Theme.of(context).colorScheme.primary),
      onPressed: onTap,
      style: IconButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        shape: const CircleBorder(),
      ),
    );
  }
}
