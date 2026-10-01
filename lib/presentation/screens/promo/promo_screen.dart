import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../controllers/app_controller.dart';

class PromoScreen extends StatefulWidget {
  final AppController controller;

  const PromoScreen({
    super.key,
    required this.controller,
  });

  @override
  State<PromoScreen> createState() => _PromoScreenState();
}

class _PromoScreenState extends State<PromoScreen> {
  String _selectedCategory = 'Semua Promo';
  final TextEditingController _promoInputController = TextEditingController();

  static const List<Map<String, String?>> _filterCategories = [
    {'name': 'Semua Promo', 'badge': null},
    {'name': 'Multi-Motor', 'badge': 'POPULER'},
    {'name': 'Oli & Part', 'badge': null},
    {'name': 'Cashback', 'badge': null},
    {'name': 'Servis Rutin', 'badge': null},
  ];

  void _handleBack() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      widget.controller.setNavIndex(0); // Safely return to Beranda
    }
  }

  void _copyPromoCode(String code) {
    Clipboard.setData(ClipboardData(text: code));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Text(
              'Kode promo "$code" berhasil disalin!',
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF16A34A),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _applyVoucher(String code) {
    _copyPromoCode(code);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Kupon "$code" siap digunakan untuk booking servis!'),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
    // Switch to booking step 1
    widget.controller.setNavIndex(1);
  }

  void _showHelpModal() {
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
                    'Syarat & Ketentuan Promo',
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
              _buildHelpBullet(
                '1. Promo Multi-Motor berlaku untuk pemesanan minimal 2 kendaraan dalam 1 sesi booking paralel di bengkel AHASS.',
                isDark,
              ),
              const SizedBox(height: 8),
              _buildHelpBullet(
                '2. Kupon oli gratis dapat diklaim saat kedatangan langsung di bengkel dengan menunjukkan barcode atau kode promo.',
                isDark,
              ),
              const SizedBox(height: 8),
              _buildHelpBullet(
                '3. Cashback QRIS akan masuk ke saldo dompet digital setelah servis dinyatakan selesai oleh mekanik AHASS.',
                isDark,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Saya Mengerti', style: TextStyle(fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHelpBullet(String text, bool isDark) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.check_circle_outline_rounded, size: 16, color: AppColors.primary),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 12.5,
              height: 1.4,
              color: isDark ? AppColors.textSecondaryDark : const Color(0xFF475569),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.controller.isDarkMode;
    final bgScaffold = isDark ? const Color(0xFF0F172A) : const Color(0xFFFAF8F5);

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
                      // Promo Code Input Box
                      _buildPromoInputBox(isDark),
                      const SizedBox(height: 16),

                      // Horizontal Filter Pills
                      _buildFilterPills(isDark),
                      const SizedBox(height: 16),

                      // Voucher Cards
                      _buildVoucherCardsList(isDark, bgScaffold),
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

          // Title & Subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Promo & Voucher',
                  style: AppTypography.getHeading(
                    isDark: isDark,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Hemat biaya servis motor kesayangan Anda',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? AppColors.textMutedDark : const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),

          // Circular Help Button (?)
          InkWell(
            onTap: _showHelpModal,
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
                Icons.help_outline_rounded,
                size: 20,
                color: isDark ? Colors.white70 : const Color(0xFF64748B),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromoInputBox(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(14),
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
      child: Row(
        children: [
          // Left Ticket Badge
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF352014) : const Color(0xFFFFF4ED),
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.confirmation_number_outlined,
              color: AppColors.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 10),

          // Text Field
          Expanded(
            child: TextField(
              controller: _promoInputController,
              style: TextStyle(
                fontSize: 13,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
                fontWeight: FontWeight.w600,
              ),
              decoration: InputDecoration(
                hintText: 'Masukkan kode promo disini...',
                hintStyle: TextStyle(
                  fontSize: 13,
                  color: isDark ? AppColors.textMutedDark : const Color(0xFF94A3B8),
                  fontWeight: FontWeight.w400,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),

          // Button: Terapkan
          InkWell(
            onTap: () {
              final text = _promoInputController.text.trim();
              if (text.isNotEmpty) {
                _applyVoucher(text.toUpperCase());
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Ketik kode promo terlebih dahulu'),
                    backgroundColor: Color(0xFFDC2626),
                  ),
                );
              }
            },
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF382012) : const Color(0xFFFFF2EB),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'Terapkan',
                style: TextStyle(
                  color: Color(0xFFEA580C),
                  fontSize: 12.5,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterPills(bool isDark) {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _filterCategories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final cat = _filterCategories[index];
          final name = cat['name'] ?? '';
          final badge = cat['badge'];
          final isSelected = name == _selectedCategory;

          return InkWell(
            onTap: () {
              setState(() => _selectedCategory = name);
            },
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary
                    : (isDark ? AppColors.cardDark : Colors.white),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primary
                      : (isDark ? AppColors.borderDark : const Color(0xFFE2E8F0)),
                  width: 1,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.3),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                      color: isSelected
                          ? Colors.white
                          : (isDark ? AppColors.textSecondaryDark : const Color(0xFF334155)),
                    ),
                  ),
                  if (badge != null) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.white.withValues(alpha: 0.25)
                            : (isDark ? const Color(0xFF382012) : const Color(0xFFFFF1E8)),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        badge,
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          color: isSelected ? Colors.white : const Color(0xFFEA580C),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildVoucherCardsList(bool isDark, Color bgScaffold) {
    final showAll = _selectedCategory == 'Semua Promo';
    final showMulti = showAll || _selectedCategory == 'Multi-Motor';
    final showOli = showAll || _selectedCategory == 'Oli & Part';
    final showCashback = showAll || _selectedCategory == 'Cashback';

    return Column(
      children: [
        // Card 1: Highlighted Multi-Motor
        if (showMulti) ...[
          _buildTicketCard(
            isDark: isDark,
            bgScaffold: bgScaffold,
            isHighlighted: true,
            topTag1Text: '★ KHUSUS MULTI-MOTOR (2+ UNIT)',
            topTag1Color: const Color(0xFFEA580C),
            topTag1Bg: isDark ? const Color(0xFF352014) : const Color(0xFFFFF1E8),
            topTag2Text: 'Hemat s/d 50rb',
            topTag2Color: const Color(0xFF16A34A),
            topTag2Bg: isDark ? const Color(0xFF142F1E) : const Color(0xFFDCFCE7),
            title: 'Diskon 30% Servis Armada Bareng',
            description:
                'Potongan biaya servis s/d Rp 50.000 untuk booking 2 motor atau lebih dalam 1 transaksi pengerjaan paralel.',
            promoCode: 'SERVISBARENG',
            validUntil: 'Berlaku s/d 30 Okt 2026',
            actionText: 'Pakai Kupon →',
            isPrimaryAction: true,
            onActionTap: () => _applyVoucher('SERVISBARENG'),
          ),
          const SizedBox(height: 16),
        ],

        // Card 2: Paket Spesial Matic
        if (showOli) ...[
          _buildTicketCard(
            isDark: isDark,
            bgScaffold: bgScaffold,
            isHighlighted: false,
            topTag1Text: 'PAKET SPESIAL MATIC',
            topTag1Color: isDark ? AppColors.textSecondaryDark : const Color(0xFF475569),
            topTag1Bg: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
            topTag2Text: 'Kuota Harian Tersedia',
            topTag2Color: isDark ? AppColors.textMutedDark : const Color(0xFF64748B),
            topTag2Bg: Colors.transparent,
            title: 'Gratis Oli Gardan Matic AHM',
            description:
                'Setiap pembelian paket Servis Berkala + Ganti Oli Mesin SPX2 di seluruh bengkel AHASS Mitra Servisin.',
            promoCode: 'OLIGARDAN',
            validUntil: 'Berlaku s/d 15 Nov 2026',
            actionText: 'Salin Kode',
            isPrimaryAction: false,
            onActionTap: () => _copyPromoCode('OLIGARDAN'),
          ),
          const SizedBox(height: 16),
        ],

        // Card 3: Cashback Instan QRIS
        if (showCashback) ...[
          _buildTicketCard(
            isDark: isDark,
            bgScaffold: bgScaffold,
            isHighlighted: false,
            topTag1Text: 'CASHBACK INSTAN',
            topTag1Color: const Color(0xFF2563EB),
            topTag1Bg: isDark ? const Color(0xFF172554) : const Color(0xFFEFF6FF),
            topTag2Text: 'Semua Metode QRIS',
            topTag2Color: isDark ? AppColors.textMutedDark : const Color(0xFF64748B),
            topTag2Bg: Colors.transparent,
            title: 'Cashback Rp 20.000 via QRIS',
            description:
                'Tanpa minimum transaksi di seluruh jaringan AHASS Mitra Servisin. Saldo langsung masuk setelah servis selesai.',
            promoCode: 'QRISSERVIS',
            validUntil: 'Berlaku s/d 20 Des 2026',
            actionText: 'Salin Kode',
            isPrimaryAction: false,
            onActionTap: () => _copyPromoCode('QRISSERVIS'),
          ),
          const SizedBox(height: 16),
        ],
      ],
    );
  }

  Widget _buildTicketCard({
    required bool isDark,
    required Color bgScaffold,
    required bool isHighlighted,
    required String topTag1Text,
    required Color topTag1Color,
    required Color topTag1Bg,
    required String topTag2Text,
    required Color topTag2Color,
    required Color topTag2Bg,
    required String title,
    required String description,
    required String promoCode,
    required String validUntil,
    required String actionText,
    required bool isPrimaryAction,
    required VoidCallback onActionTap,
  }) {
    final cardBg = isDark ? AppColors.cardDark : Colors.white;
    final borderColor = isHighlighted
        ? AppColors.primary
        : (isDark ? AppColors.borderDark : const Color(0xFFE2E8F0));
    final borderWidth = isHighlighted ? 1.5 : 1.0;

    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: borderColor,
          width: borderWidth,
        ),
        boxShadow: [
          BoxShadow(
            color: isHighlighted
                ? AppColors.primary.withValues(alpha: isDark ? 0.2 : 0.08)
                : Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: isHighlighted ? 10 : 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Upper Section
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Tags Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: topTag1Bg,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        topTag1Text,
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w800,
                          color: topTag1Color,
                        ),
                      ),
                    ),
                    if (topTag2Bg != Colors.transparent)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: topTag2Bg,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          topTag2Text,
                          style: TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w800,
                            color: topTag2Color,
                          ),
                        ),
                      )
                    else
                      Text(
                        topTag2Text,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: topTag2Color,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 10),

                // Title
                Text(
                  title,
                  style: AppTypography.getHeading(
                    isDark: isDark,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),

                // Description
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.4,
                    color: isDark ? AppColors.textSecondaryDark : const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),

          // 2. Ticket Cutout Perforation Divider
          _buildTicketDivider(isDark, bgScaffold, borderColor, borderWidth),

          // 3. Lower Section: Promo Code Pill + Expiry + Action CTA
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Promo Code Pill + Validity
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () => _copyPromoCode(promoCode),
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              promoCode,
                              style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.5,
                                color: isDark ? Colors.white : const Color(0xFF1E293B),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Icon(
                              Icons.copy_rounded,
                              size: 13,
                              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      validUntil,
                      style: TextStyle(
                        fontSize: 10.5,
                        color: isDark ? AppColors.textMutedDark : const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),

                // Action Button (Pakai Kupon → or Salin Kode)
                if (isPrimaryAction)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: onActionTap,
                    child: Text(
                      actionText,
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  )
                else
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFEA580C),
                      side: const BorderSide(color: Color(0xFFEA580C), width: 1.2),
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: onActionTap,
                    child: Text(
                      actionText,
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFFEA580C),
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

  Widget _buildTicketDivider(bool isDark, Color scaffoldBg, Color borderColor, double borderWidth) {
    return SizedBox(
      height: 18,
      child: Row(
        children: [
          // Left Notch Cutout (curved inward from left edge)
          Container(
            width: 8,
            height: 18,
            decoration: BoxDecoration(
              color: scaffoldBg,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(9),
                bottomRight: Radius.circular(9),
              ),
              border: Border(
                top: BorderSide(color: borderColor, width: borderWidth),
                right: BorderSide(color: borderColor, width: borderWidth),
                bottom: BorderSide(color: borderColor, width: borderWidth),
              ),
            ),
          ),

          // Center Dashed Line
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

          // Right Notch Cutout (curved inward from right edge)
          Container(
            width: 8,
            height: 18,
            decoration: BoxDecoration(
              color: scaffoldBg,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(9),
                bottomLeft: Radius.circular(9),
              ),
              border: Border(
                top: BorderSide(color: borderColor, width: borderWidth),
                left: BorderSide(color: borderColor, width: borderWidth),
                bottom: BorderSide(color: borderColor, width: borderWidth),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
