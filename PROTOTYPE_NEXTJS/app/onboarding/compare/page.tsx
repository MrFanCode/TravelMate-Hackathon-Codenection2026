"use client";

import { useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import AirmailHeader from "@/components/AirmailHeader";
import PrimaryButton from "@/components/PrimaryButton";
import { fetchTravelSuggestions, TravelSuggestions } from "@/lib/mockOnboardingService";
import { useOnboarding } from "@/lib/OnboardingContext";

export default function ComparePage() {
  const router = useRouter();
  const { data, setData } = useOnboarding();
  const [suggestions, setSuggestions] = useState<TravelSuggestions | null>(null);
  const [tab, setTab] = useState<"flights" | "hotels">("flights");

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
      <div className="flex-1 overflow-y-auto p-6 pt-1">
        <h2 className="font-display text-2xl font-medium text-ink">Compare your options</h2>
        <p className="text-sm text-inkSoft">Pick what fits — you can change this later.</p>

        <div className="mt-4 flex gap-2">
          <TabButton active={tab === "flights"} onClick={() => setTab("flights")} label="Flights" />
          <TabButton active={tab === "hotels"} onClick={() => setTab("hotels")} label="Hotels" />
        </div>

        {!suggestions ? (
          <p className="mt-4 text-sm text-inkSoft">Loading…</p>
        ) : tab === "flights" ? (
          <div className="mt-4 space-y-2.5">
            {[...suggestions.flights]
              .sort((a, b) => a.price_usd - b.price_usd)
              .map((f) => (
                <button
                  key={f.id}
                  onClick={() => setData({ ...data, selectedFlightId: f.id })}
                  className={`w-full rounded-lg border-[1.5px] bg-cream px-3.5 py-3 text-left ${
                    data.selectedFlightId === f.id ? "border-2 border-rust bg-paper2" : "border-ink"
                  }`}
                >
                  <div className="flex items-center justify-between">
                    <div>
                      <p className="text-sm font-bold text-ink">{f.flight_number}</p>
                      <p className="text-[11.5px] text-inkSoft">{f.direct ? "Direct" : "1 stop"}</p>
                    </div>
                    <p className="font-display text-lg font-semibold text-ink">${f.price_usd}</p>
                  </div>
                </button>
              ))}
          </div>
        ) : (
          <div className="mt-4 space-y-2.5">
            {[...suggestions.hotels]
              .sort((a, b) => a.price_per_night_usd - b.price_per_night_usd)
              .map((h) => (
                <button
                  key={h.id}
                  onClick={() => setData({ ...data, selectedHotelId: h.id })}
                  className={`w-full rounded-lg border-[1.5px] bg-cream px-3.5 py-3 text-left ${
                    data.selectedHotelId === h.id ? "border-2 border-rust bg-paper2" : "border-ink"
                  }`}
                >
                  <div className="flex items-center justify-between">
                    <div>
                      <p className="text-sm font-bold text-ink">{h.name}</p>
                      <p className="text-[11.5px] text-inkSoft">{h.distance_from_center_mi}mi from center</p>
                    </div>
                    <p className="font-display text-lg font-semibold text-ink">
                      ${h.price_per_night_usd}
                      <span className="text-xs font-normal text-inkSoft">/night</span>
                    </p>
                  </div>
                </button>
              ))}
          </div>
        )}
      </div>
      <div className="p-6 pt-0">
        <PrimaryButton label="Confirm picks →" onClick={() => router.back()} />
      </div>
    </>
  );
}

function TabButton({ active, onClick, label }: { active: boolean; onClick: () => void; label: string }) {
  return (
    <button
      onClick={onClick}
      className={`rounded-full border-[1.5px] px-4 py-1.5 font-mono text-[10.5px] uppercase ${
        active ? "border-ink bg-ink text-cream" : "border-ink bg-cream text-ink"
      }`}
    >
      {label}
    </button>
  );
}
