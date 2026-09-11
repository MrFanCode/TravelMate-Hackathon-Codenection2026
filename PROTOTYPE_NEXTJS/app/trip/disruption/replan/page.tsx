"use client";

import { useEffect, useState, Suspense } from "react";
import { useRouter, useSearchParams } from "next/navigation";
import AirmailHeader from "@/components/AirmailHeader";
import { requestReplan, ReplanDiff } from "@/lib/mockDisruptionService";

function ReplanContent() {
  const router = useRouter();
  const params = useSearchParams();
  const tripId = params.get("tripId") ?? "trip_9f2a";
  const [diff, setDiff] = useState<ReplanDiff | null>(null);
  const [accepting, setAccepting] = useState(false);

  useEffect(() => {
    requestReplan().then(setDiff);
  }, []);

  async function handleAccept() {
    setAccepting(true);
    await new Promise((r) => setTimeout(r, 300));
    router.push(`/trip?tripId=${tripId}`);
  }

  if (!diff) return <p className="p-6 text-inkSoft">Loading…</p>;

  return (
    <>
      <AirmailHeader />
      <div className="flex items-center justify-between px-2 pt-1">
        <button onClick={() => router.back()} className="p-2 text-ink" aria-label="Back">
          ←
        </button>
        <div className="mr-2 flex h-9 w-9 items-center justify-center rounded-full border-[1.5px] border-rustDark bg-rust text-center font-mono text-[6px] text-cream">
          NEW
          <br />
          PLAN
        </div>
      </div>
      <div className="flex-1 overflow-y-auto p-6 pt-1">
        <h2 className="font-display text-2xl font-medium text-ink">Day {diff.day} — updated</h2>
        <p className="text-sm text-inkSoft">Adjusted around your new landing time.</p>

        <div className="mt-4 space-y-2.5">
          {diff.removed.map((d, i) => (
            <DiffRow key={`r${i}`} time={d.time} title={d.title} variant="removed" />
          ))}
          {diff.added.map((d, i) => (
            <DiffRow key={`a${i}`} time={d.time} title={d.title} variant="added" />
          ))}
          <DiffRow time="next" title={diff.unchanged_note} variant="normal" />
        </div>
      </div>
      <div className="p-6 pt-0">
        <button
          onClick={handleAccept}
          disabled={accepting}
          className="w-full rounded-md bg-rust px-5 py-4 font-mono text-[13px] uppercase tracking-wide text-cream disabled:opacity-50"
        >
          {accepting ? "Applying…" : "Accept new plan"}
        </button>
      </div>
    </>
  );
}

function DiffRow({ time, title, variant }: { time: string; title: string; variant: "removed" | "added" | "normal" }) {
  return (
    <div
      className={`flex items-center gap-2.5 rounded-lg border-[1.5px] px-3 py-2.5 ${
        variant === "added" ? "border-pine bg-[#EAF0EA]" : "border-ink bg-cream"
      } ${variant === "removed" ? "opacity-50" : ""}`}
    >
      <span className="w-[46px] flex-shrink-0 font-mono text-[10px] text-inkSoft">{time}</span>
      <span className={`text-[12.5px] font-bold text-ink ${variant === "removed" ? "line-through" : ""}`}>
        {title}
      </span>
    </div>
  );
}

export default function ReplanPage() {
  return (
    <Suspense fallback={<p className="p-6 text-inkSoft">Loading…</p>}>
      <ReplanContent />
    </Suspense>
  );
}
