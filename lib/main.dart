import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CustomPaint(
            size: const Size(200, 300),
            painter: CharacterPainter(
              happiness: Happiness.smile,
              isDunce: true,
              isStinky: false,
              isMessy: false,
            ),
          ),
        ),
      ),
    );
  }
}

enum Happiness { smile, neutral, sad }

class CharacterPainter extends CustomPainter {
  final Happiness happiness;
  final bool isDunce;
  final bool isStinky;
  final bool isMessy;

  CharacterPainter({
    this.happiness = Happiness.neutral,
    this.isDunce = false,
    this.isStinky = false,
    this.isMessy = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    // Paint definitions
    final paintSkin = Paint()..color = const Color(0xFFD1A17E);
    final paintHair = Paint()..color = const Color(0xFF5D3A1A);
    final paintShirt = Paint()..color = const Color(0xFF5478A5);
    final paintPants = Paint()..color = const Color(0xFF1E3A5F);
    final paintEye = Paint()..color = Colors.white;
    final paintPupil = Paint()..color = Colors.black;
    final paintMouth = Paint()..color = const Color(0xFFE57373)..style = PaintingStyle.fill;
    final paintHat = Paint()..color = Colors.white..style = PaintingStyle.fill;
    final paintHatOutline = Paint()
      ..color = Colors.grey.shade400
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeJoin = StrokeJoin.round;
    final paintSmoke = Paint()
      ..color = Colors.green.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;
    final paintTrash = Paint()..color = Colors.grey.shade600;

    // Body (shirt) – draw first so smoke behind
    final body = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.2, h * 0.45, w * 0.6, h * 0.43),
      const Radius.circular(20),
    );
    canvas.drawRRect(body, paintShirt);

    // Pants
    final pants = RRect.fromRectAndCorners(
      Rect.fromLTWH(body.left, body.bottom - h * 0.1, body.width, h * 0.2),
      bottomLeft: const Radius.circular(20),
      bottomRight: const Radius.circular(20),
    );
    canvas.drawRRect(pants, paintPants);

    // Optional messy trash around feet
    if (isMessy) {
      final trashRects = [
        // larger and more scattered trash items
        Rect.fromLTWH(body.left - w * 0.08, pants.bottom + h * 0.03, w * 0.10, h * 0.03),
        Rect.fromLTWH(body.left + w * 0.05, pants.bottom + h * 0.06, w * 0.12, h * 0.035),
        Rect.fromLTWH(body.left + w * 0.25, pants.bottom + h * 0.025, w * 0.11, h * 0.03),
        Rect.fromLTWH(body.right - w * 0.18, pants.bottom + h * 0.07, w * 0.09, h * 0.028),
        Rect.fromLTWH(body.right + w * 0.02, pants.bottom + h * 0.035, w * 0.10, h * 0.032),
        Rect.fromLTWH(body.right + w * 0.12, pants.bottom + h * 0.02, w * 0.08, h * 0.025),
      ];
      for (final r in trashRects) {
        canvas.drawRect(r, paintTrash);
      }
    }

    // Smoke – three left/up, three right/up
    if (isStinky) {
      final double length = h * 0.3;
      final offsets = [
        Offset(body.left - w * 0.15, body.top - h * 0.06),
        Offset(body.left - w * 0.10, body.top - h * 0.06),
        Offset(body.left - w * 0.05, body.top - h * 0.06),
        Offset(body.right + w * 0.05, body.top - h * 0.06),
        Offset(body.right + w * 0.10, body.top - h * 0.06),
        Offset(body.right + w * 0.15, body.top - h * 0.06),
      ];
      for (int i = 0; i < offsets.length; i++) {
        final start = offsets[i];
        final bool leftSide = i < 3;
        final double angle = leftSide ? 3 * pi / 4 : pi / 4;
        final dx = cos(angle) * length;
        final dy = -sin(angle) * length;
        canvas.drawLine(start, Offset(start.dx + dx, start.dy + dy), paintSmoke);
      }
    }

    // Head
    final head = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.25, h * 0.02, w * 0.5, h * 0.4),
      const Radius.circular(12),
    );
    canvas.drawRRect(head, paintSkin);

    // Hair
    final hair = RRect.fromRectAndCorners(
      Rect.fromLTWH(head.left, head.top - h * 0.05, head.width, h * 0.12),
      topLeft: const Radius.circular(12),
      topRight: const Radius.circular(12),
    );
    canvas.drawRRect(hair, paintHair);

    // Dunce hat – moved further up
    if (isDunce) {
      final Path hat = Path()
        ..moveTo(w * 0.34, head.top - h * 0.08)
        ..lineTo(w * 0.66, head.top - h * 0.08)
        ..lineTo(w * 0.50, head.top - h * 0.48)
        ..close();
      canvas.drawPath(hat, paintHat);
      canvas.drawPath(hat, paintHatOutline);
    }

    // Eyes
    final leftEye = Offset(w * 0.35, h * 0.23);
    final rightEye = Offset(w * 0.65, h * 0.23);
    final er = w * 0.05;
    canvas.drawCircle(leftEye, er, paintEye);
    canvas.drawCircle(rightEye, er, paintEye);
    canvas.drawCircle(leftEye, er * 0.3, paintPupil);
    canvas.drawCircle(rightEye, er * 0.3, paintPupil);

    // Mouth
    final mw = w * 0.18;
    final mh = h * 0.06;
    final mx = (w - mw) / 2;
    final myDef = h * 0.33;
    final mySmile = h * 0.30;
    switch (happiness) {
      case Happiness.sad:
        canvas.drawArc(Rect.fromLTWH(mx, myDef, mw, mh * 2), pi, pi, true, paintMouth);
        break;
      case Happiness.smile:
        canvas.save();
        canvas.translate(w / 2, mySmile + mh);
        canvas.rotate(pi);
        canvas.drawArc(Rect.fromLTWH(-mw / 2, -mh, mw, mh * 2), pi, pi, true, paintMouth);
        canvas.restore();
        break;
      case Happiness.neutral:
      default:
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(mx, myDef + h * 0.02, mw, h * 0.03),
            const Radius.circular(3),
          ),
          paintMouth,
        );
    }
  }

  @override
  bool shouldRepaint(covariant CharacterPainter old) =>
      old.happiness != happiness ||
          old.isDunce != isDunce ||
          old.isStinky != isStinky ||
          old.isMessy != isMessy;
}
