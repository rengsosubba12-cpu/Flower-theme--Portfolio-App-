import 'package:flutter/material.dart';
import 'dart:math' as math;

/// A single floating petal particle in the animation.
class _Petal {
  double x;          // horizontal position (0.0 – 1.0 of width)
  double y;          // vertical position (0.0 – 1.0 of height, starts below screen)
  double size;       // radius in logical pixels
  double speed;      // upward drift speed per tick (0.0 – 1.0)
  double wobble;     // horizontal sine-wave amplitude
  double wobbleFreq; // frequency of horizontal wobble
  double phase;      // initial sine phase offset
  double opacity;    // 0.0 – 1.0
  Color color;
  int petalType;     // 0 = round, 1 = teardrop, 2 = star

  _Petal({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.wobble,
    required this.wobbleFreq,
    required this.phase,
    required this.opacity,
    required this.color,
    required this.petalType,
  });
}

/// Paints the continuous antigravity petal drift animation.
class _FloralPainter extends CustomPainter {
  final double animationValue; // 0.0 – 1.0 looping
  final List<_Petal> petals;

  _FloralPainter({required this.animationValue, required this.petals});

  @override
  void paint(Canvas canvas, Size size) {
    for (final petal in petals) {
      // Calculate current position
      final progress = (petal.y - animationValue * petal.speed * 2) % 1.2;
      final screenY = size.height * (1.1 - progress); // drift upward
      final wobbleOffset = petal.wobble * math.sin(animationValue * petal.wobbleFreq * math.pi * 2 + petal.phase);
      final screenX = size.width * petal.x + wobbleOffset;

      // Fade in near the bottom, fade out near the top
      final fadeIn  = (progress / 0.15).clamp(0.0, 1.0);
      final fadeOut = (1.0 - (progress - 0.85) / 0.15).clamp(0.0, 1.0);
      final alpha   = (petal.opacity * fadeIn * fadeOut).clamp(0.0, 1.0);

      if (alpha <= 0) continue;

      final paint = Paint()
        ..color = petal.color.withValues(alpha: alpha)
        ..style = PaintingStyle.fill;

      canvas.save();
      canvas.translate(screenX, screenY);
      canvas.rotate(animationValue * math.pi * 2 * (petal.phase > 0 ? 0.4 : -0.4));

      switch (petal.petalType) {
        case 0:
          _drawRoundPetal(canvas, paint, petal.size);
        case 1:
          _drawTearDrop(canvas, paint, petal.size);
        case 2:
          _drawStarPetal(canvas, paint, petal.size);
        default:
          _drawRoundPetal(canvas, paint, petal.size);
      }

      canvas.restore();
    }
  }

  void _drawRoundPetal(Canvas canvas, Paint paint, double size) {
    final path = Path();
    path.moveTo(0, -size);
    path.cubicTo(size * 0.8, -size * 0.6, size * 0.8, size * 0.6, 0, size);
    path.cubicTo(-size * 0.8, size * 0.6, -size * 0.8, -size * 0.6, 0, -size);
    canvas.drawPath(path, paint);
  }

  void _drawTearDrop(Canvas canvas, Paint paint, double size) {
    final path = Path();
    path.moveTo(0, -size);
    path.cubicTo(size * 0.6, -size * 0.4, size * 0.5, size * 0.3, 0, size * 0.7);
    path.cubicTo(-size * 0.5, size * 0.3, -size * 0.6, -size * 0.4, 0, -size);
    canvas.drawPath(path, paint);
  }

  void _drawStarPetal(Canvas canvas, Paint paint, double size) {
    final numPoints = 5;
    final path = Path();
    for (int i = 0; i < numPoints * 2; i++) {
      final angle = (i * math.pi / numPoints) - math.pi / 2;
      final r = i.isEven ? size : size * 0.4;
      final px = r * math.cos(angle);
      final py = r * math.sin(angle);
      if (i == 0) {
        path.moveTo(px, py);
      } else {
        path.lineTo(px, py);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_FloralPainter old) =>
      old.animationValue != animationValue;
}

/// A stateful widget that renders a continuous, lightweight animated background
/// where flower petals drift upward from the bottom (antigravity effect).
///
/// Wrap any screen content with this widget as the background layer.
class FloralBackground extends StatefulWidget {
  /// The child widget to render on top of the animated background.
  final Widget child;

  /// Optional additional tint to blend into the background.
  final Color? backgroundColor;

  const FloralBackground({
    super.key,
    required this.child,
    this.backgroundColor,
  });

  @override
  State<FloralBackground> createState() => _FloralBackgroundState();
}

class _FloralBackgroundState extends State<FloralBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<_Petal> _petals;

  static const _petalColors = [
    Color(0x55F0B8C0), // blush pink
    Color(0x447DAA92), // sage green
    Color(0x44B8A9D9), // lavender
    Color(0x55F6D78C), // petal yellow
    Color(0x33D97B8A), // dusty rose
    Color(0x33D4856A), // terracotta
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 18),
    )..repeat();
    _petals = _generatePetals();
  }

  List<_Petal> _generatePetals() {
    final rng = math.Random(42); // seeded for determinism
    return List.generate(38, (i) {
      return _Petal(
        x: rng.nextDouble(),
        y: rng.nextDouble() * 1.1,
        size: 5 + rng.nextDouble() * 10,
        speed: 0.12 + rng.nextDouble() * 0.18,
        wobble: 10 + rng.nextDouble() * 25,
        wobbleFreq: 0.5 + rng.nextDouble() * 1.5,
        phase: rng.nextDouble() * math.pi * 2,
        opacity: 0.35 + rng.nextDouble() * 0.45,
        color: _petalColors[rng.nextInt(_petalColors.length)],
        petalType: rng.nextInt(3),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Solid background colour
        ColoredBox(
          color: widget.backgroundColor ?? const Color(0xFFF9F5EE),
        ),
        // Animated petal layer
        AnimatedBuilder(
          animation: _controller,
          builder: (_, _) => CustomPaint(
            painter: _FloralPainter(
              animationValue: _controller.value,
              petals: _petals,
            ),
          ),
        ),
        // Content
        widget.child,
      ],
    );
  }
}
