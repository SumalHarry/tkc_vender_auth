import 'package:flutter/material.dart';

/// Mock Mail UI palette — light gray chrome, white cards, red accents (iOS-style).
abstract final class AppColors {
  static const primary = Color(0xFFE53935);
  static const primaryDark = Color(0xFFC62828);

  /// System grouped background (~iOS `systemGroupedBackground`).
  static const background = Color(0xFFF2F2F7);
  static const surface = Colors.white;
  static const textPrimary = Color(0xFF000000);
  static const textSecondary = Color(0xFF8E8E93);
  static const border = Color(0xFFE5E5EA);
  static const segmentBackground = Color(0xFFE5E5EA);
  static const cardShadow = Color(0x14000000);
  static const navBarBorder = Color(0xFFC6C6C8);

  static const logoGradientStart = Color(0xFF2196F3);
  static const logoGradientEnd = Color(0xFF4CAF50);

  static const shoppingBlue = Color(0xFF007AFF);
  static const concertYellow = Color(0xFFFFCC00);
  static const onlineGreen = Color(0xFF34C759);
  static const emailLinkBlue = Color(0xFF007AFF);
  static const avatarBlue = Color(0xFF5856D6);

  /// Receipt / read indicator green (mock double-checkmarks).
  static const readReceiptGreen = Color(0xFF34C759);

  static const displayNameBlue = Color(0xFF007AFF);
  static const emailIconGreen = Color(0xFF34C759);
  static const notificationYellow = Color(0xFFFFCC00);
  static const websocketBlue = Color(0xFF007AFF);

  /// Grouped inset content (e.g. receipt blocks).
  static const groupedSecondary = Color(0xFFF2F2F7);
}
