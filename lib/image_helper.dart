import 'dart:ui' as ui;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class ImageHelper {
  static Future<File> hadithToImage(String text) async {
    const int width = 800;
    int height = 1000; // default height

    // First, measure the text height to adapt image size
    final double margin = 40;
    final double textAreaWidth = width - margin * 2 - 60;
    final TextPainter measurePainter = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(
          color: Color(0xFF0B1220),
          fontSize: 26,
          fontWeight: FontWeight.w600,
          height: 1.6,
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.rtl,
    );
    measurePainter.layout(maxWidth: textAreaWidth);

    // Calculate dynamic height based on text
    final textHeight = measurePainter.height;
    height =
        ((textHeight + 200).toInt() ~/ 100) * 100; // Round up to nearest 100
    if (height < 800) height = 800; // Minimum height
    if (height > 2000) height = 2000; // Maximum height

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(
      recorder,
      Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()),
    );

    // 🌈 modern background with soft gradient + rounded card
    final Rect rect = Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble());
    final Gradient gradient = LinearGradient(
      colors: [const Color(0xFF00695C), const Color(0xFF00BFA5)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
    final Paint paint = Paint()..shader = gradient.createShader(rect);
    canvas.drawRect(rect, paint);

    // draw a translucent rounded card in the center for the hadith text
    final RRect cardRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        margin,
        margin + 40,
        width - margin * 2,
        height - margin * 2 - 80,
      ),
      const Radius.circular(24),
    );
    final Paint cardPaint = Paint()..color = Colors.white.withOpacity(0.9);
    canvas.drawRRect(cardRect, cardPaint);

    // subtle decorative top-right circles
    final Paint circlePaint = Paint()..color = Colors.white.withOpacity(0.06);
    for (int i = 0; i < 6; i++) {
      canvas.drawCircle(
        Offset(width - 60.0 - i * 28, 80.0 + i * 18),
        18.0 + i.toDouble(),
        circlePaint,
      );
    }

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

    // ✏️ hadith text painted inside the white card
    final double textAreaLeft = margin + 30;
    final double textAreaTop = margin + 80;

    final TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: const Color(0xFF0B1220),
          fontSize: 26,
          fontWeight: FontWeight.w600,
          height: 1.6,
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.rtl,
    );
    textPainter.layout(maxWidth: textAreaWidth);
    final double textY =
        textAreaTop + ((height - margin * 2 - 160) - textPainter.height) / 2;
    textPainter.paint(canvas, Offset(textAreaLeft, textY));

    final picture = recorder.endRecording();
    final img = await picture.toImage(width, height);
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    final buffer = byteData!.buffer.asUint8List();

    // watermark / app name
    final TextPainter watermark = TextPainter(
      text: TextSpan(
        text: 'البخاري',
        style: TextStyle(
          color: Colors.black.withOpacity(0.25),
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.rtl,
    );
    watermark.layout();
    watermark.paint(
      canvas,
      Offset(width - watermark.width - 24, height - watermark.height - 18),
    );

    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/hadith.png');
    await file.writeAsBytes(buffer);

    return file;
  }
}
