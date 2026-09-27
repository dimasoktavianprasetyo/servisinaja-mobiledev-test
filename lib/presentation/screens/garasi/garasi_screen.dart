import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../controllers/app_controller.dart';
import '../../widgets/servisin_app_bar.dart';
import '../../widgets/app_button.dart';
import '../../widgets/status_badge.dart';

class GarasiScreen extends StatelessWidget {
  final AppController controller;

  const GarasiScreen({
    super.key,
    required this.controller,
  });

  void _showAddVehicleModal(BuildContext context) {
    final nameController = TextEditingController();
    final plateController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: controller.isDarkMode ? AppColors.surfaceDark : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(ctx).viewInsets.bottom + 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tambah Kendaraan Baru',
                style: AppTypography.getHeading(
                  isDark: controller.isDarkMode,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Model Motor (Contoh: Honda Scoopy Prestige)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: plateController,
                decoration: InputDecoration(
                  labelText: 'Nomor Plat (Contoh: B 9876 KKL)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 20),
              AppButton(
                text: 'Simpan ke Garasi',
                icon: Icons.save_rounded,
                width: double.infinity,
                onPressed: () {
                  if (nameController.text.isNotEmpty && plateController.text.isNotEmpty) {
                    controller.addVehicle(nameController.text, plateController.text);
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Motor baru berhasil ditambahkan ke garasi!'),
                        backgroundColor: AppColors.primary,
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = controller.isDarkMode;

    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final vehicles = controller.vehicles;

        return Scaffold(
          appBar: ServisinAppBar(
            title: 'Garasi ServisinAja',
            showBack: false,
            actions: [
              IconButton(
                onPressed: () => _showAddVehicleModal(context),
                icon: const Icon(Icons.add_circle_outline_rounded, color: AppColors.primary),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.primaryContainerDark : AppColors.primaryContainerLight,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.two_wheeler_rounded, color: Colors.white, size: 24),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${vehicles.length} Motor Terdaftar',
                              style: AppTypography.getHeading(isDark: isDark, fontSize: 15),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Kelola jadwal servis & kupon perawatan berkala (KPB)',
                              style: AppTypography.getBody(isDark: isDark, fontSize: 11, isSecondary: true),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Daftar Kendaraan',
                  style: AppTypography.getHeading(
                    isDark: isDark,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 12),
                ...vehicles.map((v) {
                  final isSelected = v.isSelected;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: InkWell(
                      onTap: () => controller.selectVehicle(v.id),
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.all(16),
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
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      v.name,
                                      style: AppTypography.getHeading(isDark: isDark, fontSize: 16),
                                    ),
                                    const SizedBox(width: 8),
                                    if (isSelected)
                                      const StatusBadge(
                                        text: 'AKTIF',
                                        type: BadgeType.primary,
                                      ),
                                  ],
                                ),
                                StatusBadge(
                                  text: v.conditionStatus,
                                  type: v.conditionStatus == 'Kondisi OK'
                                      ? BadgeType.success
                                      : BadgeType.warning,
                                  icon: Icons.check_circle_rounded,
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              v.plateNumber,
                              style: AppTypography.getBody(isDark: isDark, fontSize: 13, isSecondary: true),
                            ),
                            const Divider(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Jarak Tempuh', style: AppTypography.getLabel(isDark: isDark, fontSize: 11)),
                                    const SizedBox(height: 2),
                                    Text('${v.odometerKm} km', style: AppTypography.getLabel(isDark: isDark, fontSize: 13, fontWeight: FontWeight.w700)),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text('Servis Terakhir', style: AppTypography.getLabel(isDark: isDark, fontSize: 11)),
                                    const SizedBox(height: 2),
                                    Text(v.lastService, style: AppTypography.getLabel(isDark: isDark, fontSize: 13, fontWeight: FontWeight.w700)),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 12),
                AppButton(
                  text: 'Tambah Slot Motor Baru',
                  icon: Icons.add_rounded,
                  variant: ButtonVariant.outline,
                  width: double.infinity,
                  onPressed: () => _showAddVehicleModal(context),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
