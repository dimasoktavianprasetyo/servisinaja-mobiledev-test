import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../controllers/app_controller.dart';
import '../../widgets/servisin_app_bar.dart';

class ProfileScreen extends StatelessWidget {
  final AppController controller;

  const ProfileScreen({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = controller.isDarkMode;

    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        return Scaffold(
          appBar: const ServisinAppBar(title: 'Profil Saya', showBack: false),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.cardDark : AppColors.cardLight,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isDark ? AppColors.borderDark : AppColors.borderLight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primary.withValues(alpha: 0.15),
                              border: Border.all(color: AppColors.primary, width: 2),
                            ),
                            child: const Center(
                              child: Text(
                                'TA',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.verified_rounded,
                              size: 18,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Tania Anastasia',
                              style: AppTypography.getHeading(
                                isDark: isDark,
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '+62 812-3456-7890',
                              style: AppTypography.getBody(
                                isDark: isDark,
                                fontSize: 12,
                                isSecondary: true,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.primaryContainerLight,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                'Member Gold AHASS',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                _buildMenuSection(
                  isDark: isDark,
                  title: 'Pengaturan & Preferensi',
                  items: [
                    _buildSwitchMenuItem(
                      isDark: isDark,
                      icon: isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                      title: 'Mode Gelap (Dark Mode)',
                      value: isDark,
                      onChanged: (val) => controller.toggleTheme(),
                    ),
                    _buildMenuItem(
                      isDark: isDark,
                      icon: Icons.menu_book_rounded,
                      title: 'Buku Servis Digital',
                      subtitle: 'Riwayat & nota servis resmi',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Buku Servis Digital dimuat.')),
                        );
                      },
                    ),
                    _buildMenuItem(
                      isDark: isDark,
                      icon: Icons.location_on_outlined,
                      title: 'Alamat Tersimpan',
                      subtitle: 'Rumah, Kantor, dll.',
                      onTap: () {},
                    ),
                    _buildMenuItem(
                      isDark: isDark,
                      icon: Icons.security_rounded,
                      title: 'Keamanan Akun & PIN',
                      subtitle: 'Ubah kata sandi & PIN transaksi',
                      onTap: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _buildMenuSection(
                  isDark: isDark,
                  title: 'Pusat Bantuan',
                  items: [
                    _buildMenuItem(
                      isDark: isDark,
                      icon: Icons.headset_mic_rounded,
                      title: 'Call Center 24 Jam',
                      subtitle: 'Hubungi agen customer service',
                      onTap: () {},
                    ),
                    _buildMenuItem(
                      isDark: isDark,
                      icon: Icons.info_outline_rounded,
                      title: 'Tentang ServisinAja v2.4.0',
                      onTap: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                TextButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Akun tetap aktif.')),
                    );
                  },
                  icon: const Icon(Icons.logout_rounded, color: AppColors.emergency, size: 18),
                  label: const Text(
                    'Keluar dari Akun',
                    style: TextStyle(
                      color: AppColors.emergency,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMenuSection({
    required bool isDark,
    required String title,
    required List<Widget> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: Text(
            title,
            style: AppTypography.getHeading(
              isDark: isDark,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardDark : AppColors.cardLight,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? AppColors.borderDark : AppColors.borderLight,
            ),
          ),
          child: Column(children: items),
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required bool isDark,
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isDark ? AppColors.bgDark : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 20, color: AppColors.primary),
      ),
      title: Text(
        title,
        style: AppTypography.getLabel(
          isDark: isDark,
          fontSize: 13,
          fontWeight: FontWeight.w600,
          customColor: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: AppTypography.getBody(isDark: isDark, fontSize: 11, isSecondary: true),
            )
          : null,
      trailing: Icon(
        Icons.chevron_right_rounded,
        size: 18,
        color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
      ),
      onTap: onTap,
    );
  }

  Widget _buildSwitchMenuItem({
    required bool isDark,
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isDark ? AppColors.bgDark : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 20, color: AppColors.primary),
      ),
      title: Text(
        title,
        style: AppTypography.getLabel(
          isDark: isDark,
          fontSize: 13,
          fontWeight: FontWeight.w600,
          customColor: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
        ),
      ),
      trailing: Switch.adaptive(
        value: value,
        activeTrackColor: AppColors.primary,
        onChanged: onChanged,
      ),
    );
  }
}
