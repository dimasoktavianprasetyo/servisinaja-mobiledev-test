import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';
import '../../controllers/app_controller.dart';
import '../chat/chat_montir_screen.dart';

class BookingSuccessTicketScreen extends StatefulWidget {
  final AppController controller;
  final String? bookingCode;
  final String? workshopName;
  final String? workshopDistance;
  final String? scheduleDateTimeStr;
  final int? totalPrice;
  final int? serviceFee;
  final int? sparepartFee;
  final int? appFee;
  final int? discountVoucher;
  final List<Map<String, dynamic>>? vehicles;

  const BookingSuccessTicketScreen({
    super.key,
    required this.controller,
    this.bookingCode,
    this.workshopName,
    this.workshopDistance,
    this.scheduleDateTimeStr,
    this.totalPrice,
    this.serviceFee,
    this.sparepartFee,
    this.appFee,
    this.discountVoucher,
    this.vehicles,
  });

  @override
  State<BookingSuccessTicketScreen> createState() => _BookingSuccessTicketScreenState();
}

class _BookingSuccessTicketScreenState extends State<BookingSuccessTicketScreen> {
  static const Color primaryColor = Color(0xFFF97316);

  String get _bookingCode => widget.bookingCode ?? 'SRV-2026-MULTI09';
  String get _workshopName => widget.workshopName ?? 'AHASS Servisin Mitra Cihampelas';
  String get _workshopDistance => widget.workshopDistance ?? '1.2 km';
  String get _scheduleDateTime => widget.scheduleDateTimeStr ?? 'Kamis, 26 Sep 2026 • 09:30 WIB';

