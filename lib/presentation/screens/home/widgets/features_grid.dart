import 'package:flutter/material.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../controllers/app_controller.dart';
import '../../booking/booking_step1_screen.dart';
import '../../call/call_montir_screen.dart';

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
        'image': 'assets/images/feature_booking.png',
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
        'image': 'assets/images/feature_emergency.png',
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
        'image': 'assets/images/feature_homeservice.png',
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
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: InkWell(
                    onTap: feat['onTap'] as VoidCallback,
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      height: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          feat['image'] as String,
                          fit: BoxFit.cover,
                        ),
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
