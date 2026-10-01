import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../controllers/app_controller.dart';

class PusatBantuanScreen extends StatefulWidget {
  final AppController controller;

  const PusatBantuanScreen({
    super.key,
    required this.controller,
  });

  @override
  State<PusatBantuanScreen> createState() => _PusatBantuanScreenState();
}

class _PusatBantuanScreenState extends State<PusatBantuanScreen> {
  final _searchController = TextEditingController();
  int? _expandedIndex = 0; // First one open by default as in screenshot!

  final List<Map<String, String>> _faqs = [
    {
      'question': 'Bagaimana cara booking 2 motor sekaligus?',
      'answer':
          'Pada formulir pemesanan, klik tab "Tambah Unit" untuk memilih motor kedua dari garasi Anda. Setiap motor bisa dipilih jenis servis & keluhan yang berbeda.',
    },
    {
      'question': 'Apakah ada jaminan garansi servis AHASS?',
      'answer':
          'Ya, setiap servis resmi di AHASS melalui Servisin Aja mendapatkan jaminan garansi servis hingga 14 hari kerja atau 1.000 km setelah servis selesai.',
    },
    {
      'question': 'Bagaimana cara klaim kupon diskon servis?',
      'answer':
          'Pilih promo aktif di menu Promo atau masukkan kode kupon pada halaman Ringkasan Pemesanan sebelum konfirmasi pembayaran.',
    },
    {
      'question': 'Apakah bisa membatalkan jadwal servis?',
      'answer':
          'Pembatalan jadwal servis dapat dilakukan minimal 2 jam sebelum waktu kunjungan mekanik tanpa dikenakan biaya pembatalan melalui menu Aktivitas.',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onContactTap(String channel) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Menghubungkan ke $channel...'),
        backgroundColor: AppColors.primary,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.controller.isDarkMode;

    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, _) {
        final query = _searchController.text.toLowerCase();
        final filteredFaqs = _faqs.where((faq) {
          if (query.isEmpty) return true;
          return faq['question']!.toLowerCase().contains(query) ||
              faq['answer']!.toLowerCase().contains(query);
        }).toList();

        return Scaffold(
          backgroundColor: isDark ? AppColors.bgDark : const Color(0xFFF8FAFC),
          appBar: AppBar(
            backgroundColor: isDark ? AppColors.bgDark : const Color(0xFFF8FAFC),
            elevation: 0,
            scrolledUnderElevation: 0,
            centerTitle: true,
            leading: Center(
              child: Container(
                margin: const EdgeInsets.only(left: 16),
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.cardDark : Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isDark ? AppColors.borderDark : const Color(0xFFE2E8F0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: Icon(
                    Icons.chevron_left_rounded,
                    size: 24,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
            title: Text(
              'Pusat Bantuan',
              style: AppTypography.getHeading(
                isDark: isDark,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search bar
                Container(
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.cardDark : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark ? AppColors.borderDark : const Color(0xFFE2E8F0),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.03),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (_) => setState(() {}),
                    style: TextStyle(
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                      fontSize: 13,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Cari kendala servis atau topik bantuan...',
                      hintStyle: TextStyle(
                        color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                        fontSize: 12.5,
                      ),
                      prefixIcon: Icon(
                        Icons.search_rounded,
                        color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                        size: 20,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                    ),
                  ),
                ),
                const SizedBox(height: 18),

                // 2x2 Grid Contact Options
                Row(
                  children: [
                    // Live Chat CS
                    Expanded(
                      child: _buildContactCard(
                        isDark: isDark,
                        icon: Icons.chat_bubble_outline_rounded,
                        iconColor: AppColors.primary,
                        iconBg: isDark ? const Color(0xFF2A1C14) : const Color(0xFFFFEDD5),
                        badgeText: 'Online',
                        badgeColor: const Color(0xFF16A34A),
                        badgeBg: const Color(0xFFDCFCE7),
                        title: 'Live Chat CS',
                        subtitle: 'Respon < 2 mnt',
                        hasGreenDot: true,
                        onTap: () => _onContactTap('Live Chat CS'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Call Center
                    Expanded(
                      child: _buildContactCard(
                        isDark: isDark,
                        icon: Icons.phone_outlined,
                        iconColor: isDark ? const Color(0xFF94A3B8) : const Color(0xFF334155),
                        iconBg: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                        badgeText: '24 Jam',
                        badgeColor: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                        badgeBg: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
                        title: 'Call Center',
                        subtitle: '1500-988',
                        hasGreenDot: false,
                        onTap: () => _onContactTap('Call Center 1500-988'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    // WhatsApp Resmi
                    Expanded(
                      child: _buildContactCard(
                        isDark: isDark,
                        icon: Icons.chat_rounded,
                        iconColor: const Color(0xFF16A34A),
                        iconBg: isDark ? const Color(0xFF064E3B) : const Color(0xFFDCFCE7),
                        badgeText: 'Fast Respon',
                        badgeColor: const Color(0xFF16A34A),
                        badgeBg: const Color(0xFFDCFCE7),
                        title: 'WhatsApp Resmi',
                        subtitle: '+62 811-9876-000',
                        hasGreenDot: false,
                        onTap: () => _onContactTap('WhatsApp CS'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Kirim Email
                    Expanded(
                      child: _buildContactCard(
                        isDark: isDark,
                        icon: Icons.mail_outline_rounded,
                        iconColor: isDark ? const Color(0xFF94A3B8) : const Color(0xFF334155),
                        iconBg: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                        badgeText: '24 Jam',
                        badgeColor: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                        badgeBg: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
                        title: 'Kirim Email',
                        subtitle: 'support@servisin.id',
                        hasGreenDot: false,
                        onTap: () => _onContactTap('Email Support'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // FAQ Header
                Text(
                  'Pertanyaan yang Sering Diajukan (FAQ)',
                  style: AppTypography.getHeading(
                    isDark: isDark,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 12),

                // FAQ List
                ...List.generate(filteredFaqs.length, (index) {
                  final item = filteredFaqs[index];
                  final isExpanded = _expandedIndex == index;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.cardDark : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isExpanded
                            ? (isDark ? const Color(0xFF78350F) : const Color(0xFFFFEDD5))
                            : (isDark ? AppColors.borderDark : const Color(0xFFE2E8F0)),
                        width: isExpanded ? 1.5 : 1,
                      ),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {
                        setState(() {
                          _expandedIndex = isExpanded ? null : index;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Text(
                                    item['question']!,
                                    style: TextStyle(
                                      color: isExpanded
                                          ? AppColors.primary
                                          : (isDark
                                              ? Colors.white
                                              : const Color(0xFF0F172A)),
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                Icon(
                                  isExpanded
                                      ? Icons.keyboard_arrow_up_rounded
                                      : Icons.keyboard_arrow_down_rounded,
                                  color: isExpanded
                                      ? AppColors.primary
                                      : (isDark
                                          ? const Color(0xFF64748B)
                                          : const Color(0xFF94A3B8)),
                                  size: 20,
                                ),
                              ],
                            ),
                            if (isExpanded) ...[
                              const SizedBox(height: 10),
                              Text(
                                item['answer']!,
                                style: TextStyle(
                                  color: isDark
                                      ? const Color(0xFFCBD5E1)
                                      : const Color(0xFF64748B),
                                  fontSize: 12,
                                  height: 1.45,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  );
                }),

                const SizedBox(height: 16),
                Center(
                  child: Text(
                    'Masih butuh bantuan lain? Hubungi CS kami di atas.',
                    style: TextStyle(
                      color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                      fontSize: 11,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildContactCard({
    required bool isDark,
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String badgeText,
    required Color badgeColor,
    required Color badgeBg,
    required String title,
    required String subtitle,
    required bool hasGreenDot,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.borderDark : const Color(0xFFE2E8F0),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: iconBg,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(icon, color: iconColor, size: 18),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: badgeBg,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        badgeText,
                        style: TextStyle(
                          color: badgeColor,
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: AppTypography.getHeading(
                    isDark: isDark,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    if (hasGreenDot) ...[
                      Container(
                        width: 5,
                        height: 5,
                        decoration: const BoxDecoration(
                          color: Color(0xFF16A34A),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                    ],
                    Flexible(
                      child: Text(
                        subtitle,
                        style: TextStyle(
                          color: hasGreenDot
                              ? const Color(0xFF16A34A)
                              : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                          fontSize: 10.5,
                          fontWeight: hasGreenDot ? FontWeight.w700 : FontWeight.normal,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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
}
