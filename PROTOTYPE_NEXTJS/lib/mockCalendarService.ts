/**
 * Fully fake — no real Google OAuth needed to feel the flow.
 * The REAL Google Calendar integration already exists in
 * app/api/auth/[...nextauth]/route.ts and app/api/calendar/* — those
 * are kept as the reference for when a real backend exists. This file
 * is what the actual prototype UI calls right now.
 */

export type MemberAvailability = {
  name: string;
  initial: string;
  connected: boolean;
  busySlots: string[]; // human-readable, fake
};

export async function fetchGroupAvailability(): Promise<MemberAvailability[]> {
  await new Promise((r) => setTimeout(r, 500));
  return [
    { name: "Maya (you)", initial: "M", connected: true, busySlots: [] },
    { name: "Jake", initial: "J", connected: true, busySlots: ["Oct 16, 2–4pm"] },
    { name: "Rosa", initial: "R", connected: false, busySlots: [] },
  ];
}

export async function confirmAndSyncCalendars(): Promise<{ synced: number }> {
  await new Promise((r) => setTimeout(r, 700));
  return { synced: 2 };
}
