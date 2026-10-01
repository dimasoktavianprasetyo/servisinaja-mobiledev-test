import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../controllers/app_controller.dart';
import '../widgets/badge_percent_icon.dart';
import 'home/home_screen.dart';
import 'booking/booking_step1_screen.dart';
import 'promo/promo_screen.dart';
import 'garasi/garasi_screen.dart';
import 'profile/profile_screen.dart';

class MainNavigationScreen extends StatelessWidget {
  final AppController controller;

  const MainNavigationScreen({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = controller.isDarkMode;

    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final currentIndex = controller.navIndex;

        final List<Widget> screens = [
          HomeScreen(controller: controller),
          BookingStep1Screen(controller: controller),
          PromoScreen(controller: controller),
          GarasiScreen(controller: controller),
          ProfileScreen(controller: controller),
        ];

        return Scaffold(
          backgroundColor:
              isDark ? const Color(0xFF0B1120) : const Color(0xFFFAF8F5),
          body: Container(
            decoration: BoxDecoration(
              gradient: isDark
                  ? const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [0.0, 0.22, 0.60, 1.0],
                      colors: [
                        Color(0xFF24160E), // Rich dark amber/orange top tint
                        Color(0xFF16151E), // Soft dark drift
                        Color(0xFF111827), // Deep slate
                        Color(0xFF0B1120), // Rich obsidian
                      ],
                    )
                  : const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [0.0, 0.20, 0.55, 1.0],
                      colors: [
                        Color(0xFFFFECE0), // Soft luxurious warm orange glow
                        Color(0xFFFFF6EE), // Silky peach transition
                        Color(0xFFFAF7F4), // Refined warm neutral
                        Color(0xFFF8FAFC), // Clean crisp bottom
                      ],
                    ),
            ),
            child: IndexedStack(
              index: currentIndex,
              children: screens,
            ),
          ),
          bottomNavigationBar: currentIndex == 1
              ? const SizedBox.shrink()
              : Container(
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : Colors.white,
              border: Border(
                top: BorderSide(
                  color: isDark ? AppColors.borderDark : AppColors.borderLight,
                  width: 1,
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: SizedBox(
                height: 60,
                child: Row(
                  children: [
                    _buildNavItem(
                      index: 0,
                      icon: currentIndex == 0
                          ? Icons.home_rounded
                          : Icons.home_outlined,
                      label: 'Beranda',
                      isSelected: currentIndex == 0,
                      isDark: isDark,
                    ),
                    _buildNavItem(
                      index: 1,
                      icon: currentIndex == 1
                          ? Icons.calendar_month_rounded
                          : Icons.calendar_month_outlined,
                      label: 'Booking',
                      isSelected: currentIndex == 1,
                      isDark: isDark,
                    ),
                    _buildNavItem(
                      index: 2,
                      customIcon: BadgePercentIcon(
                        size: 24,
                        color: currentIndex == 2
                            ? AppColors.primary
                            : (isDark
                                ? AppColors.textMutedDark
                                : const Color(0xFF64748B)),
                      ),
                      label: 'Promo',
                      isSelected: currentIndex == 2,
                      isDark: isDark,
                    ),
                    _buildNavItem(
                      index: 3,
                      icon: currentIndex == 3
                          ? Icons.build_rounded
                          : Icons.build_outlined,
                      label: 'Garasi',
                      isSelected: currentIndex == 3,
                      isDark: isDark,
                    ),
                    _buildNavItem(
                      index: 4,
                      icon: currentIndex == 4
                          ? Icons.person_rounded
                          : Icons.person_outline_rounded,
                      label: 'Akun',
                      isSelected: currentIndex == 4,
                      isDark: isDark,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNavItem({
    required int index,
    IconData? icon,
    Widget? customIcon,
    required String label,
    required bool isSelected,
    required bool isDark,
  }) {
    final activeColor = AppColors.primary;
    final inactiveColor =
        isDark ? AppColors.textMutedDark : const Color(0xFF64748B);

    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => controller.setNavIndex(index),
          splashColor: AppColors.primary.withValues(alpha: 0.1),
          highlightColor: Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 24,
                height: 24,
                child: Center(
                  child: customIcon ??
                      Icon(
                        icon,
                        size: 24,
                        color: isSelected ? activeColor : inactiveColor,
                      ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isSelected ? activeColor : inactiveColor,
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
