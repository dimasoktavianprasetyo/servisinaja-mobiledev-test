import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../controllers/app_controller.dart';

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

    final List<Map<String, String>> figmaCards = [
      {'id': 'v1', 'image': 'assets/images/motor_vario.png'},
      {'id': 'v2', 'image': 'assets/images/motor_beat.png'},
    ];

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
          height: 154,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: figmaCards.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final card = figmaCards[index];
              final vehicle = vehicles.firstWhere(
                (v) => v.id == card['id'],
                orElse: () => vehicles.first,
              );
              final isSelected = vehicle.isSelected;

              return InkWell(
                onTap: () => controller.selectVehicle(vehicle.id),
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  width: 173,
                  height: 152,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected ? AppColors.primary : Colors.transparent,
                      width: 2.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isSelected
                            ? AppColors.primary.withValues(alpha: 0.3)
                            : Colors.black.withValues(alpha: isDark ? 0.25 : 0.06),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.asset(
                      card['image']!,
                      fit: BoxFit.fill,
                    ),
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
