import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/vehicle_model.dart';
import '../../../data/models/service_model.dart';
import '../../controllers/app_controller.dart';
import '../../widgets/servisin_app_bar.dart';
import '../../widgets/app_button.dart';
import '../../widgets/status_badge.dart';
import 'schedule_picker_screen.dart';

class BookingStep1Screen extends StatefulWidget {
  final AppController controller;
  final bool isHomeService;

  const BookingStep1Screen({
    super.key,
    required this.controller,
    this.isHomeService = false,
  });

  @override
  State<BookingStep1Screen> createState() => _BookingStep1ScreenState();
}

class _BookingStep1ScreenState extends State<BookingStep1Screen> {
  late VehicleModel _selectedVehicle;
  late ServiceModel _selectedService;

  @override
  void initState() {
    super.initState();
    _selectedVehicle = widget.controller.selectedVehicle;
    _selectedService = widget.controller.services.first;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.controller.isDarkMode;

    return Scaffold(
      appBar: ServisinAppBar(
        title: widget.isHomeService ? 'Booking Home Service' : 'Pilih Layanan Servis',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '1. Pilih Motor Kamu',
              style: AppTypography.getHeading(
                isDark: isDark,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),
            ...widget.controller.vehicles.map((v) {
              final isCurrent = v.id == _selectedVehicle.id;

              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: InkWell(
                  onTap: () {
                    setState(() => _selectedVehicle = v);
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.cardDark : AppColors.cardLight,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isCurrent
                            ? AppColors.primary
                            : (isDark ? AppColors.borderDark : AppColors.borderLight),
                        width: isCurrent ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isCurrent
                                ? AppColors.primaryContainerLight
                                : (isDark ? AppColors.bgDark : const Color(0xFFF1F5F9)),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.two_wheeler_rounded,
                            color: isCurrent
                                ? AppColors.primary
                                : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                v.name,
                                style: AppTypography.getHeading(
                                  isDark: isDark,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${v.plateNumber} • ${v.odometerKm} km',
                                style: AppTypography.getBody(
                                  isDark: isDark,
                                  fontSize: 12,
                                  isSecondary: true,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isCurrent ? AppColors.primary : (isDark ? AppColors.borderDark : const Color(0xFFCBD5E1)),
                              width: 2,
                            ),
                          ),
                          child: isCurrent
                              ? Center(
                                  child: Container(
                                    width: 12,
                                    height: 12,
                                    decoration: const BoxDecoration(
                                      color: AppColors.primary,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                )
                              : null,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
            const SizedBox(height: 24),
            Text(
              '2. Pilih Paket Servis AHASS',
              style: AppTypography.getHeading(
                isDark: isDark,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),
            ...widget.controller.services.map((svc) {
              final isCurrent = svc.id == _selectedService.id;

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: InkWell(
                  onTap: () {
                    setState(() => _selectedService = svc);
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.cardDark : AppColors.cardLight,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isCurrent
                            ? AppColors.primary
                            : (isDark ? AppColors.borderDark : AppColors.borderLight),
                        width: isCurrent ? 2 : 1,
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
                            Expanded(
                              child: Text(
                                svc.title,
                                style: AppTypography.getHeading(
                                  isDark: isDark,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            if (svc.isPopular)
                              const StatusBadge(
                                text: 'POPULER',
                                type: BadgeType.primary,
                              ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          svc.description,
                          style: AppTypography.getBody(
                            isDark: isDark,
                            fontSize: 12,
                            isSecondary: true,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.schedule_rounded,
                                  size: 14,
                                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  svc.duration,
                                  style: AppTypography.getLabel(
                                    isDark: isDark,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              Formatters.currency(svc.price),
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : Colors.white,
          border: Border(
            top: BorderSide(
              color: isDark ? AppColors.borderDark : AppColors.borderLight,
            ),
          ),
        ),
        child: SafeArea(
          child: AppButton(
            text: 'Lanjut Pilih Jadwal Servis',
            icon: Icons.calendar_today_rounded,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SchedulePickerScreen(
                    controller: widget.controller,
                    vehicle: _selectedVehicle,
                    service: _selectedService,
                    isHomeService: widget.isHomeService,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
