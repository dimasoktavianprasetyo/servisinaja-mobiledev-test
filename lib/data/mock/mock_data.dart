import '../models/vehicle_model.dart';
import '../models/service_model.dart';
import '../models/booking_model.dart';
import '../models/chat_message_model.dart';
import '../models/promo_voucher_model.dart';

class MockData {
  static final List<VehicleModel> initialVehicles = [
    const VehicleModel(
      id: 'v1',
      name: 'Honda Vario 160',
      plateNumber: 'B 1234 XYZ',
      odometerKm: 12450,
      lastService: '15 Agu 2024',
      conditionStatus: 'Kondisi OK',
      isSelected: true,
    ),
    const VehicleModel(
      id: 'v2',
      name: 'Honda BeAT',
      plateNumber: 'B 5678 ABC',
      odometerKm: 8200,
      lastService: '02 Sep 2024',
      conditionStatus: 'Kondisi OK',
      isSelected: false,
    ),
    const VehicleModel(
      id: 'v3',
      name: 'Honda PCX 160',
      plateNumber: 'B 9988 DEF',
      odometerKm: 4100,
      lastService: '10 Jan 2025',
      conditionStatus: 'Perlu Servis',
      isSelected: false,
    ),
  ];

  static const List<ServiceModel> services = [
    ServiceModel(
      id: 's1',
      title: 'Servis Ringan / Berkala',
      description: 'Pengecekan 15 titik standar AHASS, setel rem & rantai, filter udara.',
      price: 95000,
      duration: '45 Menit',
      category: 'Servis Rutin',
      isPopular: true,
    ),
    ServiceModel(
      id: 's2',
      title: 'Paket Tune Up + Ganti Oli MPX',
      description: 'Tune up injeksi, pembersihan CVT, penggantian oli mesin MPX2 0.8L.',
      price: 165000,
      duration: '60 Menit',
      category: 'Oli & CVT',
      isPopular: true,
    ),
    ServiceModel(
      id: 's3',
      title: 'Servis Besar & Kompresi',
      description: 'Skir klep, bersihkan ruang bakar dari kerak karbon, ganti paking.',
      price: 280000,
      duration: '120 Menit',
      category: 'Mesin',
    ),
    ServiceModel(
      id: 's4',
      title: 'Bantuan Darurat (Emergency Call)',
      description: 'Montir meluncur ke lokasi mogok, tambal ban cepat atau jumper aki.',
      price: 75000,
      duration: '20-30 Menit tiba',
      category: 'Emergency',
    ),
  ];

  static final List<PromoVoucherModel> promos = [
    const PromoVoucherModel(
      id: 'p1',
      title: 'Diskon Booking Multi-Motor',
      description: 'Servis 2 motor sekaligus di AHASS resmi hemat sampai 30% jasa montir.',
      code: 'MULTIAHASS30',
      discountTag: 'Hemat 30%',
      validUntil: '31 Okt 2026',
      isMultiMotor: true,
    ),
    const PromoVoucherModel(
      id: 'p2',
      title: 'Cashback Servis Rutin QRIS',
      description: 'Pembayaran non-tunai via QRIS dapat cashback langsung Rp 20.000.',
      code: 'QRISSERVIS20',
      discountTag: 'Cashback 20RB',
      validUntil: '15 Nov 2026',
    ),
    const PromoVoucherModel(
      id: 'p3',
      title: 'Gratis Uji Emisi & Nitrogen',
      description: 'Khusus servis paket Tune Up lengkap bulan ini di seluruh bengkel mitra.',
      code: 'FREEECO26',
      discountTag: 'Gratis Emisi',
      validUntil: '20 Des 2026',
    ),
  ];

  static final List<ChatMessageModel> sampleMessages = [
    ChatMessageModel(
      id: 'm1',
      text: 'Halo kak Tania! Saya Budi dari AHASS Mitra Utama. Sedang meluncur ke lokasi ya.',
      isMe: false,
      timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
    ),
    ChatMessageModel(
      id: 'm2',
      text: 'Baik mas Budi, posisi saya persis di depan minimarket Jl. Sudirman ya.',
      isMe: true,
      timestamp: DateTime.now().subtract(const Duration(minutes: 8)),
    ),
    ChatMessageModel(
      id: 'm3',
      text: 'Siap kak, estimasi 5 menit lagi tiba dengan peralatan lengkap.',
      isMe: false,
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
  ];

  static final BookingModel activeBooking = BookingModel(
    bookingId: 'BK-2026-9021',
    bookingCode: 'AHASS-JKT-8821',
    vehicle: initialVehicles[0],
    service: services[1],
    scheduleDate: DateTime.now().add(const Duration(days: 1)),
    scheduleTime: '10:00 WIB',
    workshopName: 'AHASS Daya Motor Sudirman',
    workshopAddress: 'Jl. Jenderal Sudirman No. 45, Jakarta Pusat',
    status: BookingStatus.confirmed,
    totalAmount: 165000,
    mechanicName: 'Budi Santoso (Pit 3 Ready)',
  );
}
