import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../theme/tokens.dart';

class HelpCenterScreen extends StatelessWidget {
  final VoidCallback onBack;
  const HelpCenterScreen({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    final p = TmPalette.of(context);
    final l = AppLocalizations.of(context)!;
    final faqs = [
      (q: l.helpFaq1Q, a: l.helpFaq1A),
      (q: l.helpFaq2Q, a: l.helpFaq2A),
      (q: l.helpFaq3Q, a: l.helpFaq3A),
    ];
    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 8, 16, 0),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.chevron_left, color: p.fg, size: 28),
                  onPressed: onBack,
                ),
                Expanded(
                  child: Text(
                    l.helpTitle,
                    style: TmType.h2(color: p.fg).copyWith(fontSize: 20, letterSpacing: -0.4),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
              children: [
                for (final faq in faqs) ...[
                  Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: p.surf,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: p.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(faq.q, style: TmType.body(color: p.fg, weight: FontWeight.w600)),
                        const SizedBox(height: 6),
                        Text(faq.a, style: TmType.small(color: p.muted)),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
