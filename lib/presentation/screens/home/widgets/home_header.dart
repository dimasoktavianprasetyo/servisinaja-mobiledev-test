import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../controllers/app_controller.dart';

class HomeHeader extends StatelessWidget {
  final AppController controller;

  const HomeHeader({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = controller.isDarkMode;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.primaryContainerLight,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.location_on_rounded,
                      size: 16,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Lokasi Servis Terdekat',
                        style: AppTypography.getLabel(
                          isDark: isDark,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        'AHASS Sudirman, Jakpus',
                        style: AppTypography.getLabel(
                          isDark: isDark,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          customColor: isDark
                              ? AppColors.textPrimaryDark
                              : AppColors.textPrimaryLight,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.stars_rounded,
                          size: 14,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '1.250 Poin',
                          style: AppTypography.getLabel(
                            isDark: isDark,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            customColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filledTonal(
                    onPressed: controller.toggleTheme,
                    style: IconButton.styleFrom(
                      backgroundColor: isDark
                          ? AppColors.bgDark
                          : const Color(0xFFF1F5F9),
                    ),
                    icon: Icon(
                      isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                      size: 18,
                      color: isDark ? const Color(0xFFFBBF24) : AppColors.textSecondaryLight,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            'Halo, Tania Anastasia 👋',
            style: AppTypography.getHeading(
              isDark: isDark,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Waktunya rawat motor kamu agar tetap prima',
            style: AppTypography.getBody(
              isDark: isDark,
              fontSize: 13,
              isSecondary: true,
            ),
          ),
        ],
      ),
    );
  }
}
