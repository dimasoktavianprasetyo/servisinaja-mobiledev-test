import 'vehicle_model.dart';
import 'service_model.dart';

enum BookingStatus {
  confirmed,
  inProgress,
  completed,
  cancelled,
}

class BookingModel {
  final String bookingId;
  final String bookingCode;
  final VehicleModel vehicle;
  final ServiceModel service;
  final DateTime scheduleDate;
  final String scheduleTime;
  final String workshopName;
  final String workshopAddress;
  final BookingStatus status;
  final int totalAmount;
  final String mechanicName;

  const BookingModel({
    required this.bookingId,
    required this.bookingCode,
    required this.vehicle,
    required this.service,
    required this.scheduleDate,
    required this.scheduleTime,
    required this.workshopName,
    required this.workshopAddress,
    required this.status,
    required this.totalAmount,
    this.mechanicName = 'Budi Santoso',
  });
}
