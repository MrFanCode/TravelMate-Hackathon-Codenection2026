import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// TravelMate type system — Fraunces (display), Public Sans (body),
/// Space Mono (labels/stamps/ticket-style detail).
class AppTextStyles {
  AppTextStyles._();

  static TextStyle displayLarge = GoogleFonts.fraunces(
    fontSize: 36,
    fontWeight: FontWeight.w600,
    fontStyle: FontStyle.italic,
    height: 1.04,
    color: AppColors.ink,
  );

  static TextStyle displayMedium = GoogleFonts.fraunces(
    fontSize: 24,
    fontWeight: FontWeight.w500,
    height: 1.12,
    color: AppColors.ink,
  );

  static TextStyle body = GoogleFonts.publicSans(
    fontSize: 14,
    height: 1.5,
    color: AppColors.inkSoft,
  );

  static TextStyle bodyStrong = GoogleFonts.publicSans(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.ink,
  );

  static TextStyle label = GoogleFonts.spaceMono(
    fontSize: 11,
    letterSpacing: 1.2,
    color: AppColors.inkSoft,
  );

  static TextStyle eyebrow = GoogleFonts.spaceMono(
    fontSize: 11,
    letterSpacing: 1.4,
    fontWeight: FontWeight.w700,
    color: AppColors.rust,
  );

  static TextStyle buttonLabel = GoogleFonts.spaceMono(
    fontSize: 13,
    letterSpacing: 0.8,
    fontWeight: FontWeight.w700,
    color: AppColors.cream,
  );
}
