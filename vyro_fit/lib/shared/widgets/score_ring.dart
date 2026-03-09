import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/theme/vyro_colors.dart';
import '../../core/theme/vyro_text_styles.dart';

/// Kreisförmiger Score-Ring mit CustomPainter, Glow und Zahl in der Mitte
class ScoreRing extends StatefulWidget {
  final int score; // 0–100
  final double size;
  final String? label;
  final double strokeWidth;

  const ScoreRing({
    super.key,
    required this.score,
    this.size = 120,
    this.label,
    this.strokeWidth = 8,
  });

  @override
  State<ScoreRing> createState() => _ScoreRingState();
}

class _ScoreRingState extends State<ScoreRing>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progressAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _progressAnim = Tween<double>(
      begin: 0,
      end: widget.score / 100.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBuilder(
          animation: _progressAnim,
          builder: (context, _) {
            return CustomPaint(
              size: Size(widget.size, widget.size),
              painter: _RingPainter(
                progress: _progressAnim.value,
                strokeWidth: widget.strokeWidth,
              ),
              child: SizedBox(
                width: widget.size,
                height: widget.size,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${(widget.score * _progressAnim.value).round()}',
                        style: VyroTextStyles.dataValueSm.copyWith(fontSize: 32),
                      ),
                      Text(
                        'Score',
                        style: VyroTextStyles.caption,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        if (widget.label != null) ...[
          const SizedBox(height: 8),
          Text(widget.label!, style: VyroTextStyles.caption),
        ],
      ],
    );
  }
}

class _RingPainter extends CustomPainter {
  final double progress;
  final double strokeWidth;

  _RingPainter({required this.progress, required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;
    const startAngle = -math.pi / 2;
    final sweepAngle = 2 * math.pi * progress;

    // Track
    final trackPaint = Paint()
      ..color = VyroColors.accentDim
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, trackPaint);

    if (progress <= 0) return;

    // Glow
    final glowPaint = Paint()
      ..color = VyroColors.accent.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth + 6
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      glowPaint,
    );

    // Fill
    final fillPaint = Paint()
      ..color = VyroColors.accent
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      fillPaint,
    );
  }

  @override
  bool shouldRepaint(_RingPainter old) => old.progress != progress;
}
