"use client";

import { useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import Link from "next/link";
import AirmailHeader from "@/components/AirmailHeader";
import ProgressRail from "@/components/ProgressRail";
import PrimaryButton from "@/components/PrimaryButton";
import { fetchTravelSuggestions, TravelSuggestions } from "@/lib/mockOnboardingService";
import { useOnboarding } from "@/lib/OnboardingContext";

export default function TripSetupPage() {
  const router = useRouter();
  const { data, setData } = useOnboarding();
  const [suggestions, setSuggestions] = useState<TravelSuggestions | null>(null);

  useEffect(() => {
    fetchTravelSuggestions().then(setSuggestions);
  }, []);

  return (
    <>
      <AirmailHeader />
      <div className="flex items-center px-2 pt-1">
        <button onClick={() => router.back()} className="p-2 text-ink" aria-label="Back">
          ←
        </button>
      </div>
      <div className="flex flex-1 flex-col p-6 pt-1">
        <ProgressRail step={1} />
        <p className="mt-3 font-mono text-[11px] font-bold uppercase tracking-widest text-rust">
          Step 1 of 3
        </p>
        <h2 className="mt-1 font-display text-2xl font-medium text-ink">Where and when?</h2>
        <p className="text-sm text-inkSoft">We&apos;ll build the whole trip around this.</p>

        <div className="mt-5 flex-1 space-y-3 overflow-y-auto">
          <label className="block rounded-lg border-[1.5px] border-ink bg-cream px-3.5 py-2">
            <span className="font-mono text-[10px] uppercase tracking-wide text-inkSoft">
              Destination
            </span>
            <input
              value={data.destination}
              onChange={(e) => setData({ ...data, destination: e.target.value })}
              className="block w-full bg-transparent text-base font-semibold text-ink outline-none"
            />
          </label>

          <div className="flex gap-2.5">
            <label className="flex-1 rounded-lg border-[1.5px] border-ink bg-cream px-3.5 py-2">
              <span className="font-mono text-[10px] uppercase tracking-wide text-inkSoft">Depart</span>
              <input
                type="date"
                value={data.departDate}
                onChange={(e) => setData({ ...data, departDate: e.target.value })}
                className="block w-full bg-transparent text-base font-semibold text-ink outline-none"
              />
            </label>
            <label className="flex-1 rounded-lg border-[1.5px] border-ink bg-cream px-3.5 py-2">
              <span className="font-mono text-[10px] uppercase tracking-wide text-inkSoft">Return</span>
              <input
                type="date"
                value={data.returnDate}
                onChange={(e) => setData({ ...data, returnDate: e.target.value })}
                className="block w-full bg-transparent text-base font-semibold text-ink outline-none"
              />
            </label>
          </div>

          <hr className="border-dashed border-line" />

          <div>
            <span className="font-mono text-[10px] uppercase tracking-wide text-inkSoft">
              Total budget
            </span>
            <div className="mt-1 flex items-baseline gap-1.5">
              <span className="font-display text-3xl font-semibold text-ink">
                ${data.budgetUsd}
              </span>
              <span className="text-xs text-inkSoft">≈ ${Math.round(data.budgetUsd / 7)} / day</span>
            </div>
            <input
              type="range"
              min={200}
              max={3000}
              value={data.budgetUsd}
              onChange={(e) => setData({ ...data, budgetUsd: Number(e.target.value) })}
              className="w-full accent-rust"
            />
          </div>

          <hr className="border-dashed border-line" />

          <div>
            <div className="flex justify-between">
              <span className="font-mono text-[10px] uppercase tracking-wide text-inkSoft">
                Suggested for these dates
              </span>
              <span className="font-mono text-[9.5px] text-inkSoft">optional</span>
            </div>
            <Link
              href="/onboarding/compare"
              className="mt-1 mb-2 inline-block font-mono text-[9.5px] uppercase text-rust underline"
            >
              Compare all flights & hotels →
            </Link>
            {!suggestions ? (
              <p className="mt-2 text-sm text-inkSoft">Loading…</p>
            ) : (
              <div className="mt-2 space-y-2">
                {suggestions.flights.map((f) => (
                  <SuggestionRow
                    key={f.id}
                    title={`${f.flight_number} · direct`}
                    subtitle={`$${f.price_usd} round trip`}
                    picked={data.selectedFlightId === f.id}
                    onPick={() =>
                      setData({
                        ...data,
                        selectedFlightId: data.selectedFlightId === f.id ? null : f.id,
                      })
                    }
                  />
                ))}
                {suggestions.hotels.map((h) => (
                  <SuggestionRow
                    key={h.id}
                    title={h.name}
                    subtitle={`${h.distance_from_center_mi}mi from center · $${h.price_per_night_usd}/night`}
                    picked={data.selectedHotelId === h.id}
                    onPick={() =>
                      setData({
                        ...data,
                        selectedHotelId: data.selectedHotelId === h.id ? null : h.id,
                      })
                    }
                  />
                ))}
              </div>
            )}
          </div>
        </div>

        <div className="pt-3">
          <PrimaryButton label="Continue →" onClick={() => router.push("/onboarding/interests")} />
        </div>
      </div>
    </>
  );
}

function SuggestionRow({
  title,
  subtitle,
  picked,
  onPick,
}: {
  title: string;
  subtitle: string;
  picked: boolean;
  onPick: () => void;
}) {
  return (
    <button
      onClick={onPick}
      className={`flex w-full items-center gap-2.5 rounded-lg border-[1.5px] px-3 py-2.5 text-left ${
        picked ? "border-rust bg-paper2" : "border-ink bg-cream"
      }`}
    >
      <div className="flex-1">
        <p className="text-[12.5px] font-bold text-ink">{title}</p>
        <p className="text-[10.5px] text-inkSoft">{subtitle}</p>
      </div>
      <span
        className={`rounded-full border px-2 py-1 font-mono text-[9px] uppercase ${
          picked ? "border-rust bg-rust text-cream" : "border-rust text-rust"
        }`}
      >
        {picked ? "Picked" : "Pick"}
      </span>
    </button>
  );
}
