/** Mirrors disruption-api-contract.md */

export type Disruption = {
  id: string;
  title: string;
  description: string;
  affected_activities: { title: string; reason: string }[];
};

export async function fetchLatestDisruption(): Promise<Disruption> {
  await new Promise((r) => setTimeout(r, 300));
  return {
    id: "dis_01",
    title: "Flight TP1358 delayed",
    description: "Now landing 6:40 PM instead of 3:20 PM — this affects your Day 1 plan.",
    affected_activities: [
      { title: "Belém Tower & riverside walk", reason: "Closes 6:00 PM — will be missed" },
      { title: "Fado dinner show", reason: "Booking may need to shift later" },
    ],
  };
}

export type ReplanDiff = {
  day: number;
  removed: { time: string; title: string }[];
  added: { time: string; title: string }[];
  unchanged_note: string;
};

export async function requestReplan(): Promise<ReplanDiff> {
  await new Promise((r) => setTimeout(r, 600));
  return {
    day: 1,
    removed: [{ time: "10:00 AM", title: "Belém Tower walk" }],
    added: [
      { time: "7:15 PM", title: "Riverside sunset stroll" },
      { time: "8:30 PM", title: "Late fado dinner (rebooked)" },
    ],
    unchanged_note: "Day 2 unaffected",
  };
}
