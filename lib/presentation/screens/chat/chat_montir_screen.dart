import 'dart:async';
import 'package:flutter/material.dart';

import '../../controllers/app_controller.dart';
import '../call/call_montir_screen.dart';

// ─── Data Models ─────────────────────────────────────────────────────────────

enum _MsgType { text, photo, location, document }

class _ChatMsg {
  final bool isMe;
  final String text;
  final String time;
  final String? status;
  final _MsgType type;
  final String? imagePath;
  final String? recTitle;
  final String? recPrice;
  final bool? recDecision;
  final String? attachmentName;

  const _ChatMsg({
    required this.isMe,
    required this.text,
    required this.time,
    this.status,
    this.type = _MsgType.text,
    this.imagePath,
    this.recTitle,
    this.recPrice,
    this.recDecision,
    this.attachmentName,
  });

  _ChatMsg copyWith({bool? recDecision, String? status}) => _ChatMsg(
        isMe: isMe,
        text: text,
        time: time,
        status: status ?? this.status,
        type: type,
        imagePath: imagePath,
        recTitle: recTitle,
        recPrice: recPrice,
        recDecision: recDecision ?? this.recDecision,
        attachmentName: attachmentName,
      );
}

// ─── Typing Dots Animation ──────────────────────────────────────────────────

class _TypingDots extends StatefulWidget {
  final Color dotColor;
  const _TypingDots({required this.dotColor});

  @override
  State<_TypingDots> createState() => _TypingDotsState();
}

class _TypingDotsState extends State<_TypingDots>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animCtrl;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..repeat();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animCtrl,
      builder: (context, _) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (index) {
            final start = index * 0.18;
            final end = start + 0.45;
            double progress = 0.0;
            if (_animCtrl.value >= start && _animCtrl.value <= end) {
              progress = (_animCtrl.value - start) / 0.45;
            } else if (end > 1.0 && _animCtrl.value <= (end - 1.0)) {
              progress = (_animCtrl.value + 1.0 - start) / 0.45;
            }

            final bounce = progress < 0.5
                ? Curves.easeOut.transform(progress / 0.5)
                : Curves.easeIn.transform((1.0 - progress) / 0.5);

            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 2.5),
              transform: Matrix4.translationValues(0, -bounce * 4.5, 0),
              width: 6.5,
              height: 6.5,
              decoration: BoxDecoration(
                color: widget.dotColor.withValues(alpha: 0.35 + (bounce * 0.65)),
                shape: BoxShape.circle,
              ),
            );
          }),
        );
      },
    );
  }
}

// ─── Screen ───────────────────────────────────────────────────────────────────

class ChatMontirScreen extends StatefulWidget {
  final AppController controller;
  final String mechanicName;
  final String mechanicRole;
  final String avatarPath;
  final String vehicleName;
  final String vehiclePlate;
  final String serviceType;
  final String pit;
  final String? findingTitle;
  final String? findingPrice;
  final String? findingPhoto;
  final String? findingDesc;

  const ChatMontirScreen({
    super.key,
    required this.controller,
    this.mechanicName = 'Kang Agus',
    this.mechanicRole = 'Teknisi AHASS Cihampelas • Pit 01',
    this.avatarPath = 'assets/images/kang_agus.png',
    this.vehicleName = 'Honda Vario 160',
    this.vehiclePlate = 'B 1234 XYZ',
    this.serviceType = 'Servis Berkala & CVT',
    this.pit = 'Pit 01',
    this.findingTitle = 'Ganti Roller CVT',
    this.findingPrice = '+Rp 45.000',
    this.findingPhoto = 'assets/images/cvt_roller_inspection.png',
    this.findingDesc =
        'Ini pak kondisi roller CVT-nya sudah mulai aus dan peyang, penyebab gredeknya di sini. Disarankan ganti baru biar tarikan enteng lagi pak.',
  });

  @override
  State<ChatMontirScreen> createState() => _ChatMontirScreenState();
}

class _ChatMontirScreenState extends State<ChatMontirScreen> {
  final TextEditingController _textCtrl = TextEditingController();
  final ScrollController _scrollCtrl = ScrollController();
  bool _hasText = false;
  bool _isMontirTyping = false;
  Timer? _readTimer;
  Timer? _typingTimer;
  Timer? _replyTimer;
  late final List<_ChatMsg> _messages;

