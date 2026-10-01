import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class AnimatedSoundwave extends StatefulWidget {
  final bool isPlaying;
  final Color? color;
  final double height;
  final int barCount;
  final double barWidth;
  final double spacing;

  const AnimatedSoundwave({
    super.key,
    this.isPlaying = true,
    this.color,
    this.height = 15,
    this.barCount = 4,
    this.barWidth = 3.2,
    this.spacing = 2.0,
  });

  @override
  State<AnimatedSoundwave> createState() => _AnimatedSoundwaveState();
}

class _AnimatedSoundwaveState extends State<AnimatedSoundwave>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;

  void _ensureController() {
    _controller ??= AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
  }

  @override
  void initState() {
    super.initState();
    _ensureController();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _ensureController();
    final controller = _controller!;
    final waveColor = widget.color ?? AppColors.primary;
    final totalWidth = (widget.barCount * widget.barWidth) +
        ((widget.barCount - 1) * widget.spacing);

    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          return CustomPaint(
            size: Size(totalWidth, widget.height),
            painter: _SoundwavePainter(
              animationValue: controller.value,
              isPlaying: widget.isPlaying,
              color: waveColor,
              barCount: widget.barCount,
              barWidth: widget.barWidth,
              spacing: widget.spacing,
              maxHeight: widget.height,
            ),
          );
        },
      ),
    );
  }
}

class _SoundwavePainter extends CustomPainter {
  final double animationValue;
  final bool isPlaying;
  final Color color;
  final int barCount;
  final double barWidth;
  final double spacing;
  final double maxHeight;

  _SoundwavePainter({
    required this.animationValue,
    required this.isPlaying,
    required this.color,
    required this.barCount,
    required this.barWidth,
    required this.spacing,
    required this.maxHeight,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final glowPaint = Paint()
      ..color = color.withValues(alpha: 0.35)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.5);

    final totalWidth = (barCount * barWidth) + ((barCount - 1) * spacing);
    double startX = (size.width - totalWidth) / 2;
    if (startX < 0) startX = 0;

    final centerY = size.height / 2;
    // Exactly 2*pi per cycle
    final t = animationValue * 2 * math.pi;

    for (int i = 0; i < barCount; i++) {
      double h = 3.5;

      if (isPlaying) {
        final norm = barCount > 1 ? i / (barCount - 1) : 0.5;
        // Integer harmonic multiples: 1, 2, 3 guarantees 100% seamless C2 continuity without any hitch or pause
        final phase = i * (math.pi / 2.0);
        final s1 = math.sin(t * 1 + phase);
        final s2 = math.sin(t * 2 + phase * 1.5);
        final s3 = math.cos(t * 3 - phase * 0.7);

        // Natural speech bell curve: center bars are more pronounced
        final bell = 0.68 + (0.32 * math.sin(norm * math.pi));

        final raw = (s1 * 0.44 + s2 * 0.34 + s3 * 0.22);
        final normalized = ((raw + 1.0) / 2.0).clamp(0.0, 1.0);

        final factor = 0.20 + (0.80 * normalized * bell);
        h = (maxHeight * factor).clamp(3.5, maxHeight);
      }

      final x = startX + i * (barWidth + spacing);
      final y = centerY - (h / 2);

      final rrect = RRect.fromRectAndRadius(
        Rect.fromLTWH(x, y, barWidth, h),
        Radius.circular(barWidth / 2),
      );

      if (isPlaying) {
        canvas.drawRRect(rrect, glowPaint);
      }
      canvas.drawRRect(rrect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _SoundwavePainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.isPlaying != isPlaying ||
        oldDelegate.color != color;
  }
}