  // Dynamic fee calculation based on widget or vehicles
  int get _serviceFee {
    if (widget.serviceFee != null) return widget.serviceFee!;
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
    if (widget.sparepartFee != null) return widget.sparepartFee!;
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

  int get _appFee => widget.appFee ?? 2000;

  int get _discountVoucher {
    if (widget.discountVoucher != null) return widget.discountVoucher!;
    if (widget.vehicles != null && widget.vehicles!.length <= 1) return 0;
    return 25000;
  }

  int get _totalPrice {
    if (widget.totalPrice != null) return widget.totalPrice!;
    return _serviceFee + _sparepartFee + _appFee - _discountVoucher;
  }

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

  void _copyBookingCode() {
    Clipboard.setData(ClipboardData(text: _bookingCode));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Text('Kode booking $_bookingCode disalin!'),
          ],
        ),
        backgroundColor: const Color(0xFF0F172A),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showSaveOrShareOptions(bool isDark) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.surfaceDark : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.5 : 0.15),
                blurRadius: 20,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top drag pill
                Center(
                  child: Container(
                    width: 44,
                    height: 4.5,
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF475569) : const Color(0xFFCBD5E1),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
                const SizedBox(height: 18),

                // Title & Subtitle (No icon)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Simpan atau Bagikan Tiket',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 3),
                    const Text(
                      'Pilih format penyimpanan untuk bukti ke bengkel',
                      style: TextStyle(
                        fontSize: 11.5,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                // Option 1: Simpan sebagai Gambar (PNG)
                _buildExportOptionCard(
                  isDark: isDark,
                  icon: Icons.image_rounded,
                  iconBgColor: const Color(0xFFEFF6FF),
                  iconColor: const Color(0xFF2563EB),
                  title: 'Simpan Gambar Tiket (PNG)',
                  subtitle: 'Format gambar siap simpan ke Galeri atau kirim via WA',
                  onTap: () {
                    Navigator.pop(ctx);
                    _handleExportImage();
                  },
                ),

                const SizedBox(height: 10),

                // Option 2: Unduh Dokumen PDF
                _buildExportOptionCard(
                  isDark: isDark,
                  icon: Icons.picture_as_pdf_rounded,
                  iconBgColor: const Color(0xFFFEF2F2),
                  iconColor: const Color(0xFFDC2626),
                  title: 'Unduh Dokumen PDF Resmi',
                  subtitle: 'Format PDF lengkap rincian armada, barcode & invoice',
                  onTap: () {
                    Navigator.pop(ctx);
                    _handleExportPdf();
                  },
                ),

                const SizedBox(height: 10),

                // Option 3: Bagikan Tautan
                _buildExportOptionCard(
                  isDark: isDark,
                  icon: Icons.link_rounded,
                  iconBgColor: const Color(0xFFF0FDF4),
                  iconColor: const Color(0xFF16A34A),
                  title: 'Salin & Bagikan Tautan',
                  subtitle: 'Tautan online langsung menuju tiket servis ini',
                  onTap: () {
                    Navigator.pop(ctx);
                    _handleShareLink();
                  },
                ),

                const SizedBox(height: 14),

                // Cancel button
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Tutup',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white60 : const Color(0xFF64748B),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _handleExportImage() {
    _showProcessingSnackbar(
      loadingMessage: 'Menyiapkan gambar tiket...',
      successMessage: 'Tiket berhasil disimpan ke Galeri (servisin-$_bookingCode.png)!',
      icon: Icons.image_rounded,
      accentColor: const Color(0xFF2563EB),
    );
  }

  void _handleExportPdf() {
    _showProcessingSnackbar(
      loadingMessage: 'Menyusun dokumen PDF resmi...',
      successMessage: 'Dokumen PDF berhasil diunduh (Tiket_Servis_$_bookingCode.pdf)!',
      icon: Icons.picture_as_pdf_rounded,
      accentColor: const Color(0xFFDC2626),
    );
  }

  void _handleShareLink() {
    final link = 'https://servisinaja.id/ticket/$_bookingCode';
    Clipboard.setData(ClipboardData(text: link));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Tautan tiket berhasil disalin: $link',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF16A34A),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showProcessingSnackbar({
    required String loadingMessage,
    required String successMessage,
    required IconData icon,
    required Color accentColor,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            const SizedBox(width: 12),
            Text(loadingMessage),
          ],
        ),
        backgroundColor: const Color(0xFF1E293B),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(milliseconds: 900),
      ),
    );

    Future.delayed(const Duration(milliseconds: 950), () {
      if (!mounted) return;
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle_rounded, color: Colors.white, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  successMessage,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          backgroundColor: accentColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          duration: const Duration(seconds: 3),
        ),
      );
    });
  }

  Widget _buildExportOptionCard({
    required bool isDark,
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isDark ? AppColors.borderDark : const Color(0xFFE2E8F0),
            width: 1.0,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 10.5,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14,
              color: Color(0xFF94A3B8),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateHome() {
    widget.controller.setNavIndex(0);
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  void _navigateToTracking() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChatMontirScreen(controller: widget.controller),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
            // Left: Circular Close Button (x)
            InkWell(
              onTap: _navigateHome,
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
                      color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Icon(
                  Icons.close_rounded,
                  size: 19,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  'Tiket Servis',
                  style: TextStyle(
                    fontSize: 16.5,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
              ),
            ),
            // Right: Circular Share Button
            InkWell(
              onTap: () => _showSaveOrShareOptions(isDark),
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
                      color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Icon(
                  Icons.share_outlined,
                  size: 18,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Column(
          children: [
            // 1. Success Celebration Section
            _buildCelebrationHeader(isDark),

            const SizedBox(height: 18),

            // 2. The Boarding Pass Ticket Card
            _buildTicketCard(isDark),

            const SizedBox(height: 20),

            // 3. Status Armada Section
            _buildArmadaStatusSection(isDark),

            const SizedBox(height: 16),

            // 4. Rincian Pembayaran Card (Payment Breakdown & Total)
            _buildCardRincianPembayaran(isDark),

            const SizedBox(height: 14),

            // 5. Helpful Notice / Warning Box
            _buildNoticeBox(isDark),

            const SizedBox(height: 24),
          ],
        ),
      ),

      // Sticky Bottom Navigation Bar
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
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
              color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.04),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Primary CTA Button: Pantau Status Servis
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(26),
                    ),
                  ),
                  onPressed: _navigateToTracking,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Pantau Status Servis (Live Tracking)',
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(width: 6),
                      Icon(Icons.arrow_forward_rounded, size: 16),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // Secondary Button: Kembali ke Beranda
              SizedBox(
                width: double.infinity,
                height: 44,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: isDark ? Colors.white : const Color(0xFF0F172A),
                    side: BorderSide(
                      color: isDark ? AppColors.borderDark : const Color(0xFFE2E8F0),
                      width: 1.2,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  onPressed: _navigateHome,
                  child: const Text(
                    'Kembali ke Beranda',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
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

  // ---------------------------------------------------------------------------
  // 1. Success Celebration Header
  // ---------------------------------------------------------------------------
  Widget _buildCelebrationHeader(bool isDark) {
    return Column(
      children: [
        // Multi-particle celebration badge (vector rendered, zero 404)
        _buildCelebrationBadge(),

        const SizedBox(height: 12),

        // Heading
        Text(
          'Yeay.. Booking Berhasil Dibuat!',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w900,
            color: isDark ? Colors.white : const Color(0xFF0F172A),
          ),
        ),

        const SizedBox(height: 5),

        // Subtitle
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'Tunjukkan tiket & QR Code ini kepada petugas bengkel saat kedatangan.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11.5,
              height: 1.45,
              color: isDark ? AppColors.textSecondaryDark : const Color(0xFF64748B),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCelebrationBadge() {
    return SizedBox(
      width: 86,
      height: 86,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Confetti Particle Dots
          // Top-left orange dot
          const Positioned(
            top: 6,
            left: 14,
            child: DecoratedBox(
              decoration: BoxDecoration(color: Color(0xFFF97316), shape: BoxShape.circle),
              child: SizedBox(width: 7, height: 7),
            ),
          ),
          // Top-right yellow dot
          const Positioned(
            top: 10,
            right: 12,
            child: DecoratedBox(
              decoration: BoxDecoration(color: Color(0xFFFBBF24), shape: BoxShape.circle),
              child: SizedBox(width: 8, height: 8),
            ),
          ),
          // Mid-left cyan dot
          const Positioned(
            top: 38,
            left: 4,
            child: DecoratedBox(
              decoration: BoxDecoration(color: Color(0xFF06B6D4), shape: BoxShape.circle),
              child: SizedBox(width: 6, height: 6),
            ),
          ),
          // Mid-right cyan/blue dot
          const Positioned(
            top: 40,
            right: 4,
            child: DecoratedBox(
              decoration: BoxDecoration(color: Color(0xFF0EA5E9), shape: BoxShape.circle),
              child: SizedBox(width: 7, height: 7),
            ),
          ),
          // Bottom-left green dot
          const Positioned(
            bottom: 8,
            left: 18,
            child: DecoratedBox(
              decoration: BoxDecoration(color: Color(0xFF10B981), shape: BoxShape.circle),
              child: SizedBox(width: 6, height: 6),
            ),
          ),
          // Bottom-right orange dot
          const Positioned(
            bottom: 12,
            right: 16,
            child: DecoratedBox(
              decoration: BoxDecoration(color: Color(0xFFFB923C), shape: BoxShape.circle),
              child: SizedBox(width: 6, height: 6),
            ),
          ),

          // Outer Mint Glowing Ring
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: const Color(0xFFDCFCE7),
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFFBBF7D0).withValues(alpha: 0.7),
                width: 3.5,
              ),
            ),
          ),

          // Inner Vibrant Green Disc with Checkmark
          Container(
            width: 52,
            height: 52,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF10B981),
                  Color(0xFF059669),
                ],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Color(0x3310B981),
                  blurRadius: 10,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.check_rounded,
              color: Colors.white,
              size: 32,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 2. The Boarding Pass Ticket Card
  // ---------------------------------------------------------------------------
  Widget _buildTicketCard(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isDark ? AppColors.borderDark : const Color(0xFFE2E8F0),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Upper Ticket Section (Brand & QR Code)
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Top Row: Logo + Auto Confirmation Tag
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Brand / Logo
                    Row(
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF7ED),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFFFFEDD5)),
                          ),
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.auto_awesome_rounded,
                            size: 15,
                            color: Color(0xFFF97316),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                text: 'Servisin',
                                style: TextStyle(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w900,
                                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                                ),
                                children: const [
                                  TextSpan(
                                    text: 'Aja',
                                    style: TextStyle(
                                      color: primaryColor,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Text(
                              'OFFICIAL TICKET',
                              style: TextStyle(
                                fontSize: 8,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.6,
                                color: Color(0xFF94A3B8),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    // Konfirmasi Otomatis Pill
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0FDF4),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFBBF7D0)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 5.5,
                            height: 5.5,
                            decoration: const BoxDecoration(
                              color: Color(0xFF16A34A),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 5),
                          const Text(
                            'Konfirmasi Otomatis',
                            style: TextStyle(
                              fontSize: 9.5,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF16A34A),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Center QR Code Frame
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0xFFF1F5F9)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Exact Sharp QR Code Graphic (Vector painted, 100% sharp, no 404)
                      const _TicketQrGraphic(size: 148),

                      const SizedBox(height: 12),

                      // Booking Reference Pill with Copy Button
                      InkWell(
                        onTap: _copyBookingCode,
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _bookingCode,
                                style: const TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.8,
                                  color: Color(0xFF334155),
                                ),
                              ),
                              const SizedBox(width: 6),
                              const Icon(
                                Icons.copy_rounded,
                                size: 13,
                                color: Color(0xFF64748B),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                // Hint under QR
                const Text(
                  'Scan untuk check-in kedatangan di bengkel',
                  style: TextStyle(
                    fontSize: 10.5,
                    color: Color(0xFF94A3B8),
                  ),
                ),
              ],
            ),
          ),

          // Dashed Divider with Boarding Pass Cutout Notches
          _buildBoardingPassNotches(isDark),

          // Lower Ticket Section (Bengkel, Jadwal & Multi-Motor Banner)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: Column(
              children: [
                // 1. Bengkel Mitra Row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF7ED),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.storefront_outlined,
                        size: 16,
                        color: Color(0xFFF97316),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'BENGKEL MITRA',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                              color: Color(0xFF94A3B8),
                            ),
                          ),
                          const SizedBox(height: 1),
                          Text(
                            _workshopName,
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w800,
                              color: isDark ? Colors.white : const Color(0xFF0F172A),
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
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _workshopDistance,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white70 : const Color(0xFF64748B),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // 2. Jadwal Kedatangan Row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.calendar_today_outlined,
                        size: 15,
                        color: Color(0xFF2563EB),
                      ),
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
                          const SizedBox(height: 1),
                          Text(
                            _scheduleDateTime,
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w800,
                              color: isDark ? Colors.white : const Color(0xFF0F172A),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // 3. Multi-Motor Service Alert Banner
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF7ED),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFFFEDD5)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 26,
                        height: 26,
                        decoration: const BoxDecoration(
                          color: Color(0xFFEA580C),
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.two_wheeler_rounded,
                          size: 15,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'MULTI-MOTOR SERVICE',
                              style: TextStyle(
                                fontSize: 9.5,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFFEA580C),
                                letterSpacing: 0.5,
                              ),
                            ),
                            SizedBox(height: 1),
                            Text(
                              'Pit 01 & Pit 02 (Pengerjaan Bersama)',
                              style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: const Color(0xFFFDBA74)),
                        ),
                        child: const Text(
                          'Efisien',
                          style: TextStyle(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFFEA580C),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBoardingPassNotches(bool isDark) {
    final bgColor = isDark ? AppColors.bgDark : const Color(0xFFF8FAFC);
    final borderColor = isDark ? AppColors.borderDark : const Color(0xFFE2E8F0);

    return SizedBox(
      height: 24,
      child: Row(
        children: [
          // Left Notch Cutout
          Container(
            width: 12,
            height: 24,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
              border: Border(
                top: BorderSide(color: borderColor, width: 1.0),
                right: BorderSide(color: borderColor, width: 1.0),
                bottom: BorderSide(color: borderColor, width: 1.0),
              ),
            ),
          ),

          // Dashed Divider in Center
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                const dashWidth = 5.0;
                const dashSpace = 4.0;
                final count = (constraints.maxWidth / (dashWidth + dashSpace)).floor();
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(count, (_) {
                    return Container(
                      width: dashWidth,
                      height: 1.2,
                      margin: const EdgeInsets.symmetric(horizontal: dashSpace / 2),
                      color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
                    );
                  }),
                );
              },
            ),
          ),

          // Right Notch Cutout
          Container(
            width: 12,
            height: 24,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
              border: Border(
                top: BorderSide(color: borderColor, width: 1.0),
                left: BorderSide(color: borderColor, width: 1.0),
                bottom: BorderSide(color: borderColor, width: 1.0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 3. Status Armada Section
  // ---------------------------------------------------------------------------
  Widget _buildArmadaStatusSection(bool isDark) {
    final vehicleList = (widget.vehicles != null && widget.vehicles!.isNotEmpty)
        ? widget.vehicles!
        : null;
    final unitCount = vehicleList?.length ?? 2;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Title Row
        Row(
          children: [
            Text(
              'Status Armada',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF7ED),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                '$unitCount Unit Kendaraan',
                style: const TextStyle(
                  fontSize: 9.5,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFEA580C),
                ),
              ),
            ),
            const Spacer(),
            Text(
              'Estimasi: ~${unitCount * 45} Menit',
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Color(0xFF64748B),
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),

        if (vehicleList != null)
          for (int i = 0; i < vehicleList.length; i++) ...[
            if (i > 0) const SizedBox(height: 10),
            _buildDynamicVehicleCard(vehicleList[i], isDark),
          ]
        else ...[
          // Unit 1 Card (Honda Vario 160)
          _buildArmadaUnitCard(
            isDark: isDark,
            motorName: 'Honda Vario 160',
            plateNumber: 'B 1234 XYZ',
            statusText: '• Menunggu Kedatangan',
            packageDesc: 'Servis Berkala & Oli AHM SPX2',
            breakdownSubtext: 'Jasa Rp 85.000 + Part Rp 65.000',
            priceStr: 'Rp 150.000',
          ),

          const SizedBox(height: 10),

          // Unit 2 Card (Honda BeAT)
          _buildArmadaUnitCard(
            isDark: isDark,
            motorName: 'Honda BeAT',
            plateNumber: 'B 5678 ABC',
            statusText: '• Menunggu Kedatangan',
            packageDesc: 'Servis CVT & Kampas Rem',
            breakdownSubtext: 'Jasa Rp 60.000 + Part Rp 45.000',
            priceStr: 'Rp 105.000',
          ),
        ],
      ],
    );
  }

  Widget _buildDynamicVehicleCard(Map<String, dynamic> v, bool isDark) {
    final motorName = (v['name'] as String?) ?? 'Motor Honda';
    final plateNumber = (v['plate'] as String?) ?? 'B 1234 XYZ';

    // Package details
    const pkgNames = ['Servis Berkala', 'Servis CVT', 'Tune Up Injeksi'];
    const pkgPrices = [85000, 60000, 75000];
    final pkgIdx = (v['selectedPackageIndex'] as int?) ?? 0;
    final pkgName = (pkgIdx >= 0 && pkgIdx < pkgNames.length) ? pkgNames[pkgIdx] : 'Servis Berkala';
    final pkgPrice = (pkgIdx >= 0 && pkgIdx < pkgPrices.length) ? pkgPrices[pkgIdx] : 85000;

    // Selected parts
    final parts = (v['parts'] as List<dynamic>?) ?? [];
    final selectedParts = (v['selectedParts'] as Iterable<dynamic>?) ?? [];
    int partsTotal = 0;
    final selectedPartTitles = <String>[];
    for (final pIdx in selectedParts) {
      if (pIdx is int && pIdx >= 0 && pIdx < parts.length) {
        final p = parts[pIdx];
        if (p is Map) {
          partsTotal += (p['price'] as int?) ?? 0;
          final t = p['title']?.toString() ?? '';
          if (t.isNotEmpty) selectedPartTitles.add(t);
        }
      }
    }

    String packageDesc;
    if (selectedPartTitles.isNotEmpty) {
      String partSummary = selectedPartTitles.first;
      if (partSummary.contains('SPX')) {
        partSummary = 'Oli AHM SPX2';
      } else if (partSummary.contains('MPX')) {
        partSummary = 'Oli AHM MPX2';
      } else if (partSummary.contains('Grease') || partSummary.contains('Gemuk')) {
        partSummary = 'Gemuk CVT';
      } else if (partSummary.contains('Kampas Rem')) {
        partSummary = 'Kampas Rem';
      } else if (partSummary.length > 22) {
        partSummary = '${partSummary.substring(0, 20)}...';
      }

      if (selectedPartTitles.length > 1) {
        packageDesc = '$pkgName & $partSummary +${selectedPartTitles.length - 1} part';
      } else {
        packageDesc = '$pkgName & $partSummary';
      }
    } else {
      packageDesc = pkgName;
    }

    final unitTotal = pkgPrice + partsTotal;
    final breakdownSubtext = partsTotal > 0
        ? 'Jasa ${_formatCurrency(pkgPrice)} + Part ${_formatCurrency(partsTotal)}'
        : 'Jasa Servis ${_formatCurrency(pkgPrice)}';

    return _buildArmadaUnitCard(
      isDark: isDark,
      motorName: motorName,
      plateNumber: plateNumber,
      statusText: '• Menunggu Kedatangan',
      packageDesc: packageDesc,
      breakdownSubtext: breakdownSubtext,
      priceStr: _formatCurrency(unitTotal),
    );
  }

  // ---------------------------------------------------------------------------
  // 4. Rincian Pembayaran Card (Payment Breakdown & Total)
  // ---------------------------------------------------------------------------
  Widget _buildCardRincianPembayaran(bool isDark) {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Rincian Pembayaran',
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w800,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2.5),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'Bayar di Bengkel',
                  style: TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF475569),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Total Biaya Jasa Servis
          _buildPaymentRow(
            label: 'Total Jasa Servis (${widget.vehicles?.length ?? 2} Motor)',
            value: _formatCurrency(_serviceFee),
            isDark: isDark,
          ),
          const SizedBox(height: 6),

          // Total Sparepart & Oli
          _buildPaymentRow(
            label: 'Total Sparepart & Oli (${widget.vehicles?.length ?? 2} Motor)',
            value: _formatCurrency(_sparepartFee),
            isDark: isDark,
          ),
          const SizedBox(height: 6),

          // Subtotal Biaya Unit
          _buildPaymentRow(
            label: 'Subtotal Servis & Sparepart',
            value: _formatCurrency(_serviceFee + _sparepartFee),
            isDark: isDark,
          ),
          const SizedBox(height: 6),

          // Biaya Layanan Aplikasi
          _buildPaymentRow(
            label: 'Biaya Layanan Aplikasi',
            value: _formatCurrency(_appFee),
            isDark: isDark,
          ),
          const SizedBox(height: 10),

          // Voucher Promo Multi-Motor (30%)
          if (_discountVoucher > 0) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFF0FDF4),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFBBF7D0)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.discount_outlined, color: Color(0xFF16A34A), size: 15),
                  const SizedBox(width: 8),
                  const Expanded(
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
                    '-${_formatCurrency(_discountVoucher)}',
                    style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF16A34A),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
          ],

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
                      'Total Tagihan / Biaya',
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
                _formatCurrency(_totalPrice),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: primaryColor,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Metode Pembayaran Pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isDark ? AppColors.borderDark : const Color(0xFFE2E8F0),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.payments_outlined,
                  size: 14,
                  color: primaryColor,
                ),
                const SizedBox(width: 6),
                const Text(
                  'Metode:',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF94A3B8),
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  'Bayar di Bengkel (Tunai / QRIS)',
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentRow({
    required String label,
    required String value,
    required bool isDark,
  }) {
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

  Widget _buildArmadaUnitCard({
    required bool isDark,
    required String motorName,
    required String plateNumber,
    required String statusText,
    required String packageDesc,
    required String priceStr,
    String? breakdownSubtext,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.borderDark : const Color(0xFFE2E8F0),
          width: 1.0,
        ),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          // Unit header
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.two_wheeler_rounded,
                  size: 17,
                  color: Color(0xFF64748B),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      motorName,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                    Text(
                      plateNumber,
                      style: const TextStyle(
                        fontSize: 10,
                        color: Color(0xFF94A3B8),
                      ),
                    ),
                  ],
                ),
              ),
              // Blue Status Pill: • Menunggu Kedatangan
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFDBEAFE)),
                ),
                child: Text(
                  statusText,
                  style: const TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2563EB),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Bottom Gray Tinted Box
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          text: 'Paket: ',
                          style: const TextStyle(
                            fontSize: 10.5,
                            color: Color(0xFF94A3B8),
                          ),
                          children: [
                            TextSpan(
                              text: packageDesc,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: isDark ? Colors.white : const Color(0xFF0F172A),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (breakdownSubtext != null && breakdownSubtext.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          breakdownSubtext,
                          style: const TextStyle(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF94A3B8),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  priceStr,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    color: primaryColor,
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
  // 4. Helpful Notice / Warning Box
  // ---------------------------------------------------------------------------
  Widget _buildNoticeBox(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFFEF3C7)),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline_rounded,
            size: 17,
            color: Color(0xFFD97706),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'Mohon hadir 10 menit sebelum jadwal (09:20 WIB) untuk verifikasi mekanik dan penyerahan STNK.',
              style: TextStyle(
                fontSize: 11,
                height: 1.45,
                fontWeight: FontWeight.w600,
                color: Color(0xFF92400E),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// QR Code Graphic Painter (Pixel-perfect replica with center orange accent)
// ---------------------------------------------------------------------------
class _TicketQrGraphic extends StatelessWidget {
  final double size;
  const _TicketQrGraphic({required this.size});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _TicketQrPainter(),
      ),
    );
  }
}

