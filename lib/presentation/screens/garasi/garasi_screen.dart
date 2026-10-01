import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../controllers/app_controller.dart';
import '../../../data/models/vehicle_model.dart';
import '../buku_servis/buku_servis_screen.dart';
import '../booking/booking_step1_screen.dart';
import 'widgets/tambah_motor_sheet.dart';


class GarasiScreen extends StatefulWidget {
  final AppController controller;

  const GarasiScreen({
    super.key,
    required this.controller,
  });

  @override
  State<GarasiScreen> createState() => _GarasiScreenState();
}

class _GarasiScreenState extends State<GarasiScreen> {
  // Plat nomor kendaraan yang sedang aktif/terpilih (border orange dinamis)
  String _selectedVehiclePlate = 'B 5678 ABC';

  void _handleBack() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      widget.controller.setNavIndex(0);
    }
  }

  void _showEditOdoModal(String vehicleName, String currentOdo) {
    final odoController = TextEditingController(text: currentOdo.replaceAll(' km', '').replaceAll('.', ''));
    final isDark = widget.controller.isDarkMode;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(ctx).viewInsets.bottom + 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Perbarui Odometer',
                style: AppTypography.getHeading(
                  isDark: isDark,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                vehicleName,
                style: TextStyle(
                  fontSize: 13,
                  color: isDark ? AppColors.textMutedDark : const Color(0xFF64748B),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: odoController,
                keyboardType: TextInputType.number,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: 'Jarak Tempuh (km)',
                  suffixText: 'km',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Odometer $vehicleName berhasil diperbarui!'),
                        backgroundColor: AppColors.primary,
                      ),
                    );
                  },
                  child: const Text('Simpan Odometer', style: TextStyle(fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAddVehicleModal(BuildContext context) {
    showTambahMotorSheet(
      context,
      controller: widget.controller,
      onVehicleAdded: (newVehicle) {
        setState(() {});
      },
    );
  }

  void _navigateToBooking(String plate) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BookingStep1Screen(
          controller: widget.controller,
          initialVehiclePlate: plate,
        ),
      ),
    );
  }

  // ---------------------------------------------------------------
  // Popup: Spesifikasi Lengkap Motor (AHASS Official Spec)
  // ---------------------------------------------------------------
  void _showSpecSheet({
    required String name,
    required String plate,
    required String subtitle,
    required String year,
    required String color,
    required String transmission,
    required String cc,
    required String chassisNo,
    required String engineNo,
    required String odometer,
    required String lastService,
    required String conditionStatus,
    required String garageLabel,
    // Mesin & Performa
    String engineType = '4-Langkah, SOHC, eSP 2-Klep',
    String boreStroke = '-',
    String compressionRatio = '-',
    String maxPower = '-',
    String maxTorque = '-',
    String fuelSystem = 'PGM-FI (Programmed Fuel Injection)',
    String lubricationSystem = 'Basah (Wet Sump)',
    String recommendedOil = 'AHM Oil MPX2 10W-30 SL',
    String cooling = 'Pendingin Udara',
    String ignition = 'Full Transisterized (DC-CDI)',
    String sparkPlug = '-',
    String startSystem = 'Elektrik & Kick Starter',
    String clutch = 'Otomatis, Sentrifugal, Tipe Kering',
    // Rangka & Kaki-kaki
    String frameType = 'eSAF (Enhanced Smart Architecture Frame)',
    String frontSuspension = 'Teleskopik Ø31 mm',
    String rearSuspension = 'Lengan Ayun, Suspensi Tunggal',
    String frontBrake = 'Cakram Hidrolik Piston Tunggal',
    String rearBrake = 'Tromol',
    String brakeSystem = 'Combi Brake System (CBS)',
    String frontTire = '80/90 - 14 M/C 40P (Tubeless)',
    String rearTire = '90/90 - 14 M/C 46P (Tubeless)',
    String tirePressureFront = '29 psi (200 kPa)',
    String tirePressureRear = '33 psi (225 kPa)',
    String wheelType = 'Cast Wheel Aluminium Alloy',
    // Dimensi & Berat
    String dimensions = '-',
    String wheelbase = '-',
    String groundClearance = '-',
    String seatHeight = '-',
    String dryWeight = '-',
    String fuelCapacity = '-',
    String fuelEfficiency = '-',
    String luggageCapacity = '-',
    // Kelistrikan & Fitur
    String batteryType = 'MF 12V 5.0Ah / GTZ6V',
    String headlight = 'LED Multi-Reflector',
    List<String> features = const [],
    // Garansi & Legalitas
    String warrantyFrame = '5 Tahun (Tanpa Batas Jarak Tempuh)',
    String warrantyEngine = '3 Tahun / 30.000 km',
    String warrantyInjection = '5 Tahun / 50.000 km',
    String warrantyElectrical = '1 Tahun / 10.000 km',
    String warrantyPeriod = 'Garansi Aktif',
    String kpbStatus = 'KPB Resmi AHASS',
    String registrationStatus = 'Terverifikasi Samsat & AHASS Nasional',
    String taxExpiry = '-',
  }) {
    final isDark = widget.controller.isDarkMode;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        String activeCategory = 'Semua';

        return StatefulBuilder(
          builder: (context, setModalState) {
            return DraggableScrollableSheet(
              initialChildSize: 0.90,
              maxChildSize: 0.96,
              minChildSize: 0.55,
              builder: (_, scrollCtrl) {
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
                  child: Column(
                    children: [
                      // ── Top Drag Handle ──────────────────────────────
                      Padding(
                        padding: const EdgeInsets.only(top: 12, bottom: 8),
                        child: Center(
                          child: Container(
                            width: 44,
                            height: 4.5,
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ),
                      ),

                      // ── Modal Title Bar ─────────────────────────────
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Icons.two_wheeler_rounded,
                                    size: 18,
                                    color: AppColors.primary,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Spesifikasi Lengkap Unit',
                                      style: AppTypography.getHeading(
                                        isDark: isDark,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    Text(
                                      'Standar Pabrikan & Riwayat AHASS',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: isDark ? AppColors.textMutedDark : const Color(0xFF64748B),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            InkWell(
                              onTap: () => Navigator.pop(ctx),
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.close_rounded,
                                  size: 18,
                                  color: isDark ? Colors.white70 : const Color(0xFF475569),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // ── Hero Motorcycle Card ────────────────────────
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 8, 20, 10),
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: isDark
                                  ? [const Color(0xFF1E293B), const Color(0xFF0F172A)]
                                  : [const Color(0xFFFFF7ED), const Color(0xFFFFF1F2)],
                            ),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: AppColors.primary.withValues(alpha: isDark ? 0.35 : 0.25),
                              width: 1.2,
                            ),
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: isDark ? const Color(0xFF332014) : const Color(0xFFFFEDD5),
                                      borderRadius: BorderRadius.circular(14),
                                      border: Border.all(color: AppColors.primary.withValues(alpha: 0.4)),
                                    ),
                                    alignment: Alignment.center,
                                    child: const Icon(
                                      Icons.two_wheeler_rounded,
                                      color: AppColors.primary,
                                      size: 26,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          name,
                                          style: AppTypography.getHeading(
                                            isDark: isDark,
                                            fontSize: 16.5,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                        const SizedBox(height: 3),
                                        Row(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                              decoration: BoxDecoration(
                                                color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                                                borderRadius: BorderRadius.circular(5),
                                              ),
                                              child: Text(
                                                plate,
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w800,
                                                  color: isDark ? Colors.white : const Color(0xFF1E293B),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 6),
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                              decoration: BoxDecoration(
                                                color: AppColors.primary.withValues(alpha: 0.12),
                                                borderRadius: BorderRadius.circular(5),
                                              ),
                                              child: Text(
                                                garageLabel,
                                                style: const TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w700,
                                                  color: AppColors.primary,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Condition status pill
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                                    decoration: BoxDecoration(
                                      color: conditionStatus.contains('Perlu')
                                          ? (isDark ? const Color(0xFF45220C) : const Color(0xFFFEF3C7))
                                          : (isDark ? const Color(0xFF142F1E) : const Color(0xFFDCFCE7)),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: conditionStatus.contains('Perlu')
                                            ? const Color(0xFFD97706)
                                            : const Color(0xFF16A34A),
                                        width: 0.8,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          conditionStatus.contains('Perlu')
                                              ? Icons.warning_amber_rounded
                                              : Icons.check_circle_rounded,
                                          size: 13,
                                          color: conditionStatus.contains('Perlu')
                                              ? const Color(0xFFD97706)
                                              : const Color(0xFF16A34A),
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          conditionStatus,
                                          style: TextStyle(
                                            fontSize: 10.5,
                                            fontWeight: FontWeight.w800,
                                            color: conditionStatus.contains('Perlu')
                                                ? (isDark ? const Color(0xFFFDE68A) : const Color(0xFF92400E))
                                                : (isDark ? const Color(0xFF86EFAC) : const Color(0xFF166534)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 12),

                              // Quick Metric Grid (4 Chips)
                              Row(
                                children: [
                                  _quickMetricBox('Odometer', '$odometer km', Icons.speed_rounded, isDark),
                                  const SizedBox(width: 8),
                                  _quickMetricBox('Kapasitas', '$cc cc', Icons.bolt_rounded, isDark),
                                  const SizedBox(width: 8),
                                  _quickMetricBox('Transmisi', transmission.contains('Matic') ? 'Matic' : transmission, Icons.sync_alt_rounded, isDark),
                                  const SizedBox(width: 8),
                                  _quickMetricBox('Tahun', year, Icons.event_rounded, isDark),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      // ── Category Filter Tabs ────────────────────────
                      SizedBox(
                        height: 38,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          children: [
                            'Semua',
                            'Identitas',
                            'Mesin',
                            'Rangka & Rem',
                            'Dimensi',
                            'Fitur Modern',
                            'Garansi AHASS',
                          ].map((cat) {
                            final isSelected = activeCategory == cat;
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: ChoiceChip(
                                label: Text(cat),
                                selected: isSelected,
                                onSelected: (sel) {
                                  if (sel) {
                                    setModalState(() {
                                      activeCategory = cat;
                                    });
                                  }
                                },
                                selectedColor: AppColors.primary,
                                labelStyle: TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                                  color: isSelected
                                      ? Colors.white
                                      : (isDark ? AppColors.textSecondaryDark : const Color(0xFF475569)),
                                ),
                                backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                                side: BorderSide(
                                  color: isSelected
                                      ? AppColors.primary
                                      : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                                  width: 0.8,
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              ),
                            );
                          }).toList(),
                        ),
                      ),

                      const SizedBox(height: 10),

                      // ── Scrollable Detailed Specifications Content ──
                      Expanded(
                        child: ListView(
                          controller: scrollCtrl,
                          padding: const EdgeInsets.fromLTRB(20, 6, 20, 24),
                          children: [
                            // SECTION 1 – Identitas Unit & Legalitas
                            if (activeCategory == 'Semua' || activeCategory == 'Identitas') ...[
                              _specSectionHeader('🪪  Identitas & Registrasi Kendaraan', isDark),
                              _specGroup([
                                _specRow('Model / Varian', name, isDark),
                                _specRow('Tahun Pembuatan', year, isDark),
                                _specRow('Warna Kendaraan', color, isDark),
                                _specRow('Tipe Transmisi', transmission, isDark),
                                _specRow('Nomor Polisi / Plat', plate, isDark),
                                _specRow('Masa Pajak / STNK', taxExpiry != '-' ? taxExpiry : 'Aktif Resmi', isDark),
                                _specRow('Nomor Rangka (VIN)', chassisNo, isDark),
                                _specRow('Nomor Mesin', engineNo, isDark),
                                _specRow('Posisi Garasi', garageLabel, isDark),
                                _specRow('Status Registrasi', registrationStatus, isDark),
                                _specRow('Odometer Terkini', '$odometer km', isDark),
                                _specRow('Riwayat Servis Terakhir', lastService, isDark),
                              ], isDark),
                              const SizedBox(height: 18),
                            ],

                            // SECTION 2 – Mesin & Performa
                            if (activeCategory == 'Semua' || activeCategory == 'Mesin') ...[
                              _specSectionHeader('⚙️  Mesin & Performa (Engine)', isDark),
                              _specGroup([
                                _specRow('Tipe Mesin', engineType, isDark),
                                _specRow('Kapasitas Silinder', '$cc cc', isDark),
                                _specRow('Bore × Stroke', boreStroke, isDark),
                                _specRow('Rasio Kompresi', compressionRatio, isDark),
                                _specRow('Daya Maksimum', maxPower, isDark),
                                _specRow('Torsi Maksimum', maxTorque, isDark),
                                _specRow('Sistem Bahan Bakar', fuelSystem, isDark),
                                _specRow('Sistem Pelumasan', lubricationSystem, isDark),
                                _specRow('Rekomendasi Pelumas', recommendedOil, isDark),
                                _specRow('Sistem Pendinginan', cooling, isDark),
                                _specRow('Sistem Pengapian', ignition, isDark),
                                _specRow('Tipe Busi Rekomendasi', sparkPlug != '-' ? sparkPlug : 'Standar AHM', isDark),
                                _specRow('Sistem Starter', startSystem, isDark),
                                _specRow('Tipe Kopling', clutch, isDark),
                              ], isDark),
                              const SizedBox(height: 18),
                            ],

                            // SECTION 3 – Rangka & Kaki-Kaki
                            if (activeCategory == 'Semua' || activeCategory == 'Rangka & Rem') ...[
                              _specSectionHeader('🏗️  Rangka, Suspensi & Pengereman', isDark),
                              _specGroup([
                                _specRow('Tipe Rangka', frameType, isDark),
                                _specRow('Suspensi Depan', frontSuspension, isDark),
                                _specRow('Suspensi Belakang', rearSuspension, isDark),
                                _specRow('Rem Depan', frontBrake, isDark),
                                _specRow('Rem Belakang', rearBrake, isDark),
                                _specRow('Sistem Pengereman', brakeSystem, isDark),
                                _specRow('Ukuran Ban Depan', frontTire, isDark),
                                _specRow('Ukuran Ban Belakang', rearTire, isDark),
                                _specRow('Tekanan Ban Depan', tirePressureFront, isDark),
                                _specRow('Tekanan Ban Belakang', tirePressureRear, isDark),
                                _specRow('Tipe Velg', wheelType, isDark),
                              ], isDark),
                              const SizedBox(height: 18),
                            ],

                            // SECTION 4 – Dimensi, Bobot & Kapasitas
                            if (activeCategory == 'Semua' || activeCategory == 'Dimensi') ...[
                              _specSectionHeader('📐  Dimensi, Bobot & Kapasitas', isDark),
                              _specGroup([
                                _specRow('Dimensi (P × L × T)', dimensions != '-' ? dimensions : 'Standar Pabrikan', isDark),
                                _specRow('Jarak Sumbu Roda', wheelbase != '-' ? wheelbase : '1.256 mm', isDark),
                                _specRow('Jarak Terendah Tanah', groundClearance != '-' ? groundClearance : '147 mm', isDark),
                                _specRow('Tinggi Tempat Duduk', seatHeight != '-' ? seatHeight : '740 mm', isDark),
                                _specRow('Bobot Kosong (Curb)', dryWeight != '-' ? dryWeight : '90 kg', isDark),
                                _specRow('Kapasitas Tangki BBM', fuelCapacity != '-' ? fuelCapacity : '4,2 Liter', isDark),
                                _specRow('Konsumsi BBM Rata-rata', fuelEfficiency != '-' ? fuelEfficiency : '60,6 km/L (ECE R40)', isDark),
                                _specRow('Kapasitas Bagasi U-Box', luggageCapacity != '-' ? luggageCapacity : '12 Liter', isDark),
                              ], isDark),
                              const SizedBox(height: 18),
                            ],

                            // SECTION 5 – Kelistrikan & Fitur Canggih
                            if (activeCategory == 'Semua' || activeCategory == 'Fitur Modern') ...[
                              _specSectionHeader('⚡  Kelistrikan & Fitur Unggulan', isDark),
                              _specGroup([
                                _specRow('Tipe Aki / Baterai', batteryType, isDark),
                                _specRow('Lampu Utama (Headlight)', headlight, isDark),
                                _specRow('Panel Instrumen', 'Kombinasi Analog & LCD Digital', isDark),
                              ], isDark),
                              const SizedBox(height: 12),

                              if (features.isNotEmpty) ...[
                                Text(
                                  'Fitur Teknologi Unggulan Tersemat:',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: features.map((feat) {
                                    return Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
                                          width: 0.8,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(
                                            Icons.check_circle_rounded,
                                            size: 14,
                                            color: Color(0xFF16A34A),
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            feat,
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w700,
                                              color: isDark ? Colors.white : const Color(0xFF1E293B),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ),
                                const SizedBox(height: 18),
                              ],
                            ],

                            // SECTION 6 – Garansi & Rekomendasi AHASS
                            if (activeCategory == 'Semua' || activeCategory == 'Garansi AHASS') ...[
                              _specSectionHeader('🛡️  Garansi Resmi & Rekomendasi AHASS', isDark),
                              _specGroup([
                                _specRow('Garansi Rangka', warrantyFrame, isDark),
                                _specRow('Garansi Injeksi PGM-FI', warrantyInjection, isDark),
                                _specRow('Garansi Mesin Resmi', warrantyEngine, isDark),
                                _specRow('Garansi Kelistrikan', warrantyElectrical, isDark),
                                _specRow('Masa Garansi Berjalan', warrantyPeriod, isDark),
                                _specRow('Kupon Servis Berkala', kpbStatus, isDark),
                                _specRow('Rekomendasi Servis', 'Pemeriksaan Rutin Setiap 4.000 km', isDark),
                              ], isDark),
                              const SizedBox(height: 18),
                            ],
                          ],
                        ),
                      ),

                      // ── Bottom Action Bar (Persistent Sticky Footer) ──
                      Container(
                        padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.surfaceDark : Colors.white,
                          border: Border(
                            top: BorderSide(
                              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                              width: 1,
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
                        child: Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 44,
                                child: OutlinedButton.icon(
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: isDark ? Colors.white : const Color(0xFF1E293B),
                                    side: BorderSide(
                                      color: isDark ? AppColors.borderDark : const Color(0xFFCBD5E1),
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  icon: const Icon(Icons.menu_book_rounded, size: 17),
                                  label: const Text('Buku Servis', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                                  onPressed: () {
                                    Navigator.pop(ctx);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => BukuServisScreen(
                                          controller: widget.controller,
                                          vehicleName: name,
                                          plateNumber: plate,
                                          vehicleSub: subtitle,
                                          odometer: '$odometer km',
                                          chassisNumber: chassisNo,
                                          year: year,
                                          warrantyPeriod: warrantyPeriod,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: SizedBox(
                                height: 44,
                                child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  icon: const Icon(Icons.calendar_month_rounded, size: 17),
                                  label: const Text('Booking Servis', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13)),
                                  onPressed: () {
                                    Navigator.pop(ctx);
                                    _navigateToBooking(plate);
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  // ---------------------------------------------------------------
  // Spec Launchers for BeAT, Vario, and Dynamic Vehicles
  // ---------------------------------------------------------------
  void _openBeatSpec() {
    _showSpecSheet(
      name: 'Honda BeAT Deluxe CBS-ISS',
      plate: 'B 5678 ABC',
      subtitle: 'Garasi Kedua • Transmisi Matic (110cc eSP)',
      year: '2022',
      color: 'Deluxe Silver (Matte Edition)',
      transmission: 'Otomatis, V-Matic (CVT)',
      cc: '109,5',
      chassisNo: 'MH1JM3129PK340721',
      engineNo: 'JM31E-2340711',
      odometer: '8.200',
      lastService: '02 Sep 2024 (AHASS 01234 Surya Motor)',
      conditionStatus: 'Perlu Servis',
      garageLabel: 'Garasi Kedua',
      // Mesin & Performa
      engineType: '4-Langkah, SOHC, eSP (enhanced Smart Power) 2-Klep',
      boreStroke: '47,0 × 63,1 mm (Efisiensi Tinggi)',
      compressionRatio: '10,0 : 1',
      maxPower: '6,6 kW (9,0 PS) / 7.500 rpm',
      maxTorque: '9,3 N·m (0,95 kgf·m) / 5.500 rpm',
      fuelSystem: 'PGM-FI (Programmed Fuel Injection)',
      lubricationSystem: 'Basah (Wet Sump) • 0,65 Liter Penggantian Periodik',
      recommendedOil: 'AHM Oil MPX2 10W-30 SL JASO MB',
      cooling: 'Pendingin Udara Bertekanan (Forced Air Cooled)',
      ignition: 'Full Transisterized (DC-CDI)',
      sparkPlug: 'NGK MR9C-9N / Denso U27EPR-N9',
      startSystem: 'Elektrik & Kick Starter (ACG Starter Halus)',
      clutch: 'Otomatis, Sentrifugal, Tipe Kering',
      // Rangka & Kaki-kaki
      frameType: 'eSAF (Enhanced Smart Architecture Frame)',
      frontSuspension: 'Teleskopik Ø31 mm',
      rearSuspension: 'Lengan Ayun dengan Peredam Kejut Tunggal',
      frontBrake: 'Cakram Hidrolik Piston Tunggal (Nissin)',
      rearBrake: 'Tromol (Leading Trailing Drum Brake)',
      brakeSystem: 'Combi Brake System (CBS) Terpadu',
      frontTire: '80/90 - 14 M/C 40P (Tubeless)',
      rearTire: '90/90 - 14 M/C 46P (Tubeless)',
      tirePressureFront: '29 psi (200 kPa)',
      tirePressureRear: '33 psi (225 kPa)',
      wheelType: 'Cast Wheel Aluminium Alloy Sporty',
      // Dimensi & Berat
      dimensions: '1.877 × 669 × 1.074 mm',
      wheelbase: '1.256 mm',
      groundClearance: '147 mm',
      seatHeight: '740 mm',
      dryWeight: '89 kg (Curb Weight Sangat Ringan)',
      fuelCapacity: '4,2 Liter (Bensin Oktan 90+ / Pertalite / Pertamax)',
      fuelEfficiency: '60,6 km/Liter (Metode ECE R40 ISS On)',
      luggageCapacity: '12 Liter (Bagasi U-Box Luas Serbaguna)',
      // Kelistrikan & Fitur
      batteryType: 'MF 12V 5.0Ah (Tipe ISS) / GTZ6V',
      headlight: 'LED Multi-Reflector 12V Hemat Daya',
      features: const [
        'Idling Stop System (ISS) - Mati 3 Detik Otomatis',
        'ACG Starter - Starter Halus Senyap Tanpa Suara',
        'Combi Brake System (CBS) - Rem Terdistribusi Otomatis',
        'Parking Brake Lock - Tuas Pengunci Rem Tanjakan',
        'Side Stand Switch - Mesin Mati Otomatis saat Standar Turun',
        'Power Charger Socket USB 12W (Inner Rack)',
        'Secure Key Shutter - Kunci Kontak Magnetik Anti-Maling',
        'Tuas Pembuka Jok Terintegrasi (Seat Opener)',
        'Panel Meter Analog + LCD Digital Multifungsi',
        'Eco Indicator Lampu Panduan Berkendara Irit',
      ],
      // Garansi & Legalitas
      warrantyFrame: 'Garansi Rangka 5 Tahun (Tanpa Batas Jarak Tempuh)',
      warrantyEngine: 'Garansi Mesin 3 Tahun / 30.000 km',
      warrantyInjection: 'Garansi Sistem Injeksi PGM-FI 5 Tahun / 50.000 km',
      warrantyElectrical: 'Garansi Kelistrikan & Komponen Bodi 1 Tahun / 10.000 km',
      warrantyPeriod: 'Garansi Aktif s.d November 2027',
      kpbStatus: 'KPB 1 s/d 3 Selesai • KPB 4 Tersedia di AHASS',
      registrationStatus: 'Terverifikasi Samsat & AHASS Nasional',
      taxExpiry: '18 Oktober 2027',
    );
  }

  void _openVarioSpec() {
    _showSpecSheet(
      name: 'Honda Vario 160 CBS',
      plate: 'B 1234 XYZ',
      subtitle: 'Garasi Utama • Transmisi Matic (160cc eSP+)',
      year: '2023',
      color: 'Grande Matte Black',
      transmission: 'Otomatis, V-Matic (CVT)',
      cc: '156,9',
      chassisNo: 'MH1KF1144GH829104',
      engineNo: 'KF11E-1829103',
      odometer: '12.450',
      lastService: '15 Agu 2024 (AHASS 00123 Daya Motor)',
      conditionStatus: 'Kondisi OK',
      garageLabel: 'Garasi Utama',
      // Mesin & Performa
      engineType: '4-Langkah, 4-Katup, SOHC, eSP+ Berpendingin Cairan',
      boreStroke: '60,0 × 55,5 mm',
      compressionRatio: '12,0 : 1',
      maxPower: '11,3 kW (15,4 PS) / 8.500 rpm',
      maxTorque: '13,8 N·m (1,4 kgf·m) / 7.000 rpm',
      fuelSystem: 'PGM-FI (Programmed Fuel Injection)',
      lubricationSystem: 'Basah (Wet Sump) • 0,8 Liter Penggantian Periodik',
      recommendedOil: 'AHM Oil SPX2 10W-30 SL Fully Synthetic',
      cooling: 'Pendingin Cairan (Liquid Cooled with Radiator)',
      ignition: 'Full Transisterized',
      sparkPlug: 'NGK LMAR8L-9',
      startSystem: 'Elektrik Starter (ACG Starter Senyap)',
      clutch: 'Otomatis, Sentrifugal, Tipe Kering',
      // Rangka & Kaki-kaki
      frameType: 'eSAF (Enhanced Smart Architecture Frame)',
      frontSuspension: 'Teleskopik Ø31 mm Sporty',
      rearSuspension: 'Lengan Ayun dengan Suspensi Tunggal',
      frontBrake: 'Cakram Hidrolik Ø220 mm Piston Tunggal',
      rearBrake: 'Tromol (Combi Brake System / CBS)',
      brakeSystem: 'Combi Brake System (CBS)',
      frontTire: '100/80 - 14 M/C 48P (Tubeless Tapak Lebar)',
      rearTire: '120/70 - 14 M/C 61P (Tubeless Tapak Lebar)',
      tirePressureFront: '29 psi (200 kPa)',
      tirePressureRear: '33 psi (225 kPa)',
      wheelType: 'Cast Wheel Titanium Style Alloy',
      // Dimensi & Berat
      dimensions: '1.929 × 679 × 1.088 mm',
      wheelbase: '1.277 mm',
      groundClearance: '140 mm',
      seatHeight: '778 mm',
      dryWeight: '115 kg (Curb Weight)',
      fuelCapacity: '5,5 Liter (Bensin Oktan 92+ / Pertamax)',
      fuelEfficiency: '46,9 km/Liter (Metode WMTC)',
      luggageCapacity: '18 Liter (Muat Helm Full-Face)',
      // Kelistrikan & Fitur
      batteryType: 'MF 12V 5.0Ah / GTZ6V',
      headlight: 'All-LED Lighting (Headlamp, DRL, Sein, Stoplamp)',
      features: const [
        'Honda Smart Key System (Keyless Remote)',
        'Answer Back System & Anti-Theft Alarm',
        'Full Digital Panel Meter Multifungsi',
        'USB Charger Type A 5V 2.1A (Console Box Tertutup)',
        'Idling Stop System (ISS)',
        'ACG Starter Senyap',
        'Combi Brake System (CBS)',
        'Desain Bodi Gambot & Sporty 160cc Flat Deck',
        'Bagasi Luas 18 Liter Muat Helm',
        'Ban Tubeless Tapak Lebar 100/80 & 120/70',
      ],
      // Garansi & Legalitas
      warrantyFrame: 'Garansi Rangka 5 Tahun (Tanpa Batas Jarak Tempuh)',
      warrantyEngine: 'Garansi Mesin 3 Tahun / 30.000 km',
      warrantyInjection: 'Garansi Sistem Injeksi PGM-FI 5 Tahun / 50.000 km',
      warrantyElectrical: 'Garansi Kelistrikan 1 Tahun / 10.000 km',
      warrantyPeriod: 'Garansi Aktif s.d September 2028',
      kpbStatus: 'KPB 1 & 2 Selesai • KPB 3 Mendatang',
      registrationStatus: 'Terverifikasi Samsat & AHASS Nasional',
      taxExpiry: '22 Agustus 2028',
    );
  }

  void _openDynamicSpec(VehicleModel v) {
    _showSpecSheet(
      name: v.name,
      plate: v.plateNumber,
      subtitle: '${v.garageLabel} • ${v.transmission} (${v.engineCc})',
      year: v.year,
      color: v.color,
      transmission: v.transmission,
      cc: v.engineCc.replaceAll(RegExp(r'[^0-9]'), ''),
      chassisNo: v.chassisNumber,
      engineNo: v.engineNumber,
      odometer: '${v.odometerKm}',
      lastService: v.lastService,
      conditionStatus: v.conditionStatus,
      garageLabel: v.garageLabel,
      engineType: '4-Langkah, SOHC, eSP Injeksi PGM-FI',
      maxPower: 'Tergantung Tipe Mesin (${v.engineCc})',
      maxTorque: 'Tergantung Karakter Torsi Pabrikan',
      fuelSystem: 'PGM-FI (Programmed Fuel Injection)',
      cooling: 'Pendingin Udara / Pendingin Cairan',
      frameType: 'Underbone / Backbone eSAF Resmi Honda',
      frontSuspension: 'Teleskopik',
      rearSuspension: 'Lengan Ayun Suspensi',
      frontBrake: 'Cakram Hidrolik',
      rearBrake: 'Tromol / Cakram',
      frontTire: 'Tubeless Standar Pabrikan',
      rearTire: 'Tubeless Standar Pabrikan',
      fuelCapacity: '4,2 - 5,5 Liter',
      batteryType: 'MF 12V Maintenance Free',
      headlight: 'LED Multi-Reflector',
      features: const [
        'Injeksi PGM-FI Ramah Lingkungan',
        'Secure Key Shutter Pengaman Magnetik',
        'Side Stand Switch Standar Samping Otomatis',
        'Parking Brake Lock Pengunci Rem',
      ],
      warrantyPeriod: 'Garansi Resmi AHASS Berjalan',
      registrationStatus: 'Terdaftar di Garasi Digital AHASS',
    );
  }

  Widget _quickMetricBox(String label, String value, IconData icon, bool isDark) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF131E2B) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
            width: 0.8,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, size: 14, color: AppColors.primary),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 9.5,
                color: isDark ? AppColors.textMutedDark : const Color(0xFF64748B),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _specSectionHeader(String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w800,
          color: isDark ? Colors.white : const Color(0xFF0F172A),
          letterSpacing: 0.2,
        ),
      ),
    );
  }

  Widget _specGroup(List<Widget> rows, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF131E2B) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(children: rows),
    );
  }

  Widget _specRow(String label, String value, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8.5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 11.5,
                color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.controller.isDarkMode;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        _handleBack();
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
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
                      // Callout Banner: Booking 2 Motor Sekaligus?
                      _buildMultiMotorCallout(isDark),
                      const SizedBox(height: 16),

                      // Card 1: Honda Vario 160
                      _buildVarioCard(isDark),
                      const SizedBox(height: 16),

                      // Card 2: Honda BeAT Deluxe (Special Highlighted Orange Border)
                      _buildBeatCard(isDark),
                      const SizedBox(height: 16),

                      // Motor Tambahan yang Didaftarkan Melalui Form Lengkap
                      ...widget.controller.vehicles.skip(2).map((v) => Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _buildDynamicVehicleCard(v, isDark),
                      )),

                      // Card 3: Daftarkan Motor Baru (Dashed Border Card)
                      _buildAddVehicleCard(isDark),
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

  Widget _buildAppBar(bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
      child: Row(
        children: [
          // Circular Back Button
          InkWell(
            onTap: _handleBack,
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

          // Title + Subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Garasi Saya',
                  style: AppTypography.getHeading(
                    isDark: isDark,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '2 Unit Terdaftar',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? AppColors.textMutedDark : const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),

          // Right Action Button: + Tambah Motor
          InkWell(
            onTap: () => _showAddVehicleModal(context),
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF352014) : const Color(0xFFFFF1E8),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add_rounded, size: 16, color: Color(0xFFEA580C)),
                  SizedBox(width: 4),
                  Text(
                    'Tambah Motor',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFFEA580C),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMultiMotorCallout(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2E1B11) : const Color(0xFFFFF3EC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF442616) : const Color(0xFFFFE4D4),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Orange Bike Icon Container
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF452818) : const Color(0xFFFFE5D3),
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.two_wheeler_rounded,
              color: Color(0xFFEA580C),
              size: 24,
            ),
          ),
          const SizedBox(width: 12),

          // Message
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Booking 2 Motor Sekaligus?',
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFFEA580C),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Hemat waktu pengerjaan paralel di 2 pit. Yukk.. cobain sekarang!',
                  style: TextStyle(
                    fontSize: 11,
                    height: 1.35,
                    color: isDark ? const Color(0xFFA8A29E) : const Color(0xFF78716C),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),

          // Booking > Button
          InkWell(
            onTap: () {
              widget.controller.setNavIndex(1); // Go to booking tab
            },
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Booking',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(width: 2),
                  Icon(Icons.chevron_right_rounded, color: Colors.white, size: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVarioCard(bool isDark) {
    final isSelected = _selectedVehiclePlate == 'B 1234 XYZ';

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? AppColors.primary : (isDark ? AppColors.borderDark : const Color(0xFFE2E8F0)),
          width: isSelected ? 2.0 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: isSelected
                ? AppColors.primary.withValues(alpha: isDark ? 0.28 : 0.12)
                : Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: isSelected ? 12 : 8,
            offset: isSelected ? const Offset(0, 3) : const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            setState(() {
              _selectedVehiclePlate = 'B 1234 XYZ';
            });
            _openVarioSpec();
          },
          splashColor: AppColors.primary.withValues(alpha: 0.12),
          hoverColor: AppColors.primary.withValues(alpha: 0.04),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Row: Avatar + Title + Plate + Subtitle
                Row(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      width: isSelected ? 42 : 40,
                      height: isSelected ? 42 : 40,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? (isDark ? const Color(0xFF352614) : const Color(0xFFFEF3C7))
                            : (isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9)),
                        borderRadius: BorderRadius.circular(12),
                        border: isSelected
                            ? Border.all(color: AppColors.primary.withValues(alpha: 0.35))
                            : null,
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.two_wheeler_rounded,
                        color: isSelected
                            ? const Color(0xFFD97706)
                            : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569)),
                        size: isSelected ? 24 : 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Honda Vario 160',
                                style: AppTypography.getHeading(
                                  isDark: isDark,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                                decoration: BoxDecoration(
                                  color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  'B 1234 XYZ',
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
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Garasi Utama • Transmisi Matic (160cc)',
                                  style: TextStyle(
                                    fontSize: 11.5,
                                    color: isDark ? AppColors.textMutedDark : const Color(0xFF64748B),
                                  ),
                                ),
                              ),
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 250),
                                padding: EdgeInsets.symmetric(horizontal: isSelected ? 8 : 7, vertical: isSelected ? 3 : 2.5),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? (isDark ? const Color(0xFF452408) : const Color(0xFFFFF7ED))
                                      : (isDark ? Colors.white10 : const Color(0xFFF1F5F9)),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.primary.withValues(alpha: 0.5)
                                        : (isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1)),
                                    width: isSelected ? 1 : 0.8,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.touch_app_rounded,
                                      size: 11,
                                      color: isSelected ? AppColors.primary : (isDark ? Colors.white70 : const Color(0xFF64748B)),
                                    ),
                                    const SizedBox(width: 3),
                                    Text(
                                      'Spek Motor',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                        color: isSelected ? AppColors.primary : (isDark ? Colors.white70 : const Color(0xFF475569)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // Middle Stats Box: Odometer + Servis Terakhir
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF131E2B) : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      // Odometer
                      Expanded(
                        child: InkWell(
                          onTap: () => _showEditOdoModal('Honda Vario 160', '12.450 km'),
                          child: Row(
                            children: [
                              Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: isDark ? const Color(0xFF1E293B) : Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                alignment: Alignment.center,
                                child: Icon(
                                  Icons.access_time_rounded,
                                  size: 16,
                                  color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Odometer',
                                    style: TextStyle(
                                      fontSize: 10.5,
                                      color: isDark ? AppColors.textMutedDark : const Color(0xFF64748B),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        '12.450 km',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w800,
                                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Icon(
                                        Icons.edit_outlined,
                                        size: 13,
                                        color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Vertical Divider
                      Container(
                        width: 1,
                        height: 28,
                        color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                      ),

                      // Servis Terakhir
                      Expanded(
                        child: Row(
                          children: [
                            Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: isDark ? const Color(0xFF1E293B) : Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              alignment: Alignment.center,
                              child: Icon(
                                Icons.calendar_today_outlined,
                                size: 15,
                                color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Servis Terakhir',
                                  style: TextStyle(
                                    fontSize: 10.5,
                                    color: isDark ? AppColors.textMutedDark : const Color(0xFF64748B),
                                  ),
                                ),
                                Text(
                                  '15 Agu 2024',
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
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Recommendation Green Pill (Tapping also opens spec!)
                InkWell(
                  onTap: () {
                    setState(() {
                      _selectedVehiclePlate = 'B 1234 XYZ';
                    });
                    _openVarioSpec();
                  },
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF142F1E) : const Color(0xFFF0FDF4),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isDark ? const Color(0xFF164E28) : const Color(0xFFDCFCE7),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.check_circle_rounded,
                          color: Color(0xFF16A34A),
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              style: TextStyle(
                                fontSize: 11.5,
                                color: isDark ? const Color(0xFF86EFAC) : const Color(0xFF166534),
                              ),
                              children: const [
                                TextSpan(text: 'Servis berkala berikutnya disarankan pada '),
                                TextSpan(
                                  text: '14.000 km',
                                  style: TextStyle(fontWeight: FontWeight.w800),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                // Bottom Action Buttons (50% / 50%)
                Row(
                  children: [
                    // Buku Servis Button
                    Expanded(
                      child: SizedBox(
                        height: 42,
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: isDark ? Colors.white : const Color(0xFF1E293B),
                            side: BorderSide(
                              color: isDark ? AppColors.borderDark : const Color(0xFFCBD5E1),
                              width: 1,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: EdgeInsets.zero,
                          ),
                          icon: Icon(
                            Icons.menu_book_rounded,
                            size: 16,
                            color: isDark ? Colors.white : const Color(0xFF1E293B),
                          ),
                          label: const Text(
                            'Buku Servis',
                            style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BukuServisScreen(
                                  controller: widget.controller,
                                  vehicleName: 'Honda Vario 160',
                                  plateNumber: 'B 1234 XYZ',
                                  vehicleSub: 'Matic 160cc eSP+ • Hitam Doff',
                                  odometer: '12.450 km',
                                  chassisNumber: 'MH1KF1144GH...',
                                  year: '2023',
                                  warrantyPeriod: 'Garansi Mesin 5 Tahun / 50.000 km s.d Sep 2028',
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),

                    // Booking Servis Button
                    Expanded(
                      child: SizedBox(
                        height: 42,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: EdgeInsets.zero,
                          ),
                          onPressed: () {
                            _navigateToBooking('B 1234 XYZ');
                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Booking Servis',
                                style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700),
                              ),
                              SizedBox(width: 4),
                              Icon(Icons.chevron_right_rounded, size: 18),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBeatCard(bool isDark) {
    final isSelected = _selectedVehiclePlate == 'B 5678 ABC';

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? AppColors.primary : (isDark ? AppColors.borderDark : const Color(0xFFE2E8F0)),
          width: isSelected ? 2.0 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: isSelected
                ? AppColors.primary.withValues(alpha: isDark ? 0.28 : 0.12)
                : Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: isSelected ? 12 : 8,
            offset: isSelected ? const Offset(0, 3) : const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            setState(() {
              _selectedVehiclePlate = 'B 5678 ABC';
            });
            _openBeatSpec();
          },
          splashColor: AppColors.primary.withValues(alpha: 0.12),
          hoverColor: AppColors.primary.withValues(alpha: 0.04),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Row: Avatar + Title + Plate + Subtitle + Interactive Spec Badge
                Row(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      width: isSelected ? 42 : 40,
                      height: isSelected ? 42 : 40,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? (isDark ? const Color(0xFF352614) : const Color(0xFFFEF3C7))
                            : (isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9)),
                        borderRadius: BorderRadius.circular(12),
                        border: isSelected
                            ? Border.all(color: AppColors.primary.withValues(alpha: 0.35))
                            : null,
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.two_wheeler_rounded,
                        color: isSelected
                            ? const Color(0xFFD97706)
                            : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569)),
                        size: isSelected ? 24 : 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Honda BeAT Deluxe',
                                style: AppTypography.getHeading(
                                  isDark: isDark,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                                decoration: BoxDecoration(
                                  color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  'B 5678 ABC',
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
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Garasi Kedua • Transmisi Matic (110cc)',
                                  style: TextStyle(
                                    fontSize: 11.5,
                                    color: isDark ? AppColors.textMutedDark : const Color(0xFF64748B),
                                  ),
                                ),
                              ),
                              // Clickable Spec Indicator Badge
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 250),
                                padding: EdgeInsets.symmetric(horizontal: isSelected ? 8 : 7, vertical: isSelected ? 3 : 2.5),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? (isDark ? const Color(0xFF452408) : const Color(0xFFFFF7ED))
                                      : (isDark ? Colors.white10 : const Color(0xFFF1F5F9)),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.primary.withValues(alpha: 0.5)
                                        : (isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1)),
                                    width: isSelected ? 1 : 0.8,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.touch_app_rounded,
                                      size: 11,
                                      color: isSelected ? AppColors.primary : (isDark ? Colors.white70 : const Color(0xFF64748B)),
                                    ),
                                    const SizedBox(width: 3),
                                    Text(
                                      'Spek Motor',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                        color: isSelected ? AppColors.primary : (isDark ? Colors.white70 : const Color(0xFF475569)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // Middle Stats Box: Odometer + Servis Terakhir
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF131E2B) : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      // Odometer
                      Expanded(
                        child: InkWell(
                          onTap: () => _showEditOdoModal('Honda BeAT Deluxe', '8.200 km'),
                          child: Row(
                            children: [
                              Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: isDark ? const Color(0xFF1E293B) : Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                alignment: Alignment.center,
                                child: Icon(
                                  Icons.access_time_rounded,
                                  size: 16,
                                  color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Odometer',
                                    style: TextStyle(
                                      fontSize: 10.5,
                                      color: isDark ? AppColors.textMutedDark : const Color(0xFF64748B),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        '8.200 km',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w800,
                                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Icon(
                                        Icons.edit_outlined,
                                        size: 13,
                                        color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Vertical Divider
                      Container(
                        width: 1,
                        height: 28,
                        color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                      ),

                      // Servis Terakhir
                      Expanded(
                        child: Row(
                          children: [
                            Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: isDark ? const Color(0xFF1E293B) : Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              alignment: Alignment.center,
                              child: Icon(
                                Icons.calendar_today_outlined,
                                size: 15,
                                color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Servis Terakhir',
                                  style: TextStyle(
                                    fontSize: 10.5,
                                    color: isDark ? AppColors.textMutedDark : const Color(0xFF64748B),
                                  ),
                                ),
                                Text(
                                  '02 Sep 2024',
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
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Warning Alert Amber Pill (Tap opens spec / inspection modal!)
                InkWell(
                  onTap: () {
                    setState(() {
                      _selectedVehiclePlate = 'B 5678 ABC';
                    });
                    _openBeatSpec();
                  },
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF352A12) : const Color(0xFFFEF9C3),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isDark ? const Color(0xFF5C4410) : const Color(0xFFFDE047),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.warning_amber_rounded,
                          color: Color(0xFFD97706),
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Perlu pemeriksaan CVT & pembersihan saringan udara',
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w700,
                              color: isDark ? const Color(0xFFFDE047) : const Color(0xFF92400E),
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 11,
                          color: Color(0xFFD97706),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                // Bottom Action Buttons (50% / 50%)
                Row(
                  children: [
                    // Buku Servis Button
                    Expanded(
                      child: SizedBox(
                        height: 42,
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: isDark ? Colors.white : const Color(0xFF1E293B),
                            side: BorderSide(
                              color: isDark ? AppColors.borderDark : const Color(0xFFCBD5E1),
                              width: 1,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: EdgeInsets.zero,
                          ),
                          icon: Icon(
                            Icons.menu_book_rounded,
                            size: 16,
                            color: isDark ? Colors.white : const Color(0xFF1E293B),
                          ),
                          label: const Text(
                            'Buku Servis',
                            style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BukuServisScreen(
                                  controller: widget.controller,
                                  vehicleName: 'Honda BeAT Deluxe',
                                  plateNumber: 'B 5678 ABC',
                                  vehicleSub: 'Matic 110cc eSP • Deluxe Silver',
                                  odometer: '8.200 km',
                                  chassisNumber: 'MH1JM3129PK...',
                                  year: '2022',
                                  warrantyPeriod: 'Garansi Mesin 5 Tahun / 50.000 km s.d Nov 2027',
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),

                    // Booking Servis Button
                    Expanded(
                      child: SizedBox(
                        height: 42,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: EdgeInsets.zero,
                          ),
                          onPressed: () {
                            _navigateToBooking('B 5678 ABC');
                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Booking Servis',
                                style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700),
                              ),
                              SizedBox(width: 4),
                              Icon(Icons.chevron_right_rounded, size: 18),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDynamicVehicleCard(VehicleModel v, bool isDark) {
    final subtitle = '${v.transmission} • ${v.engineCc} • ${v.color}';
    final currentOdoStr = '${v.odometerKm} km';
    final isSelected = _selectedVehiclePlate == v.plateNumber;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? AppColors.primary : (isDark ? AppColors.borderDark : const Color(0xFFE2E8F0)),
          width: isSelected ? 2.0 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: isSelected
                ? AppColors.primary.withValues(alpha: isDark ? 0.28 : 0.12)
                : Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: isSelected ? 12 : 8,
            offset: isSelected ? const Offset(0, 3) : const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            setState(() {
              _selectedVehiclePlate = v.plateNumber;
            });
            _openDynamicSpec(v);
          },
          splashColor: AppColors.primary.withValues(alpha: 0.12),
          hoverColor: AppColors.primary.withValues(alpha: 0.04),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Row: Avatar + Title + Plate + Subtitle
                Row(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      width: isSelected ? 42 : 40,
                      height: isSelected ? 42 : 40,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? (isDark ? const Color(0xFF352614) : const Color(0xFFFEF3C7))
                            : (isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9)),
                        borderRadius: BorderRadius.circular(12),
                        border: isSelected
                            ? Border.all(color: AppColors.primary.withValues(alpha: 0.35))
                            : null,
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.two_wheeler_rounded,
                        color: isSelected
                            ? const Color(0xFFD97706)
                            : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569)),
                        size: isSelected ? 24 : 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  v.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTypography.getHeading(
                                    isDark: isDark,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                                decoration: BoxDecoration(
                                  color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  v.plateNumber,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: isDark ? AppColors.textSecondaryDark : const Color(0xFF475569),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  subtitle,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 11.5,
                                    color: isDark ? AppColors.textMutedDark : const Color(0xFF64748B),
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF97316).withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  v.garageLabel,
                                  style: const TextStyle(
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFFF97316),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 250),
                                padding: EdgeInsets.symmetric(horizontal: isSelected ? 8 : 6, vertical: isSelected ? 3 : 2),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? (isDark ? const Color(0xFF452408) : const Color(0xFFFFF7ED))
                                      : (isDark ? Colors.white10 : const Color(0xFFF1F5F9)),
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.primary.withValues(alpha: 0.5)
                                        : (isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1)),
                                    width: isSelected ? 1 : 0.8,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.touch_app_rounded,
                                      size: 10,
                                      color: isSelected ? AppColors.primary : (isDark ? Colors.white70 : const Color(0xFF64748B)),
                                    ),
                                    const SizedBox(width: 2),
                                    Text(
                                      'Spek',
                                      style: TextStyle(
                                        fontSize: 9.5,
                                        fontWeight: FontWeight.w700,
                                        color: isSelected ? AppColors.primary : (isDark ? Colors.white70 : const Color(0xFF475569)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // Middle Stats Box: Odometer + Servis Terakhir
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF131E2B) : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      // Odometer
                      Expanded(
                        child: InkWell(
                          onTap: () => _showEditOdoModal(v.name, currentOdoStr),
                          child: Row(
                            children: [
                              Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: isDark ? const Color(0xFF1E293B) : Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                alignment: Alignment.center,
                                child: Icon(
                                  Icons.access_time_rounded,
                                  size: 16,
                                  color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Odometer',
                                    style: TextStyle(
                                      fontSize: 10.5,
                                      color: isDark ? AppColors.textMutedDark : const Color(0xFF64748B),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        currentOdoStr,
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w800,
                                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Icon(
                                        Icons.edit_outlined,
                                        size: 13,
                                        color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Vertical Divider
                      Container(
                        width: 1,
                        height: 28,
                        color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                      ),

                      // Servis Terakhir / Status
                      Expanded(
                        child: Row(
                          children: [
                            Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: isDark ? const Color(0xFF1E293B) : Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              alignment: Alignment.center,
                              child: Icon(
                                Icons.calendar_today_outlined,
                                size: 15,
                                color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Status Unit',
                                  style: TextStyle(
                                    fontSize: 10.5,
                                    color: isDark ? AppColors.textMutedDark : const Color(0xFF64748B),
                                  ),
                                ),
                                Text(
                                  v.conditionStatus,
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
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Green Banner Notice (Tapping opens spec!)
                InkWell(
                  onTap: () => _openDynamicSpec(v),
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF142F1E) : const Color(0xFFF0FDF4),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isDark ? const Color(0xFF164E28) : const Color(0xFFDCFCE7),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.check_circle_rounded,
                          color: Color(0xFF16A34A),
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Unit terdaftar resmi AHASS (No Rangka: ${v.chassisNumber.length > 8 ? '${v.chassisNumber.substring(0, 8)}...' : v.chassisNumber})',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w700,
                              color: isDark ? const Color(0xFF86EFAC) : const Color(0xFF166534),
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 11,
                          color: Color(0xFF16A34A),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                // Bottom Action Buttons (50% / 50%)
                Row(
                  children: [
                    // Buku Servis Button
                    Expanded(
                      child: SizedBox(
                        height: 42,
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: isDark ? Colors.white : const Color(0xFF1E293B),
                            side: BorderSide(
                              color: isDark ? AppColors.borderDark : const Color(0xFFCBD5E1),
                              width: 1,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: EdgeInsets.zero,
                          ),
                          icon: Icon(
                            Icons.menu_book_rounded,
                            size: 16,
                            color: isDark ? Colors.white : const Color(0xFF1E293B),
                          ),
                          label: const Text(
                            'Buku Servis',
                            style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BukuServisScreen(
                                  controller: widget.controller,
                                  vehicleName: v.name,
                                  plateNumber: v.plateNumber,
                                  vehicleSub: subtitle,
                                  odometer: currentOdoStr,
                                  chassisNumber: v.chassisNumber,
                                  year: v.year,
                                  warrantyPeriod: 'Garansi Resmi AHASS s.d ${(int.tryParse(v.year) ?? 2024) + 5}',
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),

                    // Booking Servis Button
                    Expanded(
                      child: SizedBox(
                        height: 42,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: EdgeInsets.zero,
                          ),
                          onPressed: () {
                            _navigateToBooking(v.plateNumber);
                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Booking Servis',
                                style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700),
                              ),
                              SizedBox(width: 4),
                              Icon(Icons.chevron_right_rounded, size: 18),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAddVehicleCard(bool isDark) {
    return InkWell(
      onTap: () => _showAddVehicleModal(context),
      borderRadius: BorderRadius.circular(14),
      child: CustomPaint(
        painter: _DashedBorderPainter(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
          strokeWidth: 1.2,
          radius: 14,
          dashWidth: 6,
          dashSpace: 4,
        ),
        child: Container(
          width: double.infinity,
          height: 56,
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                ),
                alignment: Alignment.center,
                child: Icon(
                  Icons.add_rounded,
                  size: 18,
                  color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'Daftarkan Motor Baru',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white70 : const Color(0xFF475569),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double radius;
  final double dashWidth;
  final double dashSpace;

  _DashedBorderPainter({
    required this.color,
    this.strokeWidth = 1.0,
    this.radius = 12.0,
    this.dashWidth = 5.0,
    this.dashSpace = 3.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        strokeWidth / 2,
        strokeWidth / 2,
        size.width - strokeWidth,
        size.height - strokeWidth,
      ),
      Radius.circular(radius),
    );

    final path = Path()..addRRect(rrect);
    final dashedPath = Path();

    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final length = (distance + dashWidth < metric.length)
            ? dashWidth
            : metric.length - distance;
        dashedPath.addPath(
          metric.extractPath(distance, distance + length),
          Offset.zero,
        );
        distance += dashWidth + dashSpace;
      }
    }

    canvas.drawPath(dashedPath, paint);
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.radius != radius;
  }
}
