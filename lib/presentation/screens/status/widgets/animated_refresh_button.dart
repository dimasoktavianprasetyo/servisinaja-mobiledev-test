import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class AnimatedRefreshButton extends StatefulWidget {
  final Future<void> Function() onRefresh;
  final bool isDark;

  const AnimatedRefreshButton({
    super.key,
    required this.onRefresh,
    required this.isDark,
  });

  @override
  State<AnimatedRefreshButton> createState() => _AnimatedRefreshButtonState();
}

class _AnimatedRefreshButtonState extends State<AnimatedRefreshButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _rotationController;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  Future<void> _triggerRefresh() async {
    if (_isRefreshing) return;

    setState(() {
      _isRefreshing = true;
    });

    _rotationController.repeat();

    try {
      await widget.onRefresh();
    } finally {
      if (mounted) {
        _rotationController.stop();
        await _rotationController.animateTo(
          1.0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
        );
        _rotationController.reset();

        setState(() {
          _isRefreshing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _isRefreshing ? null : _triggerRefresh,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: isDark ? AppColors.surfaceDark : Colors.white,
            shape: BoxShape.circle,
            border: Border.all(
              color: _isRefreshing
                  ? AppColors.primary
                  : (isDark ? AppColors.borderDark : const Color(0xFFE2E8F0)),
              width: _isRefreshing ? 1.5 : 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: _isRefreshing
                    ? AppColors.primary.withValues(alpha: 0.35)
                    : Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
                blurRadius: _isRefreshing ? 10 : 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: RotationTransition(
            turns: _rotationController,
            child: Icon(
              Icons.sync_rounded,
              size: 20,
              color: _isRefreshing
                  ? AppColors.primary
                  : (isDark ? Colors.white : const Color(0xFF0F172A)),
            ),
          ),
        ),
      ),
    );
  }
}
