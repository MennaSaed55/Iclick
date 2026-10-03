import 'package:flutter/material.dart';

/// ConnectMe / Figma Social App UI Kit Color Palette.
///
/// Direct mapping to the Figma Community "Social App - Free UI Kit":
/// - cDarkPurple (#5151C6) & cPurple (#888BF4) for primary gradients and CTAs
/// - cRed (#FA6650) for accents, likes, and highlights
/// - cBlue (#2F80ED) for active states, links, and secondary accents
/// - cBlack (#242424) for dark text and surfaces
/// - cGrey1 through cGrey7 for balanced typography and borders
class AppColors {
  AppColors._();

  // --- Core Figma UI Kit Colors ---
  static const Color cWhite = Colors.white;
  static const Color cRed = Color(0xFFFA6650);
  static const Color cBlue = Color(0xFF2F80ED);
  static const Color cPurple = Color(0xFF888BF4);
  static const Color cDarkPurple = Color(0xFF5151C6);
  static const Color cBlack = Color(0xFF242424);

  // --- Figma Grey Scale ---
  static const Color cGrey1 = Color(0xFF333333);
  static const Color cGrey2 = Color(0xFF4F4F4F);
  static const Color cGrey3 = Color(0xFF828282);
  static const Color cGrey4 = Color(0xFFBDBDBD);
  static const Color cGrey5 = Color(0xFFE0E0E0);
  static const Color cGrey6 = Color(0xFFECEDEE);
  static const Color cGrey7 = Color(0xFFF2F2F2);

  // --- Clean Architecture Theme Aliases ---
  static const Color primary = cDarkPurple;
  static const Color primaryLight = cPurple;
  static const Color primaryDark = Color(0xFF38388C);

  static const Color accent = cRed;
  static const Color accentLight = Color(0xFFFF8A75);
  static const Color accentDark = Color(0xFFD94833);

  static const Color white = cWhite;
  static const Color background = Color(0xFFF8F9FB);
  static const Color surface = cWhite;
  static const Color surfaceVariant = cGrey7;

  // --- Text Colors ---
  static const Color textPrimary = cBlack;
  static const Color textSecondary = cGrey2;
  static const Color textHint = cGrey4;
  static const Color textOnDark = cWhite;
  static const Color textOnDarkSecondary = cGrey5;

  // --- Borders & Dividers ---
  static const Color border = cGrey5;
  static const Color divider = cGrey6;

  // --- Status Colors ---
  static const Color success = Color(0xFF27AE60);
  static const Color warning = Color(0xFFF2994A);
  static const Color error = cRed;
  static const Color info = cBlue;

  // --- Gradients ---
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [cDarkPurple, cPurple],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient storyGradient = LinearGradient(
    colors: [cRed, cPurple, cBlue],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
