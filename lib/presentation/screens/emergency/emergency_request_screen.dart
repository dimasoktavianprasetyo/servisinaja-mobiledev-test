import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/vehicle_model.dart';
import '../../controllers/app_controller.dart';
import '../call/call_montir_screen.dart';
import 'emergency_searching_screen.dart';

class EmergencyRequestScreen extends StatefulWidget {
  final AppController controller;

  const EmergencyRequestScreen({
    super.key,
    required this.controller,
  });

  @override
  State<EmergencyRequestScreen> createState() => _EmergencyRequestScreenState();
}

class _EmergencyRequestScreenState extends State<EmergencyRequestScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _radarController;
  late AnimationController _roadFlowController;
  late AnimationController _bobController;
  bool _controllersInitialized = false;
  int _selectedCategoryIndex = 0; // 0: Ban, 1: Aki, 2: Mesin, 3: Bensin
  late VehicleModel _currentVehicle;

  final List<Map<String, dynamic>> _categories = [
    {
      'id': 'ban',
      'title': 'Ban Bocor / Kempes',
      'subtitle': 'Tambal / Isi Angin di Tempat',
      'icon': Icons.tire_repair_rounded,
      'color': const Color(0xFFEA580C),
    },
    {
      'id': 'aki',
      'title': 'Aki Drop / Mati Total',
      'subtitle': 'Jumper Aki Darurat',
      'icon': Icons.battery_alert_rounded,
      'color': const Color(0xFF10B981),
    },
    {
      'id': 'mesin',
      'title': 'Mesin Mogok / CVT',
      'subtitle': 'Pengecekan di Lokasi',
      'icon': Icons.settings_rounded,
      'color': const Color(0xFF64748B),
    },
    {
      'id': 'bensin',
      'title': 'Kehabisan Bensin',
      'subtitle': 'Pengantaran BBM Cepat',
      'icon': Icons.local_gas_station_rounded,
      'color': const Color(0xFFEF4444),
    },
  ];

  void _ensureControllers() {
    if (_controllersInitialized) return;
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _radarController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat();

    _roadFlowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..repeat();

    _bobController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _controllersInitialized = true;
  }

  @override
  void initState() {
    super.initState();
    _currentVehicle = widget.controller.selectedVehicle;
    _ensureControllers();
  }

  @override
  void dispose() {
    if (_controllersInitialized) {
      _pulseController.dispose();
      _radarController.dispose();
      _roadFlowController.dispose();
      _bobController.dispose();
    }
    super.dispose();
  }

  void _showVehiclePickerModal(bool isDark) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark ? AppColors.surfaceDark : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Pilih Kendaraan Bermasalah',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Montir siaga akan membawa suku cadang & peralatan sesuai unit.',
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? AppColors.textSecondaryDark : const Color(0xFF64748B),
                ),
              ),
              const SizedBox(height: 16),
              ...widget.controller.vehicles.map((v) {
                final isSel = v.id == _currentVehicle.id;
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _currentVehicle = v;
                      });
                      Navigator.pop(ctx);
                    },
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isSel
                            ? const Color(0xFFFF5C00).withValues(alpha: 0.08)
                            : (isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC)),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isSel
                              ? const Color(0xFFFF5C00)
                              : (isDark ? AppColors.borderDark : const Color(0xFFE2E8F0)),
                          width: isSel ? 1.5 : 1.0,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF5C00).withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.two_wheeler_rounded,
                              color: Color(0xFFFF5C00),
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  v.name,
                                  style: TextStyle(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w800,
                                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${v.plateNumber} • ${v.garageLabel}',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Color(0xFF64748B),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (isSel)
                            const Icon(
                              Icons.check_circle_rounded,
                              color: Color(0xFFFF5C00),
                              size: 20,
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  void _handleBookingDarurat() {
    HapticFeedback.heavyImpact();
    final selectedCategory = _categories[_selectedCategoryIndex];

    // Navigate to 10-Second Live Searching Animation Screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EmergencySearchingScreen(
          controller: widget.controller,
          vehicle: _currentVehicle,
          issueTitle: selectedCategory['title'] as String,
          issueSubtitle: selectedCategory['subtitle'] as String,
        ),
      ),
    );
  }

  void _handleCallCenter() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CallMontirScreen(
          controller: widget.controller,
          isEmergency: true,
          mechanicName: 'Call Center 1500-988',
          mechanicRole: 'Layanan Darurat AHASS 24 Jam',
          workshopName: 'Pusat Bantuan Roadside Assistance',
          avatarPath: 'assets/images/kang_asep.png',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _ensureControllers();
    final isDark = widget.controller.isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? AppColors.bgDark : const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.bgDark : const Color(0xFFF8FAFC),
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: 16,
        title: Row(
          children: [
            // Circular Back Button
            InkWell(
              onTap: () => Navigator.pop(context),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceDark : Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isDark ? AppColors.borderDark : const Color(0xFFE2E8F0),
                    width: 1.0,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 16,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Screen Title & Subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Bantuan Darurat',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    'Layanan Roadside Assistance',
                    style: TextStyle(
                      fontSize: 11,
                      color: isDark ? AppColors.textSecondaryDark : const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
            // Red Pill: Siaga 24 Jam
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF2F2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFFFECACA),
                  width: 1.0,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedBuilder(
                    animation: _pulseController,
                    builder: (context, _) {
                      return Container(
                        width: 7,
                        height: 7,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEF4444),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFEF4444).withValues(
                                alpha: 0.3 + (_pulseController.value * 0.5),
                              ),
                              blurRadius: 4 + (_pulseController.value * 4),
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 5),
                  const Text(
                    'Siaga 24 Jam',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFFEF4444),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Interactive GPS Map Card
            _buildInteractiveMapSection(isDark),

            const SizedBox(height: 16),

            // 2. Kendaraan Mengalami Kendala Card
            _buildVehicleSelectorCard(isDark),

            const SizedBox(height: 18),

            // 3. Category Selector Section (2x2 Grid)
            _buildCategorySection(isDark),

            const SizedBox(height: 16),

            // 4. Assigned Nearest Workshop Card
            _buildWorkshopCard(isDark),

            const SizedBox(height: 24),

            // 5. Primary CTA: Booking Montir Darurat Sekarang
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF5C00),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shadowColor: const Color(0xFFFF5C00).withValues(alpha: 0.4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(26),
                  ),
                ),
                onPressed: _handleBookingDarurat,
                child: const Text(
                  'Booking Montir Darurat Sekarang',
                  style: TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.2,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // 6. Secondary Call Center Link Button
            Center(
              child: TextButton.icon(
                onPressed: _handleCallCenter,
                icon: const Icon(
                  Icons.phone_in_talk_rounded,
                  size: 15,
                  color: Color(0xFFDC2626),
                ),
                label: const Text(
                  'Hubungi Call Center Darurat (1500-988)',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFFDC2626),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 1. Interactive GPS Map Section
  // ---------------------------------------------------------------------------
  Widget _buildInteractiveMapSection(bool isDark) {
    return Container(
      height: 210,
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppColors.borderDark : const Color(0xFFE2E8F0),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // Custom Map Canvas Painter with live streaming road dashes, radar waves & scanner cone
            Positioned.fill(
              child: AnimatedBuilder(
                animation: Listenable.merge([
                  _pulseController,
                  _radarController,
                  _roadFlowController,
                ]),
                builder: (context, _) {
                  return CustomPaint(
                    painter: _EmergencyMapOverviewPainter(
                      isDark: isDark,
                      pulseValue: _pulseController.value,
                      radarValue: _radarController.value,
                      roadFlowValue: _roadFlowController.value,
                    ),
                  );
                },
              ),
            ),

            // Street Labels
            const Positioned(
              top: 18,
              left: 65,
              child: Text(
                'JL. CIHAMPELAS',
                style: TextStyle(
                  fontSize: 9.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                  color: Color(0xFF64748B),
                ),
              ),
            ),
            const Positioned(
              top: 56,
              left: 20,
              child: Text(
                'JL. JENDERAL SUDIRMAN',
                style: TextStyle(
                  fontSize: 9.5,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                  color: Color(0xFF9A3412),
                ),
              ),
            ),

            // Top-Right Locate Me Floating Button
            Positioned(
              top: 10,
              right: 10,
              child: InkWell(
                onTap: () {
                  HapticFeedback.lightImpact();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Lokasi GPS dikunci: Jl. Sudirman No. 45 (Akurat)'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(18),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.surfaceDark : Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isDark ? AppColors.borderDark : const Color(0xFFE2E8F0),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.my_location_rounded,
                      size: 18,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                ),
              ),
            ),

            // AHASS Cihampelas Marker (Top Left) with gentle floating animation
            Positioned(
              top: 38,
              left: 45,
              child: AnimatedBuilder(
                animation: _bobController,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, 1.8 * (1.0 - _bobController.value)),
                    child: child,
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: const Text(
                    'AHASS Cihampelas\n(0.8km)',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 8.5,
                      fontWeight: FontWeight.w700,
                      height: 1.1,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),

            // Breakdown Location Card (Center Right) with floating bounce & beacon pulse
            Positioned(
              top: 96,
              left: 110,
              child: AnimatedBuilder(
                animation: _bobController,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, -2.8 * _bobController.value),
                    child: child,
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.25),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedBuilder(
                        animation: _pulseController,
                        builder: (context, _) {
                          return Container(
                            width: 6.5,
                            height: 6.5,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF5C00),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFFF5C00).withValues(
                                    alpha: 0.4 + (_pulseController.value * 0.6),
                                  ),
                                  blurRadius: 4 + (_pulseController.value * 3),
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        'Lokasi Mogok: Jl. Sudirman No. 45',
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Bottom Floating Pill: 3 Montir Siaga di sekitar radius 3 km with pulsing halo
            Positioned(
              left: 16,
              right: 16,
              bottom: 12,
              child: AnimatedBuilder(
                animation: _bobController,
                builder: (context, _) {
                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.surfaceDark : Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: const Color(0xFFFF5C00).withValues(
                          alpha: 0.12 + (_bobController.value * 0.22),
                        ),
                        width: 1.0,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFF5C00).withValues(
                            alpha: 0.04 + (_bobController.value * 0.08),
                          ),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                        BoxShadow(
                          color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.07),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          '3 Montir Siaga ',
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFFFF5C00),
                          ),
                        ),
                        Text(
                          'di sekitar radius 3 km  ',
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w700,
                            color: isDark ? Colors.white : const Color(0xFF0F172A),
                          ),
                        ),
                        Transform.translate(
                          offset: Offset(0, -1.5 * _bobController.value),
                          child: const Text(
                            '📍',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 2. Vehicle Selector Card
  // ---------------------------------------------------------------------------
  Widget _buildVehicleSelectorCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.borderDark : const Color(0xFFE2E8F0),
          width: 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'KENDARAAN MENGALAMI KENDALA',
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                  color: isDark ? AppColors.textSecondaryDark : const Color(0xFF64748B),
                ),
              ),
              InkWell(
                onTap: () => _showVehiclePickerModal(isDark),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Ganti Unit',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFFFF5C00),
                      ),
                    ),
                    SizedBox(width: 2),
                    Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 16,
                      color: Color(0xFFFF5C00),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                width: 1.0,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF5C00).withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.two_wheeler_rounded,
                      color: Color(0xFFFF5C00),
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _currentVehicle.name,
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w800,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Plat No: ${_currentVehicle.plateNumber} • ${_currentVehicle.garageLabel}',
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFECFDF5),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFFA7F3D0),
                      width: 1.0,
                    ),
                  ),
                  child: const Text(
                    'Terpilih',
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF059669),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 3. Problem Category Selector (2x2 Grid)
  // ---------------------------------------------------------------------------
  Widget _buildCategorySection(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Pilih Jenis Masalah Darurat',
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w800,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
            ),
            Text(
              'Pilih 1 kategori',
              style: TextStyle(
                fontSize: 11,
                color: isDark ? AppColors.textSecondaryDark : const Color(0xFF64748B),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(child: _buildCategoryCard(0, isDark)),
            const SizedBox(width: 10),
            Expanded(child: _buildCategoryCard(1, isDark)),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(child: _buildCategoryCard(2, isDark)),
            const SizedBox(width: 10),
            Expanded(child: _buildCategoryCard(3, isDark)),
          ],
        ),
      ],
    );
  }

  Widget _buildCategoryCard(int index, bool isDark) {
    final cat = _categories[index];
    final isSelected = _selectedCategoryIndex == index;

    return InkWell(
      onTap: () {
        HapticFeedback.selectionClick();
        setState(() {
          _selectedCategoryIndex = index;
        });
      },
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark
                  ? const Color(0xFF321A0F)
                  : const Color(0xFFFFF7ED))
              : (isDark ? AppColors.surfaceDark : Colors.white),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? const Color(0xFFFF5C00)
                : (isDark ? AppColors.borderDark : const Color(0xFFE2E8F0)),
            width: isSelected ? 1.8 : 1.0,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFFFF5C00).withValues(alpha: 0.14),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Icon + Radio
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  cat['icon'] as IconData,
                  size: 22,
                  color: isSelected
                      ? const Color(0xFFFF5C00)
                      : (cat['color'] as Color),
                ),
                isSelected
                    ? const Icon(
                        Icons.check_circle_rounded,
                        size: 19,
                        color: Color(0xFFFF5C00),
                      )
                    : Container(
                        width: 17,
                        height: 17,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isDark ? const Color(0xFF475569) : const Color(0xFFCBD5E1),
                            width: 1.5,
                          ),
                        ),
                      ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              cat['title'] as String,
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w800,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 3),
            Text(
              cat['subtitle'] as String,
              style: TextStyle(
                fontSize: 10.5,
                color: isSelected
                    ? const Color(0xFFC2410C)
                    : (isDark ? AppColors.textSecondaryDark : const Color(0xFF64748B)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 4. Assigned Nearest Workshop Card
  // ---------------------------------------------------------------------------
  Widget _buildWorkshopCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.borderDark : const Color(0xFFE2E8F0),
          width: 1.0,
        ),
      ),
      child: Row(
        children: [
          // Orange wrench icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFFFEDD5),
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.build_rounded,
              color: Color(0xFFEA580C),
              size: 20,
            ),
          ),
          const SizedBox(width: 10),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        'AHASS Siaga Cihampelas',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w800,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF3C7),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'Terdekat',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFFD97706),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  'Biaya Panggilan: Rp 35.000 + part',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? AppColors.textSecondaryDark : const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // ETA
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'EST. TIBA',
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                  color: isDark ? AppColors.textMutedDark : const Color(0xFF94A3B8),
                ),
              ),
              const SizedBox(height: 1),
              const Text(
                '12 – 18 Menit',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF16A34A),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Custom Painter for Map Overview Canvas
