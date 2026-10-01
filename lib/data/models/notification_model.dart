import 'package:flutter/material.dart';

class NotificationItem {
  final String id;
  final String title;
  final String body;
  final String time;
  final IconData icon;
  final String category; // 'status' or 'promo' or 'tips'
  final String section; // 'HARI INI' or 'KEMARIN'
  final String? highlightTag;
  final String? badgeText;
  final Color? badgeBg;
  final Color? badgeTextColor;
  bool isRead;

  NotificationItem({
    required this.id,
    required this.title,
    required this.body,
    required this.time,
    required this.icon,
    required this.category,
    required this.section,
    this.highlightTag,
    this.badgeText,
    this.badgeBg,
    this.badgeTextColor,
    this.isRead = false,
  });
}
