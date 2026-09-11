import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/budget_mock_service.dart';
import '../models/budget_models.dart';

class BudgetNotifier extends ChangeNotifier {
  final BudgetMockService _service = BudgetMockService();

  BudgetSummary? summary;
  bool isLoadingSummary = false;

  SettleUp? settleUp;
  bool isLoadingSettleUp = false;

  bool isLoggingExpense = false;

  Future<void> loadSummary(String tripId) async {
    isLoadingSummary = true;
    notifyListeners();
    summary = await _service.fetchBudgetSummary(tripId);
    isLoadingSummary = false;
    notifyListeners();
  }

  Future<void> loadSettleUp(String tripId) async {
    isLoadingSettleUp = true;
    notifyListeners();
    settleUp = await _service.fetchSettleUp(tripId);
    isLoadingSettleUp = false;
    notifyListeners();
  }

  Future<void> logExpense({
    required String tripId,
    required double amountUsd,
    required String category,
    required String paidBy,
    required List<String> splitAmong,
  }) async {
    isLoggingExpense = true;
    notifyListeners();
    await _service.logExpense(
      amountUsd: amountUsd,
      category: category,
      paidBy: paidBy,
      splitAmong: splitAmong,
    );
    isLoggingExpense = false;
    notifyListeners();
    // Refresh the summary so the overview screen reflects the new expense.
    await loadSummary(tripId);
  }

  Future<void> notifySettleUp(String tripId) async {
    await _service.notifySettleUp(tripId);
  }
}

final budgetProvider = ChangeNotifierProvider<BudgetNotifier>((ref) => BudgetNotifier());
