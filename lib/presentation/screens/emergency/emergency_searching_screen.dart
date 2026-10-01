import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/constants/app_colors.dart';
import '../../../data/models/vehicle_model.dart';
import '../../controllers/app_controller.dart';
import 'emergency_tracking_screen.dart';

class EmergencySearchingScreen extends StatefulWidget {
  final AppController controller;
  final VehicleModel vehicle;
  final String issueTitle;
  final String issueSubtitle;

  const EmergencySearchingScreen({
    super.key,
    required this.controller,
    required this.vehicle,
    required this.issueTitle,
    required this.issueSubtitle,
  });

  @override
  State<EmergencySearchingScreen> createState() => _EmergencySearchingScreenState();
}

class _EmergencySearchingScreenState extends State<EmergencySearchingScreen>
    with TickerProviderStateMixin {
  late final AnimationController _radarController;
  late final AnimationController _pulseController;
  late final AnimationController _progressController;

  Timer? _timer;
  int _secondsLeft = 10;
  bool _isMatched = false;
  String _statusText = 'Menghubungi jaringan AHASS Siaga terdekat...';
  String _subStatusText = 'Mengirimkan koordinat GPS Jl. Sudirman No. 45';

  @override
  void initState() {
    super.initState();

    // 1. Radar rotation sweep animation (2s per rotation)
    _radarController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();

    // 2. Pulse beacon animation (1.2s ping)
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    // 3. 10-Second overall smooth progress
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..forward();

    // 4. 10-Second countdown timer with step-by-step dispatch status
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;

      setState(() {
        _secondsLeft--;

        if (_secondsLeft >= 8) {
          _statusText = 'Menghubungi AHASS Siaga terdekat...';
          _subStatusText = 'Mengirimkan koordinat GPS Jl. Sudirman No. 45';
        } else if (_secondsLeft >= 5) {
          _statusText = 'Memindai 3 montir siaga di radius 3 km...';
          _subStatusText = 'Mencocokkan peralatan untuk kendala: ${widget.issueTitle}';
        } else if (_secondsLeft >= 2) {
          _statusText = 'Montir ditemukan! Mengirim sinyal darurat...';
          _subStatusText = 'Menghubungi Kang Asep Supriyadi (AHASS Cihampelas)';
        } else if (_secondsLeft == 1) {
          _statusText = 'Mengonfirmasi penugasan teknisi...';
          _subStatusText = 'Kang Asep sedang menyiapkan motor & toolkit';
        } else if (_secondsLeft <= 0) {
          _timer?.cancel();
          _onMatchSuccess();
        }
      });
    });
  }

  void _onMatchSuccess() {
    setState(() {
      _isMatched = true;
      _statusText = 'Montir Dikonfirmasi!';
      _subStatusText = 'Kang Asep Supriyadi sedang meluncur ke lokasi Anda';
    });

    HapticFeedback.heavyImpact();

    // 1. Add notification to AppController
    widget.controller.addNotification(
      title: 'Panggilan Darurat Dikonfirmasi!',
      body:
          'Montir Kang Asep Supriyadi (AHASS Siaga) sedang meluncur ke Jl. Sudirman No. 45 untuk ${widget.vehicle.name} (${widget.issueTitle}).',
      category: 'status',
      highlightTag: 'Darurat • OTW',
      badgeText: 'Menuju Lokasi',
      badgeBg: const Color(0xFFFEF2F2),
      badgeTextColor: const Color(0xFFDC2626),
    );

    // 2. Show brief celebration and navigate to tracking screen
    Future.delayed(const Duration(milliseconds: 1400), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => EmergencyTrackingScreen(
            controller: widget.controller,
            vehicle: widget.vehicle,
            issueTitle: widget.issueTitle,
            issueSubtitle: widget.issueSubtitle,
          ),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 500),
        ),
      );
    });
  }

  void _cancelSearch() {
    _timer?.cancel();
    HapticFeedback.selectionClick();
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _radarController.dispose();
    _pulseController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _cancelSearch();
      },
      child: Scaffold(
        backgroundColor: isDark ? const Color(0xFF090D16) : const Color(0xFFF8FAFC),
        body: SafeArea(
          child: Column(
            children: [
              // Top Bar: Back/Close & Header Status
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: _cancelSearch,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF1E293B) : Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                          ),
                        ),
                        child: Icon(
                          Icons.close_rounded,
                          size: 20,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF2F2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFFECACA)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AnimatedBuilder(
                            animation: _pulseController,
                            builder: (context, _) {
                              return Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEF4444),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFFEF4444).withValues(
                                        alpha: 0.3 + (_pulseController.value * 0.6),
                                      ),
                                      blurRadius: 5 + (_pulseController.value * 4),
                                      spreadRadius: 1,
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          const SizedBox(width: 6),
                          const Text(
                            'MENCARI BANTUAN DARURAT',
                            style: TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.5,
                              color: Color(0xFFDC2626),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 36), // Balance row
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // Countdown badge & Circular time gauge
              Center(
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 62,
                          height: 62,
                          child: AnimatedBuilder(
                            animation: _progressController,
                            builder: (context, _) {
                              return CircularProgressIndicator(
                                value: 1.0 - _progressController.value,
                                strokeWidth: 4.5,
                                backgroundColor: isDark
                                    ? const Color(0xFF1E293B)
                                    : const Color(0xFFE2E8F0),
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                  Color(0xFFFF5C00),
                                ),
                              );
                            },
                          ),
                        ),
                        Text(
                          '${_secondsLeft}s',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.5,
                            color: isDark ? Colors.white : const Color(0xFF0F172A),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _isMatched ? 'Teknisi Siaga Ditemukan!' : 'Memindai area sekitar...',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.textSecondaryDark : const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Centerpiece Radar Display
              Expanded(
                child: Center(
                  child: AspectRatio(
                    aspectRatio: 1.0,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Custom Radar Canvas
                          Positioned.fill(
                            child: AnimatedBuilder(
                              animation: Listenable.merge([
                                _radarController,
                                _pulseController,
                              ]),
                              builder: (context, _) {
                                return CustomPaint(
                                  painter: _RadarSearchPainter(
                                    isDark: isDark,
                                    radarAngle: _radarController.value * 2 * math.pi,
                                    pulseValue: _pulseController.value,
                                    secondsLeft: _secondsLeft,
                                    isMatched: _isMatched,
                                  ),
                                );
                              },
                            ),
                          ),

                          // Center Target Pin: Vehicle breakdown location
                          AnimatedBuilder(
                            animation: _pulseController,
                            builder: (context, _) {
                              return Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: const Color(0xFFFF5C00),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFFFF5C00).withValues(
                                        alpha: 0.3 + (_pulseController.value * 0.4),
                                      ),
                                      blurRadius: 12 + (_pulseController.value * 8),
                                      spreadRadius: 2,
                                    ),
                                  ],
                                  border: Border.all(color: Colors.white, width: 3),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.two_wheeler_rounded,
                                    color: Colors.white,
                                    size: 22,
                                  ),
                                ),
                              );
                            },
                          ),

                          // Match Success Popover: Kang Asep's Avatar
                          if (_isMatched)
                            TweenAnimationBuilder<double>(
                              tween: Tween(begin: 0.0, end: 1.0),
                              duration: const Duration(milliseconds: 600),
                              curve: Curves.elasticOut,
                              builder: (context, val, child) {
                                return Transform.scale(
                                  scale: val,
                                  child: child,
                                );
                              },
                              child: Container(
                                width: 84,
                                height: 84,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: const Color(0xFF10B981), width: 4),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF10B981).withValues(alpha: 0.5),
                                      blurRadius: 18,
                                      spreadRadius: 3,
                                    ),
                                  ],
                                ),
                                child: ClipOval(
                                  child: Image.asset(
                                    'assets/images/kang_asep.png',
                                    fit: BoxFit.cover,
                                    errorBuilder: (ctx, err, stack) => Container(
                                      color: const Color(0xFFFF5C00),
                                      child: const Icon(
                                        Icons.person,
                                        color: Colors.white,
                                        size: 40,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Status Card & Progress Updates
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: _isMatched
                          ? const Color(0xFF10B981)
                          : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                      width: _isMatched ? 1.8 : 1.0,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: _isMatched
                            ? const Color(0xFF10B981).withValues(alpha: 0.15)
                            : Colors.black.withValues(alpha: isDark ? 0.25 : 0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              color: _isMatched
                                  ? const Color(0xFFDCFCE7)
                                  : const Color(0xFFFFEDD5),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              _isMatched
                                  ? Icons.check_circle_rounded
                                  : Icons.sensors_rounded,
                              color: _isMatched
                                  ? const Color(0xFF16A34A)
                                  : const Color(0xFFFF5C00),
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _statusText,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w800,
                                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  _subStatusText,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: isDark
                                        ? AppColors.textSecondaryDark
                                        : const Color(0xFF64748B),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Divider(height: 1),
                      const SizedBox(height: 10),
                      // Vehicle & Issue Mini Pill
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.motorcycle_rounded,
                                size: 14,
                                color: Color(0xFFFF5C00),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                '${widget.vehicle.name} (${widget.vehicle.plateNumber})',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFEDD5),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              widget.issueTitle,
                              style: const TextStyle(
                                fontSize: 9.5,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFFEA580C),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Bottom Cancel Button
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                child: SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton(
                    onPressed: _cancelSearch,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFEF4444),
                      side: const BorderSide(color: Color(0xFFFECACA), width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.close_rounded, size: 16),
                        SizedBox(width: 6),
                        Text(
                          'Batalkan Pencarian',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Custom Radar Search Canvas Painter
// -----------------------------------------------------------------------------
class _RadarSearchPainter extends CustomPainter {
  final bool isDark;
  final double radarAngle;
  final double pulseValue;
  final int secondsLeft;
  final bool isMatched;

  _RadarSearchPainter({
    required this.isDark,
    required this.radarAngle,
    required this.pulseValue,
    required this.secondsLeft,
    required this.isMatched,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width / 2;

    // 1. Radar Background Circle
    final bgPaint = Paint()
      ..color = isDark ? const Color(0xFF0F172A) : const Color(0xFFE2E8F0).withValues(alpha: 0.5)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, maxRadius, bgPaint);

    // 2. Concentric Range Grid Rings (1km, 2km, 3km)
    final ringPaint = Paint()
      ..color = isDark
          ? const Color(0xFF334155).withValues(alpha: 0.4)
          : const Color(0xFF94A3B8).withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    canvas.drawCircle(center, maxRadius * 0.35, ringPaint);
    canvas.drawCircle(center, maxRadius * 0.65, ringPaint);
    canvas.drawCircle(center, maxRadius * 0.95, ringPaint);

    // 3. Crosshairs Lines
    final crossPaint = Paint()
      ..color = isDark
          ? const Color(0xFF334155).withValues(alpha: 0.35)
          : const Color(0xFF94A3B8).withValues(alpha: 0.25)
      ..strokeWidth = 1.0;

    canvas.drawLine(Offset(center.dx, 0), Offset(center.dx, size.height), crossPaint);
    canvas.drawLine(Offset(0, center.dy), Offset(size.width, center.dy), crossPaint);

    // 4. Expanding Beacon Radar Ripples from center
    for (int i = 0; i < 3; i++) {
      final waveProgress = ((pulseValue + (i * 0.33)) % 1.0);
      final waveRadius = (maxRadius * 0.2) + (waveProgress * (maxRadius * 0.75));
      final alpha = (1.0 - waveProgress) * 0.35;

      final wavePaint = Paint()
        ..color = const Color(0xFFFF5C00).withValues(alpha: alpha)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5;
      canvas.drawCircle(center, waveRadius, wavePaint);
    }

    // 5. Rotating Radar Scanner Beam (360° Sweep Cone)
    if (!isMatched) {
      final sweepPaint = Paint()
        ..shader = SweepGradient(
          center: Alignment.center,
          startAngle: 0.0,
          endAngle: 0.6,
          colors: [
            const Color(0xFFFF5C00).withValues(alpha: 0.0),
            const Color(0xFFFF7A00).withValues(alpha: 0.28),
          ],
        ).createShader(Rect.fromCircle(center: center, radius: maxRadius));

      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate(radarAngle);
      canvas.drawArc(
        Rect.fromCircle(center: Offset.zero, radius: maxRadius * 0.95),
        0,
        0.6,
        true,
        sweepPaint,
      );
      canvas.restore();
    }

    // 6. Candidate Standby Mechanics (Blips)
    // Blip 1: AHASS Cihampelas (Top Left)
    final blip1 = Offset(center.dx - (maxRadius * 0.52), center.dy - (maxRadius * 0.40));
    _drawMechanicBlip(canvas, blip1, 'M1', const Color(0xFF10B981));

    // Blip 2: Montir Siaga Djuanda (Bottom Left)
    final blip2 = Offset(center.dx - (maxRadius * 0.42), center.dy + (maxRadius * 0.45));
    _drawMechanicBlip(canvas, blip2, 'M2', const Color(0xFF10B981));

    // Blip 3: Kang Asep (Target Matched) (Right Center)
    final blipKangAsep = Offset(center.dx + (maxRadius * 0.50), center.dy - (maxRadius * 0.15));
    _drawMechanicBlip(
      canvas,
      blipKangAsep,
      'Asep',
      const Color(0xFFFF5C00),
      isLocked: secondsLeft <= 3,
    );

    // Lock-on Reticle on Kang Asep when close to match
    if (secondsLeft <= 3) {
      final reticlePaint = Paint()
        ..color = isMatched ? const Color(0xFF10B981) : const Color(0xFFFF5C00)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;

      final reticleRadius = 18.0 + (pulseValue * 3.0);
      canvas.drawCircle(blipKangAsep, reticleRadius, reticlePaint);
    }
  }

  void _drawMechanicBlip(
    Canvas canvas,
    Offset pos,
    String label,
    Color color, {
    bool isLocked = false,
  }) {
    // Pulse ring
    final halo = Paint()
      ..color = color.withValues(alpha: 0.3)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(pos, 10, halo);

    // Blip body
    final blipPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    canvas.drawCircle(pos, 6, blipPaint);

    final border = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8;
    canvas.drawCircle(pos, 6, border);
  }

  @override
  bool shouldRepaint(covariant _RadarSearchPainter oldDelegate) => true;
}
