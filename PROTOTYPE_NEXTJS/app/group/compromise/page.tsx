"use client";

import { useEffect, useState, Suspense } from "react";
import { useRouter, useSearchParams } from "next/navigation";
import AirmailHeader from "@/components/AirmailHeader";
import { fetchCompromise, CompromiseResult } from "@/lib/mockGroupService";

function CompromiseContent() {
  const router = useRouter();
  const params = useSearchParams();
  const tripId = params.get("tripId") ?? "trip_9f2a";
  const [result, setResult] = useState<CompromiseResult | null>(null);
  const [applying, setApplying] = useState(false);

  useEffect(() => {
    fetchCompromise().then(setResult);
  }, []);

  async function apply() {
    setApplying(true);
    await new Promise((r) => setTimeout(r, 400));
    router.push(`/trip?tripId=${tripId}`);
  }

  if (!result) return <p className="p-6 text-inkSoft">Loading…</p>;

  return (
    <>
      <AirmailHeader />
      <div className="flex items-center px-2 pt-1">
        <button onClick={() => router.back()} className="p-2 text-ink" aria-label="Back">
          ←
        </button>
      </div>
      <div className="flex-1 p-6 pt-1 text-center">
        <div className="mx-auto flex h-[60px] w-[60px] items-center justify-center rounded-full border-[1.5px] border-rustDark bg-rust text-center font-mono text-[11px] text-cream">
          MATCH
          <br />
          FOUND
        </div>
        <h2 className="mt-3.5 font-display text-2xl font-medium text-ink">
          We found a compromise
        </h2>
        <p className="text-sm text-inkSoft">Split across your remaining days.</p>

        <div className="mt-5 flex gap-2.5">
          <StatBox big={result.majority_pick.voter_count} label="Museum mornings" />
          <StatBox big={result.minority_pick.voter_count} label="Beach afternoon" />
        </div>

        <div className="mt-4 space-y-2.5 text-left">
          <ResultCard
            title={`Day ${result.majority_pick.day} — ${result.majority_pick.title}`}
            subtitle={`Preferred by ${result.majority_pick.voter_count} of 4 voters`}
          />
          <ResultCard
            title={`Day ${result.minority_pick.day} — ${result.minority_pick.title}`}
            subtitle={`Preferred by ${result.minority_pick.voter_count} of 4 voters`}
          />
        </div>

        <button
          onClick={apply}
          disabled={applying}
          className="mt-6 w-full rounded-md bg-rust px-5 py-4 font-mono text-[13px] uppercase tracking-wide text-cream disabled:opacity-50"
        >
          {applying ? "Applying…" : "Apply to itinerary"}
        </button>
      </div>
    </>
  );
}

function StatBox({ big, label }: { big: number; label: string }) {
  return (
    <div className="flex-1 rounded-lg border-[1.5px] border-ink bg-cream py-3.5">
      <p className="font-display text-2xl font-semibold text-ink">{big}</p>
      <p className="font-mono text-[9.5px] uppercase text-inkSoft">{label}</p>
    </div>
  );
}

function ResultCard({ title, subtitle }: { title: string; subtitle: string }) {
  return (
    <div className="rounded-lg border-[1.5px] border-ink bg-cream px-3.5 py-3">
      <p className="text-[13.5px] font-bold text-ink">{title}</p>
      <p className="text-[11.5px] text-inkSoft">{subtitle}</p>
    </div>
  );
}

export default function CompromisePage() {
  return (
    <Suspense fallback={<p className="p-6 text-inkSoft">Loading…</p>}>
      <CompromiseContent />
    </Suspense>
  );
}
