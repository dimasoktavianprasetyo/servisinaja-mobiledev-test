import 'dart:async';
import 'package:flutter/material.dart';
import '../../data/models/vehicle_model.dart';
import '../../data/models/service_model.dart';
import '../../data/models/booking_model.dart';
import '../../data/models/chat_message_model.dart';
import '../../data/models/promo_voucher_model.dart';
import '../../data/models/notification_model.dart';
import '../../data/mock/mock_data.dart';

class AppController extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  int _navIndex = 0;

  List<VehicleModel> _vehicles = List.from(MockData.initialVehicles);
  late VehicleModel _selectedVehicle;

  final List<ServiceModel> _services = List.from(MockData.services);
  final List<PromoVoucherModel> _promos = List.from(MockData.promos);
  final List<ChatMessageModel> _chatMessages = List.from(MockData.sampleMessages);
  BookingModel? _currentBooking = MockData.activeBooking;

  final List<NotificationItem> _notifications = [
    NotificationItem(
      id: 'n0',
      title: 'Servis Multi-Motor (2 Unit) Sedang Berlangsung',
      body:
          'Motor Vario 160 & BeAT sedang dikerjakan di Pit 01 & 02 AHASS Cihampelas. Ketuk untuk pantau status live armada.',
      time: 'Baru saja',
      icon: Icons.settings_outlined,
      category: 'status',
      section: 'HARI INI',
      highlightTag: 'Pit 01 & 02',
      badgeText: 'Sedang Berlangsung',
      badgeBg: const Color(0xFFFFF3ED),
      badgeTextColor: const Color(0xFFEA580C),
      isRead: false,
    ),
    NotificationItem(
      id: 'n1',
      title: 'Booking Multi-Motor Dikonfirmasi!',
      body:
          'Servis Vario 160 & BeAT di AHASS Cihampelas untuk Kam, 26 Sep (09:30 WIB).',
      time: '10 mnt lalu',
      icon: Icons.two_wheeler_rounded,
      category: 'status',
      section: 'HARI INI',
      highlightTag: '2 Motor • Pit 01 & 02',
      isRead: false,
    ),
    NotificationItem(
      id: 'n2',
      title: 'Pit 01 & 02 Siap Digunakan',
      body:
          'Teknisi telah menyiapkan dua pit servis paralel untuk motor Anda.',
      time: '1 jam yang lalu',
      icon: Icons.schedule_rounded,
      category: 'status',
      section: 'HARI INI',
      isRead: false,
    ),
    NotificationItem(
      id: 'n3',
      title: 'Diskon 30% Servis Diklaim',
      body: 'Voucher berhasil dipasang pada ringkasan booking.',
      time: 'Kemarin',
      icon: Icons.local_offer_outlined,
      category: 'promo',
      section: 'KEMARIN',
      isRead: true,
    ),
  ];

  bool _isCallActive = false;
  bool _isCallMuted = false;
  bool _isSpeakerOn = true;
  int _callDurationSeconds = 0;
  Timer? _callTimer;

  AppController() {
    _selectedVehicle = _vehicles.first;
  }

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;
  int get navIndex => _navIndex;
  List<VehicleModel> get vehicles => _vehicles;
  VehicleModel get selectedVehicle => _selectedVehicle;
  List<ServiceModel> get services => _services;
  List<PromoVoucherModel> get promos => _promos;
  List<ChatMessageModel> get chatMessages => _chatMessages;
  BookingModel? get currentBooking => _currentBooking;
  List<NotificationItem> get notifications => _notifications;
  int get unreadNotificationCount => _notifications.where((n) => !n.isRead).length;

  bool get isCallActive => _isCallActive;
  bool get isCallMuted => _isCallMuted;
  bool get isSpeakerOn => _isSpeakerOn;
  int get callDurationSeconds => _callDurationSeconds;

  void addNotification({
    required String title,
    required String body,
    String time = 'Baru saja',
    IconData icon = Icons.notifications_active_rounded,
    String category = 'status',
    String section = 'HARI INI',
    String? highlightTag,
    String? badgeText,
    Color? badgeBg,
    Color? badgeTextColor,
  }) {
    final item = NotificationItem(
      id: 'n_${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      body: body,
      time: time,
      icon: icon,
      category: category,
      section: section,
      highlightTag: highlightTag,
      badgeText: badgeText,
      badgeBg: badgeBg,
      badgeTextColor: badgeTextColor,
      isRead: false,
    );
    _notifications.insert(0, item);
    notifyListeners();
  }

  void markAllNotificationsRead() {
    for (var n in _notifications) {
      n.isRead = true;
    }
    notifyListeners();
  }

  void markNotificationRead(String id) {
    final idx = _notifications.indexWhere((n) => n.id == id);
    if (idx != -1) {
      _notifications[idx].isRead = true;
      notifyListeners();
    }
  }

  void toggleTheme() {
    _themeMode = isDarkMode ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }

  void setNavIndex(int index) {
    _navIndex = index;
    notifyListeners();
  }

  void selectVehicle(String vehicleId) {
    _vehicles = _vehicles.map((v) {
      return v.copyWith(isSelected: v.id == vehicleId);
    }).toList();
    _selectedVehicle = _vehicles.firstWhere((v) => v.id == vehicleId);
    notifyListeners();
  }

  VehicleModel addVehicle(
    String name,
    String plateNumber, {
    int odometerKm = 0,
    String transmission = 'Matic (AT)',
    String engineCc = '160cc',
    String year = '2024',
    String color = 'Hitam Doff',
    String chassisNumber = '',
    String engineNumber = '',
    String garageLabel = 'Garasi Tambahan',
  }) {
    final newVehicle = VehicleModel(
      id: 'v_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      plateNumber: plateNumber,
      odometerKm: odometerKm,
      lastService: 'Baru Didaftarkan',
      conditionStatus: 'Kondisi OK',
      isSelected: false,
      transmission: transmission,
      engineCc: engineCc,
      year: year,
      color: color,
      chassisNumber: chassisNumber.isNotEmpty
          ? chassisNumber
          : 'MH1KF1144GH${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      engineNumber: engineNumber.isNotEmpty
          ? engineNumber
          : 'KF11E-${DateTime.now().millisecond}',
      garageLabel: garageLabel,
    );
    _vehicles.add(newVehicle);
    notifyListeners();
    return newVehicle;
  }

  void createBooking({
    required VehicleModel vehicle,
    required ServiceModel service,
    required DateTime date,
    required String time,
  }) {
    final code = 'AHASS-JKT-${1000 + DateTime.now().second * 10}';
    _currentBooking = BookingModel(
      bookingId: 'BK-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      bookingCode: code,
      vehicle: vehicle,
      service: service,
      scheduleDate: date,
      scheduleTime: time,
      workshopName: 'AHASS Daya Motor Sudirman',
      workshopAddress: 'Jl. Jenderal Sudirman No. 45, Jakarta Pusat',
      status: BookingStatus.confirmed,
      totalAmount: service.price,
    );
    addNotification(
      title: 'Booking Servis Berhasil!',
      body: 'Tiket servis Anda #$code telah terbit untuk ${vehicle.name}. Ketuk untuk lihat rincian & QR code.',
      category: 'status',
      highlightTag: 'Dikonfirmasi',
      badgeText: 'Terkonfirmasi',
      badgeBg: const Color(0xFFDCFCE7),
      badgeTextColor: const Color(0xFF16A34A),
    );
    notifyListeners();
  }

  void sendChatMessage(String text) {
    if (text.trim().isEmpty) return;

    final newMsg = ChatMessageModel(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      text: text.trim(),
      isMe: true,
      timestamp: DateTime.now(),
    );
    _chatMessages.add(newMsg);
    notifyListeners();

    Timer(const Duration(seconds: 2), () {
      final replyMsg = ChatMessageModel(
        id: 'reply_${DateTime.now().millisecondsSinceEpoch}',
        text: 'Baik kak, pesan sudah saya terima. Saya langsung cek dan siapkan ya!',
        isMe: false,
        timestamp: DateTime.now(),
      );
      _chatMessages.add(replyMsg);
      notifyListeners();
    });
  }

  void startCall() {
    _isCallActive = true;
    _isCallMuted = false;
    _isSpeakerOn = true;
    _callDurationSeconds = 0;
    _callTimer?.cancel();
    _callTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _callDurationSeconds++;
      notifyListeners();
    });
    notifyListeners();
  }

  void toggleMute() {
    _isCallMuted = !_isCallMuted;
    notifyListeners();
  }

  void toggleSpeaker() {
    _isSpeakerOn = !_isSpeakerOn;
    notifyListeners();
  }

  void endCall() {
    _isCallActive = false;
    _callTimer?.cancel();
    _callTimer = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _callTimer?.cancel();
    super.dispose();
  }
}
