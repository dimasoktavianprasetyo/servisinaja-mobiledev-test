import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/vehicle_model.dart';
import '../../../data/models/service_model.dart';
import '../../controllers/app_controller.dart';
import 'booking_success_ticket_screen.dart';

class BookingConfirmScreen extends StatefulWidget {
  final AppController controller;
  final VehicleModel? vehicle;
  final ServiceModel? service;
  final DateTime? scheduleDate;
  final String scheduleTime;
  final String workshopName;
  final String workshopAddress;
  final String workshopDistance;
  final String armadaOption;
  final int? totalPrice;
  final List<Map<String, dynamic>>? vehicles;

  const BookingConfirmScreen({
    super.key,
    required this.controller,
    this.vehicle,
    this.service,
    this.scheduleDate,
    required this.scheduleTime,
    required this.workshopName,
    this.workshopAddress = 'Jl. Asia Afrika No. 17, Kota Bandung',
    this.workshopDistance = '3.2 km',
    this.armadaOption = 'Pengerjaan Bersamaan: 2 Pit Dipesan Sekaligus',
    this.totalPrice,
    this.vehicles,
  });

  @override
  State<BookingConfirmScreen> createState() => _BookingConfirmScreenState();
}

class _BookingConfirmScreenState extends State<BookingConfirmScreen> {
  bool _isProcessing = false;

  // Dynamic breakdown values based on widget.vehicles
  int get _serviceFee {
    if (widget.vehicles != null && widget.vehicles!.isNotEmpty) {
      const pkgPrices = [85000, 60000, 75000];
      int total = 0;
      for (final v in widget.vehicles!) {
        final idx = (v['selectedPackageIndex'] as int?) ?? 0;
        if (idx >= 0 && idx < pkgPrices.length) {
          total += pkgPrices[idx];
        } else {
          total += 85000;
        }
      }
      return total;
    }
    return 145000;
  }

  int get _sparepartFee {
    if (widget.vehicles != null && widget.vehicles!.isNotEmpty) {
      int total = 0;
      for (final v in widget.vehicles!) {
        final parts = (v['parts'] as List<dynamic>?) ?? [];
        final selectedParts = (v['selectedParts'] as Iterable<dynamic>?) ?? [];
        for (final pIdx in selectedParts) {
          if (pIdx is int && pIdx >= 0 && pIdx < parts.length) {
            final p = parts[pIdx];
            if (p is Map) {
              total += (p['price'] as int?) ?? 0;
            }
          }
        }
      }
      return total;
    }
    return 110000;
  }

  int get _appFee => 2000;

  int get _discountVoucher {
    if (widget.vehicles != null && widget.vehicles!.length <= 1) {
      return 0;
    }
    return 25000;
  }

  int get _calculatedTotal => _serviceFee + _sparepartFee + _appFee - _discountVoucher;

  String _formatCurrency(int? amount) {
    if (amount == null) return 'Rp 0';
    final str = amount.toString();
    final buffer = StringBuffer();
    int count = 0;
    for (int i = str.length - 1; i >= 0; i--) {
      buffer.write(str[i]);
      count++;
      if (count % 3 == 0 && i > 0) buffer.write('.');
    }
    return 'Rp ${buffer.toString().split('').reversed.join('')}';
  }

