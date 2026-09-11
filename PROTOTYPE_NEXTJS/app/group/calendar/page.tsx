"use client";

import { useEffect, useState, Suspense } from "react";
import { useRouter, useSearchParams } from "next/navigation";
import AirmailHeader from "@/components/AirmailHeader";
import {
  fetchGroupAvailability,
  confirmAndSyncCalendars,
  MemberAvailability,
} from "@/lib/mockCalendarService";

function CalendarContent() {
  const router = useRouter();
  const params = useSearchParams();
  const tripId = params.get("tripId") ?? "trip_9f2a";
  const [members, setMembers] = useState<MemberAvailability[]>([]);
  const [confirming, setConfirming] = useState(false);
  const [synced, setSynced] = useState<number | null>(null);

  useEffect(() => {
    fetchGroupAvailability().then(setMembers);
  }, []);

  async function handleConfirm() {
    setConfirming(true);
    const result = await confirmAndSyncCalendars();
    setSynced(result.synced);
    setConfirming(false);
  }

  return (
    <>
      <AirmailHeader />
      <div className="flex items-center px-2 pt-1">
        <button onClick={() => router.back()} className="p-2 text-ink" aria-label="Back">
          ←
        </button>
      </div>
      <div className="flex-1 p-6 pt-1">
        <p className="font-mono text-[11px] font-bold uppercase tracking-widest text-rust">
          Oct 14 – Oct 21
        </p>
        <h2 className="mt-1 font-display text-2xl font-medium text-ink">
          Who&apos;s actually free?
        </h2>
        <p className="text-sm text-inkSoft">
          Checks everyone&apos;s Google Calendar for these dates before you lock them in.
        </p>

        <div className="mt-5 space-y-2.5">
          {members.length === 0 && <p className="text-sm text-inkSoft">Checking calendars…</p>}
          {members.map((m) => (
            <div
              key={m.name}
              className="flex items-center gap-3 rounded-lg border-[1.5px] border-ink bg-cream px-3.5 py-3"
            >
              <span className="flex h-9 w-9 flex-shrink-0 items-center justify-center rounded-full bg-pine font-mono text-[11px] text-cream">
                {m.initial}
              </span>
              <div className="flex-1">
                <p className="text-[13px] font-bold text-ink">{m.name}</p>
                {!m.connected ? (
                  <button className="mt-0.5 font-mono text-[9.5px] uppercase text-rust underline">
                    Connect Google Calendar
                  </button>
                ) : m.busySlots.length === 0 ? (
                  <p className="text-[11.5px] text-pine">Free the whole trip ✓</p>
                ) : (
                  <p className="text-[11.5px] text-rust">Busy: {m.busySlots.join(", ")}</p>
                )}
              </div>
            </div>
          ))}
        </div>

        {synced !== null && (
          <div className="mt-4 rounded-lg bg-pine px-3.5 py-3 text-center">
            <p className="text-[12.5px] font-bold text-cream">
              Trip added to {synced} connected calendar{synced === 1 ? "" : "s"} ✓
            </p>
          </div>
        )}
      </div>
      <div className="p-6 pt-0">
        <button
          onClick={synced !== null ? () => router.push(`/group/voting?tripId=${tripId}`) : handleConfirm}
          disabled={confirming}
          className="w-full rounded-md bg-rust px-5 py-4 font-mono text-[13px] uppercase tracking-wide text-cream disabled:opacity-50"
        >
          {confirming
            ? "Syncing…"
            : synced !== null
            ? "Continue →"
            : "Confirm dates & sync calendars"}
        </button>
      </div>
    </>
  );
}

export default function GroupCalendarPage() {
  return (
    <Suspense fallback={<p className="p-6 text-inkSoft">Loading…</p>}>
      <CalendarContent />
    </Suspense>
  );
}
