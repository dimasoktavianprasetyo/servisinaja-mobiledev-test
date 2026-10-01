import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../controllers/app_controller.dart';
import '../aktivitas/aktivitas_servis_screen.dart';
import 'alamat_tersimpan_screen.dart';
import 'keamanan_akun_screen.dart';
import 'pusat_bantuan_screen.dart';

class ProfileScreen extends StatefulWidget {
  final AppController controller;

  const ProfileScreen({
    super.key,
    required this.controller,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _userName = 'Tania Anastasia';
  String _userPhone = '+62 811-3456-7890';
  String _userEmail = 'tania@gmail.com';

  void _showEditProfileModal() {
    final isDark = widget.controller.isDarkMode;
    final nameCtrl = TextEditingController(text: _userName);
    final phoneCtrl = TextEditingController(text: _userPhone);
    final emailCtrl = TextEditingController(text: _userEmail);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardDark : Colors.white,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF475569) : const Color(0xFFCBD5E1),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Ubah Profil',
                  style: AppTypography.getHeading(
                    isDark: isDark,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Nama Lengkap',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: phoneCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Nomor Handphone',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: emailCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Alamat Email',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _userName = nameCtrl.text.trim();
                        _userPhone = phoneCtrl.text.trim();
                        _userEmail = emailCtrl.text.trim();
                      });
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Profil berhasil diperbarui'),
                          backgroundColor: AppColors.primary,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text(
                      'Simpan Perubahan',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showSettingsModal() {
    final isDark = widget.controller.isDarkMode;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardDark : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF475569) : const Color(0xFFCBD5E1),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Pengaturan Aplikasi',
                style: AppTypography.getHeading(
                  isDark: isDark,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(
                  isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                  color: AppColors.primary,
                ),
                title: const Text('Mode Gelap (Dark Mode)', style: TextStyle(fontWeight: FontWeight.w600)),
                trailing: Switch.adaptive(
                  value: isDark,
                  activeTrackColor: AppColors.primary,
                  onChanged: (val) {
                    widget.controller.toggleTheme();
                  },
                ),
              ),
              const Divider(),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.notifications_outlined, color: AppColors.primary),
                title: const Text('Notifikasi Servis & Promo', style: TextStyle(fontWeight: FontWeight.w600)),
                trailing: Switch.adaptive(
                  value: true,
                  activeTrackColor: AppColors.primary,
                  onChanged: (val) {},
                ),
              ),
              const Divider(),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.language_rounded, color: AppColors.primary),
                title: const Text('Bahasa', style: TextStyle(fontWeight: FontWeight.w600)),
                trailing: const Text('Bahasa Indonesia', style: TextStyle(color: Colors.grey)),
                onTap: () {},
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  void _showTukarPoinDialog() {
    final isDark = widget.controller.isDarkMode;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? AppColors.cardDark : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Color(0xFFFFF7ED),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.stars_rounded, color: AppColors.primary, size: 24),
            ),
            const SizedBox(width: 10),
            const Text('Tukar Poin Servis', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Saldo Poin Anda: 1.250 Poin',
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Gunakan poin Anda untuk potongan servis berkala atau voucher oli gratis di seluruh bengkel AHASS terdaftar.',
              style: AppTypography.getBody(isDark: isDark, fontSize: 12, isSecondary: true),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Diskon Servis Rp 25.000', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                  Text('500 Poin', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w800)),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Tutup'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Voucher diskon Rp 25.000 berhasil ditukarkan!'),
                  backgroundColor: AppColors.primary,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: const Text('Tukar Sekarang', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    final isDark = widget.controller.isDarkMode;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? AppColors.cardDark : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Keluar dari Akun?'),
        content: const Text('Anda perlu masuk kembali untuk mengakses booking dan riwayat servis Anda.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Anda telah keluar dari akun.'),
                  backgroundColor: AppColors.emergency,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.emergency,
            ),
            child: const Text('Keluar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.controller.isDarkMode;

    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: isDark ? AppColors.bgDark : const Color(0xFFF8FAFC),
          appBar: AppBar(
            backgroundColor: isDark ? AppColors.bgDark : const Color(0xFFF8FAFC),
            elevation: 0,
            scrolledUnderElevation: 0,
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
                  onPressed: () {
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    } else {
                      widget.controller.setNavIndex(0);
                    }
                  },
                ),
              ),
            ),
            title: Text(
              'Profil Saya',
              style: AppTypography.getHeading(
                isDark: isDark,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 16),
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
                    Icons.settings_outlined,
                    size: 20,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  ),
                  onPressed: _showSettingsModal,
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              children: [
                // User Profile Hero Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.cardDark : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isDark ? AppColors.borderDark : const Color(0xFFE2E8F0),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.04),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Tania Avatar with verified badge (1:1 from Figma, unclipped, zero 404)
                      SizedBox(
                        width: 60,
                        height: 60,
                        child: Image.asset(
                          'assets/images/tania_avatar.png',
                          width: 60,
                          height: 60,
                          fit: BoxFit.contain,
                          errorBuilder: (ctx, err, stack) => const Center(
                            child: Icon(Icons.person, size: 36, color: AppColors.primary),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      // Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _userName,
                              style: AppTypography.getHeading(
                                isDark: isDark,
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              '$_userPhone • $_userEmail',
                              style: TextStyle(
                                color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 6),
                            // Member Gold Servisin Badge
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: isDark ? const Color(0xFF2A1C14) : const Color(0xFFFFF7ED),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: isDark ? const Color(0xFF78350F) : const Color(0xFFFFEDD5),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.star_rounded,
                                    size: 14,
                                    color: Color(0xFFEA580C),
                                  ),
                                  const SizedBox(width: 4),
                                  const Text(
                                    'Member Gold Servisin',
                                    style: TextStyle(
                                      color: Color(0xFFEA580C),
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Edit Button
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                          ),
                        ),
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: Icon(
                            Icons.edit_outlined,
                            size: 18,
                            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                          ),
                          onPressed: _showEditProfileModal,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // 2 Stat Cards: 1.250 Poin & 3 Voucher
                Row(
                  children: [
                    // Left: 1.250 Poin
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.cardDark : Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: isDark ? AppColors.borderDark : const Color(0xFFE2E8F0),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(18),
                          onTap: _showTukarPoinDialog,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      color: isDark ? const Color(0xFF2A1C14) : const Color(0xFFFFF7ED),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.stars_rounded,
                                      color: Color(0xFFEA580C),
                                      size: 18,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    '1.250 Poin',
                                    style: TextStyle(
                                      color: Color(0xFFEA580C),
                                      fontSize: 15,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Tukar Poin Servis',
                                    style: TextStyle(
                                      color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const Icon(
                                    Icons.chevron_right_rounded,
                                    size: 16,
                                    color: Color(0xFFEA580C),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Right: 3 Voucher
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.cardDark : Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: isDark ? AppColors.borderDark : const Color(0xFFE2E8F0),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(18),
                          onTap: () {
                            widget.controller.setNavIndex(2); // Go to Promo tab
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      color: isDark ? const Color(0xFF1E293B) : const Color(0xFFEFF6FF),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.confirmation_number_outlined,
                                      color: Color(0xFF2563EB),
                                      size: 18,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '3 Voucher',
                                    style: TextStyle(
                                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                                      fontSize: 15,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Lihat Kupon Aktif',
                                    style: TextStyle(
                                      color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Icon(
                                    Icons.chevron_right_rounded,
                                    size: 16,
                                    color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Grouped Menu Container
                Container(
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.cardDark : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isDark ? AppColors.borderDark : const Color(0xFFE2E8F0),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.04),
                        blurRadius: 14,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Item 1: Riwayat Booking & Servis
                      _buildProfileMenuItem(
                        isDark: isDark,
                        icon: Icons.history_rounded,
                        iconBg: isDark ? const Color(0xFF2A1C14) : const Color(0xFFFFF7ED),
                        iconColor: const Color(0xFFEA580C),
                        title: 'Riwayat Booking & Servis',
                        badgeText: '1 Booking Aktif',
                        badgeBg: isDark ? const Color(0xFF332008) : const Color(0xFFFFF7ED),
                        badgeColor: const Color(0xFFEA580C),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AktivitasServisScreen(controller: widget.controller),
                            ),
                          );
                        },
                      ),
                      _buildMenuDivider(isDark),

                      // Item 2: Kelola Motor di Garasi (2 Unit)
                      _buildProfileMenuItem(
                        isDark: isDark,
                        icon: Icons.hub_rounded,
                        iconBg: isDark ? const Color(0xFF064E3B) : const Color(0xFFDCFCE7),
                        iconColor: const Color(0xFF16A34A),
                        title: 'Kelola Motor di Garasi (2 Unit)',
                        onTap: () {
                          widget.controller.setNavIndex(3); // Switch to Garasi
                        },
                      ),
                      _buildMenuDivider(isDark),

                      // Item 3: Daftar Alamat Tersimpan
                      _buildProfileMenuItem(
                        isDark: isDark,
                        icon: Icons.location_on_outlined,
                        iconBg: isDark ? const Color(0xFF1E293B) : const Color(0xFFE0F2FE),
                        iconColor: const Color(0xFF0284C7),
                        title: 'Daftar Alamat Tersimpan',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AlamatTersimpanScreen(controller: widget.controller),
                            ),
                          );
                        },
                      ),
                      _buildMenuDivider(isDark),

                      // Item 4: Pusat Bantuan & Call Center
                      _buildProfileMenuItem(
                        isDark: isDark,
                        icon: Icons.support_agent_rounded,
                        iconBg: isDark ? const Color(0xFF2E1065) : const Color(0xFFF3E8FF),
                        iconColor: const Color(0xFF9333EA),
                        title: 'Pusat Bantuan & Call Center',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PusatBantuanScreen(controller: widget.controller),
                            ),
                          );
                        },
                      ),
                      _buildMenuDivider(isDark),

                      // Item 5: Keamanan Akun & Ganti PIN
                      _buildProfileMenuItem(
                        isDark: isDark,
                        icon: Icons.lock_outline_rounded,
                        iconBg: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                        iconColor: const Color(0xFF475569),
                        title: 'Keamanan Akun & Ganti PIN',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => KeamananAkunScreen(controller: widget.controller),
                            ),
                          );
                        },
                      ),
                      _buildMenuDivider(isDark),

                      // Item 6: Keluar dari Akun
                      _buildProfileMenuItem(
                        isDark: isDark,
                        icon: Icons.logout_rounded,
                        iconBg: isDark ? const Color(0xFF3B1818) : const Color(0xFFFEE2E2),
                        iconColor: const Color(0xFFEF4444),
                        title: 'Keluar dari Akun',
                        titleColor: const Color(0xFFEF4444),
                        trailingColor: const Color(0xFFEF4444),
                        onTap: _showLogoutDialog,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Version Footer
                Text(
                  'Servisin Aja App v2.4.1 (Build 2026)',
                  style: TextStyle(
                    color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMenuDivider(bool isDark) {
    return Divider(
      height: 1,
      thickness: 1,
      color: isDark ? AppColors.borderDark : const Color(0xFFF1F5F9),
    );
  }

  Widget _buildProfileMenuItem({
    required bool isDark,
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    String? badgeText,
    Color? badgeBg,
    Color? badgeColor,
    Color? titleColor,
    Color? trailingColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 20, color: iconColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Row(
                children: [
                  Flexible(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: titleColor ?? (isDark ? Colors.white : const Color(0xFF0F172A)),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (badgeText != null) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                      decoration: BoxDecoration(
                        color: badgeBg,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFFFFEDD5),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        badgeText,
                        style: TextStyle(
                          color: badgeColor,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              size: 20,
              color: trailingColor ?? (isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8)),
            ),
          ],
        ),
      ),
    );
  }
}
