TASK: Rewrite lib/widgets/tab_bar.dart — floating notch nav bar with animation

Design: floating pill-shaped bar with animated notch + bubble for active tab.

KEEP at top of file (UNCHANGED):
  enum TmTab { trips, map, expenses, discover, profile }

CONVERT TmTabBar to StatefulWidget with SingleTickerProviderStateMixin.

CONSTANTS (inside state or as static const):
  kBubbleR = 27.0
  kBarH = 62.0
  kOverhang = 18.0   // bubble protrudes 18px above bar top edge
  kHMargin = 16.0    // horizontal margin each side (floating effect)
  kCornerR = 28.0    // bar rounded corner radius

STATE:
  late final AnimationController _ctrl (duration: TmDur.base)
  late Animation<double> _tabPos  // float 0..4, animated tab index

INIT STATE:
  _ctrl = AnimationController(vsync: this, duration: TmDur.base)
  _tabPos = AlwaysStoppedAnimation(widget.active.index.toDouble())

DID UPDATE WIDGET (when active tab changed):
  _tabPos = Tween<double>(begin: old.active.index.toDouble(), end: widget.active.index.toDouble())
            .animate(CurvedAnimation(parent: _ctrl, curve: TmDur.ease))
  _ctrl..reset()..forward()

DISPOSE: _ctrl.dispose()

BUILD:
  final p = TmPalette.of(context)
  final l = AppLocalizations.of(context)!
  final bottom = MediaQuery.of(context).padding.bottom
  final tabs = [
    (TmTab.trips, l.tabTrips, Icons.menu_outlined),
    (TmTab.map, l.tabMap, Icons.map_outlined),
    (TmTab.expenses, l.tabExpenses, Icons.account_balance_wallet_outlined),
    (TmTab.discover, l.tabDiscover, Icons.search_outlined),
    (TmTab.profile, l.tabProfile, Icons.person_outline),
  ]

  return AnimatedBuilder(
    animation: _ctrl,
    builder: (ctx, _) => LayoutBuilder(builder: (ctx, constraints) {
      final totalW = constraints.maxWidth
      final tabW = (totalW - kHMargin * 2) / 5.0
      final tabPos = _tabPos.value  // 0..4 float
      final notchAbsX = kHMargin + (tabPos + 0.5) * tabW  // absolute notch center
      final notchRelX = (tabPos + 0.5) * tabW              // relative to bar (after margin)
      final bubbleLeft = notchAbsX - kBubbleR
      final barTop = kBubbleR - kOverhang  // = 9.0

      return SizedBox(
        height: kBubbleR + kOverhang + kBarH + bottom + 8,
        // bubble top=0, center Y=kBubbleR; bar starts at barTop=kBubbleR-kOverhang
        // +8 is extra bottom breathing room
        child: Stack(
          clipBehavior: Clip.none,
          children: [

            // ── 1. BAR background (CustomPaint) ──
            Positioned(
              top: barTop, left: kHMargin, right: kHMargin,
              height: kBarH + bottom + 8,
              child: CustomPaint(
                painter: _BarPainter(
                  notchCenterX: notchRelX,
                  barColor: p.dark ? TmColors.darkSurf : p.surf,
                ),
              ),
            ),

            // ── 2. TAB ITEMS (all 5 tabs icon + label) ──
            Positioned(
              top: barTop, left: kHMargin, right: kHMargin,
              height: kBarH,
              child: Row(children: [
                for (final (id, label, icon) in tabs)
                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => widget.onChanged?.call(id),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(icon, size: 20,
                            // hide icon for active tab (bubble covers it)
                            color: id == widget.active
                              ? Colors.transparent
                              : p.accent.withValues(alpha: 0.55)),
                          const SizedBox(height: 3),
                          Text(label, style: TmType.caption(
                            color: id == widget.active
                              ? p.accent
                              : p.accent.withValues(alpha: 0.55))),
                        ],
                      ),
                    ),
                  ),
              ]),
            ),

            // ── 3. ACTIVE BUBBLE ──
            Positioned(
              top: 0.0,
              left: bubbleLeft,
              child: GestureDetector(
                onTap: () => widget.onChanged?.call(widget.active),
                child: Container(
                  width: kBubbleR * 2,
                  height: kBubbleR * 2,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: p.accent,
                    boxShadow: [BoxShadow(
                      color: p.accent.withValues(alpha: 0.45),
                      blurRadius: 14, offset: const Offset(0, 4),
                    )],
                  ),
                  child: Icon(tabs[widget.active.index].$3, color: Colors.white, size: 24),
                ),
              ),
            ),

          ],
        ),
      )
    }),
  )


ADD THIS CUSTOM PAINTER (after TmTabBar class):

class _BarPainter extends CustomPainter {
  final double notchCenterX;
  final Color barColor;
  const _BarPainter({required this.notchCenterX, required this.barColor});

  @override
  void paint(Canvas canvas, Size size) {
    final path = _buildPath(size);
    // shadow
    canvas.drawPath(path, Paint()
      ..color = Colors.black.withValues(alpha: 0.15)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10));
    // fill
    canvas.drawPath(path, Paint()..color = barColor);
  }

  Path _buildPath(Size size) {
    final w = size.width;
    final h = size.height;
    const r = 28.0;           // corner radius
    final cx = notchCenterX;  // notch center X (relative to bar)
    const nHW = 38.0;         // notch half-width
    const nD = 22.0;          // notch depth

    final nL = (cx - nHW).clamp(r, w - r);
    final nR = (cx + nHW).clamp(r, w - r);

    final path = Path()
      ..moveTo(r, 0);

    // top-left to notch start
    if (nL > r) path.lineTo(nL, 0);

    // bezier INTO notch
    path.cubicTo(
      nL + nHW * 0.35, 0,
      cx - nHW * 0.4, nD,
      cx, nD,
    );
    // bezier OUT of notch
    path.cubicTo(
      cx + nHW * 0.4, nD,
      nR - nHW * 0.35, 0,
      nR, 0,
    );

    // notch end to top-right corner
    if (nR < w - r) path.lineTo(w - r, 0);
    path.arcToPoint(Offset(w, r), radius: const Radius.circular(r), clockwise: true);
    path.lineTo(w, h - r);
    path.arcToPoint(Offset(w - r, h), radius: const Radius.circular(r), clockwise: true);
    path.lineTo(r, h);
    path.arcToPoint(Offset(0, h - r), radius: const Radius.circular(r), clockwise: true);
    path.lineTo(0, r);
    path.arcToPoint(Offset(r, 0), radius: const Radius.circular(r), clockwise: true);
    path.close();
    return path;
  }

  @override
  bool shouldRepaint(_BarPainter old) =>
    old.notchCenterX != notchCenterX || old.barColor != barColor;
}

IMPORTS NEEDED: dart:math is NOT needed. All existing imports are fine.

Run flutter analyze after writing. Report DONE or errors.