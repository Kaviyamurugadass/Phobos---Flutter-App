import 'package:flutter/material.dart';

/// AppColors class provides a centralized color palette for the entire application
/// This ensures consistency across all screens and widgets
class AppColors {
  // Private constructor to prevent instantiation
  AppColors._();

  // Primary Colors
  static const Color primary = Color.fromARGB(255, 4, 31, 73);
  static const Color gold = Color(0xFFFFD700);
  
  // Secondary Colors
  static const Color secondary = Color(0xFF1E3A8A);
  static const Color accent = Color(0xFF3B82F6);
  
  // Status Colors
  static const Color active = Colors.green;
  static const Color away = Colors.yellow;
  static const Color offline = Colors.red;
  
  // Background Colors
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Colors.white;
  static const Color cardBackground = Color(0xFFFFFFFF);
  
  // Text Colors
  static const Color textPrimary = Color(0xFF1F2937);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textLight = Color(0xFF9CA3AF);
  
  // Border Colors
  static const Color border = Color(0xFFE5E7EB);
  static const Color borderLight = Color(0xFFF3F4F6);
  
  // Error and Success Colors
  static const Color error = Color(0xFFEF4444);
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);
  
  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, secondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient goldGradient = LinearGradient(
    colors: [gold, Color(0xFFFFA500)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // Helper method to get status color based on user status
  static Color getStatusColor(int userStatus) {
    switch (userStatus) {
      case 2:
        return active; // Active
      case 1:
        return away; // Away
      default:
        return offline; // Offline
    }
  }
  
  // Helper method to get status text based on user status
  static String getStatusText(int userStatus) {
    switch (userStatus) {
      case 2:
        return "Active";
      case 1:
        return "Away";
      default:
        return "Offline";
    }
  }
} 