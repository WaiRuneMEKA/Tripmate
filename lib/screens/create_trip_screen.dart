import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../data/mock.dart';
import '../l10n/app_localizations.dart';
import '../providers/trips_provider.dart';
import '../theme/tokens.dart';
import '../widgets/primitives.dart';

class CreateTripScreen extends ConsumerStatefulWidget {
  final VoidCallback? onClose;
  const CreateTripScreen({super.key, this.onClose});

  @override
  ConsumerState<CreateTripScreen> createState() => _CreateTripScreenState();
}

class _CreateTripScreenState extends ConsumerState<CreateTripScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _budgetCtrl = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
  int _coverIndex = 0;

  static const _gradients = <List<Color>>[
    [Color(0xFFF1ECFF), Color(0xFFDFD3FF)],
    [Color(0xFFFBF1DD), Color(0xFFF4DDD9)],
    [Color(0xFFDEE5D8), Color(0xFFEFEDE6)],
    [Color(0xFFE0F2FE), Color(0xFFBAE6FD)],
    [Color(0xFFFFE4E6), Color(0xFFFECDD3)],
    [Color(0xFFF5F5F5), Color(0xFFE5E5E5)],
  ];

  @override
  void dispose() {
    _nameCtrl.dispose();
    _budgetCtrl.dispose();
    super.dispose();
  }

  String _fmt(DateTime d) => DateFormat('MMM dd').format(d);

  Future<void> _pickStart(BuildContext context) async {
    final d = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (d != null) {
      setState(() {
        _startDate = d;
        if (_endDate != null && _endDate!.isBefore(d)) _endDate = null;
      });
    }
  }

  Future<void> _pickEnd(BuildContext context) async {
    final d = await showDatePicker(
      context: context,
      initialDate: _endDate ?? _startDate?.add(const Duration(days: 7)) ?? DateTime.now(),
      firstDate: _startDate ?? DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (d != null) setState(() => _endDate = d);
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final String dates;
    final int days;
    if (_startDate != null && _endDate != null) {
      dates = '${_fmt(_startDate!)} – ${_fmt(_endDate!)}';
      days = _endDate!.difference(_startDate!).inDays + 1;
    } else if (_startDate != null) {
      dates = _fmt(_startDate!);
      days = 1;
    } else {
      dates = '—';
      days = 0;
    }
    final budget = _budgetCtrl.text.trim();
    final trip = TripData(
      id: 't${DateTime.now().millisecondsSinceEpoch}',
      title: _nameCtrl.text.trim(),
      dates: dates,
      days: days,
      spent: '—',
      budget: budget.isEmpty ? '—' : budget,
      members: [(initials: 'YO', color: TmColors.violet500)],
      coverColors: _gradients[_coverIndex],
      draft: true,
    );
    ref.read(tripsProvider.notifier).add(trip);
    widget.onClose?.call();
  }

  InputDecoration _inputDeco(TmPalette p, {required String hint}) => InputDecoration(
    hintText: hint,
    hintStyle: TmType.body(color: p.muted),
    filled: true,
    fillColor: p.surf,
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: p.border),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: p.border),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: p.accent, width: 1.5),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: p.rose),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: p.rose, width: 1.5),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final p = TmPalette.of(context);
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: p.bg,
      body: SafeArea(
        child: Column(
          children: [
            TmTopBar(
              title: l.newTripScreenTitle,
              leading: IconButtonBare(
                icon: Icons.close,
                onPressed: widget.onClose,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _Label(l.newTripFieldName),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _nameCtrl,
                        style: TmType.body(color: p.fg),
                        decoration: _inputDeco(p, hint: l.newTripFieldNameHint),
                        validator: (v) =>
                            (v == null || v.trim().isEmpty) ? l.newTripValidationName : null,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _Label(l.newTripFieldStartDate),
                                const SizedBox(height: 6),
                                _DateButton(
                                  label: _startDate != null ? _fmt(_startDate!) : '—',
                                  onTap: () => _pickStart(context),
                                  p: p,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _Label(l.newTripFieldEndDate),
                                const SizedBox(height: 6),
                                _DateButton(
                                  label: _endDate != null ? _fmt(_endDate!) : '—',
                                  onTap: () => _pickEnd(context),
                                  p: p,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _Label(l.newTripFieldBudget),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _budgetCtrl,
                        style: TmType.body(color: p.fg),
                        decoration: _inputDeco(p, hint: l.newTripFieldBudgetHint),
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.done,
                      ),
                      const SizedBox(height: 20),
                      _Label(l.newTripFieldCover),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          for (var i = 0; i < _gradients.length; i++) ...[
                            if (i > 0) const SizedBox(width: 8),
                            GestureDetector(
                              onTap: () => setState(() => _coverIndex = i),
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: _gradients[i],
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: _coverIndex == i ? p.accent : Colors.transparent,
                                    width: 2.5,
                                  ),
                                  boxShadow: _coverIndex == i
                                      ? [
                                          BoxShadow(
                                            color: p.accent.withValues(alpha: 0.35),
                                            blurRadius: 6,
                                          )
                                        ]
                                      : null,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 32),
                      TmButton(
                        fullWidth: true,
                        onPressed: _submit,
                        child: Text(l.newTripButtonCreate),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);

  @override
  Widget build(BuildContext context) {
    final p = TmPalette.of(context);
    return Text(
      text,
      style: TmType.body(color: p.fg, weight: FontWeight.w500).copyWith(fontSize: 13),
    );
  }
}

class _DateButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final TmPalette p;
  const _DateButton({required this.label, required this.onTap, required this.p});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: p.surf,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: p.border),
        ),
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            Icon(Icons.calendar_today_outlined, size: 14, color: p.muted),
            const SizedBox(width: 8),
            Text(label, style: TmType.mono(color: label == '—' ? p.muted : p.fg, size: 13)),
          ],
        ),
      ),
    );
  }
}
