import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/vehicle_model.dart';
import '../../../data/models/service_model.dart';
import '../../controllers/app_controller.dart';
import 'booking_confirm_screen.dart';

class SchedulePickerScreen extends StatefulWidget {
  final AppController controller;
  final VehicleModel vehicle;
  final ServiceModel service;
  final bool isHomeService;
  final int? totalPrice;
  final List<Map<String, dynamic>>? vehicles;

  const SchedulePickerScreen({
    super.key,
    required this.controller,
    required this.vehicle,
    required this.service,
    this.isHomeService = false,
    this.totalPrice,
    this.vehicles,
  });

  @override
  State<SchedulePickerScreen> createState() => _SchedulePickerScreenState();
}

class _SchedulePickerScreenState extends State<SchedulePickerScreen> {
  // Default values matching Figma Step 2 Mockup
  int _selectedDateIndex = 3; // Index 3 = Kamis 26
  int _selectedTimeIndex = 1; // Index 1 = 09:30
  int _selectedArmadaOption = 0; // 0 = Servis Bersamaan, 1 = Servis Bergantian

  String _selectedWorkshop = 'AHASS Servisin Mitra Cihampelas';
  String _selectedDistance = '1.2 km';
  double _selectedRating = 4.9;
  String _selectedReviewCount = '1.2rb';

  final List<Map<String, dynamic>> _dateSlots = [
    {'day': 'Sen', 'date': '23', 'fullDate': 'Senin, 23 Sep'},
    {'day': 'Sel', 'date': '24', 'fullDate': 'Selasa, 24 Sep'},
    {'day': 'Rab', 'date': '25', 'fullDate': 'Rabu, 25 Sep'},
    {'day': 'Kam', 'date': '26', 'fullDate': 'Kamis, 26 Sep'},
    {'day': 'Jum', 'date': '27', 'fullDate': 'Jumat, 27 Sep'},
    {'day': 'Sab', 'date': '28', 'fullDate': 'Sabtu, 28 Sep'},
    {'day': 'Min', 'date': '29', 'fullDate': 'Minggu, 29 Sep'},
  ];

  final List<Map<String, dynamic>> _timeSlots = [
    {'time': '08:30', 'status': 'Tersedia', 'available': true},
    {'time': '09:30', 'status': 'Dipilih', 'available': true},
    {'time': '10:30', 'status': 'Tersedia', 'available': true},
    {'time': '11:00', 'status': 'Penuh', 'available': false},
    {'time': '13:30', 'status': 'Tersedia', 'available': true},
    {'time': '15:00', 'status': 'Tersedia', 'available': true},
  ];

  final List<Map<String, dynamic>> _workshopList = [
    {
      'name': 'AHASS Servisin Mitra Cihampelas',
      'distance': '1.2 km',
      'rating': 4.9,
      'reviews': '1.2rb',
      'pits': 4,
      'isOfficial': true,
      'hasWifi': true,
    },
    {
      'name': 'AHASS Daya Motor Sudirman',
      'distance': '2.4 km',
      'rating': 4.8,
      'reviews': '950',
      'pits': 3,
      'isOfficial': true,
      'hasWifi': true,
    },
    {
      'name': 'AHASS Bintang Motor Pasteur',
      'distance': '3.1 km',
      'rating': 4.9,
      'reviews': '1.5rb',
      'pits': 5,
      'isOfficial': true,
      'hasWifi': true,
    },
    {
      'name': 'AHASS Mitra Sejahtera Thamrin',
      'distance': '4.0 km',
      'rating': 4.7,
      'reviews': '680',
      'pits': 2,
      'isOfficial': true,
      'hasWifi': false,
    },
  ];

  int get _finalPrice => widget.totalPrice ?? 285000;

