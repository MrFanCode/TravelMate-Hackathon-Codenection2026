"use client";

import { useEffect, useState, Suspense } from "react";
import { useRouter, useSearchParams } from "next/navigation";
import AirmailHeader from "@/components/AirmailHeader";
import { fetchLatestDisruption, requestReplan, Disruption } from "@/lib/mockDisruptionService";

function DisruptionContent() {
  const router = useRouter();
  const params = useSearchParams();
  const tripId = params.get("tripId") ?? "trip_9f2a";
  const [disruption, setDisruption] = useState<Disruption | null>(null);
  const [replanning, setReplanning] = useState(false);

  useEffect(() => {
    fetchLatestDisruption().then(setDisruption);
  }, []);

  async function handleReplan() {
    setReplanning(true);
    await requestReplan();
    router.push(`/trip/disruption/replan?tripId=${tripId}`);
  }

  if (!disruption) return <p className="p-6 text-inkSoft">Loading…</p>;

  return (
    <>
      <AirmailHeader />
      <div className="flex items-center px-2 pt-1">
        <button onClick={() => router.back()} className="p-2 text-ink" aria-label="Close">
          ✕
        </button>
      </div>
      <div className="flex-1 p-6 pt-1">
        <div className="flex gap-3 rounded-lg border-[1.5px] border-rustDark bg-rust p-4">
          <div className="flex h-[38px] w-[38px] flex-shrink-0 items-center justify-center rounded-full border-[1.5px] border-cream text-center font-mono text-[8px] text-cream">
            DELAY
            <br />
            3H
          </div>
          <div>
            <p className="font-display text-base font-semibold text-cream">{disruption.title}</p>
            <p className="mt-0.5 text-xs text-paper">{disruption.description}</p>
          </div>
        </div>

        <p className="mt-4 font-mono text-[10px] uppercase tracking-wide text-inkSoft">
          Affected today
        </p>
        <div className="mt-2 space-y-2.5">
          {disruption.affected_activities.map((a, i) => (
            <div key={i} className="rounded-lg border-[1.5px] border-ink bg-cream px-3.5 py-3">
              <p className="text-[13.5px] font-bold text-ink">{a.title}</p>
              <p className="text-[11.5px] text-inkSoft">{a.reason}</p>
            </div>
          ))}
        </div>
      </div>
      <div className="p-6 pt-0">
        <button
          onClick={handleReplan}
          disabled={replanning}
          className="w-full rounded-md bg-rust px-5 py-4 font-mono text-[13px] uppercase tracking-wide text-cream disabled:opacity-50"
        >
          {replanning ? "Replanning…" : "Replan this day →"}
        </button>
      </div>
    </>
  );
}

export default function DisruptionPage() {
  return (
    <Suspense fallback={<p className="p-6 text-inkSoft">Loading…</p>}>
      <DisruptionContent />
    </Suspense>
  );
}
