import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../controllers/app_controller.dart';
import '../chat/chat_montir_screen.dart';
import '../booking/booking_success_ticket_screen.dart';
import '../aktivitas/aktivitas_servis_screen.dart';
import 'widgets/animated_refresh_button.dart';
import 'widgets/status_mechanic_card.dart';
import 'widgets/mechanic_finding_card.dart';
import 'widgets/service_stepper_timeline.dart';

class StatusServisScreen extends StatefulWidget {
  final AppController controller;
  final String? bookingCode;
  final String? workshopName;
  final List<Map<String, dynamic>>? vehicles;
  final bool fromTicketScreen;
  final bool fromAktivitasScreen;

  const StatusServisScreen({
    super.key,
    required this.controller,
    this.bookingCode,
    this.workshopName,
    this.vehicles,
    this.fromTicketScreen = false,
    this.fromAktivitasScreen = false,
  });

  @override
  State<StatusServisScreen> createState() => _StatusServisScreenState();
}

class _StatusServisScreenState extends State<StatusServisScreen> {
  int _selectedVehicleIndex = 0;

  // State for mechanic findings approval per vehicle
  FindingDecisionState _motor1Decision = FindingDecisionState.pending;
  FindingDecisionState _motor2Decision = FindingDecisionState.pending;

  // Dynamic progress state for simulated live sync
  int _motor1Progress = 60;
  int _motor2Progress = 35;
  final String _motor1EstTime = '10:45 WIB';
  final String _motor2EstTime = '11:15 WIB';

  Future<void> _handleRefresh() async {
    // Simulated live telemetry sync from AHASS Pit workstation
    await Future.delayed(const Duration(milliseconds: 1400));

    if (!mounted) return;

    setState(() {
      if (_motor1Progress < 85) _motor1Progress += 5;
      if (_motor2Progress < 60) _motor2Progress += 5;
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Color(0xFF16A34A),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, color: Colors.white, size: 14),
            ),
            const SizedBox(width: 10),
            const Expanded(
              child: Text(
                'Status armada berhasil disinkronkan secara live!',
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF0F172A),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _navigateToInvoice() {
    if (widget.fromTicketScreen && Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BookingSuccessTicketScreen(
            controller: widget.controller,
            bookingCode: widget.bookingCode ?? 'SRV-20261001-8842',
            workshopName: widget.workshopName ?? 'AHASS Servisin Mitra Cihampelas',
            vehicles: widget.vehicles,
          ),
        ),
      );
    }
  }

