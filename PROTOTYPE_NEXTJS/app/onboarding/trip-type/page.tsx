"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import AirmailHeader from "@/components/AirmailHeader";
import ProgressRail from "@/components/ProgressRail";
import PrimaryButton from "@/components/PrimaryButton";
import { useOnboarding } from "@/lib/OnboardingContext";
import { createTrip } from "@/lib/mockOnboardingService";

export default function TripTypePage() {
  const router = useRouter();
  const { data, setData } = useOnboarding();
  const [submitting, setSubmitting] = useState(false);

  async function handleSubmit() {
    setSubmitting(true);
    const trip = await createTrip(data);
    setSubmitting(false);
    if (trip.invite_code) {
      router.push(`/group/invite?tripId=${trip.trip_id}&code=${trip.invite_code}&tripType=group`);
    } else {
      router.push(`/trip?tripId=${trip.trip_id}&tripType=solo`);
    }
  }

  return (
    <>
      <AirmailHeader />
      <div className="flex items-center px-2 pt-1">
        <button onClick={() => router.back()} className="p-2 text-ink" aria-label="Back">
          ←
        </button>
      </div>
      <div className="flex flex-1 flex-col p-6 pt-1">
        <ProgressRail step={3} />
        <p className="mt-3 font-mono text-[11px] font-bold uppercase tracking-widest text-rust">
          Step 3 of 3
        </p>
        <h2 className="mt-1 font-display text-2xl font-medium text-ink">
          Traveling solo,
          <br />
          or with others?
        </h2>
        <p className="text-sm text-inkSoft">This changes how we build your itinerary.</p>

        <div className="mt-6 space-y-4">
          <TypeCard
            title="Solo"
            subtitle="Just you. We generate the whole plan around your pace and budget."
            selected={data.tripType === "solo"}
            onClick={() => setData({ ...data, tripType: "solo" })}
          />
          <TypeCard
            title="Group"
            subtitle="Invite friends, vote on activities, split costs automatically."
            selected={data.tripType === "group"}
            onClick={() => setData({ ...data, tripType: "group" })}
          />
        </div>

        <div className="mt-auto pt-6">
          <PrimaryButton
            label={submitting ? "Building your trip…" : "Let's plan your trip →"}
            disabled={submitting}
            onClick={handleSubmit}
          />
        </div>
      </div>
    </>
  );
}

function TypeCard({
  title,
  subtitle,
  selected,
  onClick,
}: {
  title: string;
  subtitle: string;
  selected: boolean;
  onClick: () => void;
}) {
  return (
    <button
      onClick={onClick}
      className={`relative w-full rounded-xl border-[1.5px] p-4.5 text-left ${
        selected ? "border-2 border-rust bg-paper2" : "border-ink bg-cream"
      }`}
    >
      <div className="flex items-start gap-4">
        <div className="h-11 w-11 flex-shrink-0 rounded-full bg-ink" />
        <div>
          <p className="font-display text-lg font-semibold text-ink">{title}</p>
          <p className="mt-1 text-[12.5px] leading-snug text-inkSoft">{subtitle}</p>
        </div>
      </div>
      {selected && (
        <span className="absolute -right-1 -top-1 flex h-11 w-11 rotate-[-14deg] items-center justify-center rounded-full border-[1.5px] border-dashed border-rust text-center font-mono text-[7px] text-rust">
          SELECTED
          <br />✓
        </span>
      )}
    </button>
  );
}
