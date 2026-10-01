import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../controllers/app_controller.dart';
import '../../widgets/animated_soundwave.dart';
import '../chat/chat_montir_screen.dart';
import '../main_navigation_screen.dart';

class CallMontirScreen extends StatefulWidget {
  final AppController controller;
  final bool isEmergency;
  final String mechanicName;
  final String mechanicRole;
  final String avatarPath;
  final String workshopName;
  final String pit;

  const CallMontirScreen({
    super.key,
    required this.controller,
    this.isEmergency = false,
    this.mechanicName = 'Kang Agus',
    this.mechanicRole = 'Teknisi Utama',
    this.avatarPath = 'assets/images/kang_agus.png',
    this.workshopName = 'AHASS Servisin Mitra Cihampelas',
    this.pit = 'Pit 01',
  });

  @override
  State<CallMontirScreen> createState() => _CallMontirScreenState();
}

class _CallMontirScreenState extends State<CallMontirScreen>
    with SingleTickerProviderStateMixin {
  AnimationController? _pulseController;
  bool _isExiting = false;

  void _ensurePulseController() {
    _pulseController ??= AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);
  }

  void _handleExit() {
    if (_isExiting) return;
    _isExiting = true;
    widget.controller.endCall();
    if (mounted) {
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => MainNavigationScreen(controller: widget.controller),
          ),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    widget.controller.startCall();
    _ensurePulseController();
  }

  @override
  void dispose() {
    _pulseController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _ensurePulseController();
    final pulseController = _pulseController!;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _handleExit();
      },
      child: Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: widget.isEmergency
              ? const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF9E652C),
                    Color(0xFFB87631),
                    Color(0xFFD48D39),
                    Color(0xFFE5A152),
                    Color(0xFFF2BE7D),
                    Color(0xFFFBE4C8),
                  ],
                  stops: [0.0, 0.20, 0.42, 0.62, 0.82, 1.0],
                )
              : const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF28170D),
                    Color(0xFF3E2212),
                    Color(0xFF5C3317),
                    Color(0xFF864A1F),
                    Color(0xFFA76028),
                    Color(0xFFCB8543),
                    Color(0xFFDE9E5F),
                    Color(0xFFEBB47E),
                  ],
                  stops: [0.0, 0.12, 0.25, 0.40, 0.55, 0.72, 0.88, 1.0],
                ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ─── Top Header Bar (Static, never rebuilds on 1s tick) ──────
              if (widget.isEmergency)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Circular Back Button
                      GestureDetector(
                        onTap: _handleExit,
                        child: Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withValues(alpha: 0.18),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.15),
                              width: 1,
                            ),
                          ),
                          child: const Icon(
                            Icons.chevron_left_rounded,
                            color: Colors.white,
                            size: 26,
                          ),
                        ),
                      ),

                      // Center Protected Pill Badge: [Shield icon] Panggilan Suara Gratis Servisin Aja
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.18),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.18),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.shield_rounded,
                              size: 15,
                              color: Color(0xFF10B981),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              widget.mechanicName.contains('Call Center')
                                  ? 'Hotline Darurat 24 Jam Servisin Aja'
                                  : 'Panggilan Suara Gratis Servisin Aja',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.90),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.1,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Soundwave audio bars icon on right
                      const AnimatedSoundwave(
                        isPlaying: true,
                        color: Color(0xFF10B981),
                        height: 18,
                        barCount: 2,
                        barWidth: 3.5,
                        spacing: 3.0,
                      ),
                    ],
                  ),
                )
              else
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Circular Back Button
                      GestureDetector(
                        onTap: _handleExit,
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withValues(alpha: 0.14),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.12),
                              width: 1,
                            ),
                          ),
                          child: const Icon(
                            Icons.chevron_left_rounded,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Title & Workshop Column
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.verified_user_rounded,
                                  size: 14,
                                  color: Color(0xFF10B981),
                                ),
                                const SizedBox(width: 5),
                                const Text(
                                  'Panggilan Suara Bengkel',
                                  style: TextStyle(
                                    color: Color(0xFF34D399),
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              widget.workshopName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.2,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),

                      // HD Audio Pill Badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: const Color(0xFF064E3B).withValues(alpha: 0.65),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: const Color(0xFF10B981).withValues(alpha: 0.45),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: Color(0xFF34D399),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 5),
                            const Text(
                              'HD Audio',
                              style: TextStyle(
                                color: Color(0xFF34D399),
                                fontSize: 11.5,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

              const Spacer(flex: 2),

              // ─── Avatar & Mechanic Info with RepaintBoundary ───────────────
              RepaintBoundary(
                child: ListenableBuilder(
                  listenable: widget.controller,
                  builder: (context, _) {
                    final isMuted = widget.controller.isCallMuted;

                    return AnimatedBuilder(
                      animation: pulseController,
                      child: ClipOval(
                        child: widget.mechanicName.contains('Call Center')
                            ? Container(
                                width: 116,
                                height: 116,
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [Color(0xFFDC2626), Color(0xFFEA580C)],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.support_agent_rounded,
                                    color: Colors.white,
                                    size: 56,
                                  ),
                                ),
                              )
                            : Image.asset(
                                widget.avatarPath,
                                width: 116,
                                height: 116,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => Container(
                                  width: 116,
                                  height: 116,
                                  color: AppColors.primary,
                                  child: const Icon(
                                    Icons.person,
                                    color: Colors.white,
                                    size: 56,
                                  ),
                                ),
                              ),
                      ),
                      builder: (context, cachedAvatar) {
                        final pulse = isMuted
                            ? 0.0
                            : Curves.easeInOutSine.transform(pulseController.value);

                        return SizedBox(
                          width: 156,
                          height: 156,
                          child: Stack(
                            clipBehavior: Clip.none,
                            alignment: Alignment.center,
                            children: [
                              // Soft expanding acoustic pulse wave
                              if (!isMuted)
                                Container(
                                  width: 122 + (pulse * 24),
                                  height: 122 + (pulse * 24),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: const Color(0xFF10B981)
                                          .withValues(alpha: (1.0 - pulse) * 0.35),
                                      width: 1.5,
                                    ),
                                  ),
                                ),

                              // Avatar Photo with Fixed Verified Checkmark Badge
                              SizedBox(
                                width: 122,
                                height: 122,
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    // Avatar container with dynamic breathing neon glow ring
                                    Container(
                                      width: 122,
                                      height: 122,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: const Color(0xFF10B981),
                                          width: 3.0,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color(0xFF10B981)
                                                .withValues(alpha: 0.35 + (pulse * 0.30)),
                                            blurRadius: 16 + (pulse * 12),
                                            spreadRadius: 1 + (pulse * 2.5),
                                          ),
                                        ],
                                      ),
                                      child: Center(child: cachedAvatar),
                                    ),

                                    // Orange Verified Checkmark Badge
                                    Positioned(
                                      right: 2,
                                      bottom: 4,
                                      child: Container(
                                        width: 26,
                                        height: 26,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFFF8C00),
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: const Color(0xFF352013),
                                            width: 2.2,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withValues(alpha: 0.35),
                                              blurRadius: 4,
                                              offset: const Offset(0, 1),
                                            ),
                                          ],
                                        ),
                                        child: const Center(
                                          child: Icon(
                                            Icons.check_rounded,
                                            color: Colors.white,
                                            size: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),

              const SizedBox(height: 6),

              // Mechanic Name
              Text(
                widget.mechanicName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.3,
                ),
              ),

              const SizedBox(height: 6),

              // Mechanic Role
              Text(
                widget.mechanicRole,
                style: TextStyle(
                  color: widget.isEmergency
                      ? Colors.white.withValues(alpha: 0.88)
                      : const Color(0xFFFF8C00),
                  fontSize: 14.5,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 16),

              // Status Pill ("Terhubung (05:29)")
              ListenableBuilder(
                listenable: widget.controller,
                builder: (context, _) {
                  final durationText = Formatters.callDuration(
                    widget.controller.callDurationSeconds,
                  );
                  final isMuted = widget.controller.isCallMuted;

                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7.5),
                    decoration: BoxDecoration(
                      color: const Color(0xFF064E3B).withValues(alpha: 0.45),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: const Color(0xFF10B981).withValues(alpha: 0.35),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedSoundwave(
                          isPlaying: !isMuted,
                          color: const Color(0xFF10B981),
                          height: 15,
                          barCount: 4,
                          barWidth: 3.2,
                          spacing: 2.0,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          isMuted ? 'Terhubung (Dibisukan)' : 'Terhubung ($durationText)',
                          style: const TextStyle(
                            color: Color(0xFF34D399),
                            fontSize: 13.5,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              const Spacer(flex: 3),

              // ─── Action Buttons (Bisukan, Speaker, Kirim Pesan) ───────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: ListenableBuilder(
                  listenable: widget.controller,
                  builder: (context, _) {
                    final isMuted = widget.controller.isCallMuted;
                    final isSpeakerOn = widget.controller.isSpeakerOn;

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildCallActionButton(
                          icon: isMuted ? Icons.mic_off_rounded : Icons.mic_none_rounded,
                          label: isMuted ? 'Unmute' : 'Bisukan',
                          isActive: isMuted,
                          onTap: widget.controller.toggleMute,
                        ),
                        _buildCallActionButton(
                          icon: isSpeakerOn
                              ? Icons.volume_up_outlined
                              : Icons.volume_off_outlined,
                          label: 'Speaker',
                          isActive: isSpeakerOn,
                          onTap: widget.controller.toggleSpeaker,
                        ),
                        _buildCallActionButton(
                          icon: Icons.chat_bubble_outline_rounded,
                          label: 'Kirim Pesan',
                          isActive: false,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ChatMontirScreen(
                                  controller: widget.controller,
                                  isEmergency: widget.isEmergency,
                                  mechanicName: widget.mechanicName.contains('Call Center')
                                      ? 'Kang Asep Supriyadi'
                                      : widget.mechanicName,
                                  mechanicRole: widget.isEmergency
                                      ? 'Teknisi AHASS Siaga • OTW'
                                      : 'Teknisi AHASS Cihampelas • ${widget.pit}',
                                  avatarPath: widget.avatarPath,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  },
                ),
              ),

              const Spacer(flex: 1),

              // ─── End Call Button & Label ─────────────────────────────────
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: _handleExit,
                    child: Container(
                      width: 74,
                      height: 74,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFFEF4444),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFEF4444).withValues(alpha: 0.45),
                            blurRadius: 22,
                            spreadRadius: 2,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.call_end_rounded,
                        color: Colors.white,
                        size: 36,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Akhiri Panggilan',
                    style: TextStyle(
                      color: Color(0xFFEF4444),
                      fontSize: 14.5,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.1,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    ),
  );
}

  Widget _buildCallActionButton({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isActive
                  ? Colors.white.withValues(alpha: 0.35)
                  : Colors.white.withValues(alpha: 0.20),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.15),
                width: 1,
              ),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 27,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.85),
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
