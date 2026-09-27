import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';

enum BadgeType { success, warning, error, info, primary, neutral }

class StatusBadge extends StatelessWidget {
  final String text;
  final BadgeType type;
  final IconData? icon;

  const StatusBadge({
    super.key,
    required this.text,
    this.type = BadgeType.primary,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Color bg;
    Color fg;

    switch (type) {
      case BadgeType.success:
        bg = isDark
            ? AppColors.success.withValues(alpha: 0.2)
            : AppColors.successContainer;
        fg = isDark ? const Color(0xFF34D399) : const Color(0xFF065F46);
        break;
      case BadgeType.warning:
        bg = isDark
            ? AppColors.warning.withValues(alpha: 0.2)
            : AppColors.warningContainer;
        fg = isDark ? const Color(0xFFFBBF24) : const Color(0xFF92400E);
        break;
      case BadgeType.error:
        bg = isDark
            ? AppColors.emergency.withValues(alpha: 0.2)
            : AppColors.emergencyContainer;
        fg = isDark ? const Color(0xFFF87171) : const Color(0xFF991B1B);
        break;
      case BadgeType.info:
        bg = isDark
            ? AppColors.info.withValues(alpha: 0.2)
            : AppColors.infoContainer;
        fg = isDark ? const Color(0xFF38BDF8) : const Color(0xFF0369A1);
        break;
      case BadgeType.primary:
        bg = isDark ? AppColors.primaryContainerDark : AppColors.primary;
        fg = isDark ? AppColors.primaryLight : Colors.white;
        break;
      case BadgeType.neutral:
        bg = isDark ? AppColors.surfaceDark : const Color(0xFFF1F5F9);
        fg = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: fg),
            const SizedBox(width: 4),
          ],
          Text(
            text,
            style: AppTypography.getLabel(
              isDark: isDark,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              customColor: fg,
            ),
          ),
        ],
      ),
    );
  }
}
