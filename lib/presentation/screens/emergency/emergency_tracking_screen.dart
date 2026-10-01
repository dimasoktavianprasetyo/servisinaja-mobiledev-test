import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/vehicle_model.dart';
import '../../controllers/app_controller.dart';
import '../call/call_montir_screen.dart';
import '../chat/chat_montir_screen.dart';

class EmergencyTrackingScreen extends StatefulWidget {
  final AppController controller;
  final VehicleModel vehicle;
  final String issueTitle;
  final String issueSubtitle;

  const EmergencyTrackingScreen({
    super.key,
    required this.controller,
    required this.vehicle,
    required this.issueTitle,
    required this.issueSubtitle,
  });

  @override
  State<EmergencyTrackingScreen> createState() => _EmergencyTrackingScreenState();
}

class _EmergencyTrackingScreenState extends State<EmergencyTrackingScreen>
    with TickerProviderStateMixin {
  AnimationController? _pulseController;
  AnimationController? _routeAnimController;
  AnimationController? _bikeBobController;
  bool _isExpanded = true;

  void _ensureControllers() {
    _pulseController ??= AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1700),
    )..repeat();

    _routeAnimController ??= AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    _bikeBobController ??= AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);
  }

  @override
  void initState() {
    super.initState();
    _ensureControllers();
  }

  void _toggleExpanded() {
    HapticFeedback.selectionClick();
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  void _handleGoBackToHome() {
    widget.controller.setNavIndex(0);
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  void dispose() {
    _pulseController?.dispose();
    _routeAnimController?.dispose();
    _bikeBobController?.dispose();
    super.dispose();
  }

  void _handleCallKangAsep() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CallMontirScreen(
          controller: widget.controller,
          isEmergency: true,
          mechanicName: 'Kang Asep Supriyadi',
          mechanicRole: 'Teknisi AHASS Siaga',
          workshopName: 'AHASS Siaga Cihampelas',
          avatarPath: 'assets/images/kang_asep.png',
        ),
      ),
    );
  }

  void _handleChatKangAsep() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChatMontirScreen(
          controller: widget.controller,
          isEmergency: true,
          mechanicName: 'Kang Asep Supriyadi',
          mechanicRole: 'Teknisi AHASS Siaga • OTW',
          avatarPath: 'assets/images/kang_asep.png',
          vehicleName: widget.vehicle.name,
          vehiclePlate: widget.vehicle.plateNumber,
          serviceType: 'Bantuan Darurat Roadside',
          findingTitle: widget.issueTitle.isNotEmpty
              ? widget.issueTitle
              : 'Ban Belakang Bocor Halus',
          findingPrice: 'Tambal Tubeless',
          findingPhoto: 'assets/images/kampas_rem_inspection.jpg',
          findingDesc:
              'Halo Mbak Tania, posisi saya sudah belok di Jl. Juanda Timur ya. Sesuai navigasi sekitar 6 menitan lagi sampai di lokasi mogok.',
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

  void _handleCancelCall() {
    final isDark = widget.controller.isDarkMode;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Batalkan Panggilan Darurat?'),
        content: const Text(
          'Montir Kang Asep sudah dalam perjalanan menuju lokasi Anda. Apakah Anda yakin ingin membatalkan bantuan?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Tetap Tunggu'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              _handleGoBackToHome();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Panggilan darurat dibatalkan. Kembali ke Beranda.'),
                  backgroundColor: Color(0xFFEF4444),
                ),
              );
            },
            child: const Text('Ya, Batalkan', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _ensureControllers();
    final isDark = widget.controller.isDarkMode;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _handleGoBackToHome();
      },
      child: Scaffold(
        backgroundColor: isDark ? AppColors.bgDark : const Color(0xFFF1F5F9),
        body: Stack(
          children: [
            // 1. Full Interactive Animated Map Layer
            Positioned.fill(
              child: AnimatedBuilder(
                animation: Listenable.merge([
                  _pulseController!,
                  _routeAnimController!,
                  _bikeBobController!,
                ]),
                builder: (context, _) {
                  return CustomPaint(
                    painter: _EmergencyLiveTrackingPainter(
                      isDark: isDark,
                      pulseValue: _pulseController!.value,
                      dashOffset: _routeAnimController!.value,
                      bikeBob: _bikeBobController!.value,
                    ),
                  );
                },
              ),
            ),

            // 2. Map Floating Street Labels & POIs
            const Positioned(
              top: 155,
              left: 14,
              child: Text(
                'JL. CIHAMPELAS',
                style: TextStyle(
                  fontSize: 9.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                  color: Color(0xFF94A3B8),
                ),
              ),
            ),
            const Positioned(
              top: 255,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  'JL. JUANDA TIMUR',
                  style: TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                    color: Color(0xFF94A3B8),
                  ),
                ),
              ),
            ),
            const Positioned(
              top: 405,
              left: 14,
              child: Text(
                'JL. PANGERAN ANTASARI',
                style: TextStyle(
                  fontSize: 9.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                  color: Color(0xFF94A3B8),
                ),
              ),
            ),

            // SPBU Pertamina Marker (Left of West Avenue, above Juanda)
            Positioned(
              top: 250,
              left: 14,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Color(0xFFEF4444),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    'SPBU Pertamina',
                    style: TextStyle(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF475569),
                    ),
                  ),
                ],
              ),
            ),

            // AHASS Mitra Pusat Marker (Right of East Avenue, near Cihampelas)
            Positioned(
              top: 105,
              right: 14,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3.5),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFF5C00),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      'AHASS Mitra Pusat',
                      style: TextStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 3. Top Floating App Bar with Pill
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      // Circular Back Button (Direct ke Beranda)
                      InkWell(
                        onTap: _handleGoBackToHome,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.surfaceDark : Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.1),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            size: 16,
                            color: isDark ? Colors.white : const Color(0xFF0F172A),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Centered Floating Status Pill
                      Expanded(
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.surfaceDark : Colors.white,
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 7,
                                  height: 7,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF10B981),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                const Text(
                                  'Montir Sedang Menuju Lokasi',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF0F172A),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Locate Me Button
                      InkWell(
                        onTap: () {
                          HapticFeedback.lightImpact();
                          if (_isExpanded) {
                            setState(() => _isExpanded = false);
                          }
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Peta dipusatkan ke posisi Anda.'),
                              duration: const Duration(seconds: 2),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                          );
                        },
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.surfaceDark : Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.1),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.my_location_rounded,
                            size: 18,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // 4. Interactive Bottom Card (Bisa di-swipe ke bawah & tidak hilang)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: GestureDetector(
                onVerticalDragEnd: (details) {
                  if (details.primaryVelocity != null) {
                    if (details.primaryVelocity! > 100) {
                      // Geser ke bawah -> ciutkan card (hanya tampakkan header bar)
                      if (_isExpanded) {
                        _toggleExpanded();
                      }
                    } else if (details.primaryVelocity! < -100) {
                      // Geser ke atas -> buka detail penuh
                      if (!_isExpanded) {
                        _toggleExpanded();
                      }
                    }
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.surfaceDark : Colors.white,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.14),
                        blurRadius: 16,
                        offset: const Offset(0, -3),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    top: false,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Handle Bar & Header Ringkas (Selalu Tampak & Bisa Diklik/Digeser)
                          GestureDetector(
                            onTap: _toggleExpanded,
                            behavior: HitTestBehavior.opaque,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Center(
                                  child: Container(
                                    width: 38,
                                    height: 4,
                                    decoration: BoxDecoration(
                                      color: isDark
                                          ? Colors.white.withValues(alpha: 0.25)
                                          : Colors.grey.withValues(alpha: 0.35),
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),

                                // Baris Estimasi Waktu & Jarak dengan Indikator Putar
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Text(
                                          'Estimasi Tiba: ~12 Menit',
                                          style: TextStyle(
                                            fontSize: 14.5,
                                            fontWeight: FontWeight.w900,
                                            color: Color(0xFF10B981),
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        AnimatedRotation(
                                          turns: _isExpanded ? 0.0 : 0.5,
                                          duration: const Duration(milliseconds: 250),
                                          child: const Icon(
                                            Icons.keyboard_arrow_down_rounded,
                                            size: 19,
                                            color: Color(0xFF94A3B8),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(
                                          Icons.near_me_rounded,
                                          size: 14,
                                          color: Color(0xFF64748B),
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          'Jarak 1.8 km',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700,
                                            color: isDark ? Colors.white : const Color(0xFF0F172A),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          // Konten Detail yang Mulus Menyusut/Muncul
                          AnimatedCrossFade(
                            firstChild: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(height: 10),

                                // Kartu Profil Teknisi Kang Asep
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                                      width: 1.0,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      // Avatar dengan Centang Terverifikasi
                                      SizedBox(
                                        width: 44,
                                        height: 44,
                                        child: Stack(
                                          clipBehavior: Clip.none,
                                          children: [
                                            ClipOval(
                                              child: Image.asset(
                                                'assets/images/kang_asep.png',
                                                width: 44,
                                                height: 44,
                                                fit: BoxFit.cover,
                                                errorBuilder: (ctx, err, stack) => Container(
                                                  color: const Color(0xFFFF5C00),
                                                  child: const Icon(Icons.person, color: Colors.white),
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              bottom: -1,
                                              right: -1,
                                              child: Container(
                                                width: 14,
                                                height: 14,
                                                decoration: const BoxDecoration(
                                                  color: Color(0xFFFF8C00),
                                                  shape: BoxShape.circle,
                                                ),
                                                child: const Center(
                                                  child: Icon(Icons.check, size: 9, color: Colors.white),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      // Info
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Kang Asep Supriyadi',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w800,
                                                color: isDark ? Colors.white : const Color(0xFF0F172A),
                                              ),
                                            ),
                                            const SizedBox(height: 2),
                                            const Row(
                                              children: [
                                                Icon(Icons.star_rounded, size: 12, color: Color(0xFFF59E0B)),
                                                SizedBox(width: 3),
                                                Flexible(
                                                  child: Text(
                                                    '4.9 (420+ Servis Darurat)',
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontSize: 10,
                                                      color: Color(0xFF64748B),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 2),
                                            const Text(
                                              'Honda ADV 160 Siaga (B 4567 SA)',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w700,
                                                color: Color(0xFFFF5C00),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      // Tombol Telepon Hijau & Chat Oranye
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          InkWell(
                                            onTap: _handleCallKangAsep,
                                            borderRadius: BorderRadius.circular(18),
                                            child: Container(
                                              width: 34,
                                              height: 34,
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFDCFCE7),
                                                shape: BoxShape.circle,
                                                border: Border.all(color: const Color(0xFFBBF7D0)),
                                              ),
                                              child: const Center(
                                                child: Icon(
                                                  Icons.phone_rounded,
                                                  size: 16,
                                                  color: Color(0xFF16A34A),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 6),
                                          InkWell(
                                            onTap: _handleChatKangAsep,
                                            borderRadius: BorderRadius.circular(18),
                                            child: Container(
                                              width: 34,
                                              height: 34,
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFFFEDD5),
                                                shape: BoxShape.circle,
                                                border: Border.all(color: const Color(0xFFFED7AA)),
                                              ),
                                              child: const Center(
                                                child: Icon(
                                                  Icons.chat_bubble_rounded,
                                                  size: 15,
                                                  color: Color(0xFFEA580C),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(height: 8),

                                // Kotak Info Unit & Kendala
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(
                                      color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                                      width: 1.0,
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      RichText(
                                        text: TextSpan(
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: isDark ? Colors.white70 : const Color(0xFF475569),
                                          ),
                                          children: [
                                            const TextSpan(text: '• Unit      : '),
                                            TextSpan(
                                              text: '${widget.vehicle.name} ',
                                              style: const TextStyle(fontWeight: FontWeight.w800),
                                            ),
                                            TextSpan(
                                              text: '(${widget.vehicle.plateNumber})',
                                              style: const TextStyle(fontWeight: FontWeight.w800),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      RichText(
                                        text: TextSpan(
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: isDark ? Colors.white70 : const Color(0xFF475569),
                                          ),
                                          children: [
                                            const TextSpan(text: '• Kendala : '),
                                            TextSpan(
                                              text: widget.issueTitle,
                                              style: const TextStyle(fontWeight: FontWeight.w700),
                                            ),
                                            TextSpan(
                                              text: ' & ${widget.issueSubtitle}',
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(height: 10),

                                // Tombol Merah Batalkan Panggilan Darurat
                                SizedBox(
                                  width: double.infinity,
                                  height: 42,
                                  child: ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFEF4444),
                                      foregroundColor: Colors.white,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    onPressed: _handleCancelCall,
                                    icon: const Icon(Icons.close_rounded, size: 15),
                                    label: const Text(
                                      'Batalkan Panggilan Darurat',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 8),

                                // Footer Hubungi Call Center
                                Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Butuh bantuan segera?',
                                        style: TextStyle(
                                          fontSize: 10.5,
                                          color: isDark ? AppColors.textSecondaryDark : const Color(0xFF64748B),
                                        ),
                                      ),
                                      const SizedBox(height: 1),
                                      InkWell(
                                        onTap: _handleCallCenter,
                                        child: Text(
                                          'Hubungi Call Center 1500–988 (24 Jam)',
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w800,
                                            decoration: TextDecoration.underline,
                                            color: isDark ? Colors.white : const Color(0xFF0F172A),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            secondChild: const SizedBox(width: double.infinity, height: 0),
                            crossFadeState: _isExpanded
                                ? CrossFadeState.showFirst
                                : CrossFadeState.showSecond,
                            duration: const Duration(milliseconds: 250),
                            sizeCurve: Curves.easeOutCubic,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Custom Painter for Full Interactive Animated Live Tracking Map
// -----------------------------------------------------------------------------
class _EmergencyLiveTrackingPainter extends CustomPainter {
  final bool isDark;
  final double pulseValue;
  final double dashOffset;
  final double bikeBob;

  _EmergencyLiveTrackingPainter({
    required this.isDark,
    required this.pulseValue,
    required this.dashOffset,
    required this.bikeBob,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Map Canvas Background & City Block Blocks
    final bgPaint = Paint()
      ..color = isDark ? const Color(0xFF0B132B) : const Color(0xFFEFF6F1);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    final xWest = size.width * 0.36;
    final xEast = size.width * 0.64;
    const yCihampelas = 150.0;
    const yJuanda = 275.0;
    const yAntasari = 400.0;
    const roadWidth = 24.0;
    const hw = roadWidth / 2; // 12.0
    const gap = 3.0;

    // Draw City Grid Blocks
    final blockPaint = Paint()
      ..color = isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0);

    void drawBlock(double left, double top, double right, double bottom) {
      if (right > left && bottom > top) {
        final rrect = RRect.fromRectAndRadius(
          Rect.fromLTRB(left, top, right, bottom),
          const Radius.circular(6),
        );
        canvas.drawRRect(rrect, blockPaint);
      }
    }

    // Row 1 (0 to yCihampelas)
    drawBlock(6, 0, xWest - hw - gap, yCihampelas - hw - gap);
    drawBlock(xWest + hw + gap, 0, xEast - hw - gap, yCihampelas - hw - gap);
    drawBlock(xEast + hw + gap, 0, size.width - 6, yCihampelas - hw - gap);

    // Row 2 (yCihampelas to yJuanda)
    drawBlock(6, yCihampelas + hw + gap, xWest - hw - gap, yJuanda - hw - gap);
    drawBlock(xWest + hw + gap, yCihampelas + hw + gap, xEast - hw - gap, yJuanda - hw - gap);
    drawBlock(xEast + hw + gap, yCihampelas + hw + gap, size.width - 6, yJuanda - hw - gap);

    // Row 3 (yJuanda to yAntasari)
    drawBlock(6, yJuanda + hw + gap, xWest - hw - gap, yAntasari - hw - gap);
    drawBlock(xWest + hw + gap, yJuanda + hw + gap, xEast - hw - gap, yAntasari - hw - gap);
    drawBlock(xEast + hw + gap, yJuanda + hw + gap, size.width - 6, yAntasari - hw - gap);

    // Row 4 (yAntasari to bottom)
    drawBlock(6, yAntasari + hw + gap, xWest - hw - gap, size.height);
    drawBlock(xWest + hw + gap, yAntasari + hw + gap, xEast - hw - gap, size.height);
    drawBlock(xEast + hw + gap, yAntasari + hw + gap, size.width - 6, size.height);

    // 2. Curving Blue River Water Band (Underneath roads)
    final riverPaint = Paint()
      ..color = isDark
          ? const Color(0xFF1E3A8A).withValues(alpha: 0.35)
          : const Color(0xFFBFDBFE).withValues(alpha: 0.75)
      ..strokeWidth = 22
      ..style = PaintingStyle.stroke;

    final riverPath = Path()
      ..moveTo(0, 335)
      ..quadraticBezierTo(size.width * 0.5, 355, size.width, 330);
    canvas.drawPath(riverPath, riverPaint);

    // 3. City Roads (Over River, acting as bridges)
    final streetPaint = Paint()
      ..color = isDark ? const Color(0xFF334155) : Colors.white
      ..strokeWidth = roadWidth
      ..style = PaintingStyle.stroke;

    // Horizontal roads
    canvas.drawLine(const Offset(0, yCihampelas), Offset(size.width, yCihampelas), streetPaint);
    canvas.drawLine(const Offset(0, yJuanda), Offset(size.width, yJuanda), streetPaint);
    canvas.drawLine(const Offset(0, yAntasari), Offset(size.width, yAntasari), streetPaint);

    // Vertical roads (West Avenue & East Avenue)
    canvas.drawLine(Offset(xWest, 0), Offset(xWest, size.height), streetPaint);
    canvas.drawLine(Offset(xEast, 0), Offset(xEast, size.height), streetPaint);

    // Bridge Railings where avenues cross the river (y ~ 335)
    final bridgeRailPaint = Paint()
      ..color = isDark ? const Color(0xFF64748B) : const Color(0xFFCBD5E1)
      ..strokeWidth = 2.0;

    // West Bridge Railings
    canvas.drawLine(Offset(xWest - hw, 322), Offset(xWest - hw, 356), bridgeRailPaint);
    canvas.drawLine(Offset(xWest + hw, 322), Offset(xWest + hw, 356), bridgeRailPaint);

    // East Bridge Railings
    canvas.drawLine(Offset(xEast - hw, 318), Offset(xEast - hw, 350), bridgeRailPaint);
    canvas.drawLine(Offset(xEast + hw, 318), Offset(xEast + hw, 350), bridgeRailPaint);

    // 4. Animated Dispatch Route Path (Orange)
    // Kang Asep moves from West Ave (xWest, 125) down to Jl. Juanda Timur (xWest, 275),
    // turns East on Jl. Juanda Timur to East Ave (xEast, 275),
    // and goes down East Ave to user location at Jl. Pangeran Antasari (xEast, 400).
    final pStart = Offset(xWest, 125);
    final pCorner1 = Offset(xWest, yJuanda);
    final pCorner2 = Offset(xEast, yJuanda);
    final pDest = Offset(xEast, yAntasari);

    final routePath = Path()
      ..moveTo(pStart.dx, pStart.dy)
      ..lineTo(pCorner1.dx, pCorner1.dy)
      ..lineTo(pCorner2.dx, pCorner2.dy)
      ..lineTo(pDest.dx, pDest.dy);

    // Outer glow route line
    final outerRoute = Paint()
      ..color = const Color(0xFFFF5C00).withValues(alpha: 0.22)
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;
    canvas.drawPath(routePath, outerRoute);

    // Animated dashed center route line - 100% on the center of the road
    final dashRoute = Paint()
      ..color = const Color(0xFFFF5C00)
      ..strokeWidth = 4.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    _drawDashedPath(canvas, routePath, dashRoute, 8, 6, dashOffset * 14);

    // 5. User Destination Pin with Animated Expanding Concentric Ripple
    final pulsePaint = Paint()
      ..color = const Color(0xFFEF4444).withValues(alpha: (1.0 - pulseValue) * 0.4)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(pDest, 18 + (pulseValue * 16), pulsePaint);

    final destOuter = Paint()
      ..color = const Color(0xFFEF4444)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(pDest, 12, destOuter);

    final destRing = Paint()
      ..color = Colors.white
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(pDest, 12, destRing);

    final destCenter = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(pDest, 3.5, destCenter);

    // Destination Floating Label Pill ("Lokasi Mogok Anda")
    final destPillPaint = Paint()..color = const Color(0xFF0F172A);
    final destRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(pDest.dx, pDest.dy + 30), width: 130, height: 26),
      const Radius.circular(14),
    );
    canvas.drawRRect(destRect, destPillPaint);

    final redDot = Paint()..color = const Color(0xFFEF4444);
    canvas.drawCircle(Offset(pDest.dx - 48, pDest.dy + 30), 3.5, redDot);

    final tpDest = TextPainter(
      text: const TextSpan(
        text: 'Lokasi Mogok Anda',
        style: TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w700,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tpDest.paint(canvas, Offset(pDest.dx - 38, pDest.dy + 23));

    // 6. Kang Asep Moving Bike Marker (West Avenue with gentle bobbing)
    final bikeY = 115.0 + (bikeBob * 4.0);
    final bikePos = Offset(pStart.dx, bikeY);

    // Kang Asep Pill Label
    final asepPillBg = Paint()..color = Colors.white;
    final asepPillBorder = Paint()
      ..color = const Color(0xFFFF5C00)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    final asepRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(bikePos.dx, bikePos.dy - 32), width: 100, height: 26),
      const Radius.circular(13),
    );
    canvas.drawRRect(asepRect, asepPillBg);
    canvas.drawRRect(asepRect, asepPillBorder);

    final greenDot = Paint()..color = const Color(0xFF10B981);
    canvas.drawCircle(Offset(bikePos.dx - 34, bikePos.dy - 32), 3.5, greenDot);

    final tpAsep = TextPainter(
      text: const TextSpan(
        text: 'Kang Asep',
        style: TextStyle(
          color: Color(0xFF0F172A),
          fontSize: 11,
          fontWeight: FontWeight.w800,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tpAsep.paint(canvas, Offset(bikePos.dx - 24, bikePos.dy - 39));

    // Floating speech bubble: (~8 mnt)
    final tpTime = TextPainter(
      text: const TextSpan(
        text: '(~8 mnt)',
        style: TextStyle(
          color: Color(0xFFFF5C00),
          fontSize: 11,
          fontWeight: FontWeight.w800,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tpTime.paint(canvas, Offset(bikePos.dx + 22, bikePos.dy + 8));

    // Bike circular icon
    final bikeCircleBg = Paint()..color = const Color(0xFFFF5C00);
    canvas.drawCircle(bikePos, 18, bikeCircleBg);

    final bikeWhite = Paint()
      ..color = Colors.white
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(bikePos, 18, bikeWhite);

    // Draw simple bike vector inside
    final bikePaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 1.8
      ..style = PaintingStyle.stroke;
    // Two wheels
    canvas.drawCircle(Offset(bikePos.dx - 6, bikePos.dy + 5), 4, bikePaint);
    canvas.drawCircle(Offset(bikePos.dx + 6, bikePos.dy + 5), 4, bikePaint);
    // Frame lines
    canvas.drawLine(Offset(bikePos.dx - 6, bikePos.dy + 5), Offset(bikePos.dx, bikePos.dy), bikePaint);
    canvas.drawLine(Offset(bikePos.dx, bikePos.dy), Offset(bikePos.dx + 6, bikePos.dy + 5), bikePaint);
    canvas.drawLine(Offset(bikePos.dx, bikePos.dy), Offset(bikePos.dx + 3, bikePos.dy - 5), bikePaint);
  }

  void _drawDashedPath(
    Canvas canvas,
    Path path,
    Paint paint,
    double dashLength,
    double dashSpace,
    double phase,
  ) {
    for (final metric in path.computeMetrics()) {
      double distance = phase % (dashLength + dashSpace);
      while (distance < metric.length) {
        final len = math.min(dashLength, metric.length - distance);
        final extract = metric.extractPath(distance, distance + len);
        canvas.drawPath(extract, paint);
        distance += dashLength + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _EmergencyLiveTrackingPainter oldDelegate) => true;
}
