import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

enum StepStatus {
  completed,
  inProgress,
  pending,
}

class TimelineStepData {
  final String title;
  final String subtitle;
  final StepStatus status;
  final String? timeText;

  const TimelineStepData({
    required this.title,
    required this.subtitle,
    required this.status,
    this.timeText,
  });
}

class ServiceStepperTimeline extends StatelessWidget {
  final bool isDark;
  final String pitHeader;
  final String plateNumber;
  final List<TimelineStepData> steps;

  const ServiceStepperTimeline({
    super.key,
    required this.isDark,
    required this.pitHeader,
    required this.plateNumber,
    required this.steps,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? AppColors.borderDark : const Color(0xFFE2E8F0),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: TAHAPAN PENGERJAAN PIT 01 and Plate number
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                pitHeader.toUpperCase(),
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.4,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
              Text(
                plateNumber,
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.textSecondaryDark : const Color(0xFF64748B),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Stepper Items using robust CustomPaint (no IntrinsicHeight / LayoutBuilder conflicts)
          for (int index = 0; index < steps.length; index++) ...[
            _buildTimelineRow(index, isDark),
          ],
        ],
      ),
    );
  }

  Widget _buildTimelineRow(int index, bool isDark) {
    final step = steps[index];
    final isLast = index == steps.length - 1;
    final nextStep = !isLast ? steps[index + 1] : null;

    Color lineColor;
    bool isDotted;

    if (step.status == StepStatus.completed && nextStep?.status == StepStatus.completed) {
      lineColor = const Color(0xFF16A34A);
      isDotted = false;
    } else if (step.status == StepStatus.completed && nextStep?.status == StepStatus.inProgress) {
      lineColor = const Color(0xFFEA580C);
      isDotted = false;
    } else {
      lineColor = const Color(0xFFCBD5E1);
      isDotted = true;
    }

    return CustomPaint(
      painter: _TimelineLinePainter(
        lineColor: lineColor,
        isDotted: isDotted,
        isLast: isLast,
      ),
      child: Padding(
        padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: Center(
                child: _buildStepIndicator(step.status),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStepContent(step, isDark),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepIndicator(StepStatus status) {
    switch (status) {
      case StepStatus.completed:
        return Container(
          width: 22,
          height: 22,
          decoration: const BoxDecoration(
            color: Color(0xFF16A34A),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: const Icon(
            Icons.check_rounded,
            size: 14,
            color: Colors.white,
          ),
        );
      case StepStatus.inProgress:
        return const _SpinningGearWidget();
      case StepStatus.pending:
        return Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xFFCBD5E1),
              width: 2.0,
            ),
          ),
          alignment: Alignment.center,
          child: Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: Color(0xFFCBD5E1),
              shape: BoxShape.circle,
            ),
          ),
        );
    }
  }

  Widget _buildStepContent(TimelineStepData step, bool isDark) {
    if (step.status == StepStatus.inProgress) {
      // Active highlighted container with orange tint
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF331C0C) : const Color(0xFFFFF7ED),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? const Color(0xFF7C2D12) : const Color(0xFFFFEDD5),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    step.title,
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w800,
                      color: isDark ? const Color(0xFFFFEDD5) : const Color(0xFFC2410C),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF7C2D12) : const Color(0xFFFFEDD5),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'PROSES',
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFFC2410C),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 3),
            Text(
              step.subtitle,
              style: TextStyle(
                fontSize: 11,
                color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                step.title,
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: step.status == StepStatus.completed ? FontWeight.w800 : FontWeight.w600,
                  color: step.status == StepStatus.completed
                      ? (isDark ? Colors.white : const Color(0xFF0F172A))
                      : (isDark ? AppColors.textSecondaryDark : const Color(0xFF64748B)),
                ),
              ),
            ),
            if (step.status == StepStatus.completed) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFDCFCE7),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'Selesai',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF16A34A),
                  ),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 2),
        Text(
          step.subtitle,
          style: TextStyle(
            fontSize: 11,
            color: step.status == StepStatus.completed
                ? const Color(0xFF64748B)
                : const Color(0xFF94A3B8),
          ),
        ),
      ],
    );
  }
}

class _TimelineLinePainter extends CustomPainter {
  final Color lineColor;
  final bool isDotted;
  final bool isLast;

  _TimelineLinePainter({
    required this.lineColor,
    required this.isDotted,
    required this.isLast,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (isLast) return;

    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    const startX = 12.0; // center of 24px wide left column
    const startY = 24.0; // below the 24px indicator circle
    final endY = size.height;

    if (startY >= endY) return;

    if (!isDotted) {
      canvas.drawLine(const Offset(startX, startY), Offset(startX, endY), paint);
    } else {
      const dashLength = 4.0;
      const dashSpace = 3.0;
      double currentY = startY;
      while (currentY < endY) {
        final nextY = (currentY + dashLength < endY) ? currentY + dashLength : endY;
        canvas.drawLine(Offset(startX, currentY), Offset(startX, nextY), paint);
        currentY += dashLength + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _TimelineLinePainter oldDelegate) =>
      oldDelegate.lineColor != lineColor ||
      oldDelegate.isDotted != isDotted ||
      oldDelegate.isLast != isLast;
}

class _SpinningGearWidget extends StatefulWidget {
  const _SpinningGearWidget();

  @override
  State<_SpinningGearWidget> createState() => _SpinningGearWidgetState();
}

class _SpinningGearWidgetState extends State<_SpinningGearWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _controller,
      child: Container(
        width: 24,
        height: 24,
        decoration: const BoxDecoration(
          color: Color(0xFFEA580C),
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: const Icon(
          Icons.settings_rounded,
          size: 14,
          color: Colors.white,
        ),
      ),
    );
  }
}
