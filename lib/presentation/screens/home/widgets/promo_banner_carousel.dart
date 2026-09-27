import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../controllers/app_controller.dart';

class PromoBannerCarousel extends StatefulWidget {
  final AppController controller;

  const PromoBannerCarousel({
    super.key,
    required this.controller,
  });

  @override
  State<PromoBannerCarousel> createState() => _PromoBannerCarouselState();
}

class _PromoBannerCarouselState extends State<PromoBannerCarousel> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  final List<Map<String, dynamic>> _bannerList = [
    {
      'image': 'assets/images/promo_banner.png',
      'code': 'MULTIAHASS30',
      'title': 'Spesial Booking Multi-Motor',
    },
    {
      'code': 'QRISSERVIS20',
      'title': 'Cashback Ganti Oli MPX',
      'gradient': [const Color(0xFF0F172A), const Color(0xFF1E293B)],
    },
    {
      'code': 'FREEECO26',
      'title': 'Uji Emisi & Nitrogen Gratis',
      'gradient': [const Color(0xFF0369A1), const Color(0xFF0284C7)],
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.controller.isDarkMode;

    return Column(
      children: [
        SizedBox(
          height: 152,
          child: PageView.builder(
            controller: _pageController,
            itemCount: _bannerList.length,
            onPageChanged: (index) => setState(() => _currentIndex = index),
            itemBuilder: (context, index) {
              final banner = _bannerList[index];
              final hasImage = banner['image'] != null;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: InkWell(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Voucher "${banner['code']}" berhasil disalin!'),
                        duration: const Duration(seconds: 2),
                        backgroundColor: AppColors.primary,
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: hasImage
                        ? Image.asset(
                            banner['image'] as String,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          )
                        : Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: banner['gradient'] as List<Color>,
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            padding: const EdgeInsets.all(18),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    banner['code'] as String,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 11,
                                    ),
                                  ),
                                ),
                                Text(
                                  banner['title'] as String,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const Text(
                                  'Ketuk untuk salin kupon →',
                                  style: TextStyle(color: Colors.white70, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_bannerList.length, (index) {
            final isSelected = _currentIndex == index;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: isSelected ? 20 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary
                    : (isDark ? AppColors.borderDark : const Color(0xFFCBD5E1)),
                borderRadius: BorderRadius.circular(3),
              ),
            );
          }),
        ),
      ],
    );
  }
}
