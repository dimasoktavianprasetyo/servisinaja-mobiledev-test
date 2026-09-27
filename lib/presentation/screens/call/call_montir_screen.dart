import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../controllers/app_controller.dart';
import '../../widgets/animated_soundwave.dart';
import '../chat/chat_montir_screen.dart';

class CallMontirScreen extends StatefulWidget {
  final AppController controller;
  final bool isEmergency;

  const CallMontirScreen({
    super.key,
    required this.controller,
    this.isEmergency = false,
  });

  @override
  State<CallMontirScreen> createState() => _CallMontirScreenState();
}

class _CallMontirScreenState extends State<CallMontirScreen> {
  @override
  void initState() {
    super.initState();
    widget.controller.startCall();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, _) {
        final durationText = Formatters.callDuration(widget.controller.callDurationSeconds);
        final isMuted = widget.controller.isCallMuted;
        final isSpeakerOn = widget.controller.isSpeakerOn;

        return Scaffold(
          backgroundColor: const Color(0xFF0B1120),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          widget.controller.endCall();
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white, size: 28),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: widget.isEmergency
                              ? AppColors.emergency.withValues(alpha: 0.2)
                              : AppColors.primary.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: widget.isEmergency ? AppColors.emergency : AppColors.primary,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              widget.isEmergency ? Icons.warning_rounded : Icons.shield_rounded,
                              size: 14,
                              color: widget.isEmergency ? AppColors.emergency : AppColors.primary,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              widget.isEmergency ? 'Panggilan Darurat AHASS' : 'VoIP Layanan AHASS',
                              style: TextStyle(
                                color: widget.isEmergency ? AppColors.emergency : AppColors.primary,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                  Column(
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 170,
                            height: 170,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: (widget.isEmergency ? AppColors.emergency : AppColors.primary)
                                    .withValues(alpha: 0.2),
                                width: 2,
                              ),
                            ),
                          ),
                          Container(
                            width: 140,
                            height: 140,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: (widget.isEmergency ? AppColors.emergency : AppColors.primary)
                                    .withValues(alpha: 0.4),
                                width: 2,
                              ),
                            ),
                          ),
                          Container(
                            width: 110,
                            height: 110,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFF1E293B),
                              border: Border.all(
                                color: widget.isEmergency ? AppColors.emergency : AppColors.primary,
                                width: 3,
                              ),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.engineering_rounded,
                                size: 54,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Budi Santoso',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Montir Resmi AHASS Daya Sudirman',
                        style: TextStyle(
                          color: Color(0xFF94A3B8),
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E293B),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AnimatedSoundwave(
                              isPlaying: !isMuted,
                              color: widget.isEmergency ? AppColors.emergency : AppColors.primary,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              isMuted ? 'Mikrofon Dibisukan' : durationText,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildCallAction(
                            icon: isMuted ? Icons.mic_off_rounded : Icons.mic_rounded,
                            label: isMuted ? 'Unmute' : 'Bisukan',
                            isActive: isMuted,
                            onTap: widget.controller.toggleMute,
                          ),
                          _buildCallAction(
                            icon: isSpeakerOn ? Icons.volume_up_rounded : Icons.volume_down_rounded,
                            label: 'Speaker',
                            isActive: isSpeakerOn,
                            onTap: widget.controller.toggleSpeaker,
                          ),
                          _buildCallAction(
                            icon: Icons.chat_bubble_rounded,
                            label: 'Buka Chat',
                            isActive: false,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ChatMontirScreen(controller: widget.controller),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 36),
                      InkWell(
                        onTap: () {
                          widget.controller.endCall();
                          Navigator.pop(context);
                        },
                        borderRadius: BorderRadius.circular(36),
                        child: Container(
                          width: double.infinity,
                          height: 56,
                          decoration: BoxDecoration(
                            color: AppColors.emergency,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.emergency.withValues(alpha: 0.4),
                                blurRadius: 16,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.call_end_rounded, color: Colors.white, size: 24),
                              SizedBox(width: 10),
                              Text(
                                'Akhiri Panggilan',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCallAction({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(28),
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: isActive ? Colors.white : const Color(0xFF1E293B),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: isActive ? const Color(0xFF0F172A) : Colors.white,
              size: 24,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF94A3B8),
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
