import 'package:flutter/material.dart';
import '../../controllers/app_controller.dart';
import '../../../core/constants/app_colors.dart';
import 'widgets/home_header.dart';
import 'widgets/promo_banner_carousel.dart';
import 'widgets/features_grid.dart';
import 'widgets/garasi_preview_list.dart';
import 'widgets/tips_card.dart';
import '../aktivitas/aktivitas_servis_screen.dart';

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
                      Colors.white,              // Putih bersih di atas (status bar)
                      Color(0xFFFFF6EE),         // Silky peach transition
                      Color(0xFFFAF7F4),         // Refined warm neutral
                      Color(0xFFF8FAFC),         // Clean crisp bottom
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
                    const SizedBox(height: 18),
                    // Ongoing Service Banner
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  AktivitasServisScreen(controller: controller),
                            ),
                          );
                        },
                        borderRadius: BorderRadius.circular(18),
                        child: Container(
                          height: 96,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            gradient: isDark
                                ? const LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: [
                                      Color(0xFF2D1A0A),
                                      Color(0xFF1E1A2E),
                                    ],
                                  )
                                : const LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: [
                                      Color(0xFFFFF0E6), // warm peach kiri
                                      Color(0xFFFFF8F3), // sangat lembut kanan
                                    ],
                                  ),
                            border: Border.all(
                              color: isDark
                                  ? const Color(0xFFD97706).withValues(alpha: 0.35)
                                  : const Color(0xFFE8A070).withValues(alpha: 0.55),
                              width: 1.2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFD97706).withValues(
                                  alpha: isDark ? 0.18 : 0.10,
                                ),
                                blurRadius: 14,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(17),
                            child: Stack(
                              children: [
                                // Gambar ilustrasi di sisi kiri dengan transisi gradient halus ke kanan
                                Positioned(
                                  left: 0,
                                  top: 0,
                                  bottom: 0,
                                  width: 130,
                                  child: ShaderMask(
                                    shaderCallback: (Rect bounds) {
                                      return const LinearGradient(
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                        colors: [
                                          Colors.white,
                                          Colors.white,
                                          Colors.transparent,
                                        ],
                                        stops: [0.0, 0.45, 1.0],
                                      ).createShader(bounds);
                                    },
                                    blendMode: BlendMode.dstIn,
                                    child: Image.asset(
                                      'assets/images/ongoing_service_illustration.jpg',
                                      fit: BoxFit.cover,
                                      alignment: Alignment.centerLeft,
                                      errorBuilder: (_, __, ___) => Image.asset(
                                        'assets/images/motor_vario.png',
                                        fit: BoxFit.contain,
                                        alignment: Alignment.centerLeft,
                                      ),
                                    ),
                                  ),
                                ),

                                // Gradient overlay transisi halus agar menyatu dengan warna card (tanpa garis pembatas)
                                Positioned(
                                  left: 0,
                                  top: 0,
                                  bottom: 0,
                                  width: 140,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                        colors: [
                                          (isDark
                                                  ? const Color(0xFF2D1A0A)
                                                  : const Color(0xFFFFF0E6))
                                              .withValues(alpha: 0.05),
                                          (isDark
                                                  ? const Color(0xFF2D1A0A)
                                                  : const Color(0xFFFFF0E6))
                                              .withValues(alpha: 0.65),
                                          isDark
                                              ? const Color(0xFF2D1A0A)
                                              : const Color(0xFFFFF0E6),
                                        ],
                                        stops: const [0.0, 0.65, 1.0],
                                      ),
                                    ),
                                  ),
                                ),

                                // Konten baris teks & chevron
                                Row(
                                  children: [
                                    // Spacing penyesuaian agar teks tidak menutupi subjek ilustrasi di kiri
                                    const SizedBox(width: 88),
                                    // Konten kanan
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 12,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Row(
                                              children: [
                                                Flexible(
                                                  child: Text(
                                                    'Servis Sedang Berlangsung',
                                                    style: TextStyle(
                                                      fontSize: 12.5,
                                                      fontWeight:
                                                          FontWeight.w800,
                                                      color: isDark
                                                          ? const Color(
                                                              0xFFFBDDAE)
                                                          : const Color(
                                                              0xFF92400E),
                                                      letterSpacing: 0.1,
                                                    ),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                const SizedBox(width: 6),
                                                Container(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                    horizontal: 6,
                                                    vertical: 2,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: isDark
                                                        ? const Color(
                                                                0xFFD97706)
                                                            .withValues(
                                                                alpha: 0.25)
                                                        : const Color(
                                                                0xFFD97706)
                                                            .withValues(
                                                                alpha: 0.12),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6),
                                                  ),
                                                  child: Text(
                                                    'LIVE',
                                                    style: TextStyle(
                                                      fontSize: 8.5,
                                                      fontWeight:
                                                          FontWeight.w900,
                                                      color: isDark
                                                          ? const Color(
                                                              0xFFFBBF24)
                                                          : const Color(
                                                              0xFFB45309),
                                                      letterSpacing: 0.5,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              '2 Unit • AHASS Cihampelas',
                                              style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w600,
                                                color: isDark
                                                    ? Colors.white.withValues(
                                                        alpha: 0.75)
                                                    : const Color(0xFF78350F),
                                              ),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              'Tap untuk pantau status servis',
                                              style: TextStyle(
                                                fontSize: 10,
                                                color: isDark
                                                    ? Colors.white.withValues(
                                                        alpha: 0.45)
                                                    : const Color(0xFFA16207)
                                                        .withValues(alpha: 0.7),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    // Chevron
                                    Padding(
                                      padding: const EdgeInsets.only(right: 12),
                                      child: Icon(
                                        Icons.chevron_right_rounded,
                                        color: isDark
                                            ? const Color(0xFFFBBF24)
                                            : const Color(0xFFD97706),
                                        size: 22,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
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
