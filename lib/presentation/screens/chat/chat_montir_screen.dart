import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/utils/formatters.dart';
import '../../controllers/app_controller.dart';
import '../../widgets/servisin_app_bar.dart';
import '../call/call_montir_screen.dart';

class ChatMontirScreen extends StatefulWidget {
  final AppController controller;

  const ChatMontirScreen({
    super.key,
    required this.controller,
  });

  @override
  State<ChatMontirScreen> createState() => _ChatMontirScreenState();
}

class _ChatMontirScreenState extends State<ChatMontirScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void _sendMessage() {
    final text = _textController.text;
    if (text.trim().isEmpty) return;

    widget.controller.sendChatMessage(text);
    _textController.clear();

    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 80,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendLocation() {
    widget.controller.sendChatMessage('📍 Posisi Saya: Jl. Jenderal Sudirman No. 45, Jakarta Pusat (Patokan: Depan Halte)');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Lokasi terkini berhasil dikirim ke montir!'),
        backgroundColor: AppColors.primary,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _sendPhoto() {
    widget.controller.sendChatMessage('📷 [Foto Kendala Terkirim: Kondisi rantai kendor & bunyi gesekan]');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Foto kendala motor berhasil dikirim!'),
        backgroundColor: AppColors.primary,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.controller.isDarkMode;

    return Scaffold(
      appBar: ServisinAppBar(
        title: 'Montir Budi Santoso',
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CallMontirScreen(controller: widget.controller),
                ),
              );
            },
            icon: const Icon(Icons.phone_in_talk_rounded, color: AppColors.primary),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: isDark ? AppColors.surfaceDark : const Color(0xFFF1F5F9),
            child: Row(
              children: [
                const Icon(Icons.verified_user_rounded, size: 16, color: AppColors.success),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Teknisi Resmi AHASS • Servis Terlindungi Garansi',
                    style: AppTypography.getLabel(
                      isDark: isDark,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListenableBuilder(
              listenable: widget.controller,
              builder: (context, _) {
                final messages = widget.controller.chatMessages;

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    final isMe = msg.isMe;

                    return Align(
                      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.75,
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: isMe
                              ? AppColors.primary
                              : (isDark ? AppColors.cardDark : Colors.white),
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(16),
                            topRight: const Radius.circular(16),
                            bottomLeft: Radius.circular(isMe ? 16 : 4),
                            bottomRight: Radius.circular(isMe ? 4 : 16),
                          ),
                          border: isMe
                              ? null
                              : Border.all(
                                  color: isDark ? AppColors.borderDark : AppColors.borderLight,
                                ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment:
                              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                          children: [
                            Text(
                              msg.text,
                              style: TextStyle(
                                color: isMe
                                    ? Colors.white
                                    : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
                                fontSize: 13,
                                height: 1.4,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              Formatters.time(msg.timestamp),
                              style: TextStyle(
                                color: isMe
                                    ? Colors.white.withValues(alpha: 0.75)
                                    : (isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : Colors.white,
              border: Border(
                top: BorderSide(
                  color: isDark ? AppColors.borderDark : AppColors.borderLight,
                ),
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  Row(
                    children: [
                      ActionChip(
                        avatar: const Icon(Icons.my_location_rounded, size: 14, color: AppColors.primary),
                        label: const Text('Kirim Lokasi', style: TextStyle(fontSize: 11)),
                        backgroundColor: isDark ? AppColors.bgDark : const Color(0xFFF1F5F9),
                        onPressed: _sendLocation,
                      ),
                      const SizedBox(width: 8),
                      ActionChip(
                        avatar: const Icon(Icons.camera_alt_rounded, size: 14, color: AppColors.primary),
                        label: const Text('Kirim Foto', style: TextStyle(fontSize: 11)),
                        backgroundColor: isDark ? AppColors.bgDark : const Color(0xFFF1F5F9),
                        onPressed: _sendPhoto,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.bgDark : const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: isDark ? AppColors.borderDark : AppColors.borderLight,
                            ),
                          ),
                          child: TextField(
                            controller: _textController,
                            onSubmitted: (_) => _sendMessage(),
                            style: TextStyle(
                              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                              fontSize: 13,
                            ),
                            decoration: const InputDecoration(
                              hintText: 'Ketik pesan untuk montir...',
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton.filled(
                        style: IconButton.styleFrom(
                          backgroundColor: AppColors.primary,
                        ),
                        onPressed: _sendMessage,
                        icon: const Icon(Icons.send_rounded, color: Colors.white, size: 18),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
