import 'package:flutter/material.dart';

enum FindingDecisionState {
  pending,
  approved,
  rejected,
}

class MechanicFindingCard extends StatelessWidget {
  final bool isDark;
  final String title;
  final String description;
  final FindingDecisionState decisionState;
  final ValueChanged<FindingDecisionState> onDecisionChanged;

  const MechanicFindingCard({
    super.key,
    required this.isDark,
    required this.title,
    required this.description,
    required this.decisionState,
    required this.onDecisionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF261D0C) : const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF78350F) : const Color(0xFFFDE68A),
          width: 1.2,
        ),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row: Lightbulb icon, Title & "Butuh Konfirmasi" badge
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF3E280C) : const Color(0xFFFEF3C7),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.lightbulb_outline_rounded,
                  size: 18,
                  color: Color(0xFFD97706),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w800,
                    color: isDark ? const Color(0xFFFDE68A) : const Color(0xFF78350F),
                  ),
                ),
              ),
              _buildBadge(),
            ],
          ),

          const SizedBox(height: 8),

          // Description
          Padding(
            padding: const EdgeInsets.only(left: 42),
            child: Text(
              description,
              style: TextStyle(
                fontSize: 12,
                height: 1.4,
                fontWeight: FontWeight.w500,
                color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF92400E),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Action Buttons: Setujui vs Tolak
          Padding(
            padding: EdgeInsets.only(
              left: decisionState == FindingDecisionState.pending ? 42 : 0,
            ),
            child: decisionState == FindingDecisionState.pending
                ? Row(
                    children: [
                      // Setujui Button
                      SizedBox(
                        height: 32,
                        child: ElevatedButton(
                          onPressed: () => onDecisionChanged(FindingDecisionState.approved),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF16A34A),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Setujui',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Tolak Button
                      SizedBox(
                        height: 32,
                        child: ElevatedButton(
                          onPressed: () => onDecisionChanged(FindingDecisionState.rejected),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFDC2626),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Tolak',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : _buildDecisionResultBanner(),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge() {
    switch (decisionState) {
      case FindingDecisionState.approved:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: const Color(0xFFDCFCE7),
            borderRadius: BorderRadius.circular(6),
          ),
          child: const Text(
            'Disetujui',
            style: TextStyle(
              fontSize: 9.5,
              fontWeight: FontWeight.w800,
              color: Color(0xFF16A34A),
            ),
          ),
        );
      case FindingDecisionState.rejected:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: const Color(0xFFFEE2E2),
            borderRadius: BorderRadius.circular(6),
          ),
          child: const Text(
            'Ditolak',
            style: TextStyle(
              fontSize: 9.5,
              fontWeight: FontWeight.w800,
              color: Color(0xFFDC2626),
            ),
          ),
        );
      case FindingDecisionState.pending:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF452203) : const Color(0xFFFEF3C7),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            'Butuh Konfirmasi',
            style: TextStyle(
              fontSize: 9.5,
              fontWeight: FontWeight.w700,
              color: isDark ? const Color(0xFFFDE68A) : const Color(0xFF92400E),
            ),
          ),
        );
    }
  }

  Widget _buildDecisionResultBanner() {
    final isApproved = decisionState == FindingDecisionState.approved;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: isApproved
            ? (isDark ? const Color(0xFF063319) : const Color(0xFFF0FDF4))
            : (isDark ? const Color(0xFF350B0B) : const Color(0xFFFEF2F2)),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isApproved ? const Color(0xFFBBF7D0) : const Color(0xFFFECACA),
        ),
      ),
      child: Row(
        children: [
          Icon(
            isApproved ? Icons.check_circle_rounded : Icons.cancel_rounded,
            size: 14,
            color: isApproved ? const Color(0xFF16A34A) : const Color(0xFFDC2626),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              isApproved
                  ? 'Item disetujui & masuk ke nota'
                  : 'Pemasangan part lama dipertahankan',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: isApproved ? const Color(0xFF16A34A) : const Color(0xFFDC2626),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => onDecisionChanged(FindingDecisionState.pending),
              borderRadius: BorderRadius.circular(4),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                child: Text(
                  'Ubah',
                  style: TextStyle(
                    fontSize: 10.5,
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF64748B),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
