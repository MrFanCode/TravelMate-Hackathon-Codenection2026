"use client";

import { Suspense } from "react";
import { useSearchParams } from "next/navigation";
import AirmailHeader from "@/components/AirmailHeader";
import PrimaryButtonLink from "@/components/PrimaryButtonLink";

function InviteContent() {
  const params = useSearchParams();
  const tripId = params.get("tripId") ?? "trip_9f2a";
  const code = params.get("code") ?? "lsb-oct14";

  return (
    <>
      <AirmailHeader />
      <div className="flex flex-1 flex-col p-6">
        <h2 className="font-display text-2xl font-medium text-ink">Bring your crew</h2>
        <p className="text-sm text-inkSoft">Anyone with the link can join and vote.</p>

        <div className="mx-auto mt-8 flex h-32 w-32 items-center justify-center rounded-lg border-[1.5px] border-ink bg-cream text-5xl">
          ▦
        </div>

        <div className="mt-6 flex items-center justify-between rounded-lg border-[1.5px] border-ink bg-cream px-3.5 py-3">
          <span className="font-mono text-xs text-ink">travelmate.app/t/{code}</span>
          <span className="font-mono text-[10px] uppercase text-rust">Copy</span>
        </div>

        <p className="mt-5 font-mono text-[10px] uppercase tracking-wide text-inkSoft">
          Already joined
        </p>
        <div className="mt-2 flex">
          <span className="relative -mr-2.5 flex h-9 w-9 items-center justify-center rounded-full border-2 border-cream bg-pine font-mono text-[11px] text-cream">
            M
            <span className="absolute -bottom-px -right-px h-2.5 w-2.5 rounded-full border-2 border-paper bg-mustard" />
          </span>
        </div>
        <p className="mt-1.5 font-mono text-[9px] text-inkSoft">● mustard = sharing location now</p>

        <div className="mt-auto pt-6">
          <PrimaryButtonLink href={`/group/calendar?tripId=${tripId}`} label="Check group availability →" />
        </div>
      </div>
    </>
  );
}

export default function GroupInvitePage() {
  return (
    <Suspense fallback={<p className="p-6 text-inkSoft">Loading…</p>}>
      <InviteContent />
    </Suspense>
  );
}
