import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../controllers/app_controller.dart';
import '../status/status_servis_screen.dart';

import '../../../data/models/notification_model.dart';

class NotificationScreen extends StatefulWidget {
  final AppController controller;

  const NotificationScreen({
    super.key,
    required this.controller,
  });

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  int _selectedFilterIndex = 0;
  final List<String> _filters = ['Semua', 'Status Servis', 'Promo'];

  void _markAllAsRead() {
    widget.controller.markAllNotificationsRead();
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Semua notifikasi ditandai telah dibaca'),
        duration: Duration(seconds: 2),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  List<NotificationItem> get _filteredNotifications {
    final list = widget.controller.notifications;
    if (_selectedFilterIndex == 1) {
      return list.where((n) => n.category == 'status').toList();
    } else if (_selectedFilterIndex == 2) {
      return list.where((n) => n.category == 'promo').toList();
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.controller.isDarkMode;
    final unreadTodayCount = widget.controller.notifications
        .where((n) => n.section == 'HARI INI' && !n.isRead)
        .length;

    final hariIniList =
        _filteredNotifications.where((n) => n.section == 'HARI INI').toList();
    final kemarinList =
        _filteredNotifications.where((n) => n.section == 'KEMARIN').toList();

    return Scaffold(
      backgroundColor: isDark ? AppColors.bgDark : const Color(0xFFF8FAFC),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
        elevation: 0,
        leadingWidth: 64,
        leading: Center(
          child: Container(
            width: 38,
            height: 38,
            margin: const EdgeInsets.only(left: 16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardDark : Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: isDark ? AppColors.borderDark : const Color(0xFFE2E8F0),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: Icon(
                Icons.chevron_left_rounded,
                size: 26,
                color: isDark
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimaryLight,
              ),
              onPressed: () => Navigator.maybePop(context),
            ),
          ),
        ),
        title: Text(
          'Notifikasi',
          style: AppTypography.getHeading(
            isDark: isDark,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _markAllAsRead,
            child: const Text(
              'Tandai Dibaca',
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        children: [
          // Filter Chips
          Row(
            children: List.generate(_filters.length, (index) {
              final isSelected = _selectedFilterIndex == index;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: InkWell(
                  onTap: () => setState(() => _selectedFilterIndex = index),
                  borderRadius: BorderRadius.circular(20),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary
                          : (isDark ? AppColors.cardDark : Colors.white),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : (isDark
                                ? AppColors.borderDark
                                : const Color(0xFFE2E8F0)),
                      ),
                    ),
                    child: Text(
                      _filters[index],
                      style: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : (isDark
                                ? AppColors.textSecondaryDark
                                : AppColors.textSecondaryLight),
                        fontSize: 13,
                        fontWeight:
                            isSelected ? FontWeight.w700 : FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 24),

          // Section 1: HARI INI
          if (hariIniList.isNotEmpty) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'HARI INI',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF94A3B8),
                    letterSpacing: 0.5,
                  ),
                ),
                if (unreadTodayCount > 0)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF1E7),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '$unreadTodayCount Baru',
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            ...hariIniList.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildNotificationCard(item, isDark),
              ),
            ),
            const SizedBox(height: 12),
          ],

          // Section 2: KEMARIN
          if (kemarinList.isNotEmpty) ...[
            const Text(
              'KEMARIN',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Color(0xFF94A3B8),
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 12),
            ...kemarinList.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildNotificationCard(item, isDark),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildNotificationCard(NotificationItem item, bool isDark) {
    final isUnread = !item.isRead;
    final cardBg = isDark
        ? AppColors.cardDark
        : (isUnread ? const Color(0xFFF9F7F5) : Colors.white);
    final borderColor = isDark
        ? AppColors.borderDark
        : (isUnread ? const Color(0xFFF1EDE8) : const Color(0xFFE2E8F0));

    return InkWell(
      onTap: () {
        setState(() => item.isRead = true);
        if (item.category == 'status') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => StatusServisScreen(controller: widget.controller),
            ),
          );
        }
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.02),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left circular icon
            Container(
              width: 42,
              height: 42,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: Icon(
                item.icon,
                color: Colors.white,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title + unread dot
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          item.title,
                          style: AppTypography.getHeading(
                            isDark: isDark,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      if (isUnread) ...[
                        const SizedBox(width: 6),
                        Container(
                          width: 8,
                          height: 8,
                          margin: const EdgeInsets.only(top: 4),
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),

                  // Body text
                  Text(
                    item.body,
                    style: TextStyle(
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : const Color(0xFF64748B),
                      fontSize: 12,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Footer info
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 4,
                    runSpacing: 4,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.access_time_rounded,
                            size: 13,
                            color: Color(0xFF94A3B8),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            item.time,
                            style: const TextStyle(
                              color: Color(0xFF94A3B8),
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      if (item.highlightTag != null) ...[
                        const Text(
                          '•',
                          style: TextStyle(
                            color: Color(0xFF94A3B8),
                            fontSize: 11,
                          ),
                        ),
                        Text(
                          item.highlightTag!,
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                      if (item.badgeText != null) ...[
                        const Text(
                          '•',
                          style: TextStyle(
                            color: Color(0xFF94A3B8),
                            fontSize: 11,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: item.badgeBg ?? const Color(0xFFDCFCE7),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            item.badgeText!,
                            style: TextStyle(
                              color: item.badgeTextColor ??
                                  const Color(0xFF16A34A),
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
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
}
