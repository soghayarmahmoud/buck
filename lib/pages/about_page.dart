import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:buck/themes/theme_provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    try {
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        throw 'Could not launch $uri';
      }
    } catch (e) {
      // Handle error silently
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final primaryColor = themeProvider.primaryColor;
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'عن التطبيق',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: primaryColor,
        centerTitle: true,
        elevation: 8,
        shadowColor: primaryColor.withOpacity(0.3),
      ),
      backgroundColor: isDark ? const Color(0xFF0F1729) : Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // App Header
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      primaryColor.withOpacity(0.1),
                      primaryColor.withOpacity(0.05),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: primaryColor.withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: primaryColor.withOpacity(0.2),
                        border: Border.all(color: primaryColor, width: 3),
                      ),
                      child: Icon(Icons.book, size: 60, color: primaryColor),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'تطبيق البخاري',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'الإصدار 2.0.0',
                        style: TextStyle(
                          fontSize: 16,
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'تطبيق متخصص في أحاديث صحيح البخاري مع تنبيهات يومية وإحصائيات استخدام',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark ? Colors.white70 : Colors.grey[700],
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Developers Section
              Text(
                'فريق التطوير',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 20),

              // Developer 1: Mahmoud El-Soghayar
              _buildDeveloperCard(
                context,
                name: 'Mahmoud El-Soghayar',
                role: 'Full Stack Developer',
                avatar: 'ME',
                bio: 'مهندس برمجيات متخصص في تطوير تطبيقات Flutter',
                socialLinks: [
                  {
                    'icon': FontAwesomeIcons.github,
                    'url': 'https://github.com/soghayarmahmoud',
                    'color': Colors.black,
                  },
                  {
                    'icon': FontAwesomeIcons.linkedin,
                    'url': 'https://linkedin.com/in/soghayarmahmoud',
                    'color': const Color(0xFF0A66C2),
                  },
                ],
                primaryColor: primaryColor,
                isDark: isDark,
              ),
              const SizedBox(height: 20),

              // Developer 2: Ahmed Mahmoud Mostafa
              _buildDeveloperCard(
                context,
                name: 'Ahmed Mahmoud Mostafa',
                role: 'UI/UX & Design',
                avatar: 'AM',
                bio: 'مصمم واجهات مستخدم متخصص في التصميم الحديث',
                socialLinks: [
                  {
                    'icon': FontAwesomeIcons.dribbble,
                    'url': 'https://dribbble.com/ahmedmostafa',
                    'color': const Color(0xFFEA4C89),
                  },
                  {
                    'icon': FontAwesomeIcons.instagram,
                    'url': 'https://instagram.com/ahmedmostafa',
                    'color': const Color(0xFFE1306C),
                  },
                ],
                primaryColor: primaryColor,
                isDark: isDark,
              ),
              const SizedBox(height: 32),

              // Technologies Section
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF1A2139)
                      : primaryColor.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: primaryColor.withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '🛠️ التقنيات المستخدمة',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildTechItem('Framework', 'Flutter 3.x'),
                    _buildTechItem('Language', 'Dart'),
                    _buildTechItem('State Management', 'Provider'),
                    _buildTechItem('Database', 'SQLite'),
                    _buildTechItem(
                      'Notifications',
                      'Flutter Local Notifications',
                    ),
                    _buildTechItem('Design', 'Material Design 3'),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // License Section
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Icon(Icons.favorite, color: primaryColor, size: 32),
                    const SizedBox(height: 12),
                    Text(
                      'تم تطوير هذا التطبيق بكل محبة وإخلاص',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: isDark ? Colors.white70 : Colors.grey[700],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'جميع الحقوق محفوظة © 2024',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark ? Colors.white54 : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDeveloperCard(
    BuildContext context, {
    required String name,
    required String role,
    required String avatar,
    required String bio,
    required List<Map<String, dynamic>> socialLinks,
    required Color primaryColor,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            primaryColor.withOpacity(0.1),
            primaryColor.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: primaryColor.withOpacity(0.3), width: 2),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Avatar
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [primaryColor, primaryColor.withOpacity(0.6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withOpacity(0.3),
                  blurRadius: 12,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Center(
              child: Text(
                avatar,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Name
          Text(
            name,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
          const SizedBox(height: 4),

          // Role
          Text(
            role,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.white70 : Colors.grey[600],
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 12),

          // Bio
          Text(
            bio,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: isDark ? Colors.white60 : Colors.grey[700],
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),

          // Social Links
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var link in socialLinks)
                GestureDetector(
                  onTap: () {
                    _launchUrl(link['url'] as String);
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: (link['color'] as Color).withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      link['icon'] as IconData,
                      color: link['color'] as Color,
                      size: 20,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTechItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
