import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../controllers/app_controller.dart';
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
          body: IndexedStack(
            index: currentIndex,
            children: screens,
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : Colors.white,
              border: Border(
                top: BorderSide(
                  color: isDark ? AppColors.borderDark : AppColors.borderLight,
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: SafeArea(
              child: SizedBox(
                height: 64,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNavItem(
                      index: 0,
                      icon: Icons.home_rounded,
                      label: 'Beranda',
                      isSelected: currentIndex == 0,
                      isDark: isDark,
                    ),
                    _buildNavItem(
                      index: 1,
                      icon: Icons.calendar_month_rounded,
                      label: 'Booking',
                      isSelected: currentIndex == 1,
                      isDark: isDark,
                    ),
                    _buildNavItem(
                      index: 2,
                      icon: Icons.discount_rounded,
                      label: 'Promo',
                      isSelected: currentIndex == 2,
                      isDark: isDark,
                    ),
                    _buildNavItem(
                      index: 3,
                      icon: Icons.two_wheeler_rounded,
                      label: 'Garasi',
                      isSelected: currentIndex == 3,
                      isDark: isDark,
                    ),
                    _buildNavItem(
                      index: 4,
                      icon: Icons.person_rounded,
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
    required IconData icon,
    required String label,
    required bool isSelected,
    required bool isDark,
  }) {
    final activeColor = AppColors.primary;
    final inactiveColor = isDark ? AppColors.textMutedDark : AppColors.textSecondaryLight;

    return InkWell(
      onTap: () => controller.setNavIndex(index),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primaryContainerLight : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                size: 22,
                color: isSelected ? activeColor : inactiveColor,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? activeColor : inactiveColor,
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
