"use client";

import { Suspense } from "react";
import { useRouter, useSearchParams } from "next/navigation";
import AirmailHeader from "@/components/AirmailHeader";
import { resolveSos } from "@/lib/mockLocationService";

function SosContent() {
  const router = useRouter();
  const params = useSearchParams();
  const tripId = params.get("tripId") ?? "trip_9f2a";

  async function handleResolve() {
    await resolveSos();
    router.push(`/trip/map?tripId=${tripId}`);
  }

  return (
    <>
      <AirmailHeader />
      <div className="flex items-center px-2 pt-1">
        <button onClick={() => router.back()} className="p-2 text-ink" aria-label="Close">
          ✕
        </button>
      </div>
      <div className="flex-1 p-6 pt-1 text-center">
        <div className="mx-auto flex h-16 w-16 items-center justify-center rounded-full bg-rust text-3xl font-bold text-cream">
          !
        </div>
        <h2 className="mt-3.5 font-display text-2xl font-medium text-ink">Rosa needs help</h2>
        <p className="text-sm text-inkSoft">They shared their location with the group.</p>

        <div className="mx-auto mt-4 flex h-[150px] w-full items-center justify-center rounded-xl border-[1.5px] border-ink bg-paper2">
          <div className="flex h-8 w-8 items-center justify-center rounded-full border-[1.5px] border-inkSoft bg-rust font-mono text-xs text-cream">
            R
          </div>
        </div>

        <div className="mt-6 flex gap-2.5">
          <button className="flex-1 rounded-lg border-[1.5px] border-ink py-3.5 font-semibold text-ink">
            Get directions
          </button>
          <button onClick={handleResolve} className="flex-1 rounded-lg bg-rust py-3.5 font-mono text-[13px] uppercase text-cream">
            Found them
          </button>
        </div>
      </div>
    </>
  );
}

export default function SosPage() {
  return (
    <Suspense fallback={<p className="p-6 text-inkSoft">Loading…</p>}>
      <SosContent />
    </Suspense>
  );
}
