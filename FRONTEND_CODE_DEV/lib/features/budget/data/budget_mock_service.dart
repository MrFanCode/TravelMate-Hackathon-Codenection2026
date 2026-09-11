import '../models/budget_models.dart';

/// Stands in for the backend. Shapes match budget-api-contract.md.
class BudgetMockService {
  final List<Expense> _expenses = [
    Expense(id: 'exp_01', amountUsd: 180, category: 'food_drink', paidBy: 'u_01', splitAmong: ['u_01', 'u_02', 'u_03']),
    Expense(id: 'exp_02', amountUsd: 220, category: 'lodging', paidBy: 'u_01', splitAmong: ['u_01', 'u_02', 'u_03']),
    Expense(id: 'exp_03', amountUsd: 95, category: 'activity', paidBy: 'u_02', splitAmong: ['u_01', 'u_02', 'u_03']),
    Expense(id: 'exp_04', amountUsd: 45, category: 'transport', paidBy: 'u_03', splitAmong: ['u_01', 'u_02', 'u_03']),
  ];

  Future<Expense> logExpense({
    required double amountUsd,
    required String category,
    required String paidBy,
    required List<String> splitAmong,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final expense = Expense(
      id: 'exp_${DateTime.now().millisecondsSinceEpoch}',
      amountUsd: amountUsd,
      category: category,
      paidBy: paidBy,
      splitAmong: splitAmong,
    );
    _expenses.add(expense);
    return expense;
  }

  Future<BudgetSummary> fetchBudgetSummary(String tripId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final byCategory = <String, double>{};
    for (final e in _expenses) {
      byCategory[e.category] = (byCategory[e.category] ?? 0) + e.amountUsd;
    }
    final spent = _expenses.fold<double>(0, (sum, e) => sum + e.amountUsd);
    return BudgetSummary(
      budgetUsd: 750,
      spentUsd: spent,
      categories: byCategory.entries.map((e) => CategorySpend(category: e.key, spentUsd: e.value)).toList(),
    );
  }

  Future<SettleUp> fetchSettleUp(String tripId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    // Mocked — matches the HTML design example exactly.
    return SettleUp(
      balances: [
        Balance(fromUserId: 'u_02', fromName: 'Jake', toUserId: 'u_01', toName: 'Maya', amountUsd: 64),
        Balance(fromUserId: 'u_03', fromName: 'Rosa', toUserId: 'u_01', toName: 'Maya', amountUsd: 38),
      ],
      yourNetUsd: 102,
    );
  }

  Future<void> notifySettleUp(String tripId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    // mock — real backend triggers FCM push per balance
  }
}