  void _navigateToChatMontir(Map<String, dynamic> vehicle) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChatMontirScreen(
          controller: widget.controller,
          mechanicName: vehicle['mechanicName'] as String,
          mechanicRole: vehicle['mechanicRole'] as String,
          avatarPath: vehicle['avatarPath'] as String,
          vehicleName: vehicle['vehicleName'] as String,
          vehiclePlate: vehicle['plate'] as String,
          serviceType: vehicle['serviceType'] as String,
          pit: vehicle['pit'] as String,
          findingTitle: vehicle['findingItem'] as String,
          findingPrice: vehicle['findingPrice'] as String,
          findingPhoto: vehicle['findingPhoto'] as String,
          findingDesc: vehicle['findingDesc'] as String,
        ),
      ),
    );
  }

  void _handleBack() {
    if (widget.fromAktivitasScreen && Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => AktivitasServisScreen(controller: widget.controller),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.controller.isDarkMode;
    final workshop = widget.workshopName ?? 'AHASS Servisin Mitra Cihampelas';

    // Vehicles definition
    final vehiclesData = [
      {
        'tabTitle': 'Motor 1: Vario 160 (Pit 01)',
        'vehicleName': 'Honda Vario 160',
        'plate': 'B 1234 XYZ',
        'pit': 'Pit 01',
        'pitHeader': 'Tahapan Pengerjaan Pit 01',
        'serviceType': 'Servis Berkala & CVT',
        'mechanicName': 'Kang Agus',
        'mechanicRole': 'Teknisi Utama Pit 01 • Ahli CVT',
        'avatarPath': 'assets/images/kang_agus.png',
        'findingTitle': 'Temuan Montir Pit 01:',
        'findingDesc': 'Roller CVT mulai aus, disarankan ganti (+Rp 45.000).',
        'findingItem': 'Ganti Roller CVT',
        'findingPrice': '+Rp 45.000',
        'findingPhoto': 'assets/images/cvt_roller_inspection.png',
        'progress': _motor1Progress,
        'estTime': _motor1EstTime,
        'decision': _motor1Decision,
        'steps': [
          const TimelineStepData(
            title: '09:15 WIB – Check-in & Serah Terima',
            subtitle: 'Motor diterima SA & verifikasi keluhan awal.',
            status: StepStatus.completed,
          ),
          const TimelineStepData(
            title: '09:25 WIB – Diagnosa Awal Motor',
            subtitle: 'Scan ECU, cek tegangan aki, dan rem tromol.',
            status: StepStatus.completed,
          ),
          const TimelineStepData(
            title: '09:35 WIB – Pengerjaan Servis & Oli SPX2',
            subtitle: 'Pengecekan klep dan pembersihan filter udara sedang berjalan.',
            status: StepStatus.inProgress,
          ),
          const TimelineStepData(
            title: 'Cuci Motor Bersih Gratis',
            subtitle: 'Pencucian bodi motor setelah servis selesai.',
            status: StepStatus.pending,
          ),
          const TimelineStepData(
            title: 'Quality Control & Siap Diambil',
            subtitle: 'Test drive akhir oleh kepala mekanik & cetak faktur.',
            status: StepStatus.pending,
          ),
        ],
      },
      {
        'tabTitle': 'Motor 2: BeAT (Pit 02)',
        'vehicleName': 'Honda BeAT',
        'plate': 'B 5678 JKT',
        'pit': 'Pit 02',
        'pitHeader': 'Tahapan Pengerjaan Pit 02',
        'serviceType': 'Servis Rutin & Tune-up',
        'mechanicName': 'Kang Asep',
        'mechanicRole': 'Teknisi Pit 02 • Spesialis Tune-up',
        'avatarPath': 'assets/images/kang_asep.png',
        'findingTitle': 'Temuan Montir Pit 02:',
        'findingDesc': 'Kampas rem belakang mulai tipis, disarankan ganti (+Rp 40.000).',
        'findingItem': 'Ganti Kampas Rem Belakang',
        'findingPrice': '+Rp 40.000',
        'findingPhoto': 'assets/images/kampas_rem_inspection.jpg',
        'progress': _motor2Progress,
        'estTime': _motor2EstTime,
        'decision': _motor2Decision,
        'steps': [
          const TimelineStepData(
            title: '09:18 WIB – Check-in & Serah Terima',
            subtitle: 'Motor diterima SA & verifikasi kondisi awal.',
            status: StepStatus.completed,
          ),
          const TimelineStepData(
            title: '09:30 WIB – Diagnosa & Cek Pengereman',
            subtitle: 'Pemeriksaan kampas rem, filter udara, dan busi.',
            status: StepStatus.inProgress,
          ),
          const TimelineStepData(
            title: '10:00 WIB – Servis Rutin & Oli MPX2',
            subtitle: 'Pembersihan throttle body dan penggantian oli mesin.',
            status: StepStatus.pending,
          ),
          const TimelineStepData(
            title: 'Cuci Motor Bersih Gratis',
            subtitle: 'Pencucian bodi motor setelah servis selesai.',
            status: StepStatus.pending,
          ),
          const TimelineStepData(
            title: 'Quality Control & Siap Diambil',
            subtitle: 'Pemeriksaan keselamatan akhir & cetak faktur.',
            status: StepStatus.pending,
          ),
        ],
      },
    ];

    final currentVehicle = vehiclesData[_selectedVehicleIndex];

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _handleBack();
      },
      child: Scaffold(
        backgroundColor: isDark ? AppColors.bgDark : const Color(0xFFF8FAFC),
        appBar: AppBar(
          backgroundColor: isDark ? AppColors.bgDark : const Color(0xFFF8FAFC),
          elevation: 0,
          scrolledUnderElevation: 0,
          automaticallyImplyLeading: false,
          titleSpacing: 16,
          title: Row(
            children: [
              // Back Button
              InkWell(
                onTap: _handleBack,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceDark : Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isDark ? AppColors.borderDark : const Color(0xFFE2E8F0),
                    width: 1.0,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 16,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
            ),

            // Header Title & Workshop Name
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Status Servis Armada',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: Color(0xFF10B981),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Flexible(
                        child: Text(
                          workshop,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF059669),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Animated Refresh Button with rich physics-based rotation & pulse
            AnimatedRefreshButton(
              isDark: isDark,
              onRefresh: _handleRefresh,
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Vehicle / Pit Segmented Pills
            Row(
              children: [
                Expanded(
                  child: _buildVehiclePill(
                    label: vehiclesData[0]['tabTitle'] as String,
                    isSelected: _selectedVehicleIndex == 0,
                    isDark: isDark,
                    onTap: () => setState(() => _selectedVehicleIndex = 0),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildVehiclePill(
                    label: vehiclesData[1]['tabTitle'] as String,
                    isSelected: _selectedVehicleIndex == 1,
                    isDark: isDark,
                    onTap: () => setState(() => _selectedVehicleIndex = 1),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Card 1: Status & Mechanic Card
            StatusMechanicCard(
              isDark: isDark,
              statusText: 'Sedang Dikerjakan',
              progressPercent: currentVehicle['progress'] as int,
              estFinishedTime: currentVehicle['estTime'] as String,
              mechanicName: currentVehicle['mechanicName'] as String,
              mechanicRole: currentVehicle['mechanicRole'] as String,
              avatarPath: currentVehicle['avatarPath'] as String,
              onChatPressed: () => _navigateToChatMontir(currentVehicle),
            ),

            const SizedBox(height: 14),

            // Card 2: Temuan Montir Card with Approval Buttons
            MechanicFindingCard(
              isDark: isDark,
              title: currentVehicle['findingTitle'] as String,
              description: currentVehicle['findingDesc'] as String,
              decisionState: currentVehicle['decision'] as FindingDecisionState,
              onDecisionChanged: (newDecision) {
                setState(() {
                  if (_selectedVehicleIndex == 0) {
                    _motor1Decision = newDecision;
                  } else {
                    _motor2Decision = newDecision;
                  }
                });
              },
            ),

            const SizedBox(height: 14),

            // Card 3: Tahapan Pengerjaan Stepper
            ServiceStepperTimeline(
              isDark: isDark,
              pitHeader: currentVehicle['pitHeader'] as String,
              plateNumber: currentVehicle['plate'] as String,
              steps: currentVehicle['steps'] as List<TimelineStepData>,
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),

      // Sticky Bottom Action Bar: "Lihat Invoice & Rincian Nota Sementara ->"
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : Colors.white,
          border: Border(
            top: BorderSide(
              color: isDark ? AppColors.borderDark : const Color(0xFFE2E8F0),
              width: 1.0,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.04),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: SafeArea(
          child: SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton(
              onPressed: _navigateToInvoice,
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFFFF6B00),
                side: const BorderSide(
                  color: Color(0xFFFF6B00),
                  width: 1.5,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Lihat Invoice & Rincian Nota Sementara',
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFFFF6B00),
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(
                    Icons.arrow_forward_rounded,
                    size: 18,
                    color: Color(0xFFFF6B00),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
    );
  }

  Widget _buildVehiclePill({
    required String label,
    required bool isSelected,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFFF6B00)
              : (isDark ? AppColors.surfaceDark : Colors.white),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected
                ? const Color(0xFFFF6B00)
                : (isDark ? AppColors.borderDark : const Color(0xFFE2E8F0)),
            width: 1.2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFFFF6B00).withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
            color: isSelected
                ? Colors.white
                : (isDark ? AppColors.textSecondaryDark : const Color(0xFF64748B)),
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        ),
      ),
    );
  }
}