// -----------------------------------------------------------------------------
class _EmergencyMapOverviewPainter extends CustomPainter {
  final bool isDark;
  final double pulseValue;
  final double radarValue;
  final double roadFlowValue;

  _EmergencyMapOverviewPainter({
    required this.isDark,
    required this.pulseValue,
    required this.radarValue,
    required this.roadFlowValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Background green block areas (representing city parks/blocks)
    final bgPaint = Paint()
      ..color = isDark ? const Color(0xFF0F172A) : const Color(0xFFE8F4EC);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    final blockPaint = Paint()
      ..color = isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0);

    // City street grid blocks
    canvas.drawRRect(
      RRect.fromRectAndRadius(const Rect.fromLTWH(10, 10, 140, 50), const Radius.circular(8)),
      blockPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(const Rect.fromLTWH(160, 10, 140, 50), const Radius.circular(8)),
      blockPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(const Rect.fromLTWH(10, 75, 140, 75), const Radius.circular(8)),
      blockPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(const Rect.fromLTWH(160, 75, 140, 75), const Radius.circular(8)),
      blockPaint,
    );

    // 2. Secondary Road (Jl. Cihampelas)
    final secRoadPaint = Paint()
      ..color = isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9)
      ..strokeWidth = 16
      ..style = PaintingStyle.stroke;
    canvas.drawLine(
      const Offset(70, 0),
      const Offset(70, 170),
      secRoadPaint,
    );