  void _showTermsDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Row(
          children: [
            Icon(Icons.description_outlined, color: Color(0xFFF97316), size: 22),
            SizedBox(width: 8),
            Text(
              'Syarat & Ketentuan Servis',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
            ),
          ],
        ),
        content: const SingleChildScrollView(
          child: Text(
            '1. Harap tiba di bengkel mitra AHASS minimal 10 menit sebelum jadwal pengerjaan.\n\n'
            '2. Estimasi biaya dapat disesuaikan jika montir menemukan penggantian komponen tambahan saat inspeksi dengan persetujuan pemilik kendaraan.\n\n'
            '3. Garansi servis berlaku hingga 7 hari kalender atau 500 km sejak unit selesai dikerjakan.',
            style: TextStyle(fontSize: 12.5, height: 1.5, color: Color(0xFF475569)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Saya Mengerti',
              style: TextStyle(color: Color(0xFFF97316), fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }

  void _onConfirmBooking() {
    setState(() => _isProcessing = true);

    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;

      final veh = widget.vehicle ?? widget.controller.selectedVehicle;
      final srv = widget.service ??
          (widget.controller.services.isNotEmpty ? widget.controller.services.first : null);

      if (srv != null) {
        widget.controller.createBooking(
          vehicle: veh,
          service: srv,
          date: widget.scheduleDate ?? DateTime.now(),
          time: widget.scheduleTime,
        );
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => BookingSuccessTicketScreen(
            controller: widget.controller,
            bookingCode: 'SRV-2026-MULTI09',
            workshopName: widget.workshopName,
            workshopDistance: widget.workshopDistance,
            scheduleDateTimeStr: 'Kamis, 26 Sep 2026 • ${widget.scheduleTime}',
            totalPrice: _calculatedTotal,
            serviceFee: _serviceFee,
            sparepartFee: _sparepartFee,
            appFee: _appFee,
            discountVoucher: _discountVoucher,
            vehicles: widget.vehicles,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.controller.isDarkMode;
    const primaryColor = Color(0xFFF97316);

    return Scaffold(
      backgroundColor: isDark ? AppColors.bgDark : const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            color: isDark ? Colors.white : const Color(0xFF0F172A),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        titleSpacing: 0,
        title: Text(
          'Konfirmasi Booking',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: isDark ? Colors.white : const Color(0xFF0F172A),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Stepper Bar (Step 3 Active)
            Container(
              color: isDark ? AppColors.surfaceDark : Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Step 1: Done
                  _buildStepItem(
                    stepNumber: '1',
                    title: 'Unit & Servis',
                    isActive: false,
                    isDone: true,
                    labelColor: const Color(0xFF16A34A),
                    activeColor: primaryColor,
                    isDark: isDark,
                  ),
                  _buildStepConnector(isDone: true),

                  // Step 2: Done (Checkmark with Orange text label)
                  _buildStepItem(
                    stepNumber: '2',
                    title: 'Bengkel & Waktu',
                    isActive: false,
                    isDone: true,
                    labelColor: primaryColor,
                    activeColor: primaryColor,
                    isDark: isDark,
                  ),
                  _buildStepConnector(isDone: false),

                  // Step 3: Active (Current screen)
                  _buildStepItem(
                    stepNumber: '3',
                    title: 'Konfirmasi',
                    isActive: true,
                    isDone: false,
                    labelColor: const Color(0xFF94A3B8),
                    activeColor: primaryColor,
                    isDark: isDark,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Main Content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // CARD 1: Bengkel & Jadwal
                  _buildCardBengkelJadwal(isDark, primaryColor),

                  const SizedBox(height: 14),

                  // CARD 2: Rincian Motor & Pengerjaan
                  _buildCardRincianMotor(isDark, primaryColor),

                  const SizedBox(height: 14),

                  // CARD 3: Rincian Pembayaran
                  _buildCardRincianPembayaran(isDark, primaryColor),

                  const SizedBox(height: 14),

                  // CARD 4: Metode Pembayaran
                  _buildCardMetodePembayaran(isDark, primaryColor),

                  const SizedBox(height: 16),

                  // Terms and conditions disclaimer text
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text.rich(
                        TextSpan(
                          text: 'Dengan menekan tombol pesan, Anda menyetujui ',
                          style: TextStyle(
                            fontSize: 10.5,
                            color: isDark ? AppColors.textSecondaryDark : const Color(0xFF64748B),
                          ),
                          children: [
                            TextSpan(
                              text: 'Syarat &\nKetentuan Servis',
                              style: const TextStyle(
                                fontSize: 10.5,
                                color: primaryColor,
                                fontWeight: FontWeight.w700,
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()..onTap = _showTermsDialog,
                            ),
                            TextSpan(
                              text: ' yang berlaku.',
                              style: TextStyle(
                                fontSize: 10.5,
                                color: isDark ? AppColors.textSecondaryDark : const Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),

      // Sticky Bottom Navigation Bar
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : Colors.white,
          border: Border(
            top: BorderSide(
              color: isDark ? AppColors.borderDark : const Color(0xFFE2E8F0),
              width: 1.2,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.05),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              // Left: Total Label & Price
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'TOTAL TAGIHAN',
                    style: TextStyle(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                      color: Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _formatCurrency(_calculatedTotal),
                    style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w900,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),

              // Right: Button Konfirmasi & Buat Pesanan
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: _isProcessing ? null : _onConfirmBooking,
                  child: _isProcessing
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Text(
                                'Konfirmasi & Buat Pesanan',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            SizedBox(width: 5),
                            Icon(
                              Icons.arrow_forward_rounded,
                              size: 16,
                            ),
                          ],
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // -------------------------------------------------------------
  // Card 1: Bengkel & Jadwal Kedatangan
  // -------------------------------------------------------------
  Widget _buildCardBengkelJadwal(bool isDark, Color primaryColor) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.borderDark : const Color(0xFFE2E8F0),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Storefront Icon + Name + Address + Distance
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: const Color(0xFFEA580C),
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.storefront_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.workshopName,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.workshopAddress,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  widget.workshopDistance,
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white70 : const Color(0xFF64748B),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Rating & Badge Bengkel Resmi Honda
          Row(
            children: [
              const Icon(Icons.star_rounded, color: Color(0xFFF59E0B), size: 15),
              const SizedBox(width: 3),
              Text(
                '4.8',
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w800,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
              const SizedBox(width: 2),
              const Text(
                '(11.2rb) •',
                style: TextStyle(
                  fontSize: 10.5,
                  color: Color(0xFF64748B),
                ),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF7ED),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: const Color(0xFFFFEDD5)),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.verified_rounded, size: 11, color: Color(0xFFEA580C)),
                    SizedBox(width: 3),
                    Text(
                      'Bengkel Resmi Honda',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFEA580C),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Jadwal Kedatangan Sub-box
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark ? AppColors.borderDark : const Color(0xFFE2E8F0),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.calendar_today_rounded,
                  size: 16,
                  color: Color(0xFF64748B),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'JADWAL KEDATANGAN',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                          color: Color(0xFF94A3B8),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Kamis, 26 Sep 2026 • ${widget.scheduleTime}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () => Navigator.pop(context),
                  borderRadius: BorderRadius.circular(6),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    child: Text(
                      'Ubah →',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFF97316),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // Alert banner: Pengerjaan Bersamaan
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFBEB),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFFEF3C7)),
            ),
            child: Row(
              children: [
                const Icon(Icons.bolt_rounded, color: Color(0xFFD97706), size: 15),
                const SizedBox(width: 5),
                Expanded(
                  child: Text(
                    widget.armadaOption,
                    style: const TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFB45309),
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

  // -------------------------------------------------------------
  // Card 2: Rincian Motor & Pengerjaan
  // -------------------------------------------------------------
  Widget _buildCardRincianMotor(bool isDark, Color primaryColor) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.borderDark : const Color(0xFFE2E8F0),
          width: 1.0,
        ),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: Color(0xFFF97316),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 7),
              Text(
                'Rincian Motor & Pengerjaan',
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w800,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2.5),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF7ED),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  '2 Unit Motor',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFEA580C),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Unit 1: Honda Vario 160 (Pit 1)
          _buildUnitDetails(
            isDark: isDark,
            motorName: 'Honda Vario 160',
            plateNumber: 'B 1234 XYZ',
            pitNumber: 'Pit 1',
            services: [
              {'name': 'Servis Berkala Lengkap', 'price': 85000},
              {'name': 'Oli Mesin AHM SPX2', 'price': 65000},
            ],
            subtotal: 150000,
            unitLabel: 'Subtotal Unit 1',
          ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(height: 1, color: Color(0xFFF1F5F9)),
          ),

          // Unit 2: Honda BeAT (Pit 2)
          _buildUnitDetails(
            isDark: isDark,
            motorName: 'Honda BeAT',
            plateNumber: 'B 5678 ABC',
            pitNumber: 'Pit 2',
            services: [
              {'name': 'Servis CVT & Pelumasan', 'price': 60000},
              {'name': 'Kampas Rem Belakang Original', 'price': 45000},
            ],
            subtotal: 105000,
            unitLabel: 'Subtotal Unit 2',
          ),
        ],
      ),
    );
  }

  Widget _buildUnitDetails({
    required bool isDark,
    required String motorName,
    required String plateNumber,
    required String pitNumber,
    required List<Map<String, dynamic>> services,
    required int subtotal,
    required String unitLabel,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title row
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.two_wheeler_rounded,
                size: 13,
                color: Color(0xFF64748B),
              ),
            ),
            const SizedBox(width: 7),
            Text(
              motorName,
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w800,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                plateNumber,
                style: const TextStyle(
                  fontSize: 9.5,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF64748B),
                ),
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFFDCFCE7),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                pitNumber,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF16A34A),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        // Services list
        ...services.map((s) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '• ${s['name']}',
                    style: TextStyle(
                      fontSize: 11,
                      color: isDark ? AppColors.textSecondaryDark : const Color(0xFF475569),
                    ),
                  ),
                ),
                Text(
                  _formatCurrency(s['price'] as int),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
              ],
            ),
          );
        }),

        const SizedBox(height: 4),

        // Subtotal row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              unitLabel,
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF64748B),
              ),
            ),
            Text(
              _formatCurrency(subtotal),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // -------------------------------------------------------------
  // Card 3: Rincian Pembayaran
  // -------------------------------------------------------------
  Widget _buildCardRincianPembayaran(bool isDark, Color primaryColor) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.borderDark : const Color(0xFFE2E8F0),
          width: 1.0,
        ),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Rincian Pembayaran',
            style: TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w800,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 10),

          // Total Jasa Servis
          _buildPaymentRow(
            label: 'Total Biaya Jasa Servis',
            value: _formatCurrency(_serviceFee),
            isDark: isDark,
          ),
          const SizedBox(height: 5),

          // Total Sparepart & Oli
          _buildPaymentRow(
            label: 'Total Sparepart & Oli',
            value: _formatCurrency(_sparepartFee),
            isDark: isDark,
          ),
          const SizedBox(height: 5),

          // Biaya Layanan Aplikasi
          _buildPaymentRow(
            label: 'Biaya Layanan Aplikasi',
            value: _formatCurrency(_appFee),
            isDark: isDark,
          ),
          const SizedBox(height: 10),

          // Voucher Promo Multi-Motor (30%)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF0FDF4),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFBBF7D0)),
            ),
            child: const Row(
              children: [
                Icon(Icons.discount_outlined, color: Color(0xFF16A34A), size: 15),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Voucher Promo Multi-Motor (30%)',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF16A34A),
                    ),
                  ),
                ),
                Text(
                  '-Rp 25.000',
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF16A34A),
                  ),
                ),
              ],
            ),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(height: 1, color: Color(0xFFF1F5F9)),
          ),

          // Total Biaya Perkiraan
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Biaya Perkiraan',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w800,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 1),
                    const Text(
                      'Dapat berubah jika ada tambahan di bengkel',
                      style: TextStyle(
                        fontSize: 9.5,
                        color: Color(0xFF94A3B8),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                _formatCurrency(_calculatedTotal),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: primaryColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentRow({required String label, required String value, required bool isDark}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11.5,
            color: isDark ? AppColors.textSecondaryDark : const Color(0xFF64748B),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : const Color(0xFF0F172A),
          ),
        ),
      ],
    );
  }

  // -------------------------------------------------------------
  // Card 4: Metode Pembayaran
  // -------------------------------------------------------------
  Widget _buildCardMetodePembayaran(bool isDark, Color primaryColor) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.borderDark : const Color(0xFFE2E8F0),
          width: 1.0,
        ),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Metode Pembayaran',
            style: TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w800,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 10),

          // Radio option container (Bayar di Bengkel)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF281C14) : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: primaryColor,
                width: 1.5,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.radio_button_checked,
                      color: primaryColor,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Bayar di Bengkel (Tunai / QRIS)',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w800,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    // QRIS Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: isDark ? AppColors.borderDark : const Color(0xFFE2E8F0),
                        ),
                      ),
                      child: const Text(
                        'QRIS',
                        style: TextStyle(
                          fontSize: 8.5,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    // CASH Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: isDark ? AppColors.borderDark : const Color(0xFFE2E8F0),
                        ),
                      ),
                      child: const Text(
                        'CASH',
                        style: TextStyle(
                          fontSize: 8.5,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 28, top: 4),
                  child: Text(
                    'Bayar langsung ke kasir AHASS setelah seluruh pengerjaan selesai di inspeksi.',
                    style: TextStyle(
                      fontSize: 10.5,
                      color: Color(0xFF64748B),
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

  // -------------------------------------------------------------
  // Stepper Items & Connectors
  // -------------------------------------------------------------
  Widget _buildStepItem({
    required String stepNumber,
    required String title,
    required bool isActive,
    required bool isDone,
    required Color labelColor,
    required Color activeColor,
    required bool isDark,
  }) {
    const doneColor = Color(0xFF16A34A);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 26,
          height: 26,
          decoration: BoxDecoration(
            color: isDone
                ? const Color(0xFFDCFCE7)
                : (isActive
                    ? activeColor
                    : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0))),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: isDone
              ? const Icon(
                  Icons.check_rounded,
                  color: doneColor,
                  size: 16,
                )
              : Text(
                  stepNumber,
                  style: TextStyle(
                    color: isActive ? Colors.white : const Color(0xFF94A3B8),
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
        ),
        const SizedBox(height: 6),
        Text(
          title,
          style: TextStyle(
            color: labelColor,
            fontSize: 10,
            fontWeight: (isActive || isDone) ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildStepConnector({required bool isDone}) {
    return Container(
      width: 32,
      height: 1.5,
      margin: const EdgeInsets.only(bottom: 16, left: 6, right: 6),
      color: isDone ? const Color(0xFF16A34A) : const Color(0xFFE2E8F0),
    );
  }
}
