import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Tripmate design tokens.
///
/// Mirrors `colors_and_type.css` from the design system.
/// Vibrant violet accent · warm neutral base · first-class dark mode.
class TmColors {
  TmColors._();

  // Neutral warm grays
  static const offWhite = Color(0xFFFAFAF7);
  static const paper = Color(0xFFF5F4EF);
  static const stone50 = Color(0xFFEFEDE6);
  static const stone100 = Color(0xFFE4E1D7);
  static const stone200 = Color(0xFFD3CFC1);
  static const stone300 = Color(0xFFB6B1A1);
  static const stone400 = Color(0xFF8C8779);
  static const stone500 = Color(0xFF5F5B51);
  static const stone600 = Color(0xFF3F3C36);
  static const stone700 = Color(0xFF2A2825);
  static const stone800 = Color(0xFF1B1A18);
  static const nearBlack = Color(0xFF111110);

  // Vibrant violet accent
  static const violet50 = Color(0xFFF1ECFF);
  static const violet100 = Color(0xFFDFD3FF);
  static const violet200 = Color(0xFFC2ADFE);
  static const violet300 = Color(0xFFA685FC);
  static const violet500 = Color(0xFF7B5CFA);
  static const violet600 = Color(0xFF6342E6);
  static const violet700 = Color(0xFF4D2EC2);
  static const violet900 = Color(0xFF2A1980);

  // Semantic accents
  static const amber500 = Color(0xFFC8851B);
  static const rose500 = Color(0xFFB5483D);
  static const sage500 = Color(0xFF6B8C5A);
  static const sky500 = Color(0xFF3D7AA8);

  // Dark mode surfaces
  static const darkBg = Color(0xFF1F1F1D);
  static const darkSurf = Color(0xFF2A2A28);
  static const darkSurfSunken = Color(0xFF161614);
  static const darkBorder = Color(0xFF34332F);
  static const darkBorderStrong = Color(0xFF42413C);
  static const darkFg = Color(0xFFF2F0EA);
  static const darkFgMuted = Color(0xFF9A958A);
  static const darkFgSubtle = Color(0xFF6B6760);

  static const gradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [violet300, violet500, violet600],
    stops: [0.0, 0.6, 1.0],
  );
}

/// Theme-aware palette resolved against [Brightness].
class TmPalette {
  final Color fg;
  final Color muted;
  final Color subtle;
  final Color bg;
  final Color surf;
  final Color surfSunken;
  final Color border;
  final Color borderSoft;
  final Color borderStrong;
  final Color accent;
  final Color accentHover;
  final Color accentSoft;
  final Color accentSoftFg;
  final Color success;
  final Color warn;
  final Color rose;
  final bool dark;

  const TmPalette._({
    required this.fg,
    required this.muted,
    required this.subtle,
    required this.bg,
    required this.surf,
    required this.surfSunken,
    required this.border,
    required this.borderSoft,
    required this.borderStrong,
    required this.accent,
    required this.accentHover,
    required this.accentSoft,
    required this.accentSoftFg,
    required this.success,
    required this.warn,
    required this.rose,
    required this.dark,
  });

  factory TmPalette.of(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return dark
        ? const TmPalette._(
            fg: TmColors.darkFg,
            muted: TmColors.darkFgMuted,
            subtle: TmColors.darkFgSubtle,
            bg: TmColors.darkBg,
            surf: TmColors.darkSurf,
            surfSunken: TmColors.darkSurfSunken,
            border: TmColors.darkBorder,
            borderSoft: TmColors.darkSurf,
            borderStrong: TmColors.darkBorderStrong,
            accent: TmColors.violet300,
            accentHover: TmColors.violet200,
            accentSoft: TmColors.violet900,
            accentSoftFg: TmColors.violet200,
            success: Color(0xFF9CC58A),
            warn: TmColors.amber500,
            rose: TmColors.rose500,
            dark: true,
          )
        : const TmPalette._(
            fg: TmColors.nearBlack,
            muted: TmColors.stone500,
            subtle: TmColors.stone400,
            bg: TmColors.offWhite,
            surf: Colors.white,
            surfSunken: TmColors.paper,
            border: TmColors.stone100,
            borderSoft: TmColors.stone50,
            borderStrong: TmColors.stone200,
            accent: TmColors.violet500,
            accentHover: TmColors.violet600,
            accentSoft: TmColors.violet50,
            accentSoftFg: TmColors.violet700,
            success: TmColors.sage500,
            warn: TmColors.amber500,
            rose: TmColors.rose500,
            dark: false,
          );
  }
}

