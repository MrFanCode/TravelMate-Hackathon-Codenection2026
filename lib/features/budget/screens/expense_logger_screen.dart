import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/airmail_stripe.dart';
import '../../../core/widgets/primary_button.dart';
import '../providers/budget_provider.dart';

/// Screen 11 — Expense Logger. Modal-style (X to close), not a nav-bar tab.
class ExpenseLoggerScreen extends ConsumerStatefulWidget {
  final String tripId;
  const ExpenseLoggerScreen({super.key, required this.tripId});

  @override
  ConsumerState<ExpenseLoggerScreen> createState() => _ExpenseLoggerScreenState();
}

class _ExpenseLoggerScreenState extends ConsumerState<ExpenseLoggerScreen> {
  double _amount = 42;
  String _category = 'food_drink';
  final Set<String> _splitAmong = {'u_01', 'u_02', 'u_03'};
  static const _paidBy = 'u_01'; // "you" — matches the mock member list

  static const _categories = [
    {'id': 'food_drink', 'label': 'Food & drink'},
    {'id': 'transport', 'label': 'Transport'},
    {'id': 'lodging', 'label': 'Lodging'},
    {'id': 'activity', 'label': 'Activity'},
  ];

  static const _people = [
    {'id': 'u_01', 'label': 'Maya'},
    {'id': 'u_02', 'label': 'Jake'},
    {'id': 'u_03', 'label': 'Rosa'},
  ];

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(budgetProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const AirmailStripe(),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 4, 24, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    icon: const Icon(Icons.close, color: AppColors.ink),
                  ),
                  Text('New expense', style: AppTextStyles.eyebrow),
                  const SizedBox(width: 48),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Text('\$', style: AppTextStyles.displayMedium.copyWith(fontSize: 24, color: AppColors.inkSoft)),
                              ),
                              Text('${_amount.round()}', style: AppTextStyles.displayMedium.copyWith(fontSize: 52)),
                            ],
                          ),
                          Slider(
                            value: _amount,
                            min: 0,
                            max: 500,
                            activeColor: AppColors.rust,
                            inactiveColor: AppColors.line,
                            onChanged: (v) => setState(() => _amount = v),
                          ),
                        ],
                      ),
                    ),
                    Text('Category', style: AppTextStyles.label),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _categories.map((c) {
                        final selected = _category == c['id'];
                        return _chip(c['label']!, selected, () => setState(() => _category = c['id']!));
                      }).toList(),
                    ),
                    const SizedBox(height: 14),
                    Text('Split among', style: AppTextStyles.label),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _people.map((p) {
                        final selected = _splitAmong.contains(p['id']);
                        return _chip(p['label']!, selected, () {
                          setState(() {
                            selected ? _splitAmong.remove(p['id']) : _splitAmong.add(p['id']!);
                          });
                        });
                      }).toList(),
                    ),
                    const Spacer(),
                    PrimaryButton(
                      label: state.isLoggingExpense ? 'Logging…' : 'Log expense',
                      onPressed: state.isLoggingExpense || _splitAmong.isEmpty
                          ? null
                          : () async {
                              await ref.read(budgetProvider).logExpense(
                                    tripId: widget.tripId,
                                    amountUsd: _amount,
                                    category: _category,
                                    paidBy: _paidBy,
                                    splitAmong: _splitAmong.toList(),
                                  );
                              if (context.mounted) Navigator.of(context).maybePop();
                            },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chip(String label, bool selected, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.pine : AppColors.cream,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: selected ? AppColors.pine : AppColors.ink, width: 1.5),
        ),
        child: Text(
          label,
          style: AppTextStyles.bodyStrong.copyWith(fontSize: 12, color: selected ? AppColors.cream : AppColors.ink),
        ),
      ),
    );
  }
}
