import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/utils/formatters.dart';
import '../../controllers/app_controller.dart';
import '../../widgets/servisin_app_bar.dart';
import '../../widgets/app_button.dart';
import '../../widgets/status_badge.dart';
import '../chat/chat_montir_screen.dart';

class BookingSuccessTicketScreen extends StatelessWidget {
  final AppController controller;

  const BookingSuccessTicketScreen({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = controller.isDarkMode;
    final booking = controller.currentBooking!;

    return Scaffold(
      appBar: const ServisinAppBar(title: 'E-Tiket Servis', showBack: false),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(
                color: AppColors.successContainer,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_rounded,
                size: 38,
                color: AppColors.success,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Booking Berhasil Terkonfirmasi!',
              textAlign: TextAlign.center,
              style: AppTypography.getHeading(isDark: isDark, fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 4),
            Text(
              'Tunjukkan E-Tiket ini saat tiba di bengkel AHASS',
              textAlign: TextAlign.center,
              style: AppTypography.getBody(isDark: isDark, fontSize: 12, isSecondary: true),
            ),
            const SizedBox(height: 24),
            Container(
              decoration: BoxDecoration(
                color: isDark ? AppColors.cardDark : AppColors.cardLight,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: isDark ? AppColors.borderDark : AppColors.borderLight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.06),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'AHASS Official',
                              style: AppTypography.getHeading(isDark: isDark, fontSize: 15, fontWeight: FontWeight.w700),
                            ),
                            const StatusBadge(
                              text: 'PIT READY',
                              type: BadgeType.success,
                              icon: Icons.check_circle_outline_rounded,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                          ),
                          child: Column(
                            children: [
                              Container(
                                width: 150,
                                height: 150,
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    const Icon(Icons.qr_code_2_rounded, size: 140, color: Color(0xFF0F172A)),
                                    Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: const BoxDecoration(
                                        color: AppColors.primary,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(Icons.build_rounded, size: 16, color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                booking.bookingCode,
                                style: const TextStyle(
                                  color: Color(0xFF0F172A),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(color: isDark ? AppColors.borderDark : AppColors.borderLight, height: 1),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Motor Pelanggan', style: AppTypography.getBody(isDark: isDark, fontSize: 12, isSecondary: true)),
                            Text('${booking.vehicle.name} (${booking.vehicle.plateNumber})', style: AppTypography.getLabel(isDark: isDark, fontSize: 12, fontWeight: FontWeight.w700)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Layanan', style: AppTypography.getBody(isDark: isDark, fontSize: 12, isSecondary: true)),
                            Text(booking.service.title, style: AppTypography.getLabel(isDark: isDark, fontSize: 12, fontWeight: FontWeight.w700)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Waktu Kedatangan', style: AppTypography.getBody(isDark: isDark, fontSize: 12, isSecondary: true)),
                            Text('${Formatters.date(booking.scheduleDate)} • ${booking.scheduleTime}', style: AppTypography.getLabel(isDark: isDark, fontSize: 12, fontWeight: FontWeight.w700)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Teknisi Bertugas', style: AppTypography.getBody(isDark: isDark, fontSize: 12, isSecondary: true)),
                            Text(booking.mechanicName, style: const TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.w700)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            AppButton(
              text: 'Buka Chat dengan Montir',
              icon: Icons.chat_rounded,
              variant: ButtonVariant.secondary,
              width: double.infinity,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ChatMontirScreen(controller: controller),
                  ),
                );
              },
            ),
            const SizedBox(height: 10),
            AppButton(
              text: 'Kembali ke Beranda',
              icon: Icons.home_rounded,
              width: double.infinity,
              onPressed: () {
                controller.setNavIndex(0);
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            ),
          ],
        ),
      ),
    );
  }
}
