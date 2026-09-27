import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../controllers/app_controller.dart';
import '../../widgets/servisin_app_bar.dart';
import '../../widgets/status_badge.dart';

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
  String _selectedCategory = 'Semua';

  final List<String> _categories = [
    'Semua',
    'Multi-Motor',
    'Oli & Part',
    'Cashback',
    'Servis Rutin',
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = widget.controller.isDarkMode;
    final promos = widget.controller.promos;

    return Scaffold(
      appBar: const ServisinAppBar(title: 'Promo & Voucher', showBack: false),
      body: Column(
        children: [
          Container(
            height: 48,
            margin: const EdgeInsets.only(top: 8, bottom: 8),
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final cat = _categories[index];
                final isSelected = cat == _selectedCategory;

                return ChoiceChip(
                  label: Text(
                    cat,
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                  selected: isSelected,
                  selectedColor: AppColors.primary,
                  backgroundColor: isDark ? AppColors.cardDark : Colors.white,
                  side: BorderSide(
                    color: isSelected
                        ? AppColors.primary
                        : (isDark ? AppColors.borderDark : AppColors.borderLight),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  onSelected: (selected) {
                    if (selected) {
                      setState(() => _selectedCategory = cat);
                    }
                  },
                );
              },
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: promos.length,
              separatorBuilder: (_, __) => const SizedBox(height: 14),
              itemBuilder: (context, index) {
                final promo = promos[index];

                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.cardDark : AppColors.cardLight,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: promo.isMultiMotor
                          ? AppColors.primary
                          : (isDark ? AppColors.borderDark : AppColors.borderLight),
                      width: promo.isMultiMotor ? 2 : 1,
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          StatusBadge(
                            text: promo.discountTag,
                            type: BadgeType.primary,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.access_time_rounded,
                                size: 12,
                                color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Berlaku s/d ${promo.validUntil}',
                                style: AppTypography.getLabel(
                                  isDark: isDark,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        promo.title,
                        style: AppTypography.getHeading(
                          isDark: isDark,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        promo.description,
                        style: AppTypography.getBody(
                          isDark: isDark,
                          fontSize: 12,
                          isSecondary: true,
                          height: 1.4,
                        ),
                      ),
                      const Divider(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.bgDark : const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: isDark ? AppColors.borderDark : const Color(0xFFCBD5E1),
                                style: BorderStyle.solid,
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.confirmation_number_outlined, size: 14, color: AppColors.primary),
                                const SizedBox(width: 6),
                                Text(
                                  promo.code,
                                  style: TextStyle(
                                    color: isDark ? Colors.white : AppColors.textPrimaryLight,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Kode voucher "${promo.code}" berhasil disalin!'),
                                  backgroundColor: AppColors.primary,
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            },
                            child: const Text(
                              'Gunakan',
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
