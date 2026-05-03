import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../l10n/app_localizations.dart';
import '../providers/profile_provider.dart';
import '../theme/tokens.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  final VoidCallback onBack;
  const EditProfileScreen({super.key, required this.onBack});
  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  late final TextEditingController _name;
  late final TextEditingController _username;
  late final TextEditingController _location;
  late final TextEditingController _email;

  @override
  void initState() {
    super.initState();
    final p = ref.read(profileProvider);
    _name = TextEditingController(text: p.name);
    _username = TextEditingController(text: p.username);
    _location = TextEditingController(text: p.location);
    _email = TextEditingController(text: p.email);
  }

  @override
  void dispose() {
    _name.dispose();
    _username.dispose();
    _location.dispose();
    _email.dispose();
    super.dispose();
  }

  void _save() {
    ref.read(profileProvider.notifier).update(
          ref.read(profileProvider).copyWith(
                name: _name.text.trim(),
                username: _username.text.trim(),
                location: _location.text.trim(),
                email: _email.text.trim(),
              ),
        );
    widget.onBack();
  }

  @override
  Widget build(BuildContext context) {
    final p = TmPalette.of(context);
    final l = AppLocalizations.of(context)!;
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
                  onPressed: widget.onBack,
                ),
                Expanded(
                  child: Text(
                    l.personalInfoTitle,
                    style: TmType.h2(color: p.fg).copyWith(fontSize: 20, letterSpacing: -0.4),
                  ),
                ),
                TextButton(
                  onPressed: _save,
                  child: Text(
                    l.personalInfoSave,
                    style: TmType.body(color: p.accent, weight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
              children: [
                _EditField(label: l.personalInfoNameLabel, controller: _name, p: p),
                const SizedBox(height: 16),
                _EditField(label: l.personalInfoUsernameLabel, controller: _username, p: p),
                const SizedBox(height: 16),
                _EditField(label: l.personalInfoLocationLabel, controller: _location, p: p),
                const SizedBox(height: 16),
                _EditField(
                  label: l.personalInfoEmailLabel,
                  controller: _email,
                  p: p,
                  keyboardType: TextInputType.emailAddress,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EditField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TmPalette p;
  final TextInputType? keyboardType;
  const _EditField({
    required this.label,
    required this.controller,
    required this.p,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TmType.small(color: p.muted)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: TmType.body(color: p.fg),
          decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            filled: true,
            fillColor: p.surfSunken,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: p.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: p.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: p.accent, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
