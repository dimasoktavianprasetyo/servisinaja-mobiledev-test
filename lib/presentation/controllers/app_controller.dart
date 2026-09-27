import 'dart:async';
import 'package:flutter/material.dart';
import '../../data/models/vehicle_model.dart';
import '../../data/models/service_model.dart';
import '../../data/models/booking_model.dart';
import '../../data/models/chat_message_model.dart';
import '../../data/models/promo_voucher_model.dart';
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

  bool get isCallActive => _isCallActive;
  bool get isCallMuted => _isCallMuted;
  bool get isSpeakerOn => _isSpeakerOn;
  int get callDurationSeconds => _callDurationSeconds;

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

  void addVehicle(String name, String plateNumber) {
    final newVehicle = VehicleModel(
      id: 'v_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      plateNumber: plateNumber,
      odometerKm: 0,
      lastService: 'Baru Didaftarkan',
      conditionStatus: 'Belum Servis',
      isSelected: false,
    );
    _vehicles.add(newVehicle);
    notifyListeners();
  }

  void createBooking({
    required VehicleModel vehicle,
    required ServiceModel service,
    required DateTime date,
    required String time,
  }) {
    _currentBooking = BookingModel(
      bookingId: 'BK-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      bookingCode: 'AHASS-JKT-${1000 + DateTime.now().second * 10}',
      vehicle: vehicle,
      service: service,
      scheduleDate: date,
      scheduleTime: time,
      workshopName: 'AHASS Daya Motor Sudirman',
      workshopAddress: 'Jl. Jenderal Sudirman No. 45, Jakarta Pusat',
      status: BookingStatus.confirmed,
      totalAmount: service.price,
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
