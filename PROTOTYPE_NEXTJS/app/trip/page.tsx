"use client";

import { useEffect, useState, Suspense } from "react";
import { useSearchParams } from "next/navigation";
import Link from "next/link";
import AirmailHeader from "@/components/AirmailHeader";
import BottomNav from "@/components/BottomNav";
import { getTrip, Trip } from "@/lib/mockOnboardingService";

function TripContent() {
  const params = useSearchParams();
  const tripId = params.get("tripId") ?? "trip_9f2a";
  const tripType = (params.get("tripType") as "solo" | "group") ?? "solo";
  const [trip, setTrip] = useState<Trip | null>(null);

  useEffect(() => {
    getTrip(tripId, tripType).then(setTrip);
  }, [tripId, tripType]);

  if (!trip) return <p className="p-6 text-inkSoft">Loading…</p>;

  return (
    <>
      <AirmailHeader />
      <div className="flex-1 overflow-y-auto p-6">
        <div className="flex items-center justify-between">
          <p className="font-mono text-[11px] font-bold uppercase tracking-widest text-rust">
            {trip.destination} · trip plan
          </p>
          {/* DEMO ONLY — in production this screen opens via a push
              notification, not a button. Kept here only so the flow is
              reachable without a real disruption-detection backend yet. */}
          <div className="flex items-center gap-3">
            <Link href={`/trip/checklist?tripId=${tripId}`} title="Your checklist" className="text-ink">
              ✅
            </Link>
            <Link href={`/trip/offline?tripId=${tripId}`} title="Download offline copy (PDF)" className="text-ink">
              📄
            </Link>
            <Link
              href={`/trip/disruption?tripId=${tripId}`}
              title="Simulate a disruption (demo only)"
              className="text-rust"
            >
              🔔
            </Link>
            <Link
              href="/profile"
              title="Profile & my trips"
              className="flex h-7 w-7 items-center justify-center rounded-full bg-pine font-mono text-[11px] text-cream"
            >
              M
            </Link>
          </div>
        </div>
        <h2 className="mt-1 font-display text-2xl font-medium text-ink">Your trip</h2>

        <div className="relative mt-5 pl-5">
          <div className="absolute bottom-1.5 left-[5px] top-1.5 w-[1.5px] bg-line" />
          {trip.days[0].activities.map((a) => (
            <Link
              key={a.id}
              href={`/trip/activity?tripId=${tripId}&title=${encodeURIComponent(a.title)}&cost=${a.cost_usd}&time=${encodeURIComponent(a.time)}`}
              className="relative mb-4 block"
            >
              <span className="absolute -left-5 top-1 h-2.5 w-2.5 rounded-full border-2 border-cream bg-rust" />
              <p className="font-mono text-[10px] text-inkSoft">{a.time}</p>
              <div className="mt-0.5 rounded-lg border-[1.5px] border-ink bg-cream px-3.5 py-3">
                <p className="text-sm font-bold text-ink">{a.title}</p>
                <p className="text-[11.5px] text-inkSoft">
                  {a.cost_usd === 0 ? "Free" : `$${a.cost_usd}`}
                </p>
              </div>
            </Link>
          ))}
        </div>
      </div>
      <BottomNav tripId={tripId} />
    </>
  );
}

export default function TripPage() {
  return (
    <Suspense fallback={<p className="p-6 text-inkSoft">Loading…</p>}>
      <TripContent />
    </Suspense>
  );
}
