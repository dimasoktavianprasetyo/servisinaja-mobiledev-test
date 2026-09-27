import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../data/models/vehicle_model.dart';
import '../../../data/models/service_model.dart';
import '../../controllers/app_controller.dart';
import '../../widgets/servisin_app_bar.dart';
import '../../widgets/app_button.dart';
import 'booking_confirm_screen.dart';

class SchedulePickerScreen extends StatefulWidget {
  final AppController controller;
  final VehicleModel vehicle;
  final ServiceModel service;
  final bool isHomeService;

  const SchedulePickerScreen({
    super.key,
    required this.controller,
    required this.vehicle,
    required this.service,
    this.isHomeService = false,
  });

  @override
  State<SchedulePickerScreen> createState() => _SchedulePickerScreenState();
}

class _SchedulePickerScreenState extends State<SchedulePickerScreen> {
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  String _selectedTime = '10:00 WIB';
  String _selectedWorkshop = 'AHASS Daya Motor Sudirman';

  final List<String> _timeSlots = [
    '08:30 WIB',
    '10:00 WIB',
    '11:30 WIB',
    '13:30 WIB',
    '15:00 WIB',
    '16:30 WIB',
  ];

  final List<String> _workshops = [
    'AHASS Daya Motor Sudirman',
    'AHASS Mitra Sejahtera Thamrin',
    'AHASS Bintang Motor Kuningan',
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = widget.controller.isDarkMode;

    return Scaffold(
      appBar: const ServisinAppBar(title: 'Pilih Jadwal & Bengkel'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '1. Pilih Tanggal Servis',
              style: AppTypography.getHeading(
                isDark: isDark,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 75,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: 7,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  final date = DateTime.now().add(Duration(days: index));
                  final isSelected = date.day == _selectedDate.day &&
                      date.month == _selectedDate.month;

                  return InkWell(
                    onTap: () {
                      setState(() => _selectedDate = date);
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      width: 65,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary
                            : (isDark ? AppColors.cardDark : AppColors.cardLight),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : (isDark ? AppColors.borderDark : AppColors.borderLight),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            ['Min', 'Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab'][date.weekday % 7],
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            date.day.toString(),
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            Text(
              '2. Pilih Waktu Kedatangan',
              style: AppTypography.getHeading(
                isDark: isDark,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _timeSlots.map((time) {
                final isSelected = time == _selectedTime;

                return InkWell(
                  onTap: () {
                    setState(() => _selectedTime = time);
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primaryContainerLight
                          : (isDark ? AppColors.cardDark : AppColors.cardLight),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : (isDark ? AppColors.borderDark : AppColors.borderLight),
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Text(
                      time,
                      style: TextStyle(
                        color: isSelected
                            ? AppColors.primary
                            : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            Text(
              widget.isHomeService ? 'Lokasi Penjemputan / Alamat Rumah' : '3. Pilih Bengkel AHASS Mitra',
              style: AppTypography.getHeading(
                isDark: isDark,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),
            ..._workshops.map((ws) {
              final isSelected = ws == _selectedWorkshop;

              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: InkWell(
                  onTap: () {
                    setState(() => _selectedWorkshop = ws);
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
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
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.verified_rounded,
                          color: AppColors.primary,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            ws,
                            style: AppTypography.getHeading(
                              isDark: isDark,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected ? AppColors.primary : (isDark ? AppColors.borderDark : const Color(0xFFCBD5E1)),
                              width: 2,
                            ),
                          ),
                          child: isSelected
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
            text: 'Lanjut Konfirmasi Booking',
            icon: Icons.check_circle_outline_rounded,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BookingConfirmScreen(
                    controller: widget.controller,
                    vehicle: widget.vehicle,
                    service: widget.service,
                    scheduleDate: _selectedDate,
                    scheduleTime: _selectedTime,
                    workshopName: _selectedWorkshop,
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
