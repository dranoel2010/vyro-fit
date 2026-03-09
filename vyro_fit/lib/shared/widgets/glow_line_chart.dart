import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/theme/vyro_colors.dart';

/// Großer interaktiver Liniengraph mit Glow-Effekt, X-Labels und Touch-Tooltip
class GlowLineChart extends StatefulWidget {
  final List<double> values;
  final List<String> labels;  // X-Achsen-Labels (leer = kein Label)
  final Color color;
  final double height;
  final String? unit;

  const GlowLineChart({
    super.key,
    required this.values,
    this.labels = const [],
    this.color = VyroColors.accent,
    this.height = 120,
    this.unit,
  });

  @override
  State<GlowLineChart> createState() => _GlowLineChartState();
}

class _GlowLineChartState extends State<GlowLineChart>
    with SingleTickerProviderStateMixin {
  int? _selectedIndex;
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

  void _handleTouch(Offset localPos, Size size) {
    if (widget.values.isEmpty) return;
    final x = localPos.dx.clamp(0, size.width);
    final index = ((x / size.width) * (widget.values.length - 1)).round()
        .clamp(0, widget.values.length - 1);
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final hasLabels = widget.labels.isNotEmpty;
    final chartHeight = hasLabels ? widget.height : widget.height;
    final totalHeight = hasLabels ? chartHeight + 22.0 : chartHeight;

    return SizedBox(
      height: totalHeight,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return GestureDetector(
            onTapDown: (d) =>
                _handleTouch(d.localPosition, constraints.biggest),
            onPanUpdate: (d) =>
                _handleTouch(d.localPosition, constraints.biggest),
            onPanEnd: (_) => setState(() => _selectedIndex = null),
            onTapUp: (_) =>
                Future.delayed(const Duration(seconds: 2), () {
                  if (mounted) setState(() => _selectedIndex = null);
                }),
            child: AnimatedBuilder(
              animation: _pulseCtrl,
              builder: (_, __) => CustomPaint(
                size: Size(constraints.maxWidth, totalHeight),
                painter: _GlowChartPainter(
                  values: widget.values,
                  labels: widget.labels,
                  color: widget.color,
                  selectedIndex: _selectedIndex,
                  pulseValue: _pulseCtrl.value,
                  unit: widget.unit ?? '',
                  hasLabels: hasLabels,
                  chartHeight: chartHeight,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _GlowChartPainter extends CustomPainter {
  final List<double> values;
  final List<String> labels;
  final Color color;
  final int? selectedIndex;
  final double pulseValue;
  final String unit;
  final bool hasLabels;
  final double chartHeight;

  _GlowChartPainter({
    required this.values,
    required this.labels,
    required this.color,
    required this.selectedIndex,
    required this.pulseValue,
    required this.unit,
    required this.hasLabels,
    required this.chartHeight,
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
      final y = chartHeight - norm * chartHeight * 0.80 - chartHeight * 0.10;
      return Offset(x, y);
    }

    // Build bezier path
    final path = Path();
    final fillPath = Path();
    path.moveTo(getPoint(0).dx, getPoint(0).dy);
    fillPath.moveTo(0, chartHeight);
    fillPath.lineTo(getPoint(0).dx, getPoint(0).dy);

    for (int i = 1; i < values.length; i++) {
      final p0 = getPoint(i - 1);
      final p1 = getPoint(i);
      final cp1 = Offset((p0.dx + p1.dx) / 2, p0.dy);
      final cp2 = Offset((p0.dx + p1.dx) / 2, p1.dy);
      path.cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, p1.dx, p1.dy);
      fillPath.cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, p1.dx, p1.dy);
    }
    fillPath.lineTo(size.width, chartHeight);
    fillPath.close();

    // Gradient fill
    canvas.drawPath(
      fillPath,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [color.withOpacity(0.12), color.withOpacity(0)],
        ).createShader(Rect.fromLTWH(0, 0, size.width, chartHeight)),
    );

    // Glow line
    canvas.drawPath(
      path,
      Paint()
        ..color = color.withOpacity(0.35)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
    );

    // Main line
    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );

    // Pulsing end dot (only when no selection)
    if (selectedIndex == null) {
      final lastPt = getPoint(values.length - 1);
      canvas.drawCircle(
        lastPt,
        6,
        Paint()
          ..color = color.withOpacity(0.3 + 0.3 * pulseValue)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5),
      );
      canvas.drawCircle(lastPt, 4, Paint()..color = color);
    }

    // Touch indicator
    if (selectedIndex != null) {
      final selPt = getPoint(selectedIndex!);

      // Vertical line
      canvas.drawLine(
        Offset(selPt.dx, 0),
        Offset(selPt.dx, chartHeight),
        Paint()
          ..color = color.withOpacity(0.3)
          ..strokeWidth = 1,
      );

      // Dot on line
      canvas.drawCircle(selPt, 5,
          Paint()..color = color.withOpacity(0.3)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4));
      canvas.drawCircle(selPt, 4, Paint()..color = color);

      // Value tooltip
      final val = values[selectedIndex!];
      if (val > 0) {
        final text = '${val.round()}$unit';
        final tp = TextPainter(
          text: TextSpan(
            text: text,
            style: const TextStyle(
              fontFamily: 'Outfit',
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: VyroColors.textPrimary,
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout();

        final tooltipX =
            (selPt.dx + 8 + tp.width + 12 > size.width)
                ? selPt.dx - tp.width - 20
                : selPt.dx + 8;
        final tooltipY = (selPt.dy - 16).clamp(0.0, chartHeight - 24.0);

        final bgRect = RRect.fromRectAndRadius(
          Rect.fromLTWH(tooltipX - 6, tooltipY, tp.width + 12, 22),
          const Radius.circular(6),
        );
        canvas.drawRRect(bgRect, Paint()..color = VyroColors.card);
        tp.paint(canvas, Offset(tooltipX, tooltipY + 3));
      }
    }

    // X-Labels
    if (hasLabels && labels.isNotEmpty) {
      final step = values.length > 1 ? size.width / (labels.length - 1) : 0.0;
      for (int i = 0; i < labels.length; i++) {
        if (labels[i].isEmpty) continue;
        final tp = TextPainter(
          text: TextSpan(
            text: labels[i],
            style: const TextStyle(
              fontFamily: 'Outfit',
              fontSize: 10,
              fontWeight: FontWeight.w300,
              color: VyroColors.textSecondary,
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        tp.paint(canvas, Offset(i * step - tp.width / 2, chartHeight + 6));
      }
    }
  }

  @override
  bool shouldRepaint(_GlowChartPainter old) =>
      old.selectedIndex != selectedIndex || old.pulseValue != pulseValue;
}
