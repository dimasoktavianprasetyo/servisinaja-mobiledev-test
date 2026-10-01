import 'package:flutter/material.dart';

class AktivitasGuaranteeBanner extends StatelessWidget {
  final bool isDark;

  const AktivitasGuaranteeBanner({
    super.key,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF2C1910).withValues(alpha: 0.8)
            : const Color(0xFFFFF3ED),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark
              ? const Color(0xFF7C2D12).withValues(alpha: 0.6)
              : const Color(0xFFFFE0D0),
          width: 1.0,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              color: Color(0xFFEA580C),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.priority_high_rounded,
              size: 20,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Semua pengerjaan di bengkel resmi AHASS dilindungi',
                  style: TextStyle(
                    fontSize: 11.5,
                    color: isDark
                        ? const Color(0xFFFFD8C2)
                        : const Color(0xFF9A3412),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Garansi Servis 14 Hari / 500 km.',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w800,
                    color: isDark
                        ? const Color(0xFFFF8A4C)
                        : const Color(0xFFEA580C),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