    // 3. Main Road Base (Jl. Jenderal Sudirman)
    final roadPaint = Paint()
      ..color = isDark ? const Color(0xFF3B2516) : const Color(0xFFFFEDD5)
      ..strokeWidth = 14
      ..style = PaintingStyle.stroke;
    canvas.drawLine(
      Offset(0, 75),
      Offset(size.width, 75),
      roadPaint,
    );

    // Animated streaming dashed center road line
    final dashPaint = Paint()
      ..color = const Color(0xFFF97316)
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    const dashStep = 18.0;
    final flow = roadFlowValue * dashStep;
    double x = -dashStep + flow;
    while (x < size.width + dashStep) {
      final startX = x;
      final endX = math.min(x + 9.5, size.width);
      if (endX > 0 && startX < size.width) {
        canvas.drawLine(
          Offset(math.max(0, startX), 75),
          Offset(endX, 75),
          dashPaint,
        );
      }
      x += dashStep;
    }

    final userPos = const Offset(195, 75);

    // 4. Live Radar Sweep Cone & Radar Wave Rings around Breakdown Pin
    _drawRadarScanner(canvas, userPos);

    // 5. Nearby Technicians (Green Live Radar Dots with expanding telemetry pulses)
    _drawTechnicianDot(canvas, const Offset(70, 42), radarValue, 0.0);
    _drawTechnicianDot(canvas, const Offset(230, 55), radarValue, 0.35);
    _drawTechnicianDot(canvas, const Offset(205, 120), radarValue, 0.7);

