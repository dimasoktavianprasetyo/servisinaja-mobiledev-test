import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/vehicle_model.dart';
import '../../../data/models/service_model.dart';
import '../../controllers/app_controller.dart';
import '../../widgets/servisin_app_bar.dart';
import '../../widgets/app_button.dart';
import 'booking_success_ticket_screen.dart';

class BookingConfirmScreen extends StatefulWidget {
  final AppController controller;
  final VehicleModel vehicle;
  final ServiceModel service;
  final DateTime scheduleDate;
  final String scheduleTime;
  final String workshopName;

  const BookingConfirmScreen({
    super.key,
    required this.controller,
    required this.vehicle,
    required this.service,
    required this.scheduleDate,
    required this.scheduleTime,
    required this.workshopName,
  });

  @override
  State<BookingConfirmScreen> createState() => _BookingConfirmScreenState();
}

class _BookingConfirmScreenState extends State<BookingConfirmScreen> {
  String _paymentMethod = 'QRIS Instan';
  bool _isProcessing = false;

  final List<Map<String, dynamic>> _paymentOptions = [
    {'title': 'QRIS Instan', 'icon': Icons.qr_code_scanner_rounded, 'desc': 'Bebas biaya admin'},
    {'title': 'GoPay / OVO / Dana', 'icon': Icons.account_balance_wallet_rounded, 'desc': 'Koneksi e-wallet'},
    {'title': 'Bayar Tunai di Bengkel', 'icon': Icons.payments_rounded, 'desc': 'Setelah servis selesai'},
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = widget.controller.isDarkMode;

    return Scaffold(
      appBar: const ServisinAppBar(title: 'Ringkasan Booking'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.cardDark : AppColors.cardLight,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark ? AppColors.borderDark : AppColors.borderLight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primaryContainerLight,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.two_wheeler_rounded, color: AppColors.primary),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.vehicle.name,
                              style: AppTypography.getHeading(isDark: isDark, fontSize: 15),
                            ),
                            Text(
                              widget.vehicle.plateNumber,
                              style: AppTypography.getBody(isDark: isDark, fontSize: 12, isSecondary: true),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Paket Servis', style: AppTypography.getBody(isDark: isDark, fontSize: 13, isSecondary: true)),
                      Text(widget.service.title, style: AppTypography.getLabel(isDark: isDark, fontSize: 13, fontWeight: FontWeight.w700)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Jadwal Kedatangan', style: AppTypography.getBody(isDark: isDark, fontSize: 13, isSecondary: true)),
                      Text('${Formatters.date(widget.scheduleDate)} • ${widget.scheduleTime}', style: AppTypography.getLabel(isDark: isDark, fontSize: 13, fontWeight: FontWeight.w700)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Bengkel Mitra', style: AppTypography.getBody(isDark: isDark, fontSize: 13, isSecondary: true)),
                      Text(widget.workshopName, style: AppTypography.getLabel(isDark: isDark, fontSize: 13, fontWeight: FontWeight.w700)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Metode Pembayaran',
              style: AppTypography.getHeading(isDark: isDark, fontSize: 16, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 12),
            ..._paymentOptions.map((opt) {
              final isSelected = opt['title'] == _paymentMethod;

              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: InkWell(
                  onTap: () => setState(() => _paymentMethod = opt['title'] as String),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.cardDark : AppColors.cardLight,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : (isDark ? AppColors.borderDark : AppColors.borderLight),
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(opt['icon'] as IconData, color: AppColors.primary),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(opt['title'] as String, style: AppTypography.getHeading(isDark: isDark, fontSize: 14)),
                              Text(opt['desc'] as String, style: AppTypography.getBody(isDark: isDark, fontSize: 11, isSecondary: true)),
                            ],
                          ),
                        ),
                        Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected ? AppColors.primary : (isDark ? AppColors.borderDark : const Color(0xFFCBD5E1)),
                              width: 2,
                            ),
                          ),
                          child: isSelected
                              ? Center(
                                  child: Container(
                                    width: 12,
                                    height: 12,
                                    decoration: const BoxDecoration(
                                      color: AppColors.primary,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                )
                              : null,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceDark : const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Biaya Jasa Servis', style: AppTypography.getBody(isDark: isDark, fontSize: 13, isSecondary: true)),
                      Text(Formatters.currency(widget.service.price), style: AppTypography.getLabel(isDark: isDark, fontSize: 13)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Biaya Pemesanan', style: AppTypography.getBody(isDark: isDark, fontSize: 13, isSecondary: true)),
                      const Text('Gratis', style: TextStyle(color: AppColors.success, fontWeight: FontWeight.w700, fontSize: 13)),
                    ],
                  ),
                  const Divider(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total Pembayaran', style: AppTypography.getHeading(isDark: isDark, fontSize: 15, fontWeight: FontWeight.w800)),
                      Text(
                        Formatters.currency(widget.service.price),
                        style: const TextStyle(color: AppColors.primary, fontSize: 18, fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : Colors.white,
          border: Border(top: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight)),
        ),
        child: SafeArea(
          child: AppButton(
            text: 'Konfirmasi & Dapatkan Tiket',
            icon: Icons.confirmation_number_rounded,
            isLoading: _isProcessing,
            onPressed: () {
              setState(() => _isProcessing = true);
              final navigator = Navigator.of(context);
              Future.delayed(const Duration(milliseconds: 1200), () {
                if (!mounted) return;
                widget.controller.createBooking(
                  vehicle: widget.vehicle,
                  service: widget.service,
                  date: widget.scheduleDate,
                  time: widget.scheduleTime,
                );
                navigator.pushReplacement(
                  MaterialPageRoute(
                    builder: (_) => BookingSuccessTicketScreen(controller: widget.controller),
                  ),
                );
              });
            },
          ),
        ),
      ),
    );
  }
}
