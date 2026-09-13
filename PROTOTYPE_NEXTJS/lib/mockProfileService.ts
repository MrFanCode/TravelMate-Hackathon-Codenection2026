/** Fake user + trip list — demonstrates multi-trip support: a user can
 * have several trips in different states, and start planning a new one
 * at any time, independent of trips already in progress. */

export type TripSummary = {
  trip_id: string;
  destination: string;
  dates: string;
  status: "planning" | "upcoming" | "completed" | "cancelled";
};

export type UserProfile = {
  name: string;
  email: string;
  initial: string;
};

export async function fetchProfile(): Promise<UserProfile> {
  await new Promise((r) => setTimeout(r, 200));
  return { name: "Maya", email: "maya@example.com", initial: "M" };
}

export async function fetchMyTrips(): Promise<TripSummary[]> {
  await new Promise((r) => setTimeout(r, 300));
  return [
    { trip_id: "trip_9f2a", destination: "Lisbon, Portugal", dates: "Oct 14 – 21, 2026", status: "planning" },
    { trip_id: "trip_bali1", destination: "Bali, Indonesia", dates: "Dec 5 – 15, 2026", status: "upcoming" },
    { trip_id: "trip_tokyo1", destination: "Tokyo, Japan", dates: "Mar 2 – 9, 2026", status: "completed" },
    { trip_id: "trip_paris1", destination: "Paris, France", dates: "Jul 1 – 6, 2026", status: "cancelled" },
  ];
}
