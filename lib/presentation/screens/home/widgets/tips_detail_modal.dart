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
      builder: (_) => TipsDetailModal(controller: controller),
    );
  }

  @override
  State<TipsDetailModal> createState() => _TipsDetailModalState();
}

class _TipsDetailModalState extends State<TipsDetailModal> {
  int _selectedTab = 0;
  final List<String> _tabs = ['Oli & Mesin', 'CVT & Matik', 'Pengereman & Ban'];

  // Interactive diagnostic checklist state
  final Map<int, bool> _checks = {
    0: false,
    1: false,
    2: false,
    3: false,
  };

  @override
  Widget build(BuildContext context) {
    final isDark = widget.controller.isDarkMode;
    final size = MediaQuery.of(context).size;

    return Container(
      height: size.height * 0.90,
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 25,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Drag handle
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            width: 44,
            height: 5,
            decoration: BoxDecoration(
              color: isDark ? AppColors.borderDark : const Color(0xFFCBD5E1),
              borderRadius: BorderRadius.circular(3),
            ),
          ),

          // Scrollable Content
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                // Hero Header Banner with Gradient Scrim
                Stack(
                  children: [
                    Container(
                      height: 190,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Color(0xFF1E293B),
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
                    Container(
                      height: 190,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.2),
                            Colors.black.withValues(alpha: 0.8),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 12,
                      left: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.verified_rounded,
                                size: 13, color: Colors.white),
                            SizedBox(width: 4),
                            Text(
                              'AHASS OFFICIAL GUIDE',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 10,
                      right: 16,
                      child: Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.5),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: const Icon(Icons.close_rounded,
                              size: 20, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 16,
                      left: 16,
                      right: 16,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.timer_outlined,
                                  size: 13, color: Colors.white70),
                              SizedBox(width: 4),
                              Text('3 menit baca',
                                  style: TextStyle(
                                      color: Colors.white70, fontSize: 11)),
                              SizedBox(width: 12),
                              Icon(Icons.remove_red_eye_outlined,
                                  size: 13, color: Colors.white70),
                              SizedBox(width: 4),
                              Text('12.4k dibaca',
                                  style: TextStyle(
                                      color: Colors.white70, fontSize: 11)),
                            ],
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Panduan Perawatan Lengkap Motor Matik Honda',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              height: 1.25,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category Tabs
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(_tabs.length, (index) {
                            final isSelected = _selectedTab == index;
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: InkWell(
                                onTap: () =>
                                    setState(() => _selectedTab = index),
                                borderRadius: BorderRadius.circular(20),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? AppColors.primary
                                        : (isDark
                                            ? AppColors.cardDark
                                            : const Color(0xFFF1F5F9)),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    _tabs[index],
                                    style: TextStyle(
                                      color: isSelected
                                          ? Colors.white
                                          : (isDark
                                              ? AppColors.textSecondaryDark
                                              : AppColors.textSecondaryLight),
                                      fontSize: 12,
                                      fontWeight: isSelected
                                          ? FontWeight.w700
                                          : FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Tab Contents
                      if (_selectedTab == 0) _buildOilSection(isDark),
                      if (_selectedTab == 1) _buildCvtSection(isDark),
                      if (_selectedTab == 2) _buildBrakeSection(isDark),

                      const SizedBox(height: 24),

                      // Interactive Diagnostic Checklist
                      _buildDiagnosticChecklist(isDark),

                      const SizedBox(height: 24),

                      // Certified Mechanic Quote Box
                      _buildMechanicCallout(isDark),

                      const SizedBox(height: 24),

                      // Schedule Matrix Table
                      _buildServiceScheduleMatrix(isDark),

                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Sticky Bottom Action Bar
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : Colors.white,
              border: Border(
                top: BorderSide(
                  color:
                      isDark ? AppColors.borderDark : const Color(0xFFE2E8F0),
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: SizedBox(
              width: double.infinity,
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
                  Navigator.pop(context);
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
                  'Booking Servis Sekarang',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOilSection(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '1. Jadwal & Takaran Oli Mesin (MPX / SPX)',
          style: AppTypography.getHeading(
            isDark: isDark,
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Oli mesin bertugas melumasi komponen piston, klep, dan kruk as. Pada motor matik seperti Vario 160 dan BeAT, ganti oli disarankan tiap 2.000 - 3.000 KM atau maksimal 2 bulan sekali.',
          style: TextStyle(
            fontSize: 13,
            color: isDark ? AppColors.textSecondaryDark : const Color(0xFF475569),
            height: 1.5,
          ),
        ),
        const SizedBox(height: 14),

        // Key Points Row
        Row(
          children: [
            Expanded(
              child: _buildStatMiniCard(
                title: 'Oli Mesin (MPX2)',
                value: '2.000 KM',
                desc: 'Volume: 0.8L',
                icon: Icons.water_drop_rounded,
                isDark: isDark,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildStatMiniCard(
                title: 'Oli Gardan',
                value: '8.000 KM',
                desc: 'Rasio: 2x Ganti Oli Mesin',
                icon: Icons.settings_suggest_rounded,
                isDark: isDark,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        // Danger Warning Box
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFFEF2F2),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFFECACA)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.warning_amber_rounded,
                  color: Color(0xFFDC2626), size: 22),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Risiko Telat Ganti Oli:',
                      style: TextStyle(
                        color: Color(0xFF991B1B),
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'Piston baret, kompresi bocor, dan biaya turun mesin (overhaul) bisa mencapai lebih dari Rp 1.500.000.',
                      style: TextStyle(color: Color(0xFFB91C1C), fontSize: 11),
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

  Widget _buildCvtSection(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '2. Menjaga Kebersihan & Kesehatan CVT',
          style: AppTypography.getHeading(
            isDark: isDark,
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Sistem Continuously Variable Transmission (CVT) menyalurkan tenaga mesin ke roda belakang. Servis rutin CVT wajib dilakukan tiap 8.000 KM untuk membersihkan debu sisa gesekan kampas ganda.',
          style: TextStyle(
            fontSize: 13,
            color: isDark ? AppColors.textSecondaryDark : const Color(0xFF475569),
            height: 1.5,
          ),
        ),
        const SizedBox(height: 12),
        _buildBullet(
            'V-Belt Honda:', 'Ganti setiap 24.000 KM agar tidak putus di jalan.', isDark),
        _buildBullet(
            'Roller Weight:', 'Cek keausan/peang tiap 12.000 KM agar akselerasi tetap halus.', isDark),
        _buildBullet(
            'Pembersihan Kampas Ganda:', 'Cegah motor bergetar ("gredek") di rpm bawah saat tarikan awal.', isDark),
      ],
    );
  }

  Widget _buildBrakeSection(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '3. Kampas Rem & Tekanan Angin Ban',
          style: AppTypography.getHeading(
            isDark: isDark,
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Keselamatan berkendara sangat bergantung pada respons pengereman dan grip ban ke aspal jalan.',
          style: TextStyle(
            fontSize: 13,
            color: isDark ? AppColors.textSecondaryDark : const Color(0xFF475569),
            height: 1.5,
          ),
        ),
        const SizedBox(height: 12),
        _buildBullet(
            'Tekanan Angin Depan:', '29 PSI (tanpa beban) / 29 PSI (boncengan).', isDark),
        _buildBullet(
            'Tekanan Angin Belakang:', '33 PSI (tanpa beban) / 36 PSI (boncengan).', isDark),
        _buildBullet(
            'Minyak Rem DOT 4:', 'Kuras dan ganti setiap 2 tahun atau 20.000 KM.', isDark),
      ],
    );
  }

  Widget _buildDiagnosticChecklist(bool isDark) {
    final questions = [
      'Tarikan awal motor terasa bergetar (gredek)',
      'Suara mesin terdengar lebih kasar dari biasanya',
      'Rem belakang terasa dalam saat ditekan',
      'Sudah lebih dari 2 bulan belum ganti oli',
    ];

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
              const Icon(Icons.checklist_rounded,
                  color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                'Self-Diagnosis: Cek Gejala Motor Kamu',
                style: AppTypography.getHeading(
                  isDark: isDark,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Centang gejala yang kamu rasakan:',
            style: TextStyle(
              fontSize: 11,
              color: isDark
                  ? AppColors.textSecondaryDark
                  : const Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 12),
          ...List.generate(questions.length, (index) {
            final isChecked = _checks[index] ?? false;
            return InkWell(
              onTap: () {
                setState(() => _checks[index] = !isChecked);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Icon(
                      isChecked
                          ? Icons.check_box_rounded
                          : Icons.check_box_outline_blank_rounded,
                      color:
                          isChecked ? AppColors.primary : const Color(0xFF94A3B8),
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        questions[index],
                        style: TextStyle(
                          fontSize: 12,
                          color: isChecked
                              ? (isDark ? Colors.white : const Color(0xFF0F172A))
                              : (isDark
                                  ? AppColors.textSecondaryDark
                                  : const Color(0xFF475569)),
                          fontWeight:
                              isChecked ? FontWeight.w600 : FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildMechanicCallout(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : const Color(0xFFFFF7ED),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.borderDark : const Color(0xFFFFEDD5),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primary, width: 2),
            ),
            child: ClipOval(
              child: Image.asset(
                'assets/images/mechanic_avatar.png',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: AppColors.primary,
                  child: const Icon(Icons.person, color: Colors.white),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Budi Santoso',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
                ),
                Text(
                  'Kepala Mekanik AHASS Sudirman',
                  style: TextStyle(
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : const Color(0xFF9A3412),
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '"Motor matik modern Honda sudah memakai mesin eSP+ yang sangat presisi. Selalu gunakan oli bertaraf JASO MB asli AHM Oil agar tarikan tetap enteng dan konsumsi BBM irit."',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 12,
                    color: isDark ? Colors.white70 : const Color(0xFF7C2D12),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceScheduleMatrix(bool isDark) {
    final schedule = [
      {'km': '1.000 KM', 'action': 'Oli Mesin + Cek Baut', 'cost': 'Gratis (KPB 1)'},
      {'km': '4.000 KM', 'action': 'Oli Mesin + Tune Up', 'cost': 'Gratis Jasa (KPB 2)'},
      {'km': '8.000 KM', 'action': 'Oli Mesin + Oli Gardan + Busi', 'cost': 'Gratis Jasa (KPB 3)'},
      {'km': '12.000 KM', 'action': 'Servis Lengkap + Filter Udara', 'cost': 'Gratis Jasa (KPB 4)'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Jadwal Servis Berkala Honda (KPB)',
          style: AppTypography.getHeading(
            isDark: isDark,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 10),
        ...schedule.map((item) {
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardDark : const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isDark ? AppColors.borderDark : const Color(0xFFE2E8F0),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['km']!,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                        color: AppColors.primary,
                      ),
                    ),
                    Text(
                      item['action']!,
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : const Color(0xFF475569),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCFCE7),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    item['cost']!,
                    style: const TextStyle(
                      color: Color(0xFF16A34A),
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildStatMiniCard({
    required String title,
    required String value,
    required String desc,
    required IconData icon,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.borderDark : const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primary, size: 20),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
          ),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 11),
          ),
          const SizedBox(height: 2),
          Text(
            desc,
            style: TextStyle(
              fontSize: 10,
              color: isDark
                  ? AppColors.textSecondaryDark
                  : const Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBullet(String boldText, String normalText, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('•  ',
              style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 14)),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 12,
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : const Color(0xFF475569),
                  height: 1.4,
                ),
                children: [
                  TextSpan(
                    text: '$boldText ',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                  TextSpan(text: normalText),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
