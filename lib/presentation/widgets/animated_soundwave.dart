import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class AnimatedSoundwave extends StatefulWidget {
  final bool isPlaying;
  final Color? color;
  final double height;

  const AnimatedSoundwave({
    super.key,
    this.isPlaying = true,
    this.color,
    this.height = 24,
  });

  @override
  State<AnimatedSoundwave> createState() => _AnimatedSoundwaveState();
}

class _AnimatedSoundwaveState extends State<AnimatedSoundwave>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final waveColor = widget.color ?? AppColors.primary;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: List.generate(5, (index) {
            double factor;
            switch (index) {
              case 0:
                factor = 0.4 + (_controller.value * 0.5);
                break;
              case 1:
                factor = 0.7 - (_controller.value * 0.4);
                break;
              case 2:
                factor = 0.3 + (_controller.value * 0.7);
                break;
              case 3:
                factor = 0.8 - (_controller.value * 0.5);
                break;
              case 4:
              default:
                factor = 0.5 + (_controller.value * 0.4);
                break;
            }

            final barHeight = widget.isPlaying
                ? (widget.height * factor).clamp(4.0, widget.height)
                : 4.0;

            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              width: 3.5,
              height: barHeight,
              decoration: BoxDecoration(
                color: waveColor,
                borderRadius: BorderRadius.circular(4),
              ),
            );
          }),
        );
      },
    );
  }
}
