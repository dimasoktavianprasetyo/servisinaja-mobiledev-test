import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../controllers/app_controller.dart';
import '../../../widgets/status_badge.dart';

class GarasiPreviewList extends StatelessWidget {
  final AppController controller;

  const GarasiPreviewList({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = controller.isDarkMode;
    final vehicles = controller.vehicles;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Garasi Saya',
                style: AppTypography.getHeading(
                  isDark: isDark,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
              TextButton(
                onPressed: () => controller.setNavIndex(3),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'Lihat Semua',
                  style: AppTypography.getLabel(
                    isDark: isDark,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    customColor: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 146,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: vehicles.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final vehicle = vehicles[index];
              final isSelected = vehicle.isSelected;

              return InkWell(
                onTap: () => controller.selectVehicle(vehicle.id),
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  width: 250,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.cardDark : AppColors.cardLight,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primary
                          : (isDark ? AppColors.borderDark : AppColors.borderLight),
                      width: isSelected ? 2 : 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          StatusBadge(
                            text: vehicle.conditionStatus,
                            type: vehicle.conditionStatus == 'Kondisi OK'
                                ? BadgeType.success
                                : BadgeType.warning,
                            icon: Icons.check_circle_rounded,
                          ),
                          if (isSelected)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.primaryContainerLight,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'Aktif',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            vehicle.name,
                            style: AppTypography.getHeading(
                              isDark: isDark,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            vehicle.plateNumber,
                            style: AppTypography.getBody(
                              isDark: isDark,
                              fontSize: 12,
                              isSecondary: true,
                            ),
                          ),
                        ],
                      ),
                      Divider(
                        color: isDark ? AppColors.borderDark : AppColors.borderLight,
                        height: 1,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.speed_rounded,
                                size: 13,
                                color: isDark
                                    ? AppColors.textSecondaryDark
                                    : AppColors.textSecondaryLight,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${vehicle.odometerKm} km',
                                style: AppTypography.getLabel(
                                  isDark: isDark,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.build_circle_rounded,
                                size: 13,
                                color: isDark
                                    ? AppColors.textSecondaryDark
                                    : AppColors.textSecondaryLight,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                vehicle.lastService,
                                style: AppTypography.getLabel(
                                  isDark: isDark,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
