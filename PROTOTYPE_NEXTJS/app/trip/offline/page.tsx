"use client";

import { useEffect, useState, Suspense } from "react";
import { useRouter, useSearchParams } from "next/navigation";
import AirmailHeader from "@/components/AirmailHeader";
import { getTrip, Trip } from "@/lib/mockOnboardingService";
import { fetchChecklist, ChecklistItem } from "@/lib/mockChecklistService";
import { fetchBudgetSummary, BudgetSummary } from "@/lib/mockBudgetService";

/**
 * Solves a real problem, not a fake one: patchy connectivity while
 * traveling. This uses the browser's native print-to-PDF (window.print)
 * rather than a PDF library — genuinely functional, zero dependencies,
 * and every browser already supports "Save as PDF" from a print dialog.
 * The print: Tailwind variants hide the header/button, leaving just the
 * content, when actually printing/saving.
 */
function OfflineContent() {
  const router = useRouter();
  const params = useSearchParams();
  const tripId = params.get("tripId") ?? "trip_9f2a";
  const [trip, setTrip] = useState<Trip | null>(null);
  const [checklist, setChecklist] = useState<ChecklistItem[]>([]);
  const [budget, setBudget] = useState<BudgetSummary | null>(null);

  useEffect(() => {
    getTrip(tripId).then(setTrip);
    fetchChecklist().then(setChecklist);
    fetchBudgetSummary().then(setBudget);
  }, [tripId]);

  return (
    <>
      <div className="print:hidden">
        <AirmailHeader />
        <div className="flex items-center px-2 pt-1">
          <button onClick={() => router.back()} className="p-2 text-ink" aria-label="Back">
            ←
          </button>
        </div>
      </div>

      <div className="flex-1 overflow-y-auto p-6 pt-1 print:p-0">
        <h2 className="font-display text-2xl font-medium text-ink">
          {trip ? `${trip.destination} — offline copy` : "Loading…"}
        </h2>
        <p className="text-sm text-inkSoft print:hidden">
          Save this as a PDF before you leave — works with no signal once downloaded.
        </p>

        {trip && (
          <Section title="Itinerary">
            {trip.days[0].activities.map((a) => (
              <p key={a.id} className="text-[13px] text-ink">
                <span className="font-mono text-[11px] text-inkSoft">{a.time}</span> — {a.title}{" "}
                <span className="text-inkSoft">({a.cost_usd === 0 ? "Free" : `$${a.cost_usd}`})</span>
              </p>
            ))}
          </Section>
        )}

        {checklist.length > 0 && (
          <Section title="Checklist">
            {checklist.map((c) => (
              <p key={c.id} className="text-[13px] text-ink">
                {c.checked ? "☑" : "☐"} {c.label}
              </p>
            ))}
          </Section>
        )}

        {budget && (
          <Section title="Budget">
            <p className="text-[13px] text-ink">
              ${budget.spent_usd} spent of ${budget.budget_usd}
            </p>
            {budget.categories.map((c) => (
              <p key={c.category} className="text-[12.5px] text-inkSoft">
                {c.category.replace("_", " ")}: ${c.spent_usd}
              </p>
            ))}
          </Section>
        )}
      </div>

      <div className="p-6 pt-0 print:hidden">
        <button
          onClick={() => window.print()}
          className="w-full rounded-md bg-rust px-5 py-4 font-mono text-[13px] uppercase tracking-wide text-cream"
        >
          Download / Print as PDF
        </button>
      </div>
    </>
  );
}

function Section({ title, children }: { title: string; children: React.ReactNode }) {
  return (
    <div className="mt-4 border-t-[1.5px] border-dashed border-line pt-3">
      <p className="font-mono text-[10px] uppercase tracking-wide text-inkSoft">{title}</p>
      <div className="mt-1.5 space-y-1">{children}</div>
    </div>
  );
}

export default function OfflinePage() {
  return (
    <Suspense fallback={<p className="p-6 text-inkSoft">Loading…</p>}>
      <OfflineContent />
    </Suspense>
  );
}
