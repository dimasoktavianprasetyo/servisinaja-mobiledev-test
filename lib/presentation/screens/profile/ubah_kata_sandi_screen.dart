import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../controllers/app_controller.dart';

class UbahKataSandiScreen extends StatefulWidget {
  final AppController controller;

  const UbahKataSandiScreen({
    super.key,
    required this.controller,
  });

  @override
  State<UbahKataSandiScreen> createState() => _UbahKataSandiScreenState();
}

class _UbahKataSandiScreenState extends State<UbahKataSandiScreen> {
  final _oldPassController = TextEditingController(text: 'PasswordLama123!');
  final _newPassController = TextEditingController(text: 'ServisinAja2026!#');
  final _confirmPassController = TextEditingController(text: 'ServisinAja2026!#');

  bool _obscureOld = true;
  bool _obscureNew = false;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _oldPassController.dispose();
    _newPassController.dispose();
    _confirmPassController.dispose();
    super.dispose();
  }

  // Password criteria checks
  bool get _hasMin8 => _newPassController.text.length >= 8;
  bool get _hasUpperLower {
    final t = _newPassController.text;
    return t.contains(RegExp(r'[A-Z]')) && t.contains(RegExp(r'[a-z]'));
  }

  bool get _hasNumber => _newPassController.text.contains(RegExp(r'[0-9]'));
  bool get _hasSpecial => _newPassController.text.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

  int get _strengthScore {
    int score = 0;
    if (_hasMin8) score++;
    if (_hasUpperLower) score++;
    if (_hasNumber) score++;
    if (_hasSpecial) score++;
    return score;
  }

  String get _strengthText {
    switch (_strengthScore) {
      case 0:
      case 1:
        return 'Lemah';
      case 2:
        return 'Cukup';
      case 3:
        return 'Sedang';
      case 4:
      default:
        return 'Kuat';
    }
  }

  Color get _strengthColor {
    switch (_strengthScore) {
      case 0:
      case 1:
        return const Color(0xFFEF4444);
      case 2:
        return const Color(0xFFF59E0B);
      case 3:
        return const Color(0xFF3B82F6);
      case 4:
      default:
        return const Color(0xFF16A34A);
    }
  }

  bool get _isMatch =>
      _newPassController.text.isNotEmpty &&
      _newPassController.text == _confirmPassController.text;

  void _submit() {
    if (_strengthScore < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Kata sandi baru belum cukup kuat. Lengkapi kriteria.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    if (!_isMatch) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Konfirmasi kata sandi tidak cocok.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: widget.controller.isDarkMode ? AppColors.cardDark : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(
                color: Color(0xFFDCFCE7),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_rounded, color: Color(0xFF16A34A), size: 36),
            ),
            const SizedBox(height: 16),
            Text(
              'Kata Sandi Berhasil Diubah',
              style: AppTypography.getHeading(
                isDark: widget.controller.isDarkMode,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Gunakan kata sandi baru Anda saat melakukan login kembali di kemudian hari.',
              style: AppTypography.getBody(
                isDark: widget.controller.isDarkMode,
                fontSize: 12,
                isSecondary: true,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text(
                  'Mengerti',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
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
            centerTitle: true,
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
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
            title: Text(
              'Ubah Kata Sandi',
              style: AppTypography.getHeading(
                isDark: isDark,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header card
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.cardDark : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isDark ? AppColors.borderDark : const Color(0xFFE2E8F0),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: isDark
                                    ? const Color(0xFF2A1C14)
                                    : const Color(0xFFFFF7ED),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isDark
                                      ? const Color(0xFF45220E)
                                      : const Color(0xFFFFEDD5),
                                ),
                              ),
                              child: const Icon(
                                Icons.shield_outlined,
                                color: AppColors.primary,
                                size: 22,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Amankan Akun Servisin Aja',
                                    style: AppTypography.getHeading(
                                      isDark: isDark,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Gunakan kombinasi sandi yang kuat dan belum pernah dipakai di akun lain.',
                                    style: AppTypography.getBody(
                                      isDark: isDark,
                                      fontSize: 11,
                                      isSecondary: true,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Field 1: Kata Sandi Saat Ini
                      Text(
                        'Kata Sandi Saat Ini',
                        style: AppTypography.getLabel(
                          isDark: isDark,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildTextField(
                        controller: _oldPassController,
                        obscureText: _obscureOld,
                        prefixIcon: Icons.lock_outline_rounded,
                        isDark: isDark,
                        onToggleVisibility: () {
                          setState(() {
                            _obscureOld = !_obscureOld;
                          });
                        },
                      ),
                      const SizedBox(height: 6),
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Tautan reset password dikirim ke email tania@gmail.com'),
                                backgroundColor: AppColors.primary,
                              ),
                            );
                          },
                          child: const Text(
                            'Lupa kata sandi saat ini?',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),

                      // Field 2: Kata Sandi Baru
                      Text(
                        'Kata Sandi Baru',
                        style: AppTypography.getLabel(
                          isDark: isDark,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildTextField(
                        controller: _newPassController,
                        obscureText: _obscureNew,
                        prefixIcon: Icons.vpn_key_outlined,
                        prefixColor: AppColors.primary,
                        isDark: isDark,
                        onChanged: (_) => setState(() {}),
                        onToggleVisibility: () {
                          setState(() {
                            _obscureNew = !_obscureNew;
                          });
                        },
                      ),
                      const SizedBox(height: 10),

                      // Password strength container
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.cardDark : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isDark ? AppColors.borderDark : const Color(0xFFE2E8F0),
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Indikator Keamanan Sandi',
                                  style: AppTypography.getBody(
                                    isDark: isDark,
                                    fontSize: 12,
                                    isSecondary: true,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Container(
                                      width: 6,
                                      height: 6,
                                      decoration: BoxDecoration(
                                        color: _strengthColor,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      'Kekuatan: $_strengthText',
                                      style: TextStyle(
                                        color: _strengthColor,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            // 4 Progress Bars
                            Row(
                              children: List.generate(4, (index) {
                                final isFilled = index < _strengthScore;
                                return Expanded(
                                  child: Container(
                                    height: 5,
                                    margin: EdgeInsets.only(
                                      left: index == 0 ? 0 : 3,
                                      right: index == 3 ? 0 : 3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isFilled
                                          ? _strengthColor
                                          : (isDark
                                              ? const Color(0xFF334155)
                                              : const Color(0xFFE2E8F0)),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                );
                              }),
                            ),
                            const SizedBox(height: 14),
                            // 2x2 Checklist
                            Row(
                              children: [
                                Expanded(
                                  child: _buildCheckItem('Minimal 8 Karakter', _hasMin8, isDark),
                                ),
                                Expanded(
                                  child: _buildCheckItem('Huruf Besar & Kecil', _hasUpperLower, isDark),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildCheckItem('Mengandung Angka (0–9)', _hasNumber, isDark),
                                ),
                                Expanded(
                                  child: _buildCheckItem('Simbol Khusus (!@#\$)', _hasSpecial, isDark),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),

                      // Field 3: Ulangi Kata Sandi Baru
                      Text(
                        'Ulangi Kata Sandi Baru',
                        style: AppTypography.getLabel(
                          isDark: isDark,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildTextField(
                        controller: _confirmPassController,
                        obscureText: _obscureConfirm,
                        prefixIcon: Icons.shield_outlined,
                        isDark: isDark,
                        borderColor: _isMatch ? const Color(0xFF16A34A) : null,
                        suffixWidget: _isMatch
                            ? Container(
                                margin: const EdgeInsets.only(right: 12),
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFDCFCE7),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.check_rounded, size: 13, color: Color(0xFF16A34A)),
                                    SizedBox(width: 3),
                                    Text(
                                      'COCOK',
                                      style: TextStyle(
                                        color: Color(0xFF16A34A),
                                        fontSize: 10,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : null,
                        onChanged: (_) => setState(() {}),
                        onToggleVisibility: () {
                          setState(() {
                            _obscureConfirm = !_obscureConfirm;
                          });
                        },
                      ),
                      if (_isMatch) ...[
                        const SizedBox(height: 6),
                        const Row(
                          children: [
                            Icon(Icons.check_rounded, size: 14, color: Color(0xFF16A34A)),
                            SizedBox(width: 4),
                            Text(
                              'Kata sandi cocok dan siap disimpan',
                              style: TextStyle(
                                color: Color(0xFF16A34A),
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                      const SizedBox(height: 18),

                      // Bottom Amber Note
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF332008) : const Color(0xFFFFFBEB),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isDark ? const Color(0xFF78350F) : const Color(0xFFFDE68A),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.info_outline_rounded,
                              size: 16,
                              color: isDark ? const Color(0xFFFBBF24) : const Color(0xFFD97706),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Setelah kata sandi diganti, Anda akan tetap masuk di perangkat ini. Sesi login pada perangkat lain akan otomatis diakhiri.',
                                style: TextStyle(
                                  color: isDark ? const Color(0xFFFDE68A) : const Color(0xFFB45309),
                                  fontSize: 11,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),

              // Fixed Bottom Button
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.cardDark : Colors.white,
                  border: Border(
                    top: BorderSide(
                      color: isDark ? AppColors.borderDark : const Color(0xFFE2E8F0),
                    ),
                  ),
                ),
                child: SafeArea(
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 2,
                        shadowColor: AppColors.primary.withValues(alpha: 0.4),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Simpan Kata Sandi Baru',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward_rounded, size: 18, color: Colors.white),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCheckItem(String label, bool isChecked, bool isDark) {
    return Row(
      children: [
        Icon(
          isChecked ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
          size: 14,
          color: isChecked
              ? const Color(0xFF16A34A)
              : (isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8)),
        ),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: isChecked ? FontWeight.w600 : FontWeight.normal,
              color: isChecked
                  ? (isDark ? const Color(0xFFF1F5F9) : const Color(0xFF1E293B))
                  : (isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required bool obscureText,
    required IconData prefixIcon,
    Color? prefixColor,
    Color? borderColor,
    Widget? suffixWidget,
    required bool isDark,
    VoidCallback? onToggleVisibility,
    ValueChanged<String>? onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: borderColor ?? (isDark ? AppColors.borderDark : const Color(0xFFCBD5E1)),
          width: borderColor != null ? 1.5 : 1,
        ),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        onChanged: onChanged,
        style: TextStyle(
          fontSize: 14,
          color: isDark ? Colors.white : const Color(0xFF0F172A),
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          prefixIcon: Icon(
            prefixIcon,
            size: 20,
            color: prefixColor ?? (isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
          ),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (suffixWidget != null) suffixWidget,
              IconButton(
                icon: Icon(
                  obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                  size: 20,
                  color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                ),
                onPressed: onToggleVisibility,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
