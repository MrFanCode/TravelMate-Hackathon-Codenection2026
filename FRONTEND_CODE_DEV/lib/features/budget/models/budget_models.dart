/// Matches budget-api-contract.md.
class Expense {
  final String id;
  final double amountUsd;
  final String category;
  final String paidBy;
  final List<String> splitAmong;

  Expense({
    required this.id,
    required this.amountUsd,
    required this.category,
    required this.paidBy,
    required this.splitAmong,
  });

  factory Expense.fromJson(Map<String, dynamic> json) => Expense(
        id: json['id'],
        amountUsd: (json['amount_usd'] as num).toDouble(),
        category: json['category'],
        paidBy: json['paid_by'],
        splitAmong: List<String>.from(json['split_among']),
      );
}

class CategorySpend {
  final String category;
  final double spentUsd;

  CategorySpend({required this.category, required this.spentUsd});

  factory CategorySpend.fromJson(Map<String, dynamic> json) => CategorySpend(
        category: json['category'],
        spentUsd: (json['spent_usd'] as num).toDouble(),
      );
}

class BudgetSummary {
  final double budgetUsd;
  final double spentUsd;
  final List<CategorySpend> categories;

  BudgetSummary({required this.budgetUsd, required this.spentUsd, required this.categories});

  factory BudgetSummary.fromJson(Map<String, dynamic> json) => BudgetSummary(
        budgetUsd: (json['budget_usd'] as num).toDouble(),
        spentUsd: (json['spent_usd'] as num).toDouble(),
        categories: (json['categories'] as List).map((c) => CategorySpend.fromJson(c)).toList(),
      );

  double get ratio => budgetUsd == 0 ? 0 : (spentUsd / budgetUsd).clamp(0, 1);
}

class Balance {
  final String fromUserId;
  final String fromName;
  final String toUserId;
  final String toName;
  final double amountUsd;

  Balance({
    required this.fromUserId,
    required this.fromName,
    required this.toUserId,
    required this.toName,
    required this.amountUsd,
  });

  factory Balance.fromJson(Map<String, dynamic> json) => Balance(
        fromUserId: json['from_user_id'],
        fromName: json['from_name'],
        toUserId: json['to_user_id'],
        toName: json['to_name'],
        amountUsd: (json['amount_usd'] as num).toDouble(),
      );
}

class SettleUp {
  final List<Balance> balances;
  final double yourNetUsd;

  SettleUp({required this.balances, required this.yourNetUsd});

  factory SettleUp.fromJson(Map<String, dynamic> json) => SettleUp(
        balances: (json['balances'] as List).map((b) => Balance.fromJson(b)).toList(),
        yourNetUsd: (json['your_net_usd'] as num).toDouble(),
      );
}
