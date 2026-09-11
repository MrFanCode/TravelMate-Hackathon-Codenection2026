"use client";

import { useEffect, useState, Suspense } from "react";
import { useRouter, useSearchParams } from "next/navigation";
import Link from "next/link";
import AirmailHeader from "@/components/AirmailHeader";
import BottomNav from "@/components/BottomNav";
import { fetchBudgetSummary, BudgetSummary } from "@/lib/mockBudgetService";

const CATEGORY_LABELS: Record<string, string> = {
  food_drink: "Food",
  lodging: "Lodging",
  activity: "Activities",
  transport: "Transport",
};
const CATEGORY_COLORS: Record<string, string> = {
  food_drink: "#B84A2E",
  lodging: "#3B5C4C",
  activity: "#D89B34",
  transport: "#5B5142",
};

function BudgetContent() {
  const router = useRouter();
  const params = useSearchParams();
  const tripId = params.get("tripId") ?? "trip_9f2a";
  const [summary, setSummary] = useState<BudgetSummary | null>(null);

  useEffect(() => {
    fetchBudgetSummary().then(setSummary);
  }, []);

  if (!summary) return <p className="p-6 text-inkSoft">Loading…</p>;

  const ratio = Math.min(summary.spent_usd / summary.budget_usd, 1);
  const maxSpend = Math.max(...summary.categories.map((c) => c.spent_usd));
  const circumference = 2 * Math.PI * 62;

  return (
    <>
      <AirmailHeader />
      <div className="flex-1 overflow-y-auto p-6">
        <p className="font-mono text-[11px] font-bold uppercase tracking-widest text-rust">
          Trip budget
        </p>
        <h2 className="mt-1 font-display text-2xl font-medium text-ink">
          ${summary.spent_usd} of ${summary.budget_usd}
        </h2>

        <div className="relative mx-auto mt-4 h-[150px] w-[150px]">
          <svg width="150" height="150" className="-rotate-90">
            <circle cx="75" cy="75" r="62" fill="none" stroke="#CBB98A" strokeWidth="12" />
            <circle
              cx="75"
              cy="75"
              r="62"
              fill="none"
              stroke="#B84A2E"
              strokeWidth="12"
              strokeDasharray={circumference}
              strokeDashoffset={circumference * (1 - ratio)}
              strokeLinecap="round"
            />
          </svg>
          <div className="absolute inset-0 flex flex-col items-center justify-center text-center">
            <span className="font-display text-2xl font-semibold text-ink">
              {Math.round(ratio * 100)}%
            </span>
            <span className="font-mono text-[9px] uppercase text-inkSoft">Spent</span>
          </div>
        </div>

        <div className="mt-2 space-y-3">
          {summary.categories.map((c) => (
            <div key={c.category} className="flex items-center gap-2.5">
              <span
                className="h-2.5 w-2.5 flex-shrink-0 rounded-full"
                style={{ background: CATEGORY_COLORS[c.category] }}
              />
              <span className="w-[74px] flex-shrink-0 text-xs font-bold text-ink">
                {CATEGORY_LABELS[c.category] ?? c.category}
              </span>
              <div className="h-1.5 flex-1 overflow-hidden rounded-full bg-line">
                <div
                  className="h-full"
                  style={{
                    width: `${(c.spent_usd / maxSpend) * 100}%`,
                    background: CATEGORY_COLORS[c.category],
                  }}
                />
              </div>
              <span className="font-mono text-[11px] text-inkSoft">${c.spent_usd}</span>
            </div>
          ))}
        </div>
      </div>

      <div className="flex gap-2.5 px-6 pb-2">
        <Link
          href={`/trip/budget/split?tripId=${tripId}`}
          className="flex-1 rounded-lg border-[1.5px] border-ink py-3 text-center font-semibold text-ink"
        >
          Settle up
        </Link>
        <Link
          href={`/trip/budget/log?tripId=${tripId}`}
          className="flex-1 rounded-lg bg-rust py-3 text-center font-mono text-[13px] uppercase text-cream"
        >
          + Log expense
        </Link>
      </div>
      <BottomNav tripId={tripId} />
    </>
  );
}

export default function BudgetPage() {
  return (
    <Suspense fallback={<p className="p-6 text-inkSoft">Loading…</p>}>
      <BudgetContent />
    </Suspense>
  );
}
