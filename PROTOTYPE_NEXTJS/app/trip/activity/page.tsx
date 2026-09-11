"use client";

import { Suspense } from "react";
import { useRouter, useSearchParams } from "next/navigation";
import AirmailHeader from "@/components/AirmailHeader";

function ActivityContent() {
  const router = useRouter();
  const params = useSearchParams();
  const title = params.get("title") ?? "Activity";
  const time = params.get("time") ?? "";
  const cost = Number(params.get("cost") ?? 0);

  return (
    <>
      <AirmailHeader />
      <div className="flex items-center px-2 pt-1">
        <button onClick={() => router.back()} className="p-2 text-ink" aria-label="Back">
          ←
        </button>
      </div>
      <div className="flex-1 p-6 pt-1">
        <div
          className="h-[170px] w-full rounded-xl border-[1.5px] border-ink"
          style={{ background: "linear-gradient(135deg, #D89B34, #B84A2E, #3B5C4C)" }}
        />
        <h2 className="mt-3.5 font-display text-2xl font-medium text-ink">{title}</h2>
        <div className="mt-2.5 flex flex-wrap gap-2">
          <Tag>{time}</Tag>
          <Tag>{cost === 0 ? "Free" : `$${cost}`}</Tag>
          <Tag>Lisbon</Tag>
        </div>
        <p className="mt-3 text-sm leading-relaxed text-inkSoft">
          Part of your AI-built itinerary — swap it out anytime from the Map tab,
          or remove it below.
        </p>
      </div>
      <div className="flex gap-2.5 p-6 pt-0">
        <button
          onClick={() => router.back()}
          className="flex-1 rounded-lg border-[1.5px] border-ink bg-transparent py-3.5 font-semibold text-ink"
        >
          Remove
        </button>
        <button
          onClick={() => router.back()}
          className="flex-1 rounded-lg bg-rust py-3.5 font-mono text-[13px] uppercase text-cream"
        >
          Keep in day
        </button>
      </div>
    </>
  );
}

function Tag({ children }: { children: React.ReactNode }) {
  return (
    <span className="rounded-full border-[1.5px] border-ink bg-cream px-2.5 py-1.5 font-mono text-[10.5px] text-ink">
      {children}
    </span>
  );
}

export default function ActivityPage() {
  return (
    <Suspense fallback={<p className="p-6 text-inkSoft">Loading…</p>}>
      <ActivityContent />
    </Suspense>
  );
}