  String _formatCurrency(int amount) {
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

  void _showChangeWorkshopSheet(bool isDark) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
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
                  color: const Color(0xFFCBD5E1),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF7ED),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.location_on_rounded,
                    color: Color(0xFFF97316),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pilih Bengkel Mitra AHASS',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                        ),
                      ),
                      Text(
                        'Pilih bengkel dengan montir bersertifikat resmi',
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark ? AppColors.textSecondaryDark : const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ..._workshopList.map((ws) {
              final isCur = ws['name'] == _selectedWorkshop;
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _selectedWorkshop = ws['name'] as String;
                      _selectedDistance = ws['distance'] as String;
                      _selectedRating = (ws['rating'] as num).toDouble();
                      _selectedReviewCount = ws['reviews'] as String;
                    });
                    Navigator.pop(ctx);
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isCur
                          ? (isDark ? const Color(0xFF332014) : const Color(0xFFFFF7ED))
                          : (isDark ? const Color(0xFF1E293B) : Colors.white),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isCur
                            ? const Color(0xFFF97316)
                            : (isDark ? AppColors.borderDark : const Color(0xFFE2E8F0)),
                        width: isCur ? 1.5 : 1.0,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isCur ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                          color: isCur ? const Color(0xFFF97316) : const Color(0xFF94A3B8),
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                ws['name'] as String,
                                style: TextStyle(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w800,
                                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${ws['distance']} • ⭐ ${ws['rating']} (${ws['reviews']}) • ${ws['pits']} Pit Aktif',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFF64748B),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.controller.isDarkMode;
    const primaryColor = Color(0xFFF97316);

    final selectedDateStr = _dateSlots[_selectedDateIndex]['fullDate'] as String;
    final selectedTimeStr = _timeSlots[_selectedTimeIndex]['time'] as String;
    final vehicleCount = widget.vehicles?.length ?? 2;

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
          'Jadwal & Bengkel',
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
            // 1. Stepper Bar (Step 2 active)
            Container(
              color: isDark ? AppColors.surfaceDark : Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Step 1: Done (Checkmark)
                  _buildStepItem(
                    stepNumber: '1',
                    title: 'Unit & Servis',
                    isActive: false,
                    isDone: true,
                    activeColor: primaryColor,
                    isDark: isDark,
                  ),
                  _buildStepConnector(isDone: true),

                  // Step 2: Active (Current screen)
                  _buildStepItem(
                    stepNumber: '2',
                    title: 'Bengkel & Waktu',
                    isActive: true,
                    isDone: false,
                    activeColor: primaryColor,
                    isDark: isDark,
                  ),
                  _buildStepConnector(isDone: false),

                  // Step 3: Pending
                  _buildStepItem(
                    stepNumber: '3',
                    title: 'Konfirmasi',
                    isActive: false,
                    isDone: false,
                    activeColor: primaryColor,
                    isDark: isDark,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Content Container with Padding
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // SECTION 1: Pilih Bengkel Mitra
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Pilih Bengkel Mitra',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Search Bar with Location Pin Button
                  InkWell(
                    onTap: () => _showChangeWorkshopSheet(isDark),
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      height: 44,
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.surfaceDark : Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isDark ? AppColors.borderDark : const Color(0xFFE2E8F0),
                          width: 1.0,
                        ),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.search_rounded, color: Color(0xFF94A3B8), size: 20),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Cari bengkel terdekat...',
                              style: TextStyle(
                                fontSize: 12.5,
                                color: Color(0xFF94A3B8),
                              ),
                            ),
                          ),
                          Icon(
                            Icons.my_location_rounded,
                            color: primaryColor,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Featured Workshop Card with Orange Border
                  Container(
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.surfaceDark : Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: primaryColor,
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: primaryColor.withValues(alpha: 0.08),
                          blurRadius: 12,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title & Distance
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                _selectedWorkshop,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _selectedDistance,
                              style: const TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        // Rating & Tag Badges
                        Row(
                          children: [
                            const Icon(Icons.star_rounded, color: Color(0xFFF59E0B), size: 16),
                            const SizedBox(width: 3),
                            Text(
                              '$_selectedRating',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                color: isDark ? Colors.white : const Color(0xFF0F172A),
                              ),
                            ),
                            const SizedBox(width: 2),
                            Text(
                              '($_selectedReviewCount)',
                              style: const TextStyle(
                                fontSize: 11,
                                color: Color(0xFF64748B),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                              decoration: BoxDecoration(
                                color: const Color(0xFFDCFCE7),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                'Bengkel Resmi',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF16A34A),
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE0F2FE),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                'AC & Free WiFi',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF0284C7),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        // Alert Pill: 4 Pit Montir Aktif — Bisa servis 2 motor bersamaan
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF7ED),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: const Color(0xFFFFEDD5),
                              width: 1.0,
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.bolt_rounded, color: Color(0xFFF97316), size: 16),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  '4 Pit Montir Aktif — Bisa servis $vehicleCount motor bersamaan',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFFEA580C),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Interactive Map Route Preview
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: SizedBox(
                            height: 135,
                            width: double.infinity,
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                return Stack(
                                  children: [
                                    Positioned.fill(
                                      child: CustomPaint(
                                        painter: _MapRoutePainter(),
                                      ),
                                    ),
                                    // Destination Pin Arrow Icon perfectly aligned on route destination
                                    Positioned(
                                      left: constraints.maxWidth * 0.76 - 13,
                                      top: 135 * 0.35 - 13,
                                      child: Container(
                                        width: 26,
                                        height: 26,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF0284C7),
                                          shape: BoxShape.circle,
                                          border: Border.all(color: Colors.white, width: 2),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withValues(alpha: 0.2),
                                              blurRadius: 5,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: const Icon(
                                          Icons.near_me_rounded,
                                          color: Colors.white,
                                          size: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        // Link Ubah Bengkel
                        Align(
                          alignment: Alignment.centerRight,
                          child: InkWell(
                            onTap: () => _showChangeWorkshopSheet(isDark),
                            borderRadius: BorderRadius.circular(8),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Ubah Bengkel',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: primaryColor,
                                    ),
                                  ),
                                  SizedBox(width: 3),
                                  Icon(
                                    Icons.arrow_forward_rounded,
                                    size: 13,
                                    color: primaryColor,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // SECTION 2: Pilih Tanggal Kedatangan
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                        size: 17,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Pilih Tanggal Kedatangan',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Horizontal Date Cards (Sen 23 ... Kam 26 ... Min 29)
                  SizedBox(
                    height: 68,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemCount: _dateSlots.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (context, idx) {
                        final item = _dateSlots[idx];
                        final isSelected = _selectedDateIndex == idx;

                        return InkWell(
                          onTap: () {
                            setState(() => _selectedDateIndex = idx);
                          },
                          borderRadius: BorderRadius.circular(14),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 52,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? primaryColor
                                  : (isDark ? AppColors.surfaceDark : Colors.white),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: isSelected
                                    ? primaryColor
                                    : (isDark ? AppColors.borderDark : const Color(0xFFE2E8F0)),
                                width: 1.0,
                              ),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: primaryColor.withValues(alpha: 0.3),
                                        blurRadius: 8,
                                        offset: const Offset(0, 3),
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  item['day'] as String,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: isSelected
                                        ? Colors.white
                                        : const Color(0xFF64748B),
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  item['date'] as String,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    color: isSelected
                                        ? Colors.white
                                        : (isDark ? Colors.white : const Color(0xFF0F172A)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 20),

                  // SECTION 3: Pilih Jam Kedatangan
                  Row(
                    children: [
                      Icon(
                        Icons.access_time_rounded,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                        size: 17,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Pilih Jam Kedatangan',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Time Slots Grid (2 rows x 3 columns)
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 1.7,
                    ),
                    itemCount: _timeSlots.length,
                    itemBuilder: (context, idx) {
                      final slot = _timeSlots[idx];
                      final isSelected = _selectedTimeIndex == idx;
                      final isAvailable = slot['available'] as bool;

                      return InkWell(
                        onTap: isAvailable
                            ? () {
                                setState(() => _selectedTimeIndex = idx);
                              }
                            : null,
                        borderRadius: BorderRadius.circular(12),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFFFFF7ED)
                                : (!isAvailable
                                    ? (isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC))
                                    : (isDark ? AppColors.surfaceDark : Colors.white)),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? primaryColor
                                  : (isDark ? AppColors.borderDark : const Color(0xFFE2E8F0)),
                              width: isSelected ? 1.5 : 1.0,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                slot['time'] as String,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  color: isSelected
                                      ? primaryColor
                                      : (!isAvailable
                                          ? const Color(0xFF94A3B8)
                                          : (isDark ? Colors.white : const Color(0xFF0F172A))),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                isSelected
                                    ? '✔ Dipilih'
                                    : (slot['status'] as String),
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: isSelected
                                      ? primaryColor
                                      : (!isAvailable
                                          ? const Color(0xFFEF4444)
                                          : const Color(0xFF10B981)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  // SECTION 4: Opsi Pengerjaan Armada
                  Row(
                    children: [
                      Icon(
                        Icons.settings_outlined,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Opsi Pengerjaan Armada',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Option 1: Servis Bersamaan (2 Pit Sekaligus)
                  InkWell(
                    onTap: () {
                      setState(() => _selectedArmadaOption = 0);
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: _selectedArmadaOption == 0
                            ? const Color(0xFFFFF7ED)
                            : (isDark ? AppColors.surfaceDark : Colors.white),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: _selectedArmadaOption == 0
                              ? primaryColor
                              : (isDark ? AppColors.borderDark : const Color(0xFFE2E8F0)),
                          width: _selectedArmadaOption == 0 ? 1.5 : 1.0,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            _selectedArmadaOption == 0
                                ? Icons.radio_button_checked
                                : Icons.radio_button_unchecked,
                            color: _selectedArmadaOption == 0
                                ? primaryColor
                                : const Color(0xFF94A3B8),
                            size: 22,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Servis Bersamaan',
                                  style: TextStyle(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w800,
                                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '$vehicleCount Pit Sekaligus — Hemat Waktu',
                                  style: const TextStyle(
                                    fontSize: 11.5,
                                    color: Color(0xFF64748B),
                                  ),
                                ),
                                const SizedBox(height: 1),
                                const Text(
                                  'Est. 90 menit',
                                  style: TextStyle(
                                    fontSize: 10.5,
                                    color: Color(0xFF94A3B8),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Option 2: Servis Bergantian
                  InkWell(
                    onTap: () {
                      setState(() => _selectedArmadaOption = 1);
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: _selectedArmadaOption == 1
                            ? const Color(0xFFFFF7ED)
                            : (isDark ? AppColors.surfaceDark : Colors.white),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: _selectedArmadaOption == 1
                              ? primaryColor
                              : (isDark ? AppColors.borderDark : const Color(0xFFE2E8F0)),
                          width: _selectedArmadaOption == 1 ? 1.5 : 1.0,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            _selectedArmadaOption == 1
                                ? Icons.radio_button_checked
                                : Icons.radio_button_unchecked,
                            color: _selectedArmadaOption == 1
                                ? primaryColor
                                : const Color(0xFF94A3B8),
                            size: 22,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Servis Bergantian',
                                  style: TextStyle(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w800,
                                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                const Text(
                                  'Cocok jika bawa motor sendiri bolak-balik',
                                  style: TextStyle(
                                    fontSize: 11.5,
                                    color: Color(0xFF64748B),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),

      // Sticky Bottom Bar
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
              // Left: Info & Price
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$selectedDateStr • $selectedTimeStr WIB',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF475569),
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    _selectedWorkshop.replaceFirst('AHASS Servisin ', 'AHASS '),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 10.5,
                      color: Color(0xFF94A3B8),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _formatCurrency(_finalPrice),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 14),

              // Right: Action Button
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
                  onPressed: () {
                    final datePart = _dateSlots[_selectedDateIndex];
                    final parsedDate = DateTime(2024, 9, int.parse(datePart['date'] as String));

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BookingConfirmScreen(
                          controller: widget.controller,
                          vehicle: widget.vehicle,
                          service: widget.service,
                          scheduleDate: parsedDate,
                          scheduleTime: '$selectedTimeStr WIB',
                          workshopName: _selectedWorkshop,
                        ),
                      ),
                    );
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          'Lanjut ke Konfirmasi',
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

  Widget _buildStepItem({
    required String stepNumber,
    required String title,
    required bool isActive,
    required bool isDone,
    required Color activeColor,
    required bool isDark,
  }) {
    const inactiveColor = Color(0xFF94A3B8);
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
                    color: isActive ? Colors.white : inactiveColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
        ),
        const SizedBox(height: 6),
        Text(
          title,
          style: TextStyle(
            color: isDone
                ? doneColor
                : (isActive ? activeColor : inactiveColor),
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

// -------------------------------------------------------------
// Vector Canvas Map Route Painter
// -------------------------------------------------------------
class _MapRoutePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // 1. Background map grid
    final bgPaint = Paint()..color = const Color(0xFFF1F5F9);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    // 2. City Park areas (soft green)
    final parkPaint = Paint()..color = const Color(0xFFDCFCE7);
    final parkRect1 = RRect.fromRectAndRadius(
      Rect.fromLTWH(size.width * 0.16, size.height * 0.08, size.width * 0.30, size.height * 0.22),
      const Radius.circular(6),
    );
    canvas.drawRRect(parkRect1, parkPaint);

    final parkRect2 = RRect.fromRectAndRadius(
      Rect.fromLTWH(size.width * 0.44, size.height * 0.64, size.width * 0.26, size.height * 0.28),
      const Radius.circular(6),
    );
    canvas.drawRRect(parkRect2, parkPaint);

    final parkRect3 = RRect.fromRectAndRadius(
      Rect.fromLTWH(size.width * 0.02, size.height * 0.64, size.width * 0.26, size.height * 0.28),
      const Radius.circular(6),
    );
    canvas.drawRRect(parkRect3, parkPaint);

    // 3. Lake / Water areas (soft blue)
    final waterPaint = Paint()..color = const Color(0xFFBAE6FD);
    final waterPath = Path();
    waterPath.moveTo(size.width * 0.58, 0);
    waterPath.quadraticBezierTo(
      size.width * 0.62, size.height * 0.22,
      size.width * 0.72, size.height * 0.18,
    );
    waterPath.quadraticBezierTo(
      size.width * 0.82, size.height * 0.14,
      size.width * 0.76, 0,
    );
    waterPath.close();
    canvas.drawPath(waterPath, waterPaint);

    final waterPath2 = Path();
    waterPath2.moveTo(size.width * 0.76, size.height * 0.65);
    waterPath2.quadraticBezierTo(
      size.width * 0.70, size.height * 0.85,
      size.width * 0.85, size.height,
    );
    waterPath2.lineTo(size.width, size.height);
    waterPath2.lineTo(size.width, size.height * 0.65);
    waterPath2.close();
    canvas.drawPath(waterPath2, waterPaint);

    // 4. White roads grid
    final roadPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.square;

    // Horizontal roads
    canvas.drawLine(Offset(0, size.height * 0.35), Offset(size.width, size.height * 0.35), roadPaint);
    canvas.drawLine(Offset(0, size.height * 0.62), Offset(size.width, size.height * 0.62), roadPaint);

    // Vertical roads
    canvas.drawLine(Offset(size.width * 0.12, 0), Offset(size.width * 0.12, size.height), roadPaint);
    canvas.drawLine(Offset(size.width * 0.44, 0), Offset(size.width * 0.44, size.height), roadPaint);
    canvas.drawLine(Offset(size.width * 0.76, 0), Offset(size.width * 0.76, size.height), roadPaint);

    // 5. Street & Park text labels
    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    void drawText(String text, Offset pos, {Color color = const Color(0xFF94A3B8), double fontSize = 7.5}) {
      textPainter.text = TextSpan(
        text: text,
        style: TextStyle(color: color, fontSize: fontSize, fontWeight: FontWeight.w600),
      );
      textPainter.layout();
      textPainter.paint(canvas, pos);
    }
    drawText('City Park', Offset(size.width * 0.24, size.height * 0.16));
    drawText('City Park', Offset(size.width * 0.50, size.height * 0.76));

    // 6. Navigation Route (Vibrant Blue Polyline)
    final routePaint = Paint()
      ..color = const Color(0xFF0284C7)
      ..strokeWidth = 4.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    final routePath = Path();
    final startPt = Offset(size.width * 0.12, size.height * 0.62);
    final turn1 = Offset(size.width * 0.44, size.height * 0.62);
    final turn2 = Offset(size.width * 0.44, size.height * 0.35);
    final endPt = Offset(size.width * 0.76, size.height * 0.35);

    routePath.moveTo(startPt.dx, startPt.dy);
    routePath.lineTo(turn1.dx, turn1.dy);
    routePath.lineTo(turn2.dx, turn2.dy);
    routePath.lineTo(endPt.dx, endPt.dy);
    canvas.drawPath(routePath, routePaint);

    // 7. Start Point Dot
    final startDotPaint = Paint()..color = const Color(0xFF0284C7);
    final startRingPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(startPt, 5, startDotPaint);
    canvas.drawCircle(startPt, 5, startRingPaint);
    drawText('Start', Offset(startPt.dx - 12, startPt.dy + 7), color: const Color(0xFF0284C7), fontSize: 8);
    // 8. End Destination Pin is rendered by widget stack on top
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
