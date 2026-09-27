import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';

enum ButtonVariant { primary, secondary, outline, danger, ghost }

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final ButtonVariant variant;
  final double? width;
  final double height;
  final bool isLoading;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.variant = ButtonVariant.primary,
    this.width,
    this.height = 48,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Color bg;
    Color fg;
    BorderSide? border;

    switch (variant) {
      case ButtonVariant.primary:
        bg = AppColors.primary;
        fg = Colors.white;
        break;
      case ButtonVariant.secondary:
        bg = isDark ? AppColors.surfaceDark : AppColors.primaryContainerLight;
        fg = AppColors.primary;
        break;
      case ButtonVariant.outline:
        bg = Colors.transparent;
        fg = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
        border = BorderSide(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
          width: 1.5,
        );
        break;
      case ButtonVariant.danger:
        bg = AppColors.emergency;
        fg = Colors.white;
        break;
      case ButtonVariant.ghost:
        bg = Colors.transparent;
        fg = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
        break;
    }

    final buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: bg,
      foregroundColor: fg,
      elevation: variant == ButtonVariant.primary ? 2 : 0,
      shadowColor: AppColors.primary.withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: border ?? BorderSide.none,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
    );

    Widget childContent = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading) ...[
          SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(fg),
            ),
          ),
          const SizedBox(width: 8),
        ] else if (icon != null) ...[
          Icon(icon, size: 18, color: fg),
          const SizedBox(width: 8),
        ],
        Text(
          text,
          style: AppTypography.getLabel(
            isDark: isDark,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            customColor: fg,
          ),
        ),
      ],
    );

    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        style: buttonStyle,
        onPressed: isLoading ? null : onPressed,
        child: childContent,
      ),
    );
  }
}
