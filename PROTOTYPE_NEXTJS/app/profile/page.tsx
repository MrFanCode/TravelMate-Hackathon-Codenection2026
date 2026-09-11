"use client";

import { useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import Link from "next/link";
import AirmailHeader from "@/components/AirmailHeader";
import { fetchProfile, fetchMyTrips, UserProfile, TripSummary } from "@/lib/mockProfileService";
import { useOnboarding } from "@/lib/OnboardingContext";

const STATUS_STYLE: Record<TripSummary["status"], string> = {
  planning: "bg-mustard text-ink",
  upcoming: "bg-pine text-cream",
  completed: "bg-line text-ink",
  cancelled: "bg-transparent border-[1.5px] border-inkSoft text-inkSoft line-through",
};

export default function ProfilePage() {
  const router = useRouter();
  const { reset } = useOnboarding();
  const [profile, setProfile] = useState<UserProfile | null>(null);
  const [trips, setTrips] = useState<TripSummary[]>([]);

  useEffect(() => {
    fetchProfile().then(setProfile);
    fetchMyTrips().then(setTrips);
  }, []);

  function handlePlanNewTrip() {
    // A trip already being planned (or several) doesn't block starting
    // another — this is the actual mechanism for multi-trip support.
    reset();
    router.push("/onboarding/trip-setup");
  }

  return (
    <>
      <AirmailHeader />
      <div className="flex items-center px-2 pt-1">
        <button onClick={() => router.back()} className="p-2 text-ink" aria-label="Back">
          ←
        </button>
      </div>
      <div className="flex-1 overflow-y-auto p-6 pt-1">
        {profile && (
          <div className="flex items-center gap-3">
            <span className="flex h-14 w-14 items-center justify-center rounded-full bg-pine font-display text-xl text-cream">
              {profile.initial}
            </span>
            <div>
              <p className="font-display text-lg font-semibold text-ink">{profile.name}</p>
              <p className="text-[12.5px] text-inkSoft">{profile.email}</p>
            </div>
          </div>
        )}

        <div className="mt-6 flex items-center justify-between">
          <p className="font-mono text-[11px] font-bold uppercase tracking-widest text-rust">
            My trips
          </p>
        </div>

        <div className="mt-3 space-y-2.5">
          {trips.map((t) => (
            <Link
              key={t.trip_id}
              href={`/trip?tripId=${t.trip_id}&tripType=solo`}
              className="block rounded-lg border-[1.5px] border-ink bg-cream px-3.5 py-3"
            >
              <div className="flex items-center justify-between">
                <div>
                  <p className="text-sm font-bold text-ink">{t.destination}</p>
                  <p className="text-[11.5px] text-inkSoft">{t.dates}</p>
                </div>
                <span className={`rounded-full px-2.5 py-1 font-mono text-[9px] uppercase ${STATUS_STYLE[t.status]}`}>
                  {t.status}
                </span>
              </div>
            </Link>
          ))}
        </div>

        <button
          onClick={handlePlanNewTrip}
          className="mt-4 w-full rounded-lg border-[1.5px] border-dashed border-rust bg-transparent py-3.5 font-mono text-[12px] uppercase text-rust"
        >
          + Plan a new trip
        </button>

        <button
          onClick={() => router.push("/")}
          className="mt-8 w-full text-center text-sm font-semibold text-inkSoft underline"
        >
          Log out
        </button>
      </div>
    </>
  );
}