  @override
  void initState() {
    super.initState();
    _messages = _initMessages();
    _textCtrl.addListener(() {
      final hasText = _textCtrl.text.trim().isNotEmpty;
      if (hasText != _hasText) setState(() => _hasText = hasText);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  List<_ChatMsg> _initMessages() {
    final isAsep = widget.mechanicName.toLowerCase().contains('asep');

    if (isAsep) {
      // Conversation with Kang Asep (Motor 2: BeAT / Pit 02)
      return [
        _ChatMsg(
          isMe: false,
          text:
              'Pagi Pak Dimas, saya Kang Asep di ${widget.pit}. Motor ${widget.vehicleName} bapak sudah mulai kami lakukan pengecekan servis berkala & pengereman ya pak.',
          time: '09:32',
        ),
        const _ChatMsg(
          isMe: true,
          text:
              'Pagi kang Asep, siap. Tolong sekalian cek rem belakangnya ya kang, kemarin sempat agak dalam pas ditekan.',
          time: '09:34',
          status: 'read',
        ),
        _ChatMsg(
          isMe: false,
          text: widget.findingDesc ??
              'Ini pak kondisi kampas rem belakangnya sudah mulai tipis dan aus. Sangat disarankan ganti baru biar pengereman kembali pakem dan aman di jalan ya pak.',
          time: '09:38',
          type: _MsgType.photo,
          imagePath: widget.findingPhoto ?? 'assets/images/kampas_rem_inspection.jpg',
          recTitle: widget.findingTitle ?? 'Ganti Kampas Rem Belakang',
          recPrice: widget.findingPrice ?? '+Rp 40.000',
        ),
        const _ChatMsg(
          isMe: true,
          text: 'Baik kang Asep, langsung pasang kampas rem original AHM ya 👍',
          time: '09:41',
          status: 'sent',
        ),
      ];
    }

    // Default: Conversation with Kang Agus (Motor 1: Vario 160 / Pit 01)
    return [
      _ChatMsg(
        isMe: false,
        text:
            'Pagi Pak Dimas, saya Kang Agus di ${widget.pit}. ${widget.vehicleName} bapak sudah mulai kami bongkar untuk servis berkala ya pak.',
        time: '09:32',
      ),
      const _ChatMsg(
        isMe: true,
        text:
            'Pagi kang, siap. Tolong cek tarikan awalnya ya kang, kemarin sempat agak gredek pas nanjak.',
        time: '09:35',
        status: 'read',
      ),
      _ChatMsg(
        isMe: false,
        text: widget.findingDesc ??
            'Ini pak kondisi roller CVT-nya sudah mulai aus dan peyang, penyebab gredeknya di sini. Disarankan ganti baru biar tarikan enteng lagi pak.',
        time: '09:40',
        type: _MsgType.photo,
        imagePath: widget.findingPhoto ?? 'assets/images/cvt_roller_inspection.png',
        recTitle: widget.findingTitle ?? 'Ganti Roller CVT',
        recPrice: widget.findingPrice ?? '+Rp 45.000',
      ),
      const _ChatMsg(
        isMe: true,
        text: 'Boleh kang, langsung ganti yang original AHM ya 👍',
        time: '09:42',
        status: 'sent',
      ),
    ];
  }

  @override
  void dispose() {
    _readTimer?.cancel();
    _typingTimer?.cancel();
    _replyTimer?.cancel();
    _textCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollCtrl.hasClients) {
      _scrollCtrl.animateTo(
        _scrollCtrl.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _send() {
    final text = _textCtrl.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(_ChatMsg(
        isMe: true,
        text: text,
        time: _nowTime(),
        status: 'sent',
      ));
      _textCtrl.clear();
    });
    Future.delayed(const Duration(milliseconds: 80), _scrollToBottom);
    _triggerMontirReply(type: 'text', userQuery: text);
  }

  String _nowTime() {
    final now = DateTime.now();
    return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
  }

  void _handleRecommendation(int index, bool agreed) {
    setState(() {
      _messages[index] = _messages[index].copyWith(recDecision: agreed);
      _messages.add(_ChatMsg(
        isMe: true,
        text: agreed
            ? 'Oke kang, setuju. Ganti yang original ya 👍'
            : 'Ditolak dulu ya kang, gak usah ganti dulu',
        time: _nowTime(),
        status: 'sent',
      ));
    });
    Future.delayed(const Duration(milliseconds: 80), _scrollToBottom);
    _triggerMontirReply(type: agreed ? 'agreement' : 'rejection');
  }

  void _triggerMontirReply({
    required String type,
    String? userQuery,
  }) {
    _readTimer?.cancel();
    _typingTimer?.cancel();
    _replyTimer?.cancel();

    // 1. Mark user message as read after 700ms
    _readTimer = Timer(const Duration(milliseconds: 700), () {
      if (!mounted) return;
      setState(() {
        for (int i = _messages.length - 1; i >= 0; i--) {
          if (_messages[i].isMe && _messages[i].status == 'sent') {
            _messages[i] = _messages[i].copyWith(status: 'read');
            break;
          }
        }
      });

      // 2. Montir starts typing after 500ms
      _typingTimer = Timer(const Duration(milliseconds: 500), () {
        if (!mounted) return;
        setState(() {
          _isMontirTyping = true;
        });
        Future.delayed(const Duration(milliseconds: 60), _scrollToBottom);

        // 3. Montir delivers contextual response after 2000ms
        _replyTimer = Timer(const Duration(milliseconds: 2000), () {
          if (!mounted) return;
          final reply = _generateMontirReply(type, userQuery: userQuery);
          setState(() {
            _isMontirTyping = false;
            _messages.add(_ChatMsg(
              isMe: false,
              text: reply,
              time: _nowTime(),
            ));
          });
          Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
        });
      });
    });
  }

  String _generateMontirReply(String type, {String? userQuery}) {
    final isAsep = widget.mechanicName.toLowerCase().contains('asep');
    final pit = widget.pit;

    if (type == 'agreement') {
      if (isAsep) {
        return 'Siap Pak Dimas! Kampas rem belakang langsung kita pasang sparepart original AHM ya. Setelah dipasang akan langsung kami stel dan uji putaran roda biar pengereman pakem maksimal 👍';
      } else {
        return 'Siap Pak Dimas! Roller CVT original Honda langsung saya pasang ya. Nanti sekalian kami bersihkan mangkok pulley-nya biar tarikan makin enteng dan gredek hilang total 👍';
      }
    }

    if (type == 'rejection') {
      if (isAsep) {
        return 'Baik Pak Dimas, kampas rem belakang tidak diganti dulu. Tromol dan kampas lamanya tetap kami bersihkan dari debu serta kami stel kerapatannya ya pak. Tetap hati-hati saat berkendara ya pak!';
      } else {
        return 'Baik pak tidak apa-apa, untuk roller CVT-nya sementara kami bersihkan dan beri pelumas khusus dulu ya pak. Tapi kalau tarikan mulai makin gredek disarankan segera mampir servis lagi ya pak.';
      }
    }

    if (type == 'camera') {
      return 'Foto kamera sudah saya terima ya Pak Dimas. Langsung kami teliti dan periksa bagian tersebut di $pit.';
    }

    if (type == 'gallery') {
      return 'Foto kondisi motor dari galeri sudah masuk pak. Sangat membantu kami untuk analisa fisik kendaraannya di $pit.';
    }

    if (type == 'location') {
      return 'Sip Pak Dimas, lokasi bapak sudah terdeteksi di bengkel. Silakan santai di ruang tunggu ber-AC ya pak, pengerjaan sedang kami proses.';
    }

    if (type == 'document') {
      return 'Terima kasih pak, dokumen buku servis sudah kami terima dan verifikasi. Riwayat servis bapak sudah tercatat di sistem database AHASS.';
    }

    // Contextual Text Matching
    final q = (userQuery ?? '').toLowerCase();
    if (q.contains('oli') || q.contains('oil')) {
      return 'Untuk oli mesin & gardan sudah kami siapkan pelumas standar Honda (MPX2/SPX2) ya pak, dijamin original dan tarikan mesin jadi adem.';
    }
    if (q.contains('lama') ||
        q.contains('selesai') ||
        q.contains('kapan') ||
        q.contains('jam') ||
        q.contains('menit') ||
        q.contains('berapa')) {
      return 'Estimasi pengerjaan di $pit sekitar 20-25 menit lagi ya pak. Begitu servis & final check selesai, langsung kami kabari di sini!';
    }
    if (q.contains('biaya') ||
        q.contains('harga') ||
        q.contains('ongkos') ||
        q.contains('bayar') ||
        q.contains('rp') ||
        q.contains('total')) {
      return 'Untuk estimasi rincian biaya bisa dicek di tiket aplikasi ya pak. Nanti pembayaran di kasir bisa tunai, QRIS, atau kartu debit.';
    }
    if (q.contains('terima kasih') ||
        q.contains('makasih') ||
        q.contains('nuhun') ||
        q.contains('thanks') ||
        q.contains('thx')) {
      return 'Sama-sama Pak Dimas! Senang bisa melayani servis motor bapak hari ini. Jangan ragu tanyakan kalau ada hal lain ya pak 🙏';
    }
    if (q.contains('rem') || q.contains('kampas') || q.contains('tromol')) {
      return 'Pengereman sedang kami cek ketebalan dan kepakemannya ya pak, keselamatan bapak nomor satu.';
    }
    if (q.contains('cvt') ||
        q.contains('roller') ||
        q.contains('gredek') ||
        q.contains('vbelt') ||
        q.contains('vanbelt')) {
      return 'Area CVT sedang kami bersihkan tuntas dari kotoran dan serbuk kampas ganda ya pak.';
    }
    if (q.contains('aki') || q.contains('baterai') || q.contains('kelistrikan')) {
      return 'Tegangan aki & sistem pengisian sudah kami ukur juga pak, kondisinya masih sangat sehat dan stabil.';
    }
    if (q.contains('halo') ||
        q.contains('pagi') ||
        q.contains('siang') ||
        q.contains('sore') ||
        q.contains('hai')) {
      return 'Halo Pak Dimas! Ada yang perlu dicek atau ditambahkan untuk servis motor bapak di $pit?';
    }

    return 'Siap Pak Dimas, pesan bapak sudah saya catat. Sedang kami tangani dengan teliti di $pit ya pak 👍';
  }

  // ─── Attachment Actions ───────────────────────────────────────────────────

  void _showAttachmentOptions(bool isDark) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        return Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.1),
                blurRadius: 20,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 38,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white24 : const Color(0xFFCBD5E1),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'Lampirkan Dokumen & Media',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Kirim foto kendala atau dokumen ke ${widget.mechanicName}',
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? Colors.white60 : const Color(0xFF64748B),
                ),
              ),
              const SizedBox(height: 22),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildAttachOptionItem(
                    icon: Icons.camera_alt_rounded,
                    label: 'Kamera',
                    bgColor: const Color(0xFFFF8C00),
                    isDark: isDark,
                    onTap: () {
                      Navigator.pop(ctx);
                      _onAttachCamera();
                    },
                  ),
                  _buildAttachOptionItem(
                    icon: Icons.photo_library_rounded,
                    label: 'Galeri',
                    bgColor: const Color(0xFF2563EB),
                    isDark: isDark,
                    onTap: () {
                      Navigator.pop(ctx);
                      _onAttachGallery();
                    },
                  ),
                  _buildAttachOptionItem(
                    icon: Icons.location_on_rounded,
                    label: 'Lokasi',
                    bgColor: const Color(0xFF16A34A),
                    isDark: isDark,
                    onTap: () {
                      Navigator.pop(ctx);
                      _onAttachLocation();
                    },
                  ),
                  _buildAttachOptionItem(
                    icon: Icons.description_rounded,
                    label: 'Dokumen',
                    bgColor: const Color(0xFF9333EA),
                    isDark: isDark,
                    onTap: () {
                      Navigator.pop(ctx);
                      _onAttachDocument();
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAttachOptionItem({
    required IconData icon,
    required String label,
    required Color bgColor,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: bgColor.withValues(alpha: 0.12),
              shape: BoxShape.circle,
              border: Border.all(
                color: bgColor.withValues(alpha: 0.25),
                width: 1.5,
              ),
            ),
            child: Icon(icon, color: bgColor, size: 26),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white70 : const Color(0xFF334155),
            ),
          ),
        ],
      ),
    );
  }

  void _onAttachCamera() {
    setState(() {
      _messages.add(_ChatMsg(
        isMe: true,
        text: 'Foto kendala saat motor dijalankan (Kamera)',
        time: _nowTime(),
        type: _MsgType.photo,
        imagePath: widget.mechanicName.toLowerCase().contains('asep')
            ? 'assets/images/motor_beat.png'
            : 'assets/images/motor_vario.png',
        status: 'sent',
      ));
    });
    Future.delayed(const Duration(milliseconds: 80), _scrollToBottom);
    _triggerMontirReply(type: 'camera');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Foto kamera berhasil dilampirkan'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _onAttachGallery() {
    setState(() {
      _messages.add(_ChatMsg(
        isMe: true,
        text: 'Ini foto kondisi fisik motor kemarin ya kang (Galeri)',
        time: _nowTime(),
        type: _MsgType.photo,
        imagePath: widget.mechanicName.toLowerCase().contains('asep')
            ? 'assets/images/motor_beat.png'
            : 'assets/images/motor_vario.png',
        status: 'sent',
      ));
    });
    Future.delayed(const Duration(milliseconds: 80), _scrollToBottom);
    _triggerMontirReply(type: 'gallery');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Foto galeri berhasil dilampirkan'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _onAttachLocation() {
    setState(() {
      _messages.add(_ChatMsg(
        isMe: true,
        text: '📍 Lokasi Terkini: AHASS Cihampelas, Jl. Cihampelas No. 42, Bandung',
        time: _nowTime(),
        type: _MsgType.location,
        status: 'sent',
      ));
    });
    Future.delayed(const Duration(milliseconds: 80), _scrollToBottom);
    _triggerMontirReply(type: 'location');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Lokasi terkini berhasil dikirim'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _onAttachDocument() {
    final docName = 'Buku_Servis_Garansi_${widget.vehicleName.replaceAll(' ', '_')}.pdf';
    setState(() {
      _messages.add(_ChatMsg(
        isMe: true,
        text: '$docName (1.4 MB)',
        time: _nowTime(),
        type: _MsgType.document,
        attachmentName: docName,
        status: 'sent',
      ));
    });
    Future.delayed(const Duration(milliseconds: 80), _scrollToBottom);
    _triggerMontirReply(type: 'document');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Dokumen berhasil dikirim'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  // ─── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final isDark = widget.controller.isDarkMode;
    final bg = isDark ? const Color(0xFF111827) : const Color(0xFFF0F2F5);
    final appBarBg = isDark ? const Color(0xFF1E1B2E) : Colors.white;
    final appBarFg = isDark ? Colors.white : const Color(0xFF0F172A);

    return Scaffold(
      backgroundColor: bg,
      appBar: _buildAppBar(isDark, appBarBg, appBarFg),
      body: Column(
        children: [
          _buildVehicleBanner(isDark),
          Expanded(child: _buildMessages(isDark)),
          _buildInputBar(isDark),
        ],
      ),
    );
  }

  // ─── AppBar ────────────────────────────────────────────────────────────────
  PreferredSizeWidget _buildAppBar(bool isDark, Color bg, Color fg) {
    final roleSub = widget.mechanicRole.split('•').first.trim();

    return AppBar(
      backgroundColor: bg,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_new_rounded, color: fg, size: 20),
        onPressed: () => Navigator.pop(context),
      ),
      titleSpacing: 0,
      title: Row(
        children: [
          // Avatar Montir
          Stack(
            children: [
              ClipOval(
                child: Image.asset(
                  widget.avatarPath,
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 40,
                    height: 40,
                    color: const Color(0xFFFF8C00),
                    child: Center(
                      child: Text(
                        widget.mechanicName.length >= 2
                            ? widget.mechanicName.substring(0, 2).toUpperCase()
                            : 'M',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 11,
                  height: 11,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _isMontirTyping
                        ? const Color(0xFFFF8C00)
                        : const Color(0xFF22C55E),
                    border: Border.all(color: bg, width: 2),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${widget.mechanicName} (${widget.pit})',
                style: TextStyle(
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.2,
                ),
              ),
              Row(
                children: [
                  Text(
                    roleSub.isNotEmpty ? roleSub : 'Teknisi AHASS Cihampelas',
                    style: TextStyle(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.50)
                          : const Color(0xFF64748B),
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '  •  ',
                    style: TextStyle(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.30)
                          : const Color(0xFF94A3B8),
                      fontSize: 11,
                    ),
                  ),
                  Text(
                    _isMontirTyping ? 'Sedang mengetik...' : 'Online',
                    style: TextStyle(
                      color: _isMontirTyping
                          ? (isDark ? const Color(0xFFFFB347) : const Color(0xFFEA6C00))
                          : const Color(0xFF22C55E),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      actions: [
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CallMontirScreen(
                controller: widget.controller,
                mechanicName: widget.mechanicName,
                avatarPath: widget.avatarPath,
                pit: widget.pit,
              ),
            ),
          ),
          child: Container(
            width: 38,
            height: 38,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF22C55E),
            ),
            child: const Icon(Icons.phone_rounded, color: Colors.white, size: 18),
          ),
        ),
        const SizedBox(width: 14),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          height: 1,
          color: isDark
              ? Colors.white.withValues(alpha: 0.07)
              : const Color(0xFFE2E8F0),
        ),
      ),
    );
  }

  // ─── Vehicle banner ────────────────────────────────────────────────────────
  Widget _buildVehicleBanner(bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
      color: isDark
          ? const Color(0xFF2A1400).withValues(alpha: 0.9)
          : const Color(0xFFFFF3E0),
      child: Row(
        children: [
          Icon(
            Icons.motorcycle_rounded,
            size: 15,
            color: isDark ? const Color(0xFFFFB347) : const Color(0xFFEA6C00),
          ),
          const SizedBox(width: 7),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: isDark ? const Color(0xFFFFB347) : const Color(0xFFEA6C00),
                ),
                children: [
                  TextSpan(text: 'Unit: ${widget.vehicleName} (${widget.vehiclePlate})'),
                  TextSpan(
                    text: '  •  ${widget.serviceType}',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Messages ──────────────────────────────────────────────────────────────
  Widget _buildMessages(bool isDark) {
    final showTyping = _isMontirTyping;
    final totalItems = _messages.length + 1 + (showTyping ? 1 : 0);

    return ListView.builder(
      controller: _scrollCtrl,
      padding: const EdgeInsets.fromLTRB(14, 16, 14, 12),
      itemCount: totalItems,
      itemBuilder: (context, index) {
        if (index == 0) return _buildDateSeparator('Hari Ini, 09:30 WIB', isDark);
        if (showTyping && index == totalItems - 1) {
          return _buildTypingBubble(isDark);
        }
        final msgIndex = index - 1;
        final msg = _messages[msgIndex];
        return _buildBubble(msg, msgIndex, isDark);
      },
    );
  }

  Widget _buildTypingBubble(bool isDark) {
    final bubbleBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final dotColor = isDark ? const Color(0xFFFFB347) : const Color(0xFFFF8C00);

    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipOval(
              child: Image.asset(
                widget.avatarPath,
                width: 28,
                height: 28,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 28,
                  height: 28,
                  color: const Color(0xFFFF8C00),
                  child: Center(
                    child: Text(
                      widget.mechanicName.isNotEmpty ? widget.mechanicName[0] : 'M',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: bubbleBg,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                  bottomLeft: Radius.circular(4),
                  bottomRight: Radius.circular(16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.20 : 0.06),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _TypingDots(dotColor: dotColor),
                  const SizedBox(width: 8),
                  Text(
                    '${widget.mechanicName} sedang mengetik...',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontStyle: FontStyle.italic,
                      color: isDark ? Colors.white60 : const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSeparator(String label, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 0.5,
              color: isDark ? Colors.white12 : const Color(0xFFDDE1E7),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 12),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isDark ? Colors.white12 : const Color(0xFFE2E8F0),
              ),
            ),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white38 : const Color(0xFF94A3B8),
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: 0.5,
              color: isDark ? Colors.white12 : const Color(0xFFDDE1E7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBubble(_ChatMsg msg, int index, bool isDark) {
    if (msg.type == _MsgType.photo) {
      return _buildPhotoBubble(msg, index, isDark);
    } else if (msg.type == _MsgType.location) {
      return _buildLocationBubble(msg, isDark);
    } else if (msg.type == _MsgType.document) {
      return _buildDocumentBubble(msg, isDark);
    }
    return _buildTextBubble(msg, isDark);
  }

  Widget _buildTextBubble(_ChatMsg msg, bool isDark) {
    final isMe = msg.isMe;
    final bubbleBg = isMe
        ? const Color(0xFFFF8C00)
        : (isDark ? const Color(0xFF1E293B) : Colors.white);

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.74),
        decoration: BoxDecoration(
          color: bubbleBg,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: Radius.circular(isMe ? 18 : 4),
            bottomRight: Radius.circular(isMe ? 4 : 18),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.18 : 0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.fromLTRB(14, 10, 14, 8),
        child: Column(
          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              msg.text,
              style: TextStyle(
                color: isMe
                    ? Colors.white
                    : (isDark ? Colors.white.withValues(alpha: 0.90) : const Color(0xFF1E293B)),
                fontSize: 13,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  msg.time,
                  style: TextStyle(
                    fontSize: 10,
                    color: isMe
                        ? Colors.white.withValues(alpha: 0.70)
                        : (isDark ? Colors.white30 : const Color(0xFF94A3B8)),
                  ),
                ),
                if (isMe && msg.status != null) ...[
                  const SizedBox(width: 4),
                  _buildStatusIcon(msg.status!),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoBubble(_ChatMsg msg, int index, bool isDark) {
    final isMe = msg.isMe;

    if (isMe) {
      // User sent photo
      return Align(
        alignment: Alignment.centerRight,
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.74),
          decoration: BoxDecoration(
            color: const Color(0xFFFF8C00),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(18),
              topRight: Radius.circular(18),
              bottomLeft: Radius.circular(18),
              bottomRight: Radius.circular(4),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.20 : 0.07),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                child: Image.asset(
                  msg.imagePath ?? 'assets/images/motor_vario.png',
                  height: 140,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      msg.text,
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: Colors.white,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          msg.time,
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.white.withValues(alpha: 0.70),
                          ),
                        ),
                        if (msg.status != null) ...[
                          const SizedBox(width: 4),
                          _buildStatusIcon(msg.status!),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Montir inspection card with real photo
    final decided = msg.recDecision;
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final photo = msg.imagePath ?? widget.findingPhoto ?? 'assets/images/cvt_roller_inspection.png';

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.82),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(18),
            topRight: Radius.circular(18),
            bottomLeft: Radius.circular(4),
            bottomRight: Radius.circular(18),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.20 : 0.07),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Real inspection photo
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
              ),
              child: Stack(
                children: [
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Image.asset(
                      photo,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      alignment: Alignment.center,
                      errorBuilder: (_, __, ___) => Container(
                        height: 150,
                        color: Colors.black87,
                        child: const Center(
                          child: Icon(Icons.broken_image_rounded, color: Colors.white54, size: 36),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 10,
                    bottom: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.78),
                        borderRadius: BorderRadius.circular(7),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black45,
                            blurRadius: 4,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: Color(0xFFFF8C00),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Temuan ${widget.pit}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Message text
                  Text(
                    msg.text,
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.45,
                      color: isDark ? Colors.white.withValues(alpha: 0.90) : const Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Recommendation card
                  if (msg.recTitle != null)
                    Container(
                      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.05)
                            : const Color(0xFFFFFBEB),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isDark
                              ? const Color(0xFFFDE68A).withValues(alpha: 0.25)
                              : const Color(0xFFFDE68A),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  msg.recTitle!,
                                  style: TextStyle(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w700,
                                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  msg.recPrice!,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFFEA580C),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (decided == null) ...[
                            _recButton(
                              label: 'Setuju',
                              color: const Color(0xFF008955),
                              textColor: Colors.white,
                              onTap: () => _handleRecommendation(index, true),
                            ),
                            const SizedBox(width: 8),
                            _recButton(
                              label: 'Tolak',
                              color: Colors.transparent,
                              textColor: isDark ? Colors.white54 : const Color(0xFF64748B),
                              border: true,
                              isDark: isDark,
                              onTap: () => _handleRecommendation(index, false),
                            ),
                          ] else
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: decided
                                    ? const Color(0xFF008955).withValues(alpha: 0.12)
                                    : Colors.red.withValues(alpha: 0.10),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                decided ? '✓ Disetujui' : '✗ Ditolak',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: decided ? const Color(0xFF008955) : Colors.red,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      msg.time,
                      style: TextStyle(
                        fontSize: 10,
                        color: isDark ? Colors.white30 : const Color(0xFF94A3B8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationBubble(_ChatMsg msg, bool isDark) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.74),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFFF8C00),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(18),
            topRight: Radius.circular(18),
            bottomLeft: Radius.circular(18),
            bottomRight: Radius.circular(4),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.20 : 0.07),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: Colors.white24,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.location_on_rounded, color: Colors.white, size: 18),
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Lokasi Terkini',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              msg.text,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.92),
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  msg.time,
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.white.withValues(alpha: 0.70),
                  ),
                ),
                if (msg.status != null) ...[
                  const SizedBox(width: 4),
                  _buildStatusIcon(msg.status!),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentBubble(_ChatMsg msg, bool isDark) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.74),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFFF8C00),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(18),
            topRight: Radius.circular(18),
            bottomLeft: Radius.circular(18),
            bottomRight: Radius.circular(4),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.20 : 0.07),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: Colors.white24,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.picture_as_pdf_rounded, color: Colors.white, size: 18),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    msg.attachmentName ?? 'Dokumen',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              msg.text,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.90),
                fontSize: 11.5,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  msg.time,
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.white.withValues(alpha: 0.70),
                  ),
                ),
                if (msg.status != null) ...[
                  const SizedBox(width: 4),
                  _buildStatusIcon(msg.status!),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _recButton({
    required String label,
    required Color color,
    required Color textColor,
    required VoidCallback onTap,
    bool border = false,
    bool isDark = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
          border: border
              ? Border.all(
                  color: isDark ? Colors.white24 : const Color(0xFFCBD5E1),
                )
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: textColor,
          ),
        ),
      ),
    );
  }

  Widget _buildStatusIcon(String status) {
    if (status == 'read') {
      return const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Dibaca ',
            style: TextStyle(fontSize: 10, color: Colors.white70),
          ),
          Icon(Icons.done_all_rounded, size: 14, color: Colors.white70),
        ],
      );
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Terkirim ',
          style: TextStyle(
            fontSize: 10,
            color: Colors.white.withValues(alpha: 0.65),
          ),
        ),
        Icon(Icons.done_all_rounded, size: 14, color: Colors.white.withValues(alpha: 0.65)),
      ],
    );
  }

  // ─── Input bar ─────────────────────────────────────────────────────────────
  Widget _buildInputBar(bool isDark) {
    final barBg = isDark ? const Color(0xFF1E1B2E) : Colors.white;

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 24),
      decoration: BoxDecoration(
        color: barBg,
        border: Border(
          top: BorderSide(
            color: isDark ? Colors.white.withValues(alpha: 0.08) : const Color(0xFFE2E8F0),
            width: 1,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Attach button (+)
          GestureDetector(
            onTap: () => _showAttachmentOptions(isDark),
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDark
                    ? Colors.white.withValues(alpha: 0.08)
                    : const Color(0xFFF1F5F9),
              ),
              child: Icon(
                Icons.add_rounded,
                size: 24,
                color: isDark ? Colors.white70 : const Color(0xFF64748B),
              ),
            ),
          ),
          const SizedBox(width: 10),

          // Text field
          Expanded(
            child: Container(
              constraints: const BoxConstraints(minHeight: 42, maxHeight: 120),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF111827) : const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.10)
                      : const Color(0xFFE2E8F0),
                ),
              ),
              child: TextField(
                controller: _textCtrl,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                style: TextStyle(
                  fontSize: 13.5,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
                decoration: InputDecoration(
                  hintText: 'Ketik pesan ke ${widget.mechanicName}...',
                  hintStyle: TextStyle(
                    fontSize: 13,
                    color: isDark ? Colors.white30 : const Color(0xFF94A3B8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 11,
                  ),
                  border: InputBorder.none,
                  isDense: true,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),

          // Send button
          GestureDetector(
            onTap: _hasText ? _send : null,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _hasText
                    ? const Color(0xFFFF8C00)
                    : (isDark ? Colors.white12 : const Color(0xFFE2E8F0)),
              ),
              child: Icon(
                Icons.send_rounded,
                color: _hasText
                    ? Colors.white
                    : (isDark ? Colors.white24 : const Color(0xFF94A3B8)),
                size: 19,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
