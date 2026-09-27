import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../controllers/app_controller.dart';
import '../../booking/booking_step1_screen.dart';
import '../../call/call_montir_screen.dart';
import '../../chat/chat_montir_screen.dart';

class FeaturesGrid extends StatelessWidget {
  final AppController controller;

  const FeaturesGrid({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = controller.isDarkMode;

    final List<Map<String, dynamic>> features = [
      {
        'title': 'Booking Servis',
        'subtitle': 'Pilih jadwal kamu',
        'icon': Icons.calendar_month_rounded,
        'colors': [const Color(0xFFFF6B00), const Color(0xFFE05300)],
        'onTap': () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BookingStep1Screen(controller: controller),
            ),
          );
        },
      },
      {
        'title': 'Emergency',
        'subtitle': 'Bantuan 24 Jam',
        'icon': Icons.warning_rounded,
        'colors': [const Color(0xFFEF4444), const Color(0xFFDC2626)],
        'onTap': () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CallMontirScreen(
                controller: controller,
                isEmergency: true,
              ),
            ),
          );
        },
      },
      {
        'title': 'Home Service',
        'subtitle': 'Servis di rumah',
        'icon': Icons.home_repair_service_rounded,
        'colors': [const Color(0xFF0EA5E9), const Color(0xFF0284C7)],
        'onTap': () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BookingStep1Screen(
                controller: controller,
                isHomeService: true,
              ),
            ),
          );
        },
      },
      {
        'title': 'Chat Montir',
        'subtitle': 'Konsultasi gratis',
        'icon': Icons.chat_rounded,
        'colors': [const Color(0xFF10B981), const Color(0xFF059669)],
        'onTap': () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ChatMontirScreen(controller: controller),
            ),
          );
        },
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Layanan Kami',
            style: AppTypography.getHeading(
              isDark: isDark,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: features.map((feat) {
              final gradient = feat['colors'] as List<Color>;

              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: InkWell(
                    onTap: feat['onTap'] as VoidCallback,
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: gradient,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: gradient[0].withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.25),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              feat['icon'] as IconData,
                              size: 22,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            feat['title'] as String,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            feat['subtitle'] as String,
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.8),
                              fontSize: 9,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
