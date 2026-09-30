import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../controllers/app_controller.dart';
import '../../booking/booking_step1_screen.dart';

class TipsDetailModal extends StatefulWidget {
  final AppController controller;

  const TipsDetailModal({
    super.key,
    required this.controller,
  });

  static void show(BuildContext context, AppController controller) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enableDrag: false,
      builder: (_) => TipsDetailModal(controller: controller),
    );
  }

  @override
  State<TipsDetailModal> createState() => _TipsDetailModalState();
}

class _TipsDetailModalState extends State<TipsDetailModal> {
  final ScrollController _scrollController = ScrollController();
  double _dragOffset = 0.0;
  bool _isDragging = false;
  bool _isPopping = false;

  void _safePop() {
    if (_isPopping || !mounted) return;
    _isPopping = true;
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  int _selectedOilCondition = 1; // Default to "Cokelat Kehitaman"
  int _selectedMotorcycle = 0; // Default to Vario
  int _selectedPriceIndex = 0; // Default to MPX 2 (Terpopuler)

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // Honda official oil price list
  static const List<Map<String, dynamic>> _prices = [
    {
      'title': 'Oli Mesin MPX 2 (Matic 0.8L)',
      'spec': 'Semi-Synthetic SAE 10W-30',
      'price': 'Rp 52.000',
      'popular': true,
    },
    {
      'title': 'Oli Mesin SPX 2 (Matic 0.8L)',
      'spec': 'Full Synthetic Superior Protection',
      'price': 'Rp 68.000',
      'popular': false,
    },
    {
      'title': 'Oli Gardan AHM (Gear Oil 120ml)',
      'spec': 'Pelumas Transmisi Girboks Matik',
      'price': 'Rp 16.000',
      'popular': false,
    },
  ];

  // Motorcycle data pool - only Vario and BeAT (matching actual app garage)
  static const List<Map<String, dynamic>> _motorData = [
    {
      'name': 'Honda Vario 160 / 125',
      'tag': 'eSP+ 4-Katup',
      'engineOil': 'AHM Oil MPX 2 / SPX 2',
      'capacity': '0.8 Liter',
      'gearOil': '120 ml (Tiap 8.000 KM)',
      'spec': 'SAE 10W-30 JASO MB',
      'image': 'assets/images/motor_vario.png',
      'price': 'Rp 55.000',
    },
    {
      'name': 'Honda BeAT / Scoopy',
      'tag': 'eSP 110cc Compact',
      'engineOil': 'AHM Oil MPX 2 (Matic)',
      'capacity': '0.65 Liter (Model Baru)',
      'gearOil': '120 ml (Tiap 8.000 KM)',
      'spec': 'SAE 10W-30 JASO MB',
      'image': 'assets/images/motor_beat.png',
      'price': 'Rp 52.000',
    },
  ];

  // Oil condition data pool
  static const List<Map<String, dynamic>> _oilConditions = [
    {
      'title': 'Kuning Keemasan',
      'km': '0 - 1.000 KM',
      'status': 'Kondisi Prima',
      'statusColor': Color(0xFF16A34A),
      'oilColor': Color(0xFFEAB308),
      'headline': 'Daya Lumasan Maksimal',
      'desc':
          'Oli masih sangat jernih dan licin. Melindungi gesekan piston, klep, dan kruk as secara sempurna. Suara mesin halus dan tarikan sangat responsif.',
    },
    {
      'title': 'Cokelat Kehitaman',
      'km': '1.500 - 2.500 KM',
      'status': 'Siap Ganti',
      'statusColor': Color(0xFFD97706),
      'oilColor': Color(0xFFB45309),
      'headline': 'Viskositas Mulai Menurun',
      'desc':
          'Oli mulai teroksidasi dan menyerap residu karbon sisa pembakaran. Sangat disarankan untuk segera melakukan penggantian agar mesin tidak cepat panas.',
    },
    {
      'title': 'Hitam Pekat & Encer',
      'km': '> 3.000 KM',
      'status': 'Kritis! Wajib Ganti',
      'statusColor': Color(0xFFDC2626),
      'oilColor': Color(0xFF0F172A),
      'headline': 'Resiko Turun Mesin (Overhaul)',
      'desc':
          'Daya lumas hilang total! Gesekan antar logam memicu dinding silinder dan piston baret. Biaya turun mesin bisa mencapai lebih dari Rp 1.500.000.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = widget.controller.isDarkMode;
    final size = MediaQuery.of(context).size;
    final currentMotor = _motorData[_selectedMotorcycle];
    final currentCondition = _oilConditions[_selectedOilCondition];

    return AnimatedContainer(
      duration: _isDragging ? Duration.zero : const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      transform: Matrix4.translationValues(0, _dragOffset, 0),
      child: Container(
        height: size.height * 0.90,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.35),
              blurRadius: 30,
              offset: const Offset(0, -6),
            ),
          ],
        ),
        child: Column(
          children: [
            // Scrollable Content Body with drag-to-dismiss support
            Expanded(
              child: NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  if (notification is OverscrollNotification &&
                      notification.overscroll < 0) {
                    setState(() {
                      _isDragging = true;
                      _dragOffset =
                          (_dragOffset - notification.overscroll * 0.7)
                              .clamp(0.0, 600.0);
                    });
                  } else if (notification is ScrollEndNotification) {
                    setState(() => _isDragging = false);
                    if (_dragOffset > 75) {
                      _safePop();
                    } else if (_dragOffset > 0) {
                      setState(() => _dragOffset = 0.0);
                    }
                  }
                  return false;
                },
                child: ListView(
                  controller: _scrollController,
                  physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  padding: EdgeInsets.zero,
                  children: [
                    // 1. Hero Header Banner with drag gesture
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onVerticalDragStart: (_) =>
                          setState(() => _isDragging = true),
                      onVerticalDragUpdate: (details) {
                        if ((details.primaryDelta != null &&
                                details.primaryDelta! > 0) ||
                            _dragOffset > 0) {
                          setState(() {
                            _dragOffset = (_dragOffset +
                                    (details.primaryDelta ?? 0))
                                .clamp(0.0, 600.0);
                          });
                        }
                      },
                      onVerticalDragEnd: (details) {
                        setState(() => _isDragging = false);
                        if (_dragOffset > 75 ||
                            (details.primaryVelocity != null &&
                                details.primaryVelocity! > 250)) {
                          _safePop();
                        } else {
                          setState(() => _dragOffset = 0.0);
                        }
                      },
                      child: _buildHeroBanner(context, isDark),
                    ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 20, 18, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 2. Interactive Oil Health Indicator (Warna & Kondisi Oli)
                      _buildOilConditionSection(isDark, currentCondition),

                      const SizedBox(height: 24),

                      // 3. Vehicle-specific Oil Spec & Capacity Matrix
                      _buildMotorcycleMatrixSection(isDark, currentMotor),

                      const SizedBox(height: 24),

                      // 4. Golden Rule: 2:1 Ratio (Mesin vs Gardan)
                      _buildGoldenRuleCard(isDark),

                      const SizedBox(height: 24),

                      // 5. Why AHM Oil (Genuine Value Props)
                      _buildGenuineValueProps(isDark),

                      const SizedBox(height: 24),

                      // 6. Transparent Price List AHASS
                      _buildPriceListSection(isDark),

                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Sticky Bottom Booking Bar
        _buildStickyBottomBar(context, isDark, currentMotor),
      ],
    ),
  ),
);
}