class _TicketQrPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final darkPaint = Paint()
      ..color = const Color(0xFF0F172A)
      ..style = PaintingStyle.fill;

    final orangePaint = Paint()
      ..color = const Color(0xFFF97316)
      ..style = PaintingStyle.fill;

    const int gridCount = 21;
    final double cellSize = size.width / gridCount;

    // Helper to draw a single module with slight corner rounding
    void drawModule(int col, int row, Paint paint) {
      final rect = Rect.fromLTWH(
        col * cellSize,
        row * cellSize,
        cellSize,
        cellSize,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, Radius.circular(cellSize * 0.2)),
        paint,
      );
    }

    // Helper to draw a 7x7 Finder Pattern with inner square
    void drawFinderPattern(int startCol, int startRow) {
      // Outer 7x7 box
      for (int r = 0; r < 7; r++) {
        for (int c = 0; c < 7; c++) {
          if (r == 0 || r == 6 || c == 0 || c == 6) {
            drawModule(startCol + c, startRow + r, darkPaint);
          }
        }
      }
      // Inner 3x3 solid box
      for (int r = 2; r < 5; r++) {
        for (int c = 2; c < 5; c++) {
          drawModule(startCol + c, startRow + r, darkPaint);
        }
      }
    }

    // 1. Draw the 3 finder patterns (Top-left, Top-right, Bottom-left)
    drawFinderPattern(0, 0);
    drawFinderPattern(gridCount - 7, 0);
    drawFinderPattern(0, gridCount - 7);

    // 2. Draw Timing patterns
    for (int i = 7; i < gridCount - 7; i += 2) {
      drawModule(i, 6, darkPaint);
      drawModule(6, i, darkPaint);
    }

    // 3. Central Signature Orange Block (distinctive to ServisinAja Figma QR)
    for (int r = 9; r <= 11; r++) {
      for (int c = 9; c <= 11; c++) {
        drawModule(c, r, orangePaint);
      }
    }

    // 4. Deterministic QR data matrix pattern
    const pattern = [
      // row 0-6 are corners + timing
      [8, 2], [9, 0], [11, 1], [13, 3],
      [8, 8], [9, 7], [10, 8], [11, 7], [12, 8],
      [7, 9], [8, 10], [7, 12], [8, 13],
      [13, 8], [14, 9], [15, 7], [16, 8], [17, 9], [18, 7], [19, 8], [20, 9],
      [12, 11], [13, 10], [14, 12], [15, 11], [16, 13], [17, 12], [18, 11], [19, 13], [20, 12],
      [7, 14], [8, 15], [9, 16], [10, 14], [11, 15], [12, 16],
      [14, 14], [15, 15], [16, 16], [17, 14], [18, 15], [19, 16], [20, 15],
      [7, 18], [8, 17], [9, 19], [10, 18], [11, 20], [12, 19],
      [13, 17], [14, 18], [15, 19], [16, 18], [17, 20], [18, 19], [19, 17], [20, 18],
      [8, 19], [9, 20], [10, 19], [11, 18], [12, 20], [13, 19],
      [14, 20], [15, 19], [16, 20], [17, 19], [18, 18], [19, 20], [20, 19],
    ];

    for (final pt in pattern) {
      final c = pt[0];
      final r = pt[1];
      if (c < gridCount && r < gridCount) {
        // Skip finder areas
        if ((c < 8 && r < 8) || (c >= gridCount - 8 && r < 8) || (c < 8 && r >= gridCount - 8)) {
          continue;
        }
        // Skip center orange box
        if (c >= 9 && c <= 11 && r >= 9 && r <= 11) {
          continue;
        }
        drawModule(c, r, darkPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
