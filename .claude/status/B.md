=== START === tab_bar floating notch rewrite

tab_bar.dart: rewritten as floating notch nav bar
  - StatefulWidget + SingleTickerProviderStateMixin
  - AnimationController(TmDur.base) + Tween animates _tabPos on active tab change
  - Stack: bar background (CustomPaint with notch path), 5 tab items (icon hidden behind bubble for active), floating accent bubble

Spec deviation:
  - Removed kCornerR static constant — was unused (painter has its own const r = 28.0
    per spec); analyze warned unused_field. All other constants kept and used.

flutter analyze: No issues found! (ran in 3.1s)
  (also confirms missing help_center_screen.dart from previous task is now resolved)
=== DONE ===