  // 1. Hero Header Banner
  Widget _buildHeroBanner(BuildContext context, bool isDark) {
    return Stack(
      children: [
        Container(
          height: 210,
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Color(0xFF0F172A),
          ),
          child: Image.asset(
            'assets/images/Ilustrasi-ganti-oli.webp',
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              color: AppColors.primaryContainerLight,
              child: const Icon(Icons.two_wheeler_rounded,
                  size: 64, color: AppColors.primary),
            ),
          ),
        ),
        // Smooth gradient scrim overlay
        Container(
          height: 210,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withValues(alpha: 0.35),
                Colors.black.withValues(alpha: 0.50),
                Colors.black.withValues(alpha: 0.92),
              ],
            ),
          ),
        ),

        // Floating drag handle pill at top center
        Positioned(
          top: 10,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              width: 42,
              height: 4.5,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.65),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ),

        // Top badges & close button
        Positioned(
          top: 24,
          left: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.verified_rounded, size: 13, color: Colors.white),
                SizedBox(width: 5),
                Text(
                  'AHASS GENUINE CARE',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.6,
                  ),
                ),
              ],
            ),
          ),
        ),

        Positioned(
          top: 22,
          right: 16,
          child: InkWell(
            onTap: _safePop,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.5),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.2),
                ),
              ),
              child: const Icon(Icons.close_rounded,
                  size: 20, color: Colors.white),
            ),
          ),
        ),

        // Hero title
        Positioned(
          bottom: 16,
          left: 16,
          right: 16,
          child: const Text(
            'Kapan Waktu Tepat Ganti Oli Mesin & Gardan?',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w800,
              height: 1.25,
            ),
          ),
        ),
      ],
    );
  }

  // 2. Interactive Oil Condition Section
  Widget _buildOilConditionSection(
      bool isDark, Map<String, dynamic> currentCondition) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.colorize_rounded,
                  color: AppColors.primary, size: 18),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Cek Warna Oli Motormu',
                    style: AppTypography.getHeading(
                      isDark: isDark,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    'Ketuk kondisi oli untuk melihat dampak pada mesin:',
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
        const SizedBox(height: 14),

        // 3 Selectable Oil Cards
        Row(
          children: List.generate(_oilConditions.length, (index) {
            final item = _oilConditions[index];
            final isSelected = _selectedOilCondition == index;

            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  right: index < _oilConditions.length - 1 ? 8 : 0,
                ),
                child: InkWell(
                  onTap: () => setState(() => _selectedOilCondition = index),
                  borderRadius: BorderRadius.circular(14),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? (isDark
                              ? const Color(0xFF1E293B)
                              : const Color(0xFFFFF7ED))
                          : (isDark
                              ? AppColors.cardDark
                              : const Color(0xFFF8FAFC)),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : (isDark
                                ? AppColors.borderDark
                                : const Color(0xFFE2E8F0)),
                        width: isSelected ? 2 : 1,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: 0.2),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ]
                          : null,
                    ),
                    child: Column(
                      children: [
                        // Droplet visual
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: item['oilColor'] as Color,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: (item['oilColor'] as Color)
                                    .withValues(alpha: 0.4),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(
                            isSelected
                                ? Icons.check_circle_rounded
                                : Icons.water_drop_rounded,
                            size: 16,
                            color: index == 0 ? Colors.black87 : Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          item['title'] as String,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: isDark
                                ? Colors.white
                                : const Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: (item['statusColor'] as Color)
                                .withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            item['status'] as String,
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                              color: item['statusColor'] as Color,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ),

        const SizedBox(height: 12),

        // Condition Details Card
        AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardDark : const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isDark ? AppColors.borderDark : const Color(0xFFE2E8F0),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                _selectedOilCondition == 0
                    ? Icons.sentiment_very_satisfied_rounded
                    : (_selectedOilCondition == 1
                        ? Icons.info_outline_rounded
                        : Icons.warning_rounded),
                color: currentCondition['statusColor'] as Color,
                size: 24,
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
                          currentCondition['headline'] as String,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: isDark
                                ? Colors.white
                                : const Color(0xFF0F172A),
                          ),
                        ),
                        Text(
                          currentCondition['km'] as String,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: currentCondition['statusColor'] as Color,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      currentCondition['desc'] as String,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : const Color(0xFF475569),
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // 3. Vehicle-specific Oil Spec & Capacity Matrix
  Widget _buildMotorcycleMatrixSection(
      bool isDark, Map<String, dynamic> currentMotor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.two_wheeler_rounded,
                  color: AppColors.primary, size: 18),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Takaran Presisi Sesuai Motormu',
                  style: AppTypography.getHeading(
                    isDark: isDark,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  'Pilih tipe motormu untuk melihat takaran oli resmi:',
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),

        // 2 Symmetrical Motor Segment Tabs: Vario & BeAT
        Row(
          children: List.generate(_motorData.length, (index) {
            final motor = _motorData[index];
            final isSelected = _selectedMotorcycle == index;

            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  right: index == 0 ? 8 : 0,
                ),
                child: InkWell(
                  onTap: () => setState(() => _selectedMotorcycle = index),
                  borderRadius: BorderRadius.circular(14),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(vertical: 9),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary
                          : (isDark
                              ? AppColors.cardDark
                              : const Color(0xFFF1F5F9)),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : (isDark
                                ? AppColors.borderDark
                                : const Color(0xFFE2E8F0)),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        motor['name'] as String,
                        style: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : (isDark
                                  ? AppColors.textSecondaryDark
                                  : AppColors.textSecondaryLight),
                          fontSize: 12,
                          fontWeight:
                              isSelected ? FontWeight.w700 : FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),

        const SizedBox(height: 12),

        // Spec Display Card with Bike Illustration
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDark
                  ? [
                      const Color(0xFF1E293B),
                      const Color(0xFF0F172A),
                    ]
                  : [
                      const Color(0xFFFFF7ED),
                      const Color(0xFFFAF7F4),
                    ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark
                  ? AppColors.borderDark
                  : AppColors.primary.withValues(alpha: 0.2),
            ),
          ),
          child: Row(
            children: [
              // Left: Spec details
              Expanded(
                flex: 6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        currentMotor['tag'] as String,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildSpecRow(
                      icon: Icons.water_drop_rounded,
                      title: 'Kapasitas Mesin',
                      value: currentMotor['capacity'] as String,
                      isDark: isDark,
                    ),
                    const SizedBox(height: 6),
                    _buildSpecRow(
                      icon: Icons.shield_rounded,
                      title: 'Oli Rekomendasi',
                      value: currentMotor['engineOil'] as String,
                      isDark: isDark,
                    ),
                    const SizedBox(height: 6),
                    _buildSpecRow(
                      icon: Icons.settings_suggest_rounded,
                      title: 'Oli Gardan',
                      value: currentMotor['gearOil'] as String,
                      isDark: isDark,
                    ),
                  ],
                ),
              ),

              // Right: Real Motorcycle Graphic
              Expanded(
                flex: 4,
                child: Center(
                  child: Image.asset(
                    currentMotor['image'] as String,
                    height: 105,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.two_wheeler_rounded,
                      size: 64,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSpecRow({
    required IconData icon,
    required String title,
    required String value,
    required bool isDark,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 14, color: AppColors.primary),
        const SizedBox(width: 6),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 10,
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : const Color(0xFF64748B),
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // 4. Golden Rule: 2:1 Ratio
  Widget _buildGoldenRuleCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.borderDark : const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.auto_awesome_rounded,
                  color: Color(0xFFEAB308), size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Aturan Emas: Rasio 2 : 1 Penggantian Oli',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF0F172A)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '2x Ganti Oli Mesin',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w800,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Tiap 2.000 - 3.000 KM atau 2 Bulan sekali',
                        style: TextStyle(
                          fontSize: 10,
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.arrow_forward_rounded,
                  size: 16, color: Color(0xFF94A3B8)),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF0F172A)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFF0284C7).withValues(alpha: 0.3),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '1x Ganti Oli Gardan',
                        style: TextStyle(
                          color: Color(0xFF0284C7),
                          fontWeight: FontWeight.w800,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Tiap 8.000 KM (Melindungi girboks matik)',
                        style: TextStyle(
                          fontSize: 10,
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 5. Why AHM Oil (Genuine Value Props)
  Widget _buildGenuineValueProps(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Kenapa Harus Oli Asli Honda di AHASS?',
          style: AppTypography.getHeading(
            isDark: isDark,
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 10),
        _buildValuePropTile(
          icon: Icons.verified_user_rounded,
          iconColor: const Color(0xFF16A34A),
          title: '100% Asli Bersegel Barcode AHM',
          desc: 'Terbebas dari oli oplosan/palsu yang merusak mesin motormu.',
          isDark: isDark,
        ),
        const SizedBox(height: 8),
        _buildValuePropTile(
          icon: Icons.local_gas_station_rounded,
          iconColor: AppColors.primary,
          title: 'Efisiensi BBM Naik Hingga 8%',
          desc: 'Formula viskositas rendah mengurangi friksi saat stop & go perkotaan.',
          isDark: isDark,
        ),
        const SizedBox(height: 8),
        _buildValuePropTile(
          icon: Icons.construction_rounded,
          iconColor: const Color(0xFF0284C7),
          title: 'Gratis 10-Point Safety Inspection',
          desc: 'Cek rem, ban, aki, lampu, rantai/CVT oleh mekanik tersertifikasi.',
          isDark: isDark,
        ),
      ],
    );
  }

  Widget _buildValuePropTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String desc,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.borderDark : const Color(0xFFE2E8F0),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 18, color: iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
                Text(
                  desc,
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
    );
  }

  // 6. Transparent Price List AHASS
  Widget _buildPriceListSection(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Daftar Harga Resmi Oli Honda',
              style: AppTypography.getHeading(
                isDark: isDark,
                fontSize: 14,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              'Ketuk untuk memilih',
              style: TextStyle(
                fontSize: 11,
                color: isDark
                    ? AppColors.textSecondaryDark
                    : const Color(0xFF64748B),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ...List.generate(_prices.length, (index) {
          final item = _prices[index];
          final isPopular = item['popular'] as bool;
          final isSelected = _selectedPriceIndex == index;

          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  setState(() {
                    _selectedPriceIndex = index;
                  });
                },
                borderRadius: BorderRadius.circular(14),
                splashColor: AppColors.primary.withValues(alpha: 0.12),
                highlightColor: AppColors.primary.withValues(alpha: 0.05),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 260),
                  curve: Curves.easeInOutCubic,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? (isDark
                            ? AppColors.primary.withValues(alpha: 0.14)
                            : const Color(0xFFFFF7ED))
                        : (isDark ? AppColors.cardDark : Colors.white),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primary
                          : (isDark
                              ? AppColors.borderDark
                              : const Color(0xFFE2E8F0)),
                      width: isSelected ? 1.8 : 1.0,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: AppColors.primary.withValues(
                                  alpha: isDark ? 0.25 : 0.14),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ]
                        : null,
                  ),
                  child: Row(
                    children: [
                      // Radio check indicator with smooth animated scale & color
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 220),
                        curve: Curves.easeInOutCubic,
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected
                              ? AppColors.primary
                              : Colors.transparent,
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primary
                                : (isDark
                                    ? const Color(0xFF64748B)
                                    : const Color(0xFFCBD5E1)),
                            width: isSelected ? 2 : 1.5,
                          ),
                        ),
                        child: isSelected
                            ? const Icon(
                                Icons.check_rounded,
                                size: 14,
                                color: Colors.white,
                              )
                            : null,
                      ),
                      const SizedBox(width: 12),

                      // Title & Subtitle/Spec
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['title'] as String,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: isSelected
                                    ? FontWeight.w800
                                    : FontWeight.w700,
                                color: isSelected
                                    ? (isDark
                                        ? Colors.white
                                        : AppColors.primary)
                                    : (isDark
                                        ? Colors.white
                                        : const Color(0xFF0F172A)),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              item['spec'] as String,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 10,
                                color: isDark
                                    ? AppColors.textSecondaryDark
                                    : const Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 10),

                      // Price & Badge on top of price
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (isPopular) ...[
                            Container(
                              margin: const EdgeInsets.only(bottom: 3),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                'TERPOPULER',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 8,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ],
                          AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 220),
                            curve: Curves.easeInOutCubic,
                            style: TextStyle(
                              fontSize: isSelected ? 14 : 13,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primary,
                            ),
                            child: Text(item['price'] as String),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  // 7. Sticky Bottom Action Bar
  Widget _buildStickyBottomBar(
      BuildContext context, bool isDark, Map<String, dynamic> currentMotor) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.borderDark : const Color(0xFFE2E8F0),
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Pricing preview
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Estimasi Biaya Mulai',
                  style: TextStyle(
                    fontSize: 10,
                    color: Color(0xFF64748B),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  _prices[_selectedPriceIndex]['price'] as String,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
                const Text(
                  'Free Cek 10 Titik',
                  style: TextStyle(
                    fontSize: 9,
                    color: Color(0xFF16A34A),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),

          // Primary CTA Button
          Expanded(
            flex: 6,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: () {
                _safePop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BookingStep1Screen(
                      controller: widget.controller,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.calendar_month_rounded, size: 18),
              label: const Text(
                'Booking Ganti Oli',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
