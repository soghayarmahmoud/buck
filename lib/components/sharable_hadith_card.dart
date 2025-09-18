// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:buck/models/hadith.dart';

class ShareableHadithCard extends StatelessWidget {
  final Hadith hadith;
  const ShareableHadithCard({super.key, required this.hadith});

  @override
  Widget build(BuildContext context) {
    return Container(
      // خلفية متدرجة جذابة
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.grey.shade800, Colors.grey.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // علامات اقتباس شفافة كبيرة في الخلفية
          Positioned(
            top: -10,
            left: -10,
            child: Icon(
              Icons.format_quote,
              size: 150,
              color: Colors.white.withOpacity(0.05),
            ),
          ),
          Positioned(
            bottom: -10,
            right: -10,
            child: Icon(
              Icons.format_quote,
              size: 150,
              color: Colors.white.withOpacity(0.05),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // نص الحديث
              Text(
                hadith.text,
                style: TextStyle(
                  fontSize: 20,
                  height: 1.8,
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withOpacity(0.9),
                ),
                textAlign: TextAlign.justify,
                textDirection: TextDirection.rtl,
              ),
              const SizedBox(height: 20),
              // مصدر الحديث
              Text(
                'صحيح البخاري - حديث رقم ${hadith.id}',
                style: TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  color: Colors.white.withOpacity(0.5),
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
