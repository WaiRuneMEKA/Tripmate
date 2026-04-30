import 'package:flutter/material.dart';
import '../theme/tokens.dart';

class Avatar extends StatelessWidget {
  final String initials;
  final Color color;
  final double size;
  final Color? ring;
  const Avatar({
    super.key,
    required this.initials,
    this.color = TmColors.violet700,
    this.size = 28,
    this.ring,
  });

  @override
  Widget build(BuildContext context) {
    final p = TmPalette.of(context);
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: ring ?? p.bg, width: 2),
      ),
      child: Text(
        initials,
        style: TmType.h3(color: Colors.white).copyWith(
          fontSize: (size * 0.38).round().toDouble(),
        ),
      ),
    );
  }
}

class AvatarStack extends StatelessWidget {
  final List<({String initials, Color color})> people;
  final double size;
  final Color? ring;
  const AvatarStack({
    super.key,
    required this.people,
    this.size = 28,
    this.ring,
  });

  @override
  Widget build(BuildContext context) {
    final width = size + (people.length - 1) * (size - 8);
    return SizedBox(
      width: width,
      height: size,
      child: Stack(
        children: [
          for (var i = 0; i < people.length; i++)
            Positioned(
              left: i * (size - 8),
              child: Avatar(
                initials: people[i].initials,
                color: people[i].color,
                size: size,
                ring: ring,
              ),
            ),
        ],
      ),
    );
  }
}

enum TmButtonVariant { primary, secondary, ghost, destructive }

class TmButton extends StatelessWidget {
  final TmButtonVariant variant;
  final bool small;
  final Widget child;
  final VoidCallback? onPressed;
  final bool fullWidth;
  final EdgeInsets? padding;

  const TmButton({
    super.key,
    this.variant = TmButtonVariant.primary,
    this.small = false,
    required this.child,
    this.onPressed,
    this.fullWidth = false,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final p = TmPalette.of(context);
    Color bg, fg, bd;
    switch (variant) {
      case TmButtonVariant.primary:
        bg = p.accent;
        fg = Colors.white;
        bd = Colors.transparent;
        break;
      case TmButtonVariant.secondary:
        bg = p.surf;
        fg = p.fg;
        bd = p.border;
        break;
      case TmButtonVariant.ghost:
        bg = Colors.transparent;
        fg = p.fg;
        bd = Colors.transparent;
        break;
      case TmButtonVariant.destructive:
        bg = p.surf;
        fg = p.rose;
        bd = p.border;
        break;
    }
    final h = small ? 36.0 : 44.0;
    final padH = small ? 14.0 : 20.0;
    return SizedBox(
      width: fullWidth ? double.infinity : null,
      height: h,
      child: Material(
        color: bg,
        borderRadius: const BorderRadius.all(TmRadius.md),
        child: InkWell(
          onTap: onPressed,
          borderRadius: const BorderRadius.all(TmRadius.md),
          child: Container(
            padding: padding ?? EdgeInsets.symmetric(horizontal: padH),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(TmRadius.md),
              border: Border.all(color: bd),
            ),
            alignment: Alignment.center,
            child: DefaultTextStyle(
              style: TmType.body(color: fg, weight: FontWeight.w500),
              child: IconTheme(
                data: IconThemeData(color: fg, size: 18),
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

enum TmChipTone { neutral, warn, success, rose, violet }

class TmChip extends StatelessWidget {
  final Widget child;
  final bool active;
  final TmChipTone tone;
  final VoidCallback? onPressed;
  const TmChip({
    super.key,
    required this.child,
    this.active = false,
    this.tone = TmChipTone.neutral,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final p = TmPalette.of(context);
    Color bg, fg, bd;
    if (tone == TmChipTone.warn) {
      bg = const Color(0xFFFBF1DD);
      fg = const Color(0xFF7C5311);
      bd = Colors.transparent;
    } else if (tone == TmChipTone.success) {
      bg = const Color(0xFFE6EFDE);
      fg = const Color(0xFF4A6938);
      bd = Colors.transparent;
    } else if (tone == TmChipTone.rose) {
      bg = const Color(0xFFF4DDD9);
      fg = const Color(0xFF7A2C24);
      bd = Colors.transparent;
    } else if (tone == TmChipTone.violet) {
      bg = const Color(0xFFF1ECFF);
      fg = const Color(0xFF4D2EC2);
      bd = Colors.transparent;
    } else if (active) {
      bg = p.dark ? p.fg : TmColors.nearBlack;
      fg = p.dark ? TmColors.darkBg : Colors.white;
      bd = bg;
    } else {
      bg = p.surf;
      fg = p.fg;
      bd = p.border;
    }
    return Material(
      color: bg,
      borderRadius: const BorderRadius.all(TmRadius.pill),
      child: InkWell(
        onTap: onPressed,
        borderRadius: const BorderRadius.all(TmRadius.pill),
        child: Container(
          height: 30,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(TmRadius.pill),
            border: Border.all(color: bd),
          ),
          alignment: Alignment.center,
          child: DefaultTextStyle(
            style: GoogleFontsHelper.interStyle().copyWith(
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
              color: fg,
            ),
            child: IconTheme(
              data: IconThemeData(color: fg, size: 14),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

// Tiny helper so we don't repeat google_fonts import for the chip text style
class GoogleFontsHelper {
  static TextStyle interStyle() => TmType.body();
}

class CategoryDot extends StatelessWidget {
  final TmCategory cat;
  final double size;
  const CategoryDot({super.key, required this.cat, this.size = 24});

  @override
  Widget build(BuildContext context) {
    final p = TmPalette.of(context);
    final def = tmCategories[cat]!;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: def.color(p.dark),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Icon(def.icon, size: size * 0.55, color: Colors.white),
    );
  }
}

class TmTopBar extends StatelessWidget {
  final String title;
  final Widget? leading;
  final Widget? trailing;
  const TmTopBar({super.key, required this.title, this.leading, this.trailing});

  @override
  Widget build(BuildContext context) {
    final p = TmPalette.of(context);
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: p.bg,
        border: Border(bottom: BorderSide(color: p.borderSoft)),
      ),
      child: Row(
        children: [
          SizedBox(width: 32, child: Align(alignment: Alignment.centerLeft, child: leading)),
          Expanded(
            child: Center(
              child: Text(
                title,
                style: TmType.h2(color: p.fg).copyWith(letterSpacing: -0.17),
              ),
            ),
          ),
          SizedBox(width: 32, child: Align(alignment: Alignment.centerRight, child: trailing)),
        ],
      ),
    );
  }
}

class IconButtonBare extends StatelessWidget {
  final IconData icon;
  final double size;
  final VoidCallback? onPressed;
  final Color? color;
  const IconButtonBare({
    super.key,
    required this.icon,
    this.size = 22,
    this.onPressed,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final p = TmPalette.of(context);
    return InkResponse(
      onTap: onPressed,
      radius: 20,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Icon(icon, size: size, color: color ?? p.fg),
      ),
    );
  }
}
