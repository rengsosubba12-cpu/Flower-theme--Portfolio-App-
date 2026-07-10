import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../theme/app_theme.dart';

/// Custom painted bottom navigation bar item.
class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem({required this.icon, required this.label});
}

/// Paints a single nav item — a blooming flower when active,
/// a closed bud when inactive.
class _FlowerNavItemPainter extends CustomPainter {
  final bool isActive;
  final Color activeColor;
  final Color inactiveColor;
  final double animValue; // 0.0 (bud) → 1.0 (bloom)

  _FlowerNavItemPainter({
    required this.isActive,
    required this.activeColor,
    required this.inactiveColor,
    required this.animValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final color = Color.lerp(inactiveColor, activeColor, animValue)!;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    if (animValue < 0.3) {
      // Draw a bud (small teardrop)
      _drawBud(canvas, cx, cy, paint, size.width * 0.18);
    } else {
      // Draw a blooming flower
      _drawBloom(canvas, cx, cy, paint, size.width * 0.22, animValue);
    }
  }

  void _drawBud(Canvas canvas, double cx, double cy, Paint paint, double r) {
    final path = Path();
    path.moveTo(cx, cy - r * 1.4);
    path.cubicTo(cx + r, cy - r * 0.5, cx + r, cy + r * 0.3, cx, cy + r * 0.6);
    path.cubicTo(cx - r, cy + r * 0.3, cx - r, cy - r * 0.5, cx, cy - r * 1.4);
    canvas.drawPath(path, paint);
    // Stem
    final stemPaint = Paint()
      ..color = paint.color.withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(cx, cy + r * 0.6), Offset(cx, cy + r * 1.8), stemPaint);
  }

  void _drawBloom(Canvas canvas, double cx, double cy, Paint paint, double r, double bloom) {
    final numPetals = 5;
    final petalLength = r * (1.0 + bloom * 0.5);
    final petalWidth  = r * (0.5 + bloom * 0.3);

    for (int i = 0; i < numPetals; i++) {
      final angle = (i / numPetals) * math.pi * 2 - math.pi / 2;
      canvas.save();
      canvas.translate(cx, cy);
      canvas.rotate(angle);

      final path = Path();
      path.moveTo(0, 0);
      path.cubicTo(-petalWidth, -petalLength * 0.3, -petalWidth, -petalLength * 0.8, 0, -petalLength);
      path.cubicTo(petalWidth, -petalLength * 0.8, petalWidth, -petalLength * 0.3, 0, 0);
      canvas.drawPath(path, paint);
      canvas.restore();
    }
    // Center circle
    canvas.drawCircle(
      Offset(cx, cy),
      r * 0.3,
      Paint()..color = AppTheme.petalYellow.withValues(alpha: 0.9),
    );
  }

  @override
  bool shouldRepaint(_FlowerNavItemPainter old) =>
      old.isActive != isActive || old.animValue != animValue;
}

/// A single animated nav item widget.
class _AnimatedFlowerNavItem extends StatefulWidget {
  final bool isActive;
  final String label;
  final VoidCallback onTap;

  const _AnimatedFlowerNavItem({
    required this.isActive,
    required this.label,
    required this.onTap,
  });

  @override
  State<_AnimatedFlowerNavItem> createState() => _AnimatedFlowerNavItemState();
}

class _AnimatedFlowerNavItemState extends State<_AnimatedFlowerNavItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
      value: widget.isActive ? 1.0 : 0.0,
    );
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutBack);
  }

  @override
  void didUpdateWidget(_AnimatedFlowerNavItem old) {
    super.didUpdateWidget(old);
    if (widget.isActive != old.isActive) {
      widget.isActive ? _ctrl.forward() : _ctrl.reverse();
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: widget.onTap,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _anim,
              builder: (_, _) => CustomPaint(
                size: const Size(44, 44),
                painter: _FlowerNavItemPainter(
                  isActive: widget.isActive,
                  activeColor: AppTheme.navActive,
                  inactiveColor: AppTheme.navInactive,
                  animValue: _anim.value,
                ),
              ),
            ),
            const SizedBox(height: 2),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 250),
              style: TextStyle(
                fontSize: 10,
                fontWeight: widget.isActive ? FontWeight.w700 : FontWeight.w400,
                color: widget.isActive ? AppTheme.navActive : AppTheme.navInactive,
                fontFamily: 'Poppins',
              ),
              child: Text(widget.label),
            ),
          ],
        ),
      ),
    );
  }
}

/// The main floating-styled bottom navigation bar used across all primary screens.
///
/// Shows flower-bud icons for inactive items and blooming-flower icons for the
/// active item. The bar floats above the bottom edge with a soft shadow.
class FloralNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  static const _items = [
    _NavItem(icon: Icons.home_rounded,        label: 'Home'),
    _NavItem(icon: Icons.person_rounded,      label: 'About'),
    _NavItem(icon: Icons.star_rounded,        label: 'Skills'),
    _NavItem(icon: Icons.work_rounded,        label: 'Projects'),
    _NavItem(icon: Icons.mail_rounded,        label: 'Contact'),
  ];

  const FloralNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
        child: Container(
          height: 72,
          decoration: BoxDecoration(
            color: AppTheme.navBackground,
            borderRadius: BorderRadius.circular(36),
            boxShadow: [
              BoxShadow(
                color: AppTheme.sageGreen.withValues(alpha: 0.18),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: List.generate(
              _items.length,
              (i) => _AnimatedFlowerNavItem(
                isActive: currentIndex == i,
                label: _items[i].label,
                onTap: () => onTap(i),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
