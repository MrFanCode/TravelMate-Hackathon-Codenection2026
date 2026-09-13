/**
 * Mirrors OnboardingMockService from the Flutter build. Same shapes as
 * onboarding-api-contract.md — swap the bodies for real fetch() calls
 * to FastAPI once the backend exists. Nothing else needs to change.
 */

export type TravelSuggestions = {
  flights: { id: string; flight_number: string; direct: boolean; price_usd: number }[];
  hotels: { id: string; name: string; distance_from_center_mi: number; price_per_night_usd: number }[];
};

export async function fetchTravelSuggestions(): Promise<TravelSuggestions> {
  await new Promise((r) => setTimeout(r, 300));
  return {
    flights: [
      { id: "fl_001", flight_number: "TP1358", direct: true, price_usd: 340 },
      { id: "fl_002", flight_number: "IB4821", direct: false, price_usd: 268 },
      { id: "fl_003", flight_number: "AF1122", direct: false, price_usd: 295 },
    ],
    hotels: [
      { id: "ht_001", name: "Hotel Alfama Rio", distance_from_center_mi: 0.4, price_per_night_usd: 86 },
      { id: "ht_002", name: "Baixa Central Suites", distance_from_center_mi: 0.2, price_per_night_usd: 112 },
      { id: "ht_003", name: "Belém Riverside Inn", distance_from_center_mi: 1.8, price_per_night_usd: 64 },
    ],
  };
}

export type OnboardingData = {
  destination: string;
  departDate: string;
  returnDate: string;
  budgetUsd: number;
  selectedFlightId: string | null;
  selectedHotelId: string | null;
  interests: string[];
  tripType: "solo" | "group";
};

export type Trip = {
  trip_id: string;
  destination: string;
  trip_type: "solo" | "group";
  invite_code?: string;
  days: { day: number; date: string; activities: { id: string; time: string; title: string; cost_usd: number }[] }[];
};

const TRIP_DESTINATIONS: Record<string, string> = {
  trip_9f2a: "Lisbon",
  trip_bali1: "Bali",
  trip_tokyo1: "Tokyo",
  trip_paris1: "Paris",
};

export async function getTrip(tripId: string, tripType: "solo" | "group" = "solo"): Promise<Trip> {
  await new Promise((r) => setTimeout(r, 300));
  return {
    trip_id: tripId,
    destination: TRIP_DESTINATIONS[tripId] ?? "Lisbon",
    trip_type: tripType,
    days: [
      {
        day: 1,
        date: "2026-10-14",
        activities: [
          { id: "act_01", time: "8:30 AM", title: "Pastel de nata at Manteigaria", cost_usd: 6 },
          { id: "act_02", time: "10:00 AM", title: "Belém Tower & riverside walk", cost_usd: 8 },
          { id: "act_03", time: "1:00 PM", title: "Lunch — Time Out Market", cost_usd: 18 },
        ],
      },
    ],
  };
}

export async function createTrip(data: OnboardingData): Promise<Trip> {
  await new Promise((r) => setTimeout(r, 500));
  return {
    trip_id: "trip_9f2a",
    destination: data.destination,
    trip_type: data.tripType,
    invite_code: data.tripType === "group" ? "lsb-oct14" : undefined,
    days: [
      {
        day: 1,
        date: "2026-10-14",
        activities: [
          { id: "act_01", time: "8:30 AM", title: "Pastel de nata at Manteigaria", cost_usd: 6 },
          { id: "act_02", time: "10:00 AM", title: "Belém Tower & riverside walk", cost_usd: 8 },
        ],
      },
    ],
  };
}
