import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:buck/models/hadith.dart';
import 'package:buck/themes/theme_provider.dart';

class ShareableHadithCard extends StatelessWidget {
  final Hadith hadith;
  const ShareableHadithCard({super.key, required this.hadith});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final primaryColor = themeProvider.primaryColor;
    final lightColor = primaryColor.withOpacity(0.8);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            primaryColor.withOpacity(0.95),
            lightColor.withOpacity(0.85),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 36),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Decorative circles in top-left
          Positioned(
            top: -20,
            left: -20,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.08),
              ),
            ),
          ),
          // Decorative circles in bottom-right
          Positioned(
            bottom: -15,
            right: -15,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.06),
              ),
            ),
          ),
          // Quote marks
          Positioned(
            top: 12,
            right: 16,
            child: Icon(
              Icons.format_quote,
              size: 80,
              color: Colors.white.withOpacity(0.12),
            ),
          ),
          Positioned(
            bottom: 12,
            left: 16,
            child: Icon(
              Icons.format_quote,
              size: 80,
              color: Colors.white.withOpacity(0.10),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Hadith text
              Text(
                hadith.text,
                style: TextStyle(
                  fontSize: 22,
                  height: 1.6,
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withOpacity(0.95),
                  letterSpacing: 0.4,
                ),
                textAlign: TextAlign.justify,
                textDirection: TextDirection.rtl,
              ),
              const SizedBox(height: 24),
              // Divider
              Container(
                height: 1.5,
                color: Colors.white.withOpacity(0.25),
                margin: const EdgeInsets.symmetric(horizontal: 16),
              ),
              const SizedBox(height: 18),
              // Source
              Text(
                'صحيح البخاري - حديث رقم ${hadith.id}',
                style: TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  color: Colors.white.withOpacity(0.7),
                  letterSpacing: 0.2,
                ),
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
