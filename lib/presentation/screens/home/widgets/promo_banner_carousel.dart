import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
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
  Timer? _autoSlideTimer;

  // Locked 4 promo banners strictly requested by user (all are perfect 2:1 aspect ratio)
  static const List<Map<String, dynamic>> _masterBannerPool = [
    {
      'image': 'assets/images/6e5ada02-8767-4771-8320-781bacd59251.jpg',
      'code': 'GANTIOLIMPX',
      'title': 'Diskon Paket Oli AHM Oil',
      'gradient': [Color(0xFF0F172A), Color(0xFF1E293B)],
    },
    {
      'image': 'assets/images/96cb9d2c-d0cc-4ff7-91a9-49e6647fc64d.jpg',
      'code': 'TUNEUPHEMAT',
      'title': 'Tune Up & Injeksi Hemat',
      'gradient': [Color(0xFF1E40AF), Color(0xFF1E3A8A)],
    },
    {
      'image': 'assets/images/0a6b4d5e-bf6c-44d2-bcca-3ec70ec4abf8.jpg',
      'code': 'SERVISAHASS25',
      'title': 'Promo Servis Lengkap AHASS',
      'gradient': [Color(0xFF18181B), Color(0xFF7F1D1D)],
    },
    {
      'image': 'assets/images/a2464b49-efe3-488d-9cee-02ee949a84f8.jpg',
      'code': 'HONDAEXPRESS',
      'title': 'Layanan Servis Cepat Tanpa Antre',
      'gradient': [Color(0xFF1D4ED8), Color(0xFF1E3A8A)],
    },
  ];

  List<Map<String, dynamic>> _activeBanners = [];

  @override
  void initState() {
    super.initState();
    _initBanners();
    _startAutoSlide();
  }

  void _initBanners() {
    // Display all 4 locked banners in carousel
    _activeBanners = List<Map<String, dynamic>>.from(_masterBannerPool);
  }

  void _startAutoSlide() {
    _autoSlideTimer?.cancel();
    _autoSlideTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_pageController.hasClients && _activeBanners.isNotEmpty) {
        final nextPage = (_currentIndex + 1) % _activeBanners.length;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  @override
  void dispose() {
    _autoSlideTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  Widget _buildGradientCard(Map<String, dynamic> banner) {
    final gradientColors = (banner['gradient'] as List<Color>?) ??
        const [AppColors.primary, AppColors.primaryDark];

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
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
              banner['code'] as String? ?? 'PROMO',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 11,
              ),
            ),
          ),
          Text(
            banner['title'] as String? ?? 'Promo AHASS',
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
    );
  }

  Widget _buildBannerImage(Map<String, dynamic> banner) {
    final imagePath = banner['image'] as String?;
    if (imagePath == null) return _buildGradientCard(banner);

    final fileName = imagePath.split('/').last;
    final githubRawUrl =
        'https://raw.githubusercontent.com/dimasoktavianprasetyo/servisinaja-mobiledev-test/dev/assets/images/$fileName';

    final gradientColors = (banner['gradient'] as List<Color>?) ??
        const [Color(0xFF1E293B), Color(0xFF0F172A)];

    File? localFile;
    if (!kIsWeb) {
      final f = File('/sdcard/Download/servisin_banners/$fileName');
      if (f.existsSync()) {
        localFile = f;
      }
    }

    // Foreground image widget that preserves aspect ratio (never cut off)
    Widget buildForegroundImage() {
      if (localFile != null) {
        return Image.file(
          localFile,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) =>
              _buildAssetOrNetworkImage(banner, imagePath, fileName, githubRawUrl),
        );
      }
      return _buildAssetOrNetworkImage(banner, imagePath, fileName, githubRawUrl);
    }

    // Ambient blurred background layer so edges blend perfectly for any aspect ratio
    Widget buildBlurredBackground() {
      if (localFile != null) {
        return Image.file(
          localFile,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => const SizedBox(),
        );
      }
      return Image.asset(
        imagePath,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const SizedBox(),
      );
    }

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Ambient background layer
          Opacity(
            opacity: 0.35,
            child: buildBlurredBackground(),
          ),
          // Sharp full banner image - NEVER cropped, fits perfectly!
          Center(
            child: buildForegroundImage(),
          ),
        ],
      ),
    );
  }

  Widget _buildAssetOrNetworkImage(
      Map<String, dynamic> banner, String imagePath, String fileName, String githubRawUrl) {
    return Image.asset(
      imagePath,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        // Tier 3: Fetch directly from GitHub repo / Cloud CDN so rebuild is NEVER needed!
        return Image.network(
          githubRawUrl,
          fit: BoxFit.contain,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return const Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) =>
              _buildGradientCard(banner),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_activeBanners.isEmpty) {
      _initBanners();
    }
    final isDark = widget.controller.isDarkMode;

    return LayoutBuilder(
      builder: (context, constraints) {
        // Horizontal padding is 16 on each side = 32
        final cardWidth = constraints.maxWidth - 32;
        // Standard marketing banner aspect ratio is 2:1 (e.g. 2160x1080, 1024x512)
        // Proportional height ensures banners fit with exact aspect ratio on any phone
        final bannerHeight = cardWidth / 2.0;

        return Column(
          children: [
            SizedBox(
              height: bannerHeight,
              child: PageView.builder(
                controller: _pageController,
                itemCount: _activeBanners.length,
                onPageChanged: (index) => setState(() => _currentIndex = index),
                itemBuilder: (context, index) {
                  final banner = _activeBanners[index];

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: InkWell(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Voucher "${banner['code']}" berhasil disalin!'),
                            duration: const Duration(seconds: 2),
                            backgroundColor: AppColors.primary,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: _buildBannerImage(banner),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_activeBanners.length, (index) {
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
      },
    );
  }
}
