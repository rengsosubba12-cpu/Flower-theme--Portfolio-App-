import 'package:flutter/material.dart';
import '../models/skill_model.dart';
import '../theme/app_theme.dart';
import 'dart:math' as math;

/// Custom painter that draws a vine-like progress track with a flower
/// blooming at the progress endpoint.
class _VineProgressPainter extends CustomPainter {
  final double progress;   // 0.0 – 1.0 animated value
  final double target;     // final target value
  final Color color;

  _VineProgressPainter({
    required this.progress,
    required this.target,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final trackH = size.height;
    final filled  = size.width * progress;

    // ── Track (vine stem background) ──────────────────────────────────────
    final trackPaint = Paint()
      ..color = color.withValues(alpha: 0.12)
      ..style = PaintingStyle.fill;
    final trackRRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, trackH * 0.3, size.width, trackH * 0.4),
      const Radius.circular(20),
    );
    canvas.drawRRect(trackRRect, trackPaint);

    if (filled <= 0) return;

    // ── Filled vine ───────────────────────────────────────────────────────
    final vinePaint = Paint()
      ..color = color.withValues(alpha: 0.8)
      ..style = PaintingStyle.fill;

    // Wavy vine path
    final vinePath = Path();
    vinePath.moveTo(0, trackH * 0.5);
    for (double x = 0; x < filled; x += 6) {
      final y = trackH * 0.5 + math.sin((x / filled) * math.pi * 4) * (trackH * 0.12);
      vinePath.lineTo(x, y);
    }
    vinePath.lineTo(filled, trackH * 0.5);
    vinePath.lineTo(filled, trackH * 0.7);
    vinePath.lineTo(0, trackH * 0.7);
    vinePath.close();

    canvas.save();
    canvas.clipRRect(trackRRect);
    canvas.drawPath(vinePath, vinePaint);
    canvas.restore();

    // ── Small leaf buds along the vine ────────────────────────────────────
    final leafPaint = Paint()..color = color.withValues(alpha: 0.55)..style = PaintingStyle.fill;
    for (int i = 1; i <= 3; i++) {
      final lx = filled * (i / 4.0);
      if (lx > filled - 8) continue;
      final ly = trackH * 0.5;
      final leafPath = Path();
      leafPath.moveTo(lx, ly);
      leafPath.cubicTo(lx + 8, ly - 10, lx + 16, ly - 6, lx + 12, ly);
      leafPath.cubicTo(lx + 16, ly + 6, lx + 8, ly + 10, lx, ly);
      canvas.drawPath(leafPath, leafPaint);
    }

    // ── Blooming flower at tip ─────────────────────────────────────────────
    if (filled > 20) {
      final fx = filled;
      final fy = trackH * 0.5;
      final flowerSize = trackH * 0.45;
      final bloom = (progress / target).clamp(0.0, 1.0);
      final flowerPaint = Paint()..color = color..style = PaintingStyle.fill;

      for (int i = 0; i < 5; i++) {
        final angle = (i / 5) * math.pi * 2 - math.pi / 2;
        final px = fx + math.cos(angle) * flowerSize * bloom;
        final py = fy + math.sin(angle) * flowerSize * bloom;
        final petalPath = Path();
        petalPath.moveTo(fx, fy);
        petalPath.cubicTo(
          fx + math.cos(angle - 0.4) * flowerSize * 0.7 * bloom,
          fy + math.sin(angle - 0.4) * flowerSize * 0.7 * bloom,
          px - math.cos(angle + 0.4) * flowerSize * 0.4 * bloom,
          py - math.sin(angle + 0.4) * flowerSize * 0.4 * bloom,
          px, py,
        );
        petalPath.cubicTo(
          px + math.cos(angle + 0.4) * flowerSize * 0.4 * bloom,
          py + math.sin(angle + 0.4) * flowerSize * 0.4 * bloom,
          fx + math.cos(angle + 0.4) * flowerSize * 0.7 * bloom,
          fy + math.sin(angle + 0.4) * flowerSize * 0.7 * bloom,
          fx, fy,
        );
        canvas.drawPath(petalPath, flowerPaint);
      }
      // Center dot
      canvas.drawCircle(
        Offset(fx, fy),
        flowerSize * 0.25,
        Paint()..color = AppTheme.petalYellow,
      );
    }
  }

  @override
  bool shouldRepaint(_VineProgressPainter old) =>
      old.progress != progress || old.target != target;
}

/// An animated skill progress bar styled as a growing vine with a blooming
/// flower at the progress tip.
///
/// Call [animate] after the widget is mounted (e.g., from [TickerProvider])
/// or place it in a screen that triggers animation on [initState].
class SkillProgressBar extends StatefulWidget {
  final SkillModel skill;
  final Duration delay;
  final bool shouldAnimate;

  const SkillProgressBar({
    super.key,
    required this.skill,
    this.delay = Duration.zero,
    this.shouldAnimate = true,
  });

  @override
  State<SkillProgressBar> createState() => _SkillProgressBarState();
}

class _SkillProgressBarState extends State<SkillProgressBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _anim = Tween<double>(begin: 0.0, end: widget.skill.percentage)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));

    if (widget.shouldAnimate) {
      _startAnimation();
    }
  }

  @override
  void didUpdateWidget(SkillProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.shouldAnimate && !oldWidget.shouldAnimate) {
      _startAnimation();
    } else if (!widget.shouldAnimate && oldWidget.shouldAnimate) {
      _ctrl.reset();
    }
  }

  void _startAnimation() {
    Future.delayed(widget.delay, () {
      if (mounted && widget.shouldAnimate) {
        _ctrl.forward();
      }
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: widget.skill.color.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(widget.skill.icon, color: widget.skill.color, size: 16),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  widget.skill.name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.darkForest,
                  ),
                ),
              ),
              AnimatedBuilder(
                animation: _anim,
                builder: (_, _) => Text(
                  '${(_anim.value * 100).toInt()}%',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: widget.skill.color,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 22,
            child: AnimatedBuilder(
              animation: _anim,
              builder: (_, _) => CustomPaint(
                size: const Size(double.infinity, 22),
                painter: _VineProgressPainter(
                  progress: _anim.value,
                  target: widget.skill.percentage,
                  color: widget.skill.color,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
