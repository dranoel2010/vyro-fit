import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/theme/vyro_colors.dart';

/// Kleine Liniengraph-Komponente für Mini-Ansichten (z.B. im Heart-Card)
/// Mit Gradient-Fill, Glow-Linie und pulsierendem Endpunkt
class MiniLineChart extends StatefulWidget {
  final List<double> values;
  final Color color;
  final double height;

  const MiniLineChart({
    super.key,
    required this.values,
    this.color = VyroColors.accent,
    this.height = 80,
  });

  @override
  State<MiniLineChart> createState() => _MiniLineChartState();
}

class _MiniLineChartState extends State<MiniLineChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseCtrl;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.values.isEmpty) return SizedBox(height: widget.height);

    return AnimatedBuilder(
      animation: _pulseCtrl,
      builder: (_, __) {
        return CustomPaint(
          size: Size(double.infinity, widget.height),
          painter: _LineChartPainter(
            values: widget.values,
            color: widget.color,
            pulseValue: _pulseCtrl.value,
          ),
        );
      },
    );
  }
}

class _LineChartPainter extends CustomPainter {
  final List<double> values;
  final Color color;
  final double pulseValue;

  _LineChartPainter({
    required this.values,
    required this.color,
    required this.pulseValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (values.length < 2) return;

    final nonZero = values.where((v) => v > 0);
    if (nonZero.isEmpty) return;
    final maxVal = nonZero.reduce(max);
    final minVal = nonZero.reduce(min);
    final range = (maxVal - minVal).clamp(1.0, double.infinity);

    Offset getPoint(int i) {
      final x = i / (values.length - 1) * size.width;
      final norm = values[i] > 0 ? (values[i] - minVal) / range : 0.5;
      final y = size.height - norm * size.height * 0.85 - size.height * 0.075;
      return Offset(x, y);
    }

    // Build path
    final path = Path();
    final fillPath = Path();

    path.moveTo(getPoint(0).dx, getPoint(0).dy);
    fillPath.moveTo(0, size.height);
    fillPath.lineTo(getPoint(0).dx, getPoint(0).dy);

    for (int i = 1; i < values.length; i++) {
      final p0 = getPoint(i - 1);
      final p1 = getPoint(i);
      final cp1 = Offset((p0.dx + p1.dx) / 2, p0.dy);
      final cp2 = Offset((p0.dx + p1.dx) / 2, p1.dy);
      path.cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, p1.dx, p1.dy);
      fillPath.cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, p1.dx, p1.dy);
    }

    fillPath.lineTo(size.width, size.height);
    fillPath.close();

    // Gradient fill
    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [color.withOpacity(0.15), color.withOpacity(0)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawPath(fillPath, fillPaint);

    // Glow line
    final glowPaint = Paint()
      ..color = color.withOpacity(0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    canvas.drawPath(path, glowPaint);

    // Main line
    final linePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(path, linePaint);

    // Pulsing end dot
    final lastPoint = getPoint(values.length - 1);
    final dotOpacity = 0.4 + 0.4 * pulseValue;

    // Glow halo
    final haloPaint = Paint()
      ..color = color.withOpacity(dotOpacity * 0.4)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawCircle(lastPoint, 6, haloPaint);

    // Solid dot
    canvas.drawCircle(lastPoint, 4, Paint()..color = color);
  }

  @override
  bool shouldRepaint(_LineChartPainter old) =>
      old.pulseValue != pulseValue || old.values != values;
}
