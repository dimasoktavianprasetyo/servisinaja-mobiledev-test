import 'package:flutter/material.dart';
import '../../controllers/app_controller.dart';
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

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        return SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
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
        );
      },
    );
  }
}
