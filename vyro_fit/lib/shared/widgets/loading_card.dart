import 'package:flutter/material.dart';
import '../../core/theme/vyro_colors.dart';
import '../../core/constants/app_constants.dart';

/// Shimmer/Skeleton Platzhalter-Karte
class LoadingCard extends StatefulWidget {
  final double height;

  const LoadingCard({super.key, this.height = 120});

  @override
  State<LoadingCard> createState() => _LoadingCardState();
}

class _LoadingCardState extends State<LoadingCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _anim = Tween<double>(begin: 0.3, end: 0.7).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (context, _) {
        return Container(
          height: widget.height,
          decoration: BoxDecoration(
            color: VyroColors.card,
            borderRadius: BorderRadius.circular(AppConstants.cardRadius),
          ),
          child: Stack(
            children: [
              // Shimmer overlay
              ClipRRect(
                borderRadius: BorderRadius.circular(AppConstants.cardRadius),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Colors.transparent,
                        VyroColors.accent.withOpacity(_anim.value * 0.08),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.5, 1.0],
                    ),
                  ),
                ),
              ),
              // Skeleton lines
              Padding(
                padding: const EdgeInsets.all(AppConstants.cardPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SkeletonLine(width: 80, height: 10, opacity: _anim.value),
                    const SizedBox(height: 12),
                    _SkeletonLine(width: 120, height: 28, opacity: _anim.value),
                    const SizedBox(height: 8),
                    _SkeletonLine(width: double.infinity, height: 8, opacity: _anim.value * 0.6),
                    const SizedBox(height: 6),
                    _SkeletonLine(width: 160, height: 8, opacity: _anim.value * 0.4),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SkeletonLine extends StatelessWidget {
  final double width;
  final double height;
  final double opacity;

  const _SkeletonLine({
    required this.width,
    required this.height,
    required this.opacity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width == double.infinity ? null : width,
      height: height,
      decoration: BoxDecoration(
        color: VyroColors.accentDim.withOpacity(opacity),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
