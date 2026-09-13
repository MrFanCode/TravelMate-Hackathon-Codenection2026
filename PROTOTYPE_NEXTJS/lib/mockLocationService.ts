/** Mirrors group-location-api-contract.md */

export type MemberLocation = { user_id: string; name: string; initial: string; lat: number; lng: number };

export async function fetchMemberLocations(): Promise<MemberLocation[]> {
  await new Promise((r) => setTimeout(r, 300));
  return [
    { user_id: "u_02", name: "Jake", initial: "J", lat: 38.7108, lng: -9.1421 },
    { user_id: "u_03", name: "Rosa", initial: "R", lat: 38.7135, lng: -9.129 },
  ];
}

export type SosAlert = { sos_id: string; from_name: string; lat: number; lng: number };

let activeSos: SosAlert | null = null;

export async function triggerSos(lat: number, lng: number): Promise<SosAlert> {
  await new Promise((r) => setTimeout(r, 300));
  activeSos = { sos_id: "sos_01", from_name: "You", lat, lng };
  return activeSos;
}

export async function fetchLatestSos(): Promise<SosAlert | null> {
  await new Promise((r) => setTimeout(r, 200));
  return activeSos;
}

export async function resolveSos() {
  await new Promise((r) => setTimeout(r, 200));
  activeSos = null;
}