    // 6. User Breakdown Pin with Multi-stage Beacon Core
    _drawBreakdownPin(canvas, userPos);
  }

  void _drawRadarScanner(Canvas canvas, Offset center) {
    // 3 expanding radar waves radiating outward from breakdown location
    for (int i = 0; i < 3; i++) {
      final waveProgress = (radarValue + (i * 0.33)) % 1.0;
      final radius = 14.0 + (waveProgress * 48.0);
      final alpha = (1.0 - waveProgress) * 0.38;

      // Soft filled wave
      final fillPaint = Paint()
        ..color = const Color(0xFFFF5C00).withValues(alpha: alpha * 0.35)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(center, radius, fillPaint);

      // Crisp outer ring wave
      final ringPaint = Paint()
        ..color = const Color(0xFFFF7A00).withValues(alpha: alpha)
        ..strokeWidth = 1.4
        ..style = PaintingStyle.stroke;
      canvas.drawCircle(center, radius, ringPaint);
    }

    // Rotating radar sweep beam (360 degree scanner cone)
    final sweepAngle = radarValue * 2 * math.pi;
    const sweepRadius = 56.0;

    final sweepPaint = Paint()
      ..shader = SweepGradient(
        center: Alignment.center,
        startAngle: 0.0,
        endAngle: 0.55,
        colors: [
          const Color(0xFFFF5C00).withValues(alpha: 0.0),
          const Color(0xFFFF7A00).withValues(alpha: 0.20),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: sweepRadius));

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(sweepAngle);
    canvas.drawArc(
      Rect.fromCircle(center: Offset.zero, radius: sweepRadius),
      0,
      0.55,
      true,
      sweepPaint,
    );
    canvas.restore();
  }

  void _drawTechnicianDot(Canvas canvas, Offset offset, double radarVal, double phaseOffset) {
    final dotProgress = (radarVal + phaseOffset) % 1.0;
    final rippleRadius = 7.0 + (dotProgress * 15.0);
    final rippleAlpha = (1.0 - dotProgress) * 0.55;

    // Expanding green radar ripple
    final halo = Paint()
      ..color = const Color(0xFF10B981).withValues(alpha: rippleAlpha)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.3;
    canvas.drawCircle(offset, rippleRadius, halo);

    // Inner subtle glow
    final glow = Paint()
      ..color = const Color(0xFF10B981).withValues(
        alpha: 0.20 + (0.15 * math.sin(radarVal * 2 * math.pi)),
      )
      ..style = PaintingStyle.fill;
    canvas.drawCircle(offset, 9, glow);

    // Outer dark ring
    final outer = Paint()
      ..color = const Color(0xFF0F172A)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(offset, 6.5, outer);

    // Inner vivid emerald dot
    final inner = Paint()
      ..color = const Color(0xFF10B981)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(offset, 3.8, inner);

    // Center bright spark
    final spark = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(offset, 1.2, spark);
  }

  void _drawBreakdownPin(Canvas canvas, Offset userPos) {
    // Pulse breathing glow
    final glowRadius = 15.0 + (pulseValue * 3.5);
    final glowPaint = Paint()
      ..color = const Color(0xFFFF5C00).withValues(alpha: 0.35 + (pulseValue * 0.25))
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);
    canvas.drawCircle(userPos, glowRadius, glowPaint);

    // Solid orange core
    final innerPulse = Paint()
      ..color = const Color(0xFFFF5C00)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(userPos, 14, innerPulse);

    // Crisp white border
    final whiteBorder = Paint()
      ..color = Colors.white
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(userPos, 14, whiteBorder);

    // Center white dot
    final pinCenter = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(userPos, 4.5, pinCenter);
  }

  @override
  bool shouldRepaint(covariant _EmergencyMapOverviewPainter oldDelegate) => true;
}
