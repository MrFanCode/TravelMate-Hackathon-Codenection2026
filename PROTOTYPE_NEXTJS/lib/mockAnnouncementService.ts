/** Mirrors announcement-api-contract.md */

export type Announcement = { announcement_id: string; from_name: string; message: string };

let latest: Announcement | null = null;

export async function sendAnnouncement(message: string): Promise<Announcement> {
  await new Promise((r) => setTimeout(r, 300));
  latest = { announcement_id: `ann_${Date.now()}`, from_name: "You", message };
  return latest;
}

export async function fetchLatestAnnouncement(): Promise<Announcement | null> {
  await new Promise((r) => setTimeout(r, 200));
  return latest;
}

export function dismissAnnouncement() {
  latest = null;
}
