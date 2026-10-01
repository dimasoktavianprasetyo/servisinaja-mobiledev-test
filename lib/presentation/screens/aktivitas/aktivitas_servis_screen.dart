import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../controllers/app_controller.dart';
import '../booking/booking_step1_screen.dart';
import '../booking/booking_success_ticket_screen.dart';
import '../main_navigation_screen.dart';
import '../status/status_servis_screen.dart';
import '../../widgets/badge_percent_icon.dart';
import 'widgets/aktivitas_filter_bar.dart';
import 'widgets/aktivitas_guarantee_banner.dart';
import 'widgets/aktivitas_history_card.dart';
import 'widgets/aktivitas_ongoing_card.dart';

class AktivitasServisScreen extends StatefulWidget {
  final AppController controller;

  const AktivitasServisScreen({
    super.key,
    required this.controller,
  });

  @override
  State<AktivitasServisScreen> createState() => _AktivitasServisScreenState();
}

class _AktivitasServisScreenState extends State<AktivitasServisScreen> {
  int _selectedFilterIndex = 0; // 0: Semua, 1: Servis Bengkel, 2: Bantuan Darurat

  void _showInfoDialog(bool isDark) {
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF5C00).withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.shield_outlined,
                      color: Color(0xFFFF5C00),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Garansi Servis AHASS',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Setiap servis bengkel resmi AHASS terlindungi garansi 14 hari atau 500 km (mana yang tercapai lebih dahulu). Simpan invoice digital Anda untuk klaim garansi tanpa ribet di bengkel mitra manapun.',
                style: TextStyle(
                  fontSize: 13.5,
                  height: 1.5,
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : const Color(0xFF475569),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 13),
                  ),
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text(
                    'Mengerti',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _navigateToPantauStatus() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => StatusServisScreen(
          controller: widget.controller,
          fromAktivitasScreen: true,
        ),
      ),
    );
  }

  void _navigateToBookingArmada() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BookingStep1Screen(
          controller: widget.controller,
        ),
      ),
    );
  }

  void _navigateToInvoiceEmergency() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BookingSuccessTicketScreen(
          controller: widget.controller,
          bookingCode: 'EMG-20260930-104',
          workshopName: 'AHASS Servisin Emergency Team',
          workshopDistance: '0.8 km',
          scheduleDateTimeStr: 'Rabu, 30 Sep 2026 • 14:15 WIB',
          totalPrice: 35000,
          serviceFee: 35000,
          sparepartFee: 0,
          appFee: 0,
          discountVoucher: 0,
        ),
      ),
    );
  }

  void _onBottomNavTapped(int index) {
    if (index == 0) {
      widget.controller.setNavIndex(0);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => MainNavigationScreen(controller: widget.controller),
        ),
        (route) => false,
      );
    } else if (index == 1) {
      _navigateToBookingArmada();
    } else {
      widget.controller.setNavIndex(index);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => MainNavigationScreen(controller: widget.controller),
        ),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, _) {
        final isDark = widget.controller.isDarkMode;

        final showOngoing =
            _selectedFilterIndex == 0 || _selectedFilterIndex == 1;
        final showEmergency =
            _selectedFilterIndex == 0 || _selectedFilterIndex == 2;
        final showPeriodic =
            _selectedFilterIndex == 0 || _selectedFilterIndex == 1;

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
                        Color(0xFF24160E),
                        Color(0xFF16151E),
                        Color(0xFF111827),
                        Color(0xFF0B1120),
                      ],
                    )
                  : const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [0.0, 0.20, 0.55, 1.0],
                      colors: [
                        Color(0xFFFFECE0),
                        Color(0xFFFFF6EE),
                        Color(0xFFFAF7F4),
                        Color(0xFFF8FAFC),
                      ],
                    ),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),

                    // Top Bar / Header
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Aktivitas Servis',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                color: isDark
                                    ? Colors.white
                                    : const Color(0xFF0F172A),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Riwayat pesanan servis & bantuan darurat',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: isDark
                                    ? AppColors.textMutedDark
                                    : const Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),

                        // Info Button
                        InkWell(
                          onTap: () => _showInfoDialog(isDark),
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              color: isDark
                                  ? AppColors.surfaceDark
                                  : Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isDark
                                    ? AppColors.borderDark
                                    : const Color(0xFFE2E8F0),
                                width: 1.0,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(
                                    alpha: isDark ? 0.2 : 0.03,
                                  ),
                                  blurRadius: 4,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.info_outline_rounded,
                              size: 19,
                              color: isDark
                                  ? Colors.white70
                                  : const Color(0xFF475569),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Filter Pills Row
                    AktivitasFilterBar(
                      selectedIndex: _selectedFilterIndex,
                      onSelected: (idx) {
                        setState(() => _selectedFilterIndex = idx);
                      },
                      onFilterTap: () => _showInfoDialog(isDark),
                      isDark: isDark,
                    ),

                    const SizedBox(height: 16),

                    // Card 1: Ongoing Multi-Motor Service
                    if (showOngoing) ...[
                      AktivitasOngoingCard(
                        onPantauStatus: _navigateToPantauStatus,
                        isDark: isDark,
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Card 2: Bantuan Darurat (Emergency) Selesai
                    if (showEmergency) ...[
                      AktivitasHistoryCard(
                        icon: Icons.warning_amber_rounded,
                        iconColor: const Color(0xFFEF4444),
                        iconBgColor: const Color(0xFFFEF2F2),
                        title: 'Bantuan Darurat (Emergency)',
                        statusText: '✓ Selesai',
                        subtitleIcon: Icons.location_on_outlined,
                        subtitleText:
                            'Kemarin (1 hari lalu)  •  Jl. Sudirman No. 45',
                        vehicleName: 'Honda Vario 160',
                        serviceDesc: 'Ban Bocor & Tambal Tubeless',
                        totalPrice: 'Rp 35.000',
                        isPaid: true,
                        buttonText: 'Lihat Invoice',
                        buttonIcon: Icons.receipt_long_outlined,
                        onActionTap: _navigateToInvoiceEmergency,
                        isDark: isDark,
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Card 3: Servis Berkala & Ganti Oli Selesai
                    if (showPeriodic) ...[
                      AktivitasHistoryCard(
                        icon: Icons.bolt_rounded,
                        iconColor: const Color(0xFF3B82F6),
                        iconBgColor: const Color(0xFFEFF6FF),
                        title: 'Servis Berkala & Ganti Oli',
                        statusText: '✓ Selesai',
                        subtitleIcon: Icons.calendar_today_outlined,
                        subtitleText:
                            '1 bulan lalu (15 Agu 2024)  •  AHASS Cihampelas',
                        vehicleName: 'Honda BeAT',
                        serviceDesc: 'Oli Mesin SPX2 & Filter Udara',
                        totalPrice: 'Rp 145.000',
                        isPaid: false,
                        buttonText: 'Booking Lagi',
                        buttonIcon: Icons.sync_rounded,
                        isPrimaryOutline: true,
                        onActionTap: _navigateToBookingArmada,
                        isDark: isDark,
                      ),
                      const SizedBox(height: 16),
                    ],

                    // AHASS Warranty Guarantee Banner
                    AktivitasGuaranteeBanner(isDark: isDark),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),

          // Bottom Navigation Bar matching Figma
          bottomNavigationBar: Container(
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
                    _buildBottomNavItem(
                      index: 0,
                      icon: Icons.home_rounded,
                      label: 'Beranda',
                      isSelected: true,
                      isDark: isDark,
                    ),
                    _buildBottomNavItem(
                      index: 1,
                      icon: Icons.calendar_month_outlined,
                      label: 'Booking',
                      isSelected: false,
                      isDark: isDark,
                    ),
                    _buildBottomNavItem(
                      index: 2,
                      customIcon: BadgePercentIcon(
                        size: 24,
                        color: isDark
                            ? AppColors.textMutedDark
                            : const Color(0xFF64748B),
                      ),
                      label: 'Promo',
                      isSelected: false,
                      isDark: isDark,
                    ),
                    _buildBottomNavItem(
                      index: 3,
                      icon: Icons.build_outlined,
                      label: 'Garasi',
                      isSelected: false,
                      isDark: isDark,
                    ),
                    _buildBottomNavItem(
                      index: 4,
                      icon: Icons.person_outline_rounded,
                      label: 'Akun',
                      isSelected: false,
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

  Widget _buildBottomNavItem({
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
      child: InkWell(
        onTap: () => _onBottomNavTapped(index),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            customIcon ??
                Icon(
                  icon,
                  size: 24,
                  color: isSelected ? activeColor : inactiveColor,
                ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? activeColor : inactiveColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
