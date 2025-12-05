// ignore_for_file: depend_on_referenced_packages, deprecated_member_use, use_build_context_synchronously, unused_label

import 'package:flutter/material.dart';
import 'package:buck/components/custom_appbar.dart';
import 'package:buck/components/notification_helper.dart';
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
  bool _dailyReminderEnabled = false;
  late TimeOfDay _reminderTime;

  @override
  void initState() {
    super.initState();
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    _isBold = themeProvider.isBold;
    _isItalic = themeProvider.isItalic;
    _isUnderline = themeProvider.isUnderline;
    _reminderTime = const TimeOfDay(hour: 8, minute: 0);
    _loadReminderSettings();
  }

  Future<void> _loadReminderSettings() async {
    final enabled = await NotificationHelper.isDailyReminderEnabled();
    final (hour, minute) = await NotificationHelper.getReminderTime();
    setState(() {
      _dailyReminderEnabled = enabled;
      _reminderTime = TimeOfDay(hour: hour, minute: minute);
    });
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
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('تعذر مشاركة التطبيق.')));
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
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('تعذر فتح الرابط $url')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: const CustomAppBar(title: 'الإعدادات'),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: ListView(
          padding: const EdgeInsets.all(16.0).copyWith(bottom: 100.0),
          children: [
            // ===== تخصيص المظهر =====
            _buildSectionCard(
              context,
              icon: Icons.palette_outlined,
              title: 'تخصيص المظهر',
              children: [
                // Dark mode toggle
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: ListTile(
                    leading: Icon(
                      themeProvider.isDarkMode
                          ? Icons.dark_mode
                          : Icons.light_mode,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    title: const Text('الوضع الليلي'),
                    trailing: Switch(
                      value: themeProvider.isDarkMode,
                      onChanged: (bool value) {
                        themeProvider.toggleTheme();
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Font size slider
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.text_format,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 12),
                          const Text('حجم الخط'),
                        ],
                      ),
                      Slider(
                        value: themeProvider.fontSize,
                        min: 12.0,
                        max: 32.0,
                        divisions: 20,
                        label: themeProvider.fontSize.round().toString(),
                        onChanged: (double value) {
                          themeProvider.setFontSize(value);
                        },
                      ),
                      Text(
                        'حجم الخط الحالي: ${themeProvider.fontSize.toStringAsFixed(1)}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                // Font styles
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.style,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 12),
                          const Text('نمط الخط'),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildStyleButton(
                            icon: Icons.format_bold,
                            label: 'غامق',
                            isActive: _isBold,
                            onTap: () {
                              setState(() {
                                _isBold = !_isBold;
                              });
                              themeProvider.setFontStyle(isBold: _isBold);
                            },
                          ),
                          _buildStyleButton(
                            icon: Icons.format_italic,
                            label: 'مائل',
                            isActive: _isItalic,
                            onTap: () {
                              setState(() {
                                _isItalic = !_isItalic;
                              });
                              themeProvider.setFontStyle(isItalic: _isItalic);
                            },
                          ),
                          _buildStyleButton(
                            icon: Icons.format_underline,
                            label: 'تحته خط',
                            isActive: _isUnderline,
                            onTap: () {
                              setState(() {
                                _isUnderline = !_isUnderline;
                              });
                              themeProvider.setFontStyle(
                                isUnderline: _isUnderline,
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // ===== التنبيهات والتذكيرات =====
            _buildSectionCard(
              context,
              icon: Icons.notifications_active_outlined,
              title: 'التنبيهات والتذكيرات',
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: ListTile(
                    leading: Icon(
                      Icons.alarm,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    title: const Text('تذكير يومي'),
                    subtitle: const Text('اقرأ الحديث يومياً في وقت محدد'),
                    trailing: Switch(
                      value: _dailyReminderEnabled,
                      onChanged: (bool value) async {
                        if (value) {
                          // Show time picker
                          final TimeOfDay? picked = await showTimePicker(
                            context: context,
                            initialTime: _reminderTime,
                          );
                          if (picked != null) {
                            setState(() {
                              _reminderTime = picked;
                            });
                            await NotificationHelper.scheduleDailyReminder(
                              hour: picked.hour,
                              minute: picked.minute,
                            );
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'تم تفعيل التذكير الساعة ${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}',
                                  ),
                                ),
                              );
                            }
                          }
                        } else {
                          await NotificationHelper.disableDailyReminder();
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('تم تعطيل التذكير')),
                            );
                          }
                        }
                      },
                    ),
                  ),
                ),
                if (_dailyReminderEnabled)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Theme.of(
                            context,
                          ).colorScheme.primary.withOpacity(0.2),
                        ),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'الساعة: ${_reminderTime.hour.toString().padLeft(2, '0')}:${_reminderTime.minute.toString().padLeft(2, '0')}',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              final TimeOfDay? picked = await showTimePicker(
                                context: context,
                                initialTime: _reminderTime,
                              );
                              if (picked != null) {
                                setState(() {
                                  _reminderTime = picked;
                                });
                                await NotificationHelper.scheduleDailyReminder(
                                  hour: picked.hour,
                                  minute: picked.minute,
                                );
                              }
                            },
                            child: const Text('غيّر الوقت'),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),

            // ===== إدارة البيانات =====
            _buildSectionCard(
              context,
              icon: Icons.storage_outlined,
              title: 'إدارة البيانات',
              children: [
                _buildOptionTile(
                  context,
                  icon: Icons.refresh,
                  title: 'إعادة تعيين الإعدادات',
                  subtitle: 'استعادة الإعدادات الافتراضية',
                  onTap: _resetSettings,
                ),
                const SizedBox(height: 8),
                _buildOptionTile(
                  context,
                  icon: Icons.delete_sweep,
                  title: 'مسح البيانات المؤقتة',
                  subtitle: 'احذف ملفات مؤقتة لتحرير المساحة',
                  onTap: _clearTempData,
                ),
              ],
            ),
            const SizedBox(height: 16),

            // ===== حول التطبيق =====
            _buildSectionCard(
              context,
              icon: Icons.info_outline,
              title: 'حول التطبيق',
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('رقم الإصدار'),
                          Text(
                            '1.2.1',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('المطورون'),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Mahmoud El-Soghayar',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Ahmed Mahmoud',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                _buildOptionTile(
                  context,
                  icon: Icons.share,
                  title: 'مشاركة التطبيق',
                  subtitle: 'شارك التطبيق مع أصدقائك',
                  onTap: _shareApp,
                ),
                const SizedBox(height: 8),
                _buildOptionTile(
                  context,
                  icon: Icons.download_for_offline,
                  title: 'تحميل APK',
                  subtitle: 'حمّل نسخة التطبيق الكاملة',
                  onTap: _shareApk,
                ),
              ],
            ),
            const SizedBox(height: 16),

            // ===== التواصل والدعم =====
            _buildSectionCard(
              context,
              icon: Icons.support_agent_outlined,
              title: 'للتواصل والدعم',
              children: [
                Text(
                  'تابعنا على الشبكات الاجتماعية',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildSocialButton(
                      Icons.facebook,
                      () => _launchUrl(
                        'https://web.facebook.com/mahmoud.elsieghaiar',
                      ),
                      'Facebook',
                    ),
                    _buildSocialButton(
                      FontAwesomeIcons.whatsapp,
                      () => _launchUrl('https://wa.me/+201019593092'),
                      'WhatsApp',
                    ),
                    _buildSocialButton(
                      Icons.email,
                      () => _launchUrl('mailto:alsighiar@gmail.com'),
                      'البريد',
                    ),
                    _buildSocialButton(
                      Icons.language,
                      () => _launchUrl('https://m-el-soghayar.vercel.app/'),
                      'الموقع',
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard(
    BuildContext context, {
    required String title,
    required List<Widget> children,
    required IconData icon,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.surface,
              Theme.of(context).colorScheme.surface.withOpacity(0.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    icon,
                    color: Theme.of(context).colorScheme.primary,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 8),
              ...children,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Theme.of(context).colorScheme.primary,
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildStyleButton({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: isActive
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(12),
            child: Icon(
              icon,
              color: isActive
                  ? Colors.white
                  : Theme.of(context).colorScheme.primary,
              size: 24,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isActive
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton(IconData icon, VoidCallback onTap, String label) {
    return Tooltip(
      message: label,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.12),
            shape: BoxShape.circle,
          ),
          padding: const EdgeInsets.all(12),
          child: Icon(
            icon,
            size: 26,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }

  Future<void> _shareApk() async {
    try {
      const apkUrl =
          'https://drive.google.com/uc?export=download&id=1i_inm8g9IyRvfJ-0DjslSmwGvs0N_mvn';
      await _launchUrl(apkUrl);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم فتح رابط التحميل بنجاح')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('فشل فتح رابط التحميل')));
      }
    }
  }
}
