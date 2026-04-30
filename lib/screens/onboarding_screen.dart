import 'package:flutter/material.dart';
import '../theme/tokens.dart';

class OnboardingScreen extends StatelessWidget {
  final VoidCallback? onStart;
  final VoidCallback? onLogin;
  const OnboardingScreen({super.key, this.onStart, this.onLogin});

  @override
  Widget build(BuildContext context) {
    final p = TmPalette.of(context);
    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: const Alignment(0, -1),
          radius: 1.2,
          colors: p.dark
              ? [TmColors.violet900, TmColors.darkBg, TmColors.darkBg]
              : [TmColors.violet50, TmColors.offWhite, TmColors.offWhite],
          stops: const [0.0, 0.6, 1.0],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 40, 24, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: TmColors.gradient,
                    ),
                    child: const Center(
                      child: SizedBox(
                        width: 22,
                        height: 22,
                        child: _LogoMark(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'tripmate',
                    style: TmType.h2(color: p.fg).copyWith(
                      fontSize: 20,
                      letterSpacing: -0.4,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                'Plan, split,\nand remember.',
                style: TmType.display(color: p.fg).copyWith(
                  fontSize: 38,
                  height: 42 / 38,
                  letterSpacing: -0.95,
                ),
              ),
              const SizedBox(height: 14),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 320),
                child: Text(
                  'Trips you actually finish planning. Costs that actually balance. Friends still on the same itinerary.',
                  style: TmType.body(color: p.muted),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: onStart,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: p.accent,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text('Start a trip', style: TmType.body(color: Colors.white, weight: FontWeight.w500).copyWith(fontSize: 16)),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: p.fg,
                    side: BorderSide(color: p.border),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(
                    'I have an invite link',
                    style: TmType.body(color: p.fg, weight: FontWeight.w500).copyWith(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: GestureDetector(
                  onTap: onLogin,
                  child: RichText(
                    text: TextSpan(
                      style: TmType.small(color: p.muted),
                      children: [
                        const TextSpan(text: 'Already on Tripmate? '),
                        TextSpan(
                          text: 'Log in',
                          style: TmType.small(color: p.accent, weight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LogoMark extends StatelessWidget {
  const _LogoMark();
  @override
  Widget build(BuildContext context) => CustomPaint(painter: _LogoPainter());
}

class _LogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final stroke = Paint()
      ..color = Colors.white
      ..strokeWidth = 2.6
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;
    final s = size.width / 32;
    canvas.drawLine(Offset(6 * s, 8 * s), Offset(26 * s, 8 * s), stroke);
    canvas.drawLine(Offset(16 * s, 8 * s), Offset(16 * s, 25 * s), stroke);
    canvas.drawLine(Offset(16 * s, 25 * s), Offset(21 * s, 20 * s), stroke);
    canvas.drawLine(Offset(16 * s, 25 * s), Offset(11 * s, 20 * s), stroke);
  }

  @override
  bool shouldRepaint(_LogoPainter old) => false;
}
