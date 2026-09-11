"use client";

import { useState, Suspense } from "react";
import { useRouter, useSearchParams } from "next/navigation";
import AirmailHeader from "@/components/AirmailHeader";
import { logExpense } from "@/lib/mockBudgetService";

const CATEGORIES = [
  { id: "food_drink", label: "Food & drink" },
  { id: "transport", label: "Transport" },
  { id: "lodging", label: "Lodging" },
  { id: "activity", label: "Activity" },
];
const PEOPLE = [
  { id: "u_01", label: "Maya" },
  { id: "u_02", label: "Jake" },
  { id: "u_03", label: "Rosa" },
];

function LogExpenseContent() {
  const router = useRouter();
  const params = useSearchParams();
  const tripId = params.get("tripId") ?? "trip_9f2a";
  const [amount, setAmount] = useState(42);
  const [category, setCategory] = useState("food_drink");
  const [splitAmong, setSplitAmong] = useState<string[]>(["u_01", "u_02", "u_03"]);
  const [saving, setSaving] = useState(false);

  function toggleSplit(id: string) {
    setSplitAmong((prev) => (prev.includes(id) ? prev.filter((p) => p !== id) : [...prev, id]));
  }

  async function handleSave() {
    setSaving(true);
    await logExpense(amount, category, "u_01", splitAmong);
    router.push(`/trip/budget?tripId=${tripId}`);
  }

  return (
    <>
      <AirmailHeader />
      <div className="flex items-center justify-between px-2 pt-1">
        <button onClick={() => router.back()} className="p-2 text-ink" aria-label="Close">
          ✕
        </button>
        <p className="font-mono text-[11px] font-bold uppercase tracking-widest text-rust">
          New expense
        </p>
        <span className="w-9" />
      </div>
      <div className="flex-1 p-6 pt-2">
        <div className="text-center">
          <span className="align-top font-display text-2xl text-inkSoft">$</span>
          <span className="font-display text-5xl font-semibold text-ink">{amount}</span>
          <input
            type="range"
            min={0}
            max={500}
            value={amount}
            onChange={(e) => setAmount(Number(e.target.value))}
            className="mt-2 w-full accent-rust"
          />
        </div>

        <p className="mt-2 font-mono text-[10px] uppercase tracking-wide text-inkSoft">Category</p>
        <div className="mt-2 flex flex-wrap gap-2">
          {CATEGORIES.map((c) => (
            <button
              key={c.id}
              onClick={() => setCategory(c.id)}
              className={`rounded-full border-[1.5px] px-3.5 py-2 text-xs font-bold ${
                category === c.id ? "border-pine bg-pine text-cream" : "border-ink bg-cream text-ink"
              }`}
            >
              {c.label}
            </button>
          ))}
        </div>

        <p className="mt-3.5 font-mono text-[10px] uppercase tracking-wide text-inkSoft">Split among</p>
        <div className="mt-2 flex flex-wrap gap-2">
          {PEOPLE.map((p) => (
            <button
              key={p.id}
              onClick={() => toggleSplit(p.id)}
              className={`rounded-full border-[1.5px] px-3.5 py-2 text-xs font-bold ${
                splitAmong.includes(p.id) ? "border-pine bg-pine text-cream" : "border-ink bg-cream text-ink"
              }`}
            >
              {p.label}
            </button>
          ))}
        </div>
      </div>
      <div className="p-6 pt-0">
        <button
          onClick={handleSave}
          disabled={saving || splitAmong.length === 0}
          className="w-full rounded-md bg-rust px-5 py-4 font-mono text-[13px] uppercase tracking-wide text-cream disabled:opacity-50"
        >
          {saving ? "Logging…" : "Log expense"}
        </button>
      </div>
    </>
  );
}

export default function LogExpensePage() {
  return (
    <Suspense fallback={<p className="p-6 text-inkSoft">Loading…</p>}>
      <LogExpenseContent />
    </Suspense>
  );
}
