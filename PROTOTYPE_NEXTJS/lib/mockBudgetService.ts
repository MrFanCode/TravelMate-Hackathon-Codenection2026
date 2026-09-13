/** Mirrors budget-api-contract.md */

export type Expense = {
  id: string;
  amount_usd: number;
  category: string;
  paid_by: string;
  split_among: string[];
};

let expenses: Expense[] = [
  { id: "exp_01", amount_usd: 180, category: "food_drink", paid_by: "u_01", split_among: ["u_01", "u_02", "u_03"] },
  { id: "exp_02", amount_usd: 220, category: "lodging", paid_by: "u_01", split_among: ["u_01", "u_02", "u_03"] },
  { id: "exp_03", amount_usd: 95, category: "activity", paid_by: "u_02", split_among: ["u_01", "u_02", "u_03"] },
  { id: "exp_04", amount_usd: 45, category: "transport", paid_by: "u_03", split_among: ["u_01", "u_02", "u_03"] },
];

export async function logExpense(amountUsd: number, category: string, paidBy: string, splitAmong: string[]) {
  await new Promise((r) => setTimeout(r, 300));
  const expense: Expense = {
    id: `exp_${Date.now()}`,
    amount_usd: amountUsd,
    category,
    paid_by: paidBy,
    split_among: splitAmong,
  };
  expenses.push(expense);
  return expense;
}

export type BudgetSummary = {
  budget_usd: number;
  spent_usd: number;
  categories: { category: string; spent_usd: number }[];
};

export async function fetchBudgetSummary(): Promise<BudgetSummary> {
  await new Promise((r) => setTimeout(r, 300));
  const byCategory = new Map<string, number>();
  for (const e of expenses) {
    byCategory.set(e.category, (byCategory.get(e.category) ?? 0) + e.amount_usd);
  }
  const spent = expenses.reduce((sum, e) => sum + e.amount_usd, 0);
  return {
    budget_usd: 750,
    spent_usd: spent,
    categories: Array.from(byCategory.entries()).map(([category, spent_usd]) => ({ category, spent_usd })),
  };
}

export type Balance = { from_name: string; to_name: string; amount_usd: number };

export async function fetchSettleUp(): Promise<{ balances: Balance[]; your_net_usd: number }> {
  await new Promise((r) => setTimeout(r, 300));
  return {
    balances: [
      { from_name: "Jake", to_name: "Maya", amount_usd: 64 },
      { from_name: "Rosa", to_name: "Maya", amount_usd: 38 },
    ],
    your_net_usd: 102,
  };
}
