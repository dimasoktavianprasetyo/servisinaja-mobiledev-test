import 'package:flutter/material.dart';
import '../../controllers/app_controller.dart';
import '../../../core/constants/app_colors.dart';
import 'widgets/home_header.dart';
import 'widgets/promo_banner_carousel.dart';
import 'widgets/features_grid.dart';
import 'widgets/garasi_preview_list.dart';
import 'widgets/tips_card.dart';

class HomeScreen extends StatelessWidget {
  final AppController controller;

  const HomeScreen({
    super.key,
    required this.controller,
  });

  Future<void> _handleRefresh() async {
    // Smooth standard refresh
    await Future.delayed(const Duration(milliseconds: 600));
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final isDark = controller.isDarkMode;

        return Container(
          decoration: BoxDecoration(
            gradient: isDark
                ? const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.0, 0.22, 0.60, 1.0],
                    colors: [
                      Color(0xFF24160E), // Rich dark amber/orange top tint
                      Color(0xFF16151E), // Soft dark drift
                      Color(0xFF111827), // Deep slate
                      Color(0xFF0B1120), // Rich obsidian
                    ],
                  )
                : const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.0, 0.20, 0.55, 1.0],
                    colors: [
                      Color(0xFFFFECE0), // Soft luxurious warm orange glow
                      Color(0xFFFFF6EE), // Silky peach transition
                      Color(0xFFFAF7F4), // Refined warm neutral
                      Color(0xFFF8FAFC), // Clean crisp bottom
                    ],
                  ),
          ),
          child: SafeArea(
            child: RefreshIndicator(
              color: AppColors.primary,
              backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
              onRefresh: _handleRefresh,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HomeHeader(controller: controller),
                    const SizedBox(height: 18),
                    PromoBannerCarousel(controller: controller),
                    const SizedBox(height: 24),
                    FeaturesGrid(controller: controller),
                    const SizedBox(height: 24),
                    GarasiPreviewList(controller: controller),
                    const SizedBox(height: 24),
                    TipsCard(controller: controller),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
