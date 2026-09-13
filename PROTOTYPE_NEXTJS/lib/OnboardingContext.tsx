"use client";

import { createContext, useContext, useState, ReactNode } from "react";
import { OnboardingData } from "./mockOnboardingService";

const defaultData: OnboardingData = {
  destination: "Lisbon, Portugal",
  departDate: "2026-10-14",
  returnDate: "2026-10-21",
  budgetUsd: 750,
  selectedFlightId: null,
  selectedHotelId: null,
  interests: [],
  tripType: "solo",
};

type Ctx = {
  data: OnboardingData;
  setData: (d: OnboardingData) => void;
  reset: () => void;
};

const OnboardingContext = createContext<Ctx | null>(null);

/** Same job as Flutter's ChangeNotifierProvider for onboarding — holds
 * state across screens 2-4 until the final POST /trips submit. */
export function OnboardingProvider({ children }: { children: ReactNode }) {
  const [data, setData] = useState<OnboardingData>(defaultData);
  const reset = () => setData(defaultData);
  return (
    <OnboardingContext.Provider value={{ data, setData, reset }}>{children}</OnboardingContext.Provider>
  );
}

export function useOnboarding() {
  const ctx = useContext(OnboardingContext);
  if (!ctx) throw new Error("useOnboarding must be used within OnboardingProvider");
  return ctx;
}
