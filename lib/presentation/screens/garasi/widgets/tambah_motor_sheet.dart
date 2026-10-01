import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../controllers/app_controller.dart';
import '../../../../data/models/vehicle_model.dart';

void showTambahMotorSheet(
  BuildContext context, {
  required AppController controller,
  void Function(VehicleModel newVehicle)? onVehicleAdded,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => TambahMotorSheet(
      controller: controller,
      onVehicleAdded: onVehicleAdded,
    ),
  );
}

class TambahMotorSheet extends StatefulWidget {
  final AppController controller;
  final void Function(VehicleModel newVehicle)? onVehicleAdded;

  const TambahMotorSheet({
    super.key,
    required this.controller,
    this.onVehicleAdded,
  });

  @override
  State<TambahMotorSheet> createState() => _TambahMotorSheetState();
}

class _TambahMotorSheetState extends State<TambahMotorSheet> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _modelController = TextEditingController(text: 'Honda PCX 160 ABS');
  final TextEditingController _plateController = TextEditingController(text: 'B 3456 KKL');
  final TextEditingController _odometerController = TextEditingController(text: '2500');
  final TextEditingController _chassisController = TextEditingController(text: 'MH1KF5118PK459021');
  final TextEditingController _engineNumController = TextEditingController(text: 'KF51E-1049281');

  String _selectedTransmission = 'Matic (AT)';
  String _selectedCc = '160cc';
  String _selectedYear = '2024';
  String _selectedColor = 'Hitam Doff';
  String _selectedGarageLabel = 'Garasi Utama';
  bool _hasPhotoAttached = false;

  final List<String> _popularModels = [
    'Honda PCX 160 ABS',
    'Honda Vario 160',
    'Honda BeAT Deluxe',
    'Honda Scoopy Prestige',
    'Honda ADV 160',
    'Honda Stylo 160',
    'Honda CBR 150R',
    'Honda EM1 e: (Listrik)',
  ];

  final List<String> _transmissions = [
    'Matic (AT)',
    'Manual / Sport (MT)',
    'Bebek (Cub)',
    'EV (Listrik)',
  ];

  final List<String> _engineCcs = [
    '110cc',
    '125cc',
    '150cc',
    '160cc',
    '250cc',
    'Elektrik',
  ];

  final List<String> _years = [
    '2024',
    '2023',
    '2022',
    '2021',
    '2020',
    '2019',
  ];

  final List<String> _colors = [
    'Hitam Doff',
    'Putih Mutiara',
    'Merah Candy',
    'Deluxe Silver',
    'Matte Blue',
    'Titanium Gold',
  ];

  final List<String> _garageLabels = [
    'Garasi Utama',
    'Garasi Kedua',
    'Armada Operasional',
  ];

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      final name = _modelController.text.trim();
      final plate = _plateController.text.trim().toUpperCase();
      final odo = int.tryParse(_odometerController.text.replaceAll('.', '').trim()) ?? 0;

      final newVehicle = widget.controller.addVehicle(
        name,
        plate,
        odometerKm: odo,
        transmission: '$_selectedTransmission ($_selectedCc)',
        engineCc: _selectedCc,
        year: _selectedYear,
        color: _selectedColor,
        chassisNumber: _chassisController.text.trim(),
        engineNumber: _engineNumController.text.trim(),
        garageLabel: _selectedGarageLabel,
      );

      widget.onVehicleAdded?.call(newVehicle);
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Motor $name ($plate) berhasil didaftarkan ke Garasi!',
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
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
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.controller.isDarkMode;

    return DraggableScrollableSheet(
      initialChildSize: 0.90,
      minChildSize: 0.50,
      maxChildSize: 0.96,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.surfaceDark : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.15),
                blurRadius: 16,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Column(
            children: [
              // 1. Top Drag Handle & Title Row
              _buildHeader(isDark),

              // 2. Scrollable Form Body
              Expanded(
                child: Form(
                  key: _formKey,
                  child: ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
                    children: [
                      // STNK Plate Live Preview Banner
                      _buildPlatePreview(isDark),
                      const SizedBox(height: 20),

                      // Section 1: Identitas Motor
                      _buildSectionHeader('1. Identitas & Model Motor', Icons.two_wheeler_rounded, isDark),
                      const SizedBox(height: 12),

                      // Model Motor Text Field
                      TextFormField(
                        controller: _modelController,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                        ),
                        decoration: InputDecoration(
                          labelText: 'Nama / Model Motor *',
                          hintText: 'Contoh: Honda PCX 160 ABS',
                          prefixIcon: const Icon(Icons.motorcycle_rounded, color: AppColors.primary),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          filled: true,
                          fillColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
                        ),
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return 'Model motor wajib diisi';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),

                      // Quick Model Chips
                      Text(
                        'Pilihan Model Populer Honda:',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: isDark ? AppColors.textMutedDark : const Color(0xFF64748B),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        children: _popularModels.map((m) {
                          final isSelected = _modelController.text == m;
                          return ChoiceChip(
                            label: Text(m, style: TextStyle(fontSize: 11, fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500)),
                            selected: isSelected,
                            selectedColor: AppColors.primary.withValues(alpha: 0.15),
                            side: BorderSide(
                              color: isSelected ? AppColors.primary : (isDark ? AppColors.borderDark : const Color(0xFFCBD5E1)),
                            ),
                            labelStyle: TextStyle(
                              color: isSelected ? AppColors.primary : (isDark ? Colors.white70 : const Color(0xFF334155)),
                            ),
                            backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                            onSelected: (selected) {
                              if (selected) {
                                setState(() {
                                  _modelController.text = m;
                                  if (m.contains('160')) _selectedCc = '160cc';
                                  if (m.contains('150')) _selectedCc = '150cc';
                                  if (m.contains('BeAT') || m.contains('Scoopy')) _selectedCc = '110cc';
                                  if (m.contains('Listrik')) {
                                    _selectedTransmission = 'EV (Listrik)';
                                    _selectedCc = 'Elektrik';
                                  }
                                });
                              }
                            },
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 18),

                      // Transmisi & Kapasitas Mesin (CC)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Transmisi
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Tipe Transmisi',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: isDark ? Colors.white70 : const Color(0xFF334155),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  decoration: BoxDecoration(
                                    color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: isDark ? AppColors.borderDark : const Color(0xFFCBD5E1),
                                    ),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: _selectedTransmission,
                                      isExpanded: true,
                                      dropdownColor: isDark ? AppColors.surfaceDark : Colors.white,
                                      items: _transmissions.map((t) {
                                        return DropdownMenuItem(
                                          value: t,
                                          child: Text(t, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600)),
                                        );
                                      }).toList(),
                                      onChanged: (v) {
                                        if (v != null) setState(() => _selectedTransmission = v);
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),

                          // Kapasitas CC
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Kapasitas Mesin',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: isDark ? Colors.white70 : const Color(0xFF334155),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  decoration: BoxDecoration(
                                    color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: isDark ? AppColors.borderDark : const Color(0xFFCBD5E1),
                                    ),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: _selectedCc,
                                      isExpanded: true,
                                      dropdownColor: isDark ? AppColors.surfaceDark : Colors.white,
                                      items: _engineCcs.map((cc) {
                                        return DropdownMenuItem(
                                          value: cc,
                                          child: Text(cc, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600)),
                                        );
                                      }).toList(),
                                      onChanged: (v) {
                                        if (v != null) setState(() => _selectedCc = v);
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),

                      // Tahun & Warna
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Tahun
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Tahun Pembuatan',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: isDark ? Colors.white70 : const Color(0xFF334155),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  decoration: BoxDecoration(
                                    color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: isDark ? AppColors.borderDark : const Color(0xFFCBD5E1),
                                    ),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: _selectedYear,
                                      isExpanded: true,
                                      dropdownColor: isDark ? AppColors.surfaceDark : Colors.white,
                                      items: _years.map((y) {
                                        return DropdownMenuItem(
                                          value: y,
                                          child: Text(y, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600)),
                                        );
                                      }).toList(),
                                      onChanged: (v) {
                                        if (v != null) setState(() => _selectedYear = v);
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),

                          // Warna
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Warna Bodi',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: isDark ? Colors.white70 : const Color(0xFF334155),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  decoration: BoxDecoration(
                                    color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: isDark ? AppColors.borderDark : const Color(0xFFCBD5E1),
                                    ),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: _selectedColor,
                                      isExpanded: true,
                                      dropdownColor: isDark ? AppColors.surfaceDark : Colors.white,
                                      items: _colors.map((c) {
                                        return DropdownMenuItem(
                                          value: c,
                                          child: Text(c, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600)),
                                        );
                                      }).toList(),
                                      onChanged: (v) {
                                        if (v != null) setState(() => _selectedColor = v);
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Section 2: Dokumen Legalitas (STNK & Plat)
                      _buildSectionHeader('2. Dokumen Legalitas Resmi AHASS', Icons.description_outlined, isDark),
                      const SizedBox(height: 12),

                      // Plat Nomor Input
                      TextFormField(
                        controller: _plateController,
                        textCapitalization: TextCapitalization.characters,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                        ),
                        decoration: InputDecoration(
                          labelText: 'Nomor Polisi (Plat Nomor) *',
                          hintText: 'Contoh: B 3456 KKL',
                          prefixIcon: const Icon(Icons.pin_outlined, color: AppColors.primary),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          filled: true,
                          fillColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
                        ),
                        onChanged: (_) => setState(() {}),
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return 'Plat nomor wajib diisi';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),

                      // Nomor Rangka (Chassis VIN)
                      TextFormField(
                        controller: _chassisController,
                        textCapitalization: TextCapitalization.characters,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                        ),
                        decoration: InputDecoration(
                          labelText: 'Nomor Rangka (VIN / Chassis)',
                          hintText: 'Contoh: MH1KF5118PK459021',
                          helperText: '17 Karakter tertera di lembar STNK motor',
                          prefixIcon: const Icon(Icons.qr_code_rounded, color: Color(0xFF64748B)),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          filled: true,
                          fillColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Nomor Mesin
                      TextFormField(
                        controller: _engineNumController,
                        textCapitalization: TextCapitalization.characters,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                        ),
                        decoration: InputDecoration(
                          labelText: 'Nomor Mesin (Opsional)',
                          hintText: 'Contoh: KF51E-1049281',
                          prefixIcon: const Icon(Icons.settings_outlined, color: Color(0xFF64748B)),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          filled: true,
                          fillColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // AHASS Verification Guarantee Notice
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF332014) : const Color(0xFFFFF7ED),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isDark ? const Color(0xFF552D18) : const Color(0xFFFFEDD5),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.verified_rounded, size: 18, color: Color(0xFFEA580C)),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Data nomor rangka & nomor mesin akan disinkronkan secara otomatis ke sistem AHASS Online untuk aktivasi Kupon Perawatan Berkala (KPB gratis jasa & oli).',
                                style: TextStyle(
                                  fontSize: 11,
                                  height: 1.4,
                                  color: isDark ? const Color(0xFFFED7AA) : const Color(0xFF9A3412),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Section 3: Odometer & Status Garasi
                      _buildSectionHeader('3. Kondisi & Status Garasi', Icons.speed_rounded, isDark),
                      const SizedBox(height: 12),

                      // Odometer Input
                      TextFormField(
                        controller: _odometerController,
                        keyboardType: TextInputType.number,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                        ),
                        decoration: InputDecoration(
                          labelText: 'Jarak Tempuh Odometer Saat Ini *',
                          hintText: 'Contoh: 12450',
                          suffixText: 'km',
                          suffixStyle: const TextStyle(fontWeight: FontWeight.w700),
                          prefixIcon: const Icon(Icons.access_time_rounded, color: AppColors.primary),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          filled: true,
                          fillColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Label Garasi Selector
                      Text(
                        'Prioritas Kendaraan di Garasi:',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white70 : const Color(0xFF334155),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: _garageLabels.map((label) {
                          final isSelected = _selectedGarageLabel == label;
                          return Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 3),
                              child: InkWell(
                                onTap: () => setState(() => _selectedGarageLabel = label),
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? AppColors.primary
                                        : (isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC)),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: isSelected
                                          ? AppColors.primary
                                          : (isDark ? AppColors.borderDark : const Color(0xFFE2E8F0)),
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    label,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 10.5,
                                      fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                                      color: isSelected
                                          ? Colors.white
                                          : (isDark ? Colors.white70 : const Color(0xFF475569)),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 20),

                      // Section 4: Upload Foto Kendaraan / STNK
                      _buildPhotoUploadSlot(isDark),
                      const SizedBox(height: 28),

                      // Action Buttons
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                side: BorderSide(
                                  color: isDark ? AppColors.borderDark : const Color(0xFFCBD5E1),
                                ),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              onPressed: () => Navigator.pop(context),
                              child: Text(
                                'Batal',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: isDark ? Colors.white70 : const Color(0xFF475569),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 2,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              icon: const Icon(Icons.save_rounded, size: 20),
                              label: const Text(
                                'Daftarkan Motor',
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
                              ),
                              onPressed: _submitForm,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(bool isDark) {
    return Column(
      children: [
        // Drag Pill
        Center(
          child: Container(
            margin: const EdgeInsets.only(top: 10, bottom: 8),
            width: 44,
            height: 4.5,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF475569) : const Color(0xFFCBD5E1),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        ),

        // Header Title Row
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 6, 16, 12),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF352014) : const Color(0xFFFFF2EB),
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: const Icon(Icons.two_wheeler_rounded, color: AppColors.primary, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tambah Motor ke Garasi',
                      style: AppTypography.getHeading(
                        isDark: isDark,
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Sinkronisasi Buku Servis & Garansi AHASS',
                      style: TextStyle(
                        fontSize: 11.5,
                        color: isDark ? AppColors.textMutedDark : const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close_rounded, size: 22),
                color: isDark ? Colors.white70 : const Color(0xFF64748B),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
        const Divider(height: 1, thickness: 1, color: Color(0xFFF1F5F9)),
      ],
    );
  }

  Widget _buildPlatePreview(bool isDark) {
    final plate = _plateController.text.trim().isEmpty ? 'B 0000 XYZ' : _plateController.text.trim().toUpperCase();

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF131E2B) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.borderDark : const Color(0xFFE2E8F0),
        ),
      ),
      child: Row(
        children: [
          // Indonesian License Plate Miniature
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B), // Black plate
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.white70, width: 1.5),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  plate,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 1),
                const Text(
                  '09 • 29',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 8.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),

          // Vehicle Live Preview Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _modelController.text.trim().isEmpty ? 'Nama Motor' : _modelController.text,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.getHeading(isDark: isDark, fontSize: 14),
                ),
                const SizedBox(height: 2),
                Text(
                  '$_selectedTransmission • $_selectedCc • $_selectedColor',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? AppColors.textMutedDark : const Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Tahun $_selectedYear • $_selectedGarageLabel',
                  style: const TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFEA580C),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, bool isDark) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.w800,
            color: isDark ? Colors.white : const Color(0xFF0F172A),
          ),
        ),
      ],
    );
  }

  Widget _buildPhotoUploadSlot(bool isDark) {
    return InkWell(
      onTap: () {
        setState(() {
          _hasPhotoAttached = !_hasPhotoAttached;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_hasPhotoAttached ? 'Foto kendaraan & STNK berhasil dipilih!' : 'Foto kendaraan dihapus.'),
            duration: const Duration(seconds: 1),
          ),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: _hasPhotoAttached
              ? (isDark ? const Color(0xFF142F1E) : const Color(0xFFF0FDF4))
              : (isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC)),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _hasPhotoAttached
                ? const Color(0xFF16A34A)
                : (isDark ? AppColors.borderDark : const Color(0xFFCBD5E1)),
            style: BorderStyle.solid,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _hasPhotoAttached ? const Color(0xFF16A34A) : AppColors.primary.withValues(alpha: 0.15),
              ),
              alignment: Alignment.center,
              child: Icon(
                _hasPhotoAttached ? Icons.check_rounded : Icons.camera_alt_outlined,
                color: _hasPhotoAttached ? Colors.white : AppColors.primary,
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _hasPhotoAttached ? 'Foto Motor & Lembar STNK Terlampir' : 'Upload Foto Motor / STNK (Opsional)',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: _hasPhotoAttached
                          ? const Color(0xFF16A34A)
                          : (isDark ? Colors.white70 : const Color(0xFF334155)),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _hasPhotoAttached ? 'Tap untuk mengganti atau menghapus' : 'Mempermudah verifikasi unit di bengkel resmi',
                    style: TextStyle(
                      fontSize: 10.5,
                      color: isDark ? AppColors.textMutedDark : const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
