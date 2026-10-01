import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../controllers/app_controller.dart';
import '../status/status_servis_screen.dart';

class BukuServisScreen extends StatefulWidget {
  final AppController controller;
  final String vehicleName;
  final String plateNumber;
  final String vehicleSub;
  final String chassisNumber;
  final String year;
  final String odometer;
  final String warrantyPeriod;

  const BukuServisScreen({
    super.key,
    required this.controller,
    this.vehicleName = 'Honda Vario 160',
    this.plateNumber = 'B 1234 XYZ',
    this.vehicleSub = 'Matic 160cc eSP+ • Hitam Doff',
    this.chassisNumber = 'MH1KF1144GH...',
    this.year = '2023',
    this.odometer = '12.450 km',
    this.warrantyPeriod = 'Garansi Mesin 5 Tahun / 50.000 km s.d Sep 2028',
  });

  @override
  State<BukuServisScreen> createState() => _BukuServisScreenState();
}

class _BukuServisScreenState extends State<BukuServisScreen> {
  void _downloadPdf() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Buku Servis Digital ${widget.vehicleName} berhasil diunduh (PDF)!',
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
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

  void _showInvoiceModal() {
    final isDark = widget.controller.isDarkMode;
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Invoice Digital AHASS',
                    style: AppTypography.getHeading(
                      isDark: isDark,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.cardDark : const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDark ? AppColors.borderDark : const Color(0xFFE2E8F0),
                  ),
                ),
                child: Column(
                  children: [
                    _buildInvoiceRow('No. Invoice', 'INV-AHASS-20240815-092', isDark),
                    const Divider(height: 16),
                    _buildInvoiceRow('Tanggal Servis', '15 Agu 2024, 10:30 WIB', isDark),
                    const Divider(height: 16),
                    _buildInvoiceRow('Tipe Servis', 'Servis Rutin + Filter Udara', isDark),
                    const Divider(height: 16),
                    _buildInvoiceRow('Bengkel', 'AHASS Mitra Cihampelas', isDark),
                    const Divider(height: 16),
                    _buildInvoiceRow('Total Pembayaran', 'Rp 145.000 (LUNAS)', isDark, isHighlight: true),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  icon: const Icon(Icons.download_rounded, size: 18),
                  label: const Text('Unduh Lembar Invoice (PDF)', style: TextStyle(fontWeight: FontWeight.w700)),
                  onPressed: () {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Lembar invoice digital berhasil disimpan!'),
                        backgroundColor: AppColors.primary,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInvoiceRow(String label, String value, bool isDark, {bool isHighlight = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12.5,
            color: isDark ? AppColors.textMutedDark : const Color(0xFF64748B),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isHighlight ? FontWeight.w800 : FontWeight.w600,
            color: isHighlight
                ? AppColors.primary
                : (isDark ? Colors.white : const Color(0xFF1E293B)),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.controller.isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0B1120) : const Color(0xFFFAF8F5),
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
          child: Column(
            children: [
              // 1. Top App Bar Header
              _buildAppBar(isDark),

              // 2. Scrollable Body
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Card 1: Kendaraan & Garansi
                      _buildVehicleInfoCard(isDark),
                      const SizedBox(height: 16),

                      // Card 2: Status Kupon Servis Rutin (KPB)
                      _buildKpbStatusCard(isDark),
                      const SizedBox(height: 20),

                      // Section 3: Riwayat Servis Resmi AHASS
                      _buildServiceHistorySection(isDark),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),

              // 3. Fixed Bottom Action Button (Unduh Riwayat PDF)
              _buildBottomActionBar(isDark),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
      child: Row(
        children: [
          // Back Button
          InkWell(
            onTap: () => Navigator.pop(context),
            borderRadius: BorderRadius.circular(20),
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDark ? AppColors.cardDark : Colors.white,
                border: Border.all(
                  color: isDark ? AppColors.borderDark : const Color(0xFFE2E8F0),
                  width: 1,
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
                Icons.chevron_left_rounded,
                size: 24,
                color: isDark ? Colors.white : const Color(0xFF1E293B),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Title (Center aligned look)
          Expanded(
            child: Text(
              'Buku Servis Digital',
              textAlign: TextAlign.center,
              style: AppTypography.getHeading(
                isDark: isDark,
                fontSize: 17,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),

          // Download Icon Button
          InkWell(
            onTap: _downloadPdf,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDark ? AppColors.cardDark : Colors.white,
                border: Border.all(
                  color: isDark ? AppColors.borderDark : const Color(0xFFE2E8F0),
                  width: 1,
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
                Icons.file_download_outlined,
                size: 20,
                color: isDark ? Colors.white : const Color(0xFF334155),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVehicleInfoCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.borderDark : const Color(0xFFE2E8F0),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: Bike Icon + Name + Plate + Garansi Aktif Badge
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Orange Bike Avatar
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF352014) : const Color(0xFFFFF2EB),
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.two_wheeler_rounded,
                  color: AppColors.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),

              // Title, Plate, Subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            widget.vehicleName,
                            style: AppTypography.getHeading(
                              isDark: isDark,
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            widget.plateNumber,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: isDark ? AppColors.textSecondaryDark : const Color(0xFF475569),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      widget.vehicleSub,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? AppColors.textMutedDark : const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),

              // Garansi Aktif Pill Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check_rounded, color: Colors.white, size: 12),
                    SizedBox(width: 3),
                    Text(
                      'Garansi Aktif',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10.5,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),
          const Divider(height: 1, thickness: 1, color: Color(0xFFF1F5F9)),
          const SizedBox(height: 12),

          // Specs 2-Column Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'No. Rangka : ${widget.chassisNumber}',
                    style: TextStyle(
                      fontSize: 11.5,
                      color: isDark ? AppColors.textMutedDark : const Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'Tahun : ${widget.year}',
                    style: TextStyle(
                      fontSize: 11.5,
                      color: isDark ? AppColors.textMutedDark : const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    'Odometer: ',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? AppColors.textMutedDark : const Color(0xFF64748B),
                    ),
                  ),
                  Text(
                    widget.odometer,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Engine Guarantee Banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF331E12) : const Color(0xFFFFF3EB),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isDark ? const Color(0xFF552D18) : const Color(0xFFFFDEC9),
                width: 1,
              ),
            ),
            child: Text(
              widget.warrantyPeriod,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Color(0xFFEA580C),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKpbStatusCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.borderDark : const Color(0xFFE2E8F0),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row: STATUS KUPON SERVIS RUTIN (KPB) + Gratis Jasa AHASS
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'STATUS KUPON SERVIS RUTIN (KPB)',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.4,
                  color: isDark ? AppColors.textMutedDark : const Color(0xFF64748B),
                ),
              ),
              const Text(
                'Gratis Jasa AHASS',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFFEA580C),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // 4-Step Stepper
          Row(
            children: [
              _buildKpbStep(
                stepNum: '1',
                title: 'KPB 1',
                subtitle: '1.000 km',
                isCompleted: true,
                isActive: false,
                isDark: isDark,
              ),
              _buildStepConnector(isCompleted: true, isDark: isDark),
              _buildKpbStep(
                stepNum: '2',
                title: 'KPB 2',
                subtitle: '4.000 km',
                isCompleted: true,
                isActive: false,
                isDark: isDark,
              ),
              _buildStepConnector(isCompleted: true, isDark: isDark),
              _buildKpbStep(
                stepNum: '3',
                title: 'KPB 3',
                subtitle: '8.000 km',
                isCompleted: true,
                isActive: false,
                isDark: isDark,
              ),
              _buildStepConnector(isCompleted: false, isDark: isDark),
              _buildKpbStep(
                stepNum: '4',
                title: 'KPB 4',
                subtitle: 'Hari Ini',
                isCompleted: false,
                isActive: true,
                isDark: isDark,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildKpbStep({
    required String stepNum,
    required String title,
    required String subtitle,
    required bool isCompleted,
    required bool isActive,
    required bool isDark,
  }) {
    return Column(
      children: [
        // Circle indicator
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isCompleted
                ? const Color(0xFF16A34A)
                : (isActive ? AppColors.primary : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0))),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.35),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          alignment: Alignment.center,
          child: isCompleted
              ? const Icon(Icons.check_rounded, color: Colors.white, size: 16)
              : Text(
                  stepNum,
                  style: TextStyle(
                    color: (isActive || isCompleted)
                        ? Colors.white
                        : (isDark ? Colors.white70 : const Color(0xFF64748B)),
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
        ),
        const SizedBox(height: 6),

        // Title
        Text(
          title,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            color: isActive
                ? const Color(0xFFEA580C)
                : (isDark ? Colors.white : const Color(0xFF1E293B)),
          ),
        ),
        const SizedBox(height: 2),

        // Subtitle
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 10,
            fontWeight: (isActive || isCompleted) ? FontWeight.w700 : FontWeight.w500,
            color: isCompleted
                ? const Color(0xFF16A34A)
                : (isActive ? const Color(0xFFEA580C) : (isDark ? AppColors.textMutedDark : const Color(0xFF64748B))),
          ),
        ),
      ],
    );
  }

  Widget _buildStepConnector({required bool isCompleted, required bool isDark}) {
    return Expanded(
      child: Container(
        height: 2.2,
        margin: const EdgeInsets.only(bottom: 24, left: 2, right: 2),
        decoration: BoxDecoration(
          color: isCompleted
              ? const Color(0xFF16A34A)
              : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
          borderRadius: BorderRadius.circular(1),
        ),
      ),
    );
  }

  Widget _buildServiceHistorySection(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Riwayat Servis Resmi AHASS',
              style: AppTypography.getHeading(
                isDark: isDark,
                fontSize: 15.5,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              'Total 3 Servis',
              style: TextStyle(
                fontSize: 12,
                color: isDark ? AppColors.textMutedDark : const Color(0xFF64748B),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // History Card 1: Sedang Dikerjakan (Highlighted Orange Border)
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardDark : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.primary,
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: isDark ? 0.2 : 0.08),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Date + Odo | Status Pill
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Kamis, 26 Sep 2026 • 12.450 km',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white70 : const Color(0xFF1E293B),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF352014) : const Color(0xFFFFF1E8),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFFEA580C),
                          ),
                        ),
                        const SizedBox(width: 5),
                        const Text(
                          'Sedang Dikerjakan',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFFEA580C),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Title
              Text(
                'Servis Berkala + Ganti Oli SPX2 + Cek CVT',
                style: AppTypography.getHeading(
                  isDark: isDark,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),

              // Bengkel & Montir
              Text(
                'AHASS Servisin Mitra Cihampelas • Pit 01 (Kang Agus)',
                style: TextStyle(
                  fontSize: 11.5,
                  color: isDark ? AppColors.textMutedDark : const Color(0xFF64748B),
                ),
              ),
              const SizedBox(height: 12),

              // Bottom Link: Pantau Status Pengerjaan Live → & KPB 4
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => StatusServisScreen(controller: widget.controller),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(6),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 2),
                      child: Text(
                        'Pantau Status Pengerjaan Live →',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFFEA580C),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'KPB 4',
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.textSecondaryDark : const Color(0xFF475569),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // History Card 2: Servis Selesai (Standard Border)
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardDark : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? AppColors.borderDark : const Color(0xFFE2E8F0),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Date + Odo | Status Pill Selesai
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '15 Agu 2024 • 8.200 km',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white70 : const Color(0xFF1E293B),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF142F1E) : const Color(0xFFDCFCE7),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check_rounded, color: Color(0xFF16A34A), size: 13),
                        SizedBox(width: 4),
                        Text(
                          'Servis Selesai',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF16A34A),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Title
              Text(
                'Servis Rutin + Pembersihan Filter Udara',
                style: AppTypography.getHeading(
                  isDark: isDark,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),

              // Bengkel & Price
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'AHASS Mitra Cihampelas',
                    style: TextStyle(
                      fontSize: 11.5,
                      color: isDark ? AppColors.textMutedDark : const Color(0xFF64748B),
                    ),
                  ),
                  Text(
                    'Rp 145.000',
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Bottom Link: Lihat Bukti Invoice Digital → & KPB 3
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: _showInvoiceModal,
                    borderRadius: BorderRadius.circular(6),
                    child: Text(
                      'Lihat Bukti Invoice Digital →',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.textSecondaryDark : const Color(0xFF64748B),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'KPB 3',
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.textSecondaryDark : const Color(0xFF475569),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBottomActionBar(bool isDark) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.borderDark : const Color(0xFFE2E8F0),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.05),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        height: 48,
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          icon: const Icon(Icons.file_download_outlined, size: 20),
          label: const Text(
            'Unduh Riwayat Servis (PDF)',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
          onPressed: _downloadPdf,
        ),
      ),
    );
  }
}
