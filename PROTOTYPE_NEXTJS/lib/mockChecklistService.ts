/** Mirrors checklist-api-contract.md. AI-starter items are pre-seeded here
 * to simulate what Ollama would generate from destination/season/interests. */

export type ChecklistItem = {
  id: string;
  label: string;
  source: "ai" | "manual";
  checked: boolean;
};

let items: ChecklistItem[] = [
  { id: "chk_01", label: "Passport (valid 6+ months)", source: "ai", checked: false },
  { id: "chk_02", label: "Cash exchanged to Euros", source: "ai", checked: false },
  { id: "chk_03", label: "EU plug adapter", source: "ai", checked: false },
  { id: "chk_04", label: "Light jacket for cool evenings", source: "ai", checked: false },
  { id: "chk_05", label: "Comfortable walking shoes", source: "ai", checked: true },
  { id: "chk_06", label: "Travel insurance confirmation", source: "ai", checked: false },
  { id: "chk_07", label: "Phone charger", source: "ai", checked: false },
];

export async function fetchChecklist(): Promise<ChecklistItem[]> {
  await new Promise((r) => setTimeout(r, 400));
  return items;
}

export async function addItem(label: string): Promise<ChecklistItem> {
  await new Promise((r) => setTimeout(r, 200));
  const item: ChecklistItem = { id: `chk_${Date.now()}`, label, source: "manual", checked: false };
  items.push(item);
  return item;
}

export async function toggleItem(id: string, checked: boolean) {
  await new Promise((r) => setTimeout(r, 150));
  items = items.map((i) => (i.id === id ? { ...i, checked } : i));
}

export async function removeItem(id: string) {
  await new Promise((r) => setTimeout(r, 150));
  items = items.filter((i) => i.id !== id);
}