/// Category palette — map pins, timeline categories, dots.
enum TmCategory { stay, eat, doActivity, go, see }

class TmCategoryDef {
  final IconData icon;
  final Color light;
  final Color dark;
  final String label;
  const TmCategoryDef(this.icon, this.light, this.dark, this.label);

  Color color(bool dark) => dark ? this.dark : light;
}

const Map<TmCategory, TmCategoryDef> tmCategories = {
  TmCategory.stay: TmCategoryDef(
    Icons.bed_outlined,
    TmColors.violet700,
    TmColors.violet300,
    'Stay',
  ),
  TmCategory.eat: TmCategoryDef(
    Icons.restaurant_outlined,
    TmColors.amber500,
    Color(0xFFE0A042),
    'Eat',
  ),
  TmCategory.doActivity: TmCategoryDef(
    Icons.explore_outlined,
    TmColors.violet500,
    TmColors.violet300,
    'Do',
  ),
  TmCategory.go: TmCategoryDef(
    Icons.directions_bus_outlined,
    TmColors.sky500,
    Color(0xFF6FA3D1),
    'Go',
  ),
  TmCategory.see: TmCategoryDef(
    Icons.account_balance_outlined,
    TmColors.rose500,
    Color(0xFFD86E60),
    'See',
  ),
};

/// Inter + JetBrains Mono via google_fonts.
class TmType {
  TmType._();

  static TextStyle display({Color? color}) => GoogleFonts.inter(
        fontSize: 32,
        height: 38 / 32,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.64,
        color: color,
      );

  static TextStyle title({Color? color}) => GoogleFonts.inter(
        fontSize: 22,
        height: 28 / 22,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.22,
        color: color,
      );

  static TextStyle h2({Color? color}) => GoogleFonts.inter(
        fontSize: 17,
        height: 24 / 17,
        fontWeight: FontWeight.w600,
        color: color,
      );

  static TextStyle h3({Color? color}) => GoogleFonts.inter(
        fontSize: 15,
        height: 22 / 15,
        fontWeight: FontWeight.w600,
        color: color,
      );

  static TextStyle body({Color? color, FontWeight? weight}) => GoogleFonts.inter(
        fontSize: 15,
        height: 22 / 15,
        fontWeight: weight ?? FontWeight.w400,
        color: color,
      );

  static TextStyle small({Color? color, FontWeight? weight}) => GoogleFonts.inter(
        fontSize: 13,
        height: 18 / 13,
        fontWeight: weight ?? FontWeight.w400,
        color: color,
      );

  static TextStyle caption({Color? color}) => GoogleFonts.inter(
        fontSize: 12,
        height: 16 / 12,
        fontWeight: FontWeight.w500,
        color: color,
      );

  static TextStyle overline({Color? color}) => GoogleFonts.inter(
        fontSize: 11,
        height: 14 / 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.66,
        color: color,
      );

  static TextStyle mono({Color? color, FontWeight? weight, double size = 14}) =>
      GoogleFonts.jetBrainsMono(
        fontSize: size,
        height: 20 / 14,
        fontWeight: weight ?? FontWeight.w500,
        color: color,
        fontFeatures: const [FontFeature.tabularFigures()],
      );
}

/// Standard radii (4/8 grid · md = 10 default).
class TmRadius {
  TmRadius._();
  static const sm = Radius.circular(6);
  static const md = Radius.circular(10);
  static const lg = Radius.circular(14);
  static const xl = Radius.circular(20);
  static const pill = Radius.circular(999);
}

class TmDur {
  TmDur._();
  static const tap = Duration(milliseconds: 140);
  static const base = Duration(milliseconds: 220);
  static const sheet = Duration(milliseconds: 360);
  static const ease = Cubic(0.2, 0.8, 0.2, 1);
}
