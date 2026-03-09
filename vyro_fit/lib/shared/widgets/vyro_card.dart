import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/vyro_colors.dart';
import '../../core/theme/vyro_text_styles.dart';

/// Einheitliche animierte Karte im VYRO Fit Dark-Tech-Design.
/// Animation: scale 0.96→1, opacity 0→1 mit optionalem Stagger-Delay.
class VyroCard extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Duration animationDelay;
  final VoidCallback? onTap;

  const VyroCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.animationDelay = Duration.zero,
    this.onTap,
  });

  @override
  State<VyroCard> createState() => _VyroCardState();
}

class _VyroCardState extends State<VyroCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _opacity;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _opacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOut),
    );
    _scale = Tween<double>(begin: 0.96, end: 1).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOut),
    );

    Future.delayed(widget.animationDelay, () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final card = AnimatedBuilder(
      animation: _ctrl,
      child: Container(
        margin: widget.margin ??
            const EdgeInsets.only(bottom: AppConstants.cardGap),
        padding: widget.padding ??
            const EdgeInsets.all(AppConstants.cardPadding),
        decoration: BoxDecoration(
          color: VyroColors.card,
          borderRadius: BorderRadius.circular(AppConstants.cardRadius),
          boxShadow: const [
            BoxShadow(
              color: Color(0x59000000),
              blurRadius: 30,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: widget.child,
      ),
      builder: (_, child) => Opacity(
        opacity: _opacity.value,
        child: Transform.scale(scale: _scale.value, child: child),
      ),
    );

    if (widget.onTap != null) {
      return GestureDetector(onTap: widget.onTap, child: card);
    }
    return card;
  }
}

/// Card-Label: UPPERCASE, 12px, Light, letter-spacing 1.2
class VyroCardLabel extends StatelessWidget {
  final String text;
  const VyroCardLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Text(text.toUpperCase(), style: VyroTextStyles.label),
    );
  }
}

/// Großer Zahlenwert mit optionaler Einheit und Subtitel
class VyroBigStat extends StatelessWidget {
  final String value;
  final String? unit;
  final String? subtitle;
  final double fontSize;

  const VyroBigStat({
    super.key,
    required this.value,
    this.unit,
    this.subtitle,
    this.fontSize = 42,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              value,
              style: VyroTextStyles.dataValue.copyWith(fontSize: fontSize),
            ),
            if (unit != null) ...[
              const SizedBox(width: 4),
              Text(
                unit!,
                style: VyroTextStyles.body.copyWith(
                  color: VyroColors.textSecondary,
                ),
              ),
            ],
          ],
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 4),
          Text(subtitle!, style: VyroTextStyles.sub),
        ],
      ],
    );
  }
}
