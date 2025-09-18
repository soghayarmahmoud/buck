import 'dart:ui' as ui;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class ImageHelper {
  static Future<File> hadithToImage(String text) async {
    const int width = 800;
    const int height = 1000;

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder, Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()));

    // 🌈 خلفية بتدرج ألوان جذاب
    final Rect rect = Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble());
    final Gradient gradient = LinearGradient(
      colors: [Colors.blue.shade500, Colors.blue.shade200],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
    final Paint paint = Paint()..shader = gradient.createShader(rect);
    canvas.drawRect(rect, paint);

    // ✨ علامات اقتباس كبيرة
    final TextPainter quotePainter1 = TextPainter(
      text: TextSpan(
        text: '“',
        style: TextStyle(
          color: Colors.white.withOpacity(0.3),
          fontSize: 150,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    quotePainter1.layout();
    quotePainter1.paint(canvas, Offset(20, 20));

    final TextPainter quotePainter2 = TextPainter(
      text: TextSpan(
        text: '”',
        style: TextStyle(
          color: Colors.white.withOpacity(0.3),
          fontSize: 150,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    quotePainter2.layout();
    quotePainter2.paint(canvas, Offset(20, height - 120));

    // ✏️ نص الحديث
    final TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: Colors.black,
          shadows: [
            Shadow(
              offset: Offset(1, 1),
              blurRadius: 2,
              color: Colors.white,
            ),
          ],
          fontSize: 28,
          fontWeight: FontWeight.w500,
          height: 1.4,
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.rtl,
    );
    textPainter.layout(maxWidth: width.toDouble() - 60);
    final double textY = (height - textPainter.height) / 2;
    textPainter.paint(canvas, Offset(30, textY));

    final picture = recorder.endRecording();
    final img = await picture.toImage(width, height);
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    final buffer = byteData!.buffer.asUint8List();

    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/hadith.png');
    await file.writeAsBytes(buffer);

    return file;
  }
}
