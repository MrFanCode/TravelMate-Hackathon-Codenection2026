"use client";

import { useEffect, useState, Suspense } from "react";
import { useRouter, useSearchParams } from "next/navigation";
import AirmailHeader from "@/components/AirmailHeader";
import {
  fetchChecklist,
  addItem,
  toggleItem,
  removeItem,
  ChecklistItem,
} from "@/lib/mockChecklistService";

function ChecklistContent() {
  const router = useRouter();
  const params = useSearchParams();
  const tripId = params.get("tripId") ?? "trip_9f2a";
  const [items, setItems] = useState<ChecklistItem[]>([]);
  const [newLabel, setNewLabel] = useState("");
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetchChecklist().then((i) => {
      setItems(i);
      setLoading(false);
    });
  }, []);

  async function handleToggle(item: ChecklistItem) {
    setItems((prev) => prev.map((i) => (i.id === item.id ? { ...i, checked: !i.checked } : i)));
    await toggleItem(item.id, !item.checked);
  }

  async function handleAdd() {
    if (!newLabel.trim()) return;
    const item = await addItem(newLabel.trim());
    setItems((prev) => [...prev, item]);
    setNewLabel("");
  }

  async function handleRemove(id: string) {
    setItems((prev) => prev.filter((i) => i.id !== id));
    await removeItem(id);
  }

  const doneCount = items.filter((i) => i.checked).length;

  return (
    <>
      <AirmailHeader />
      <div className="flex items-center px-2 pt-1">
        <button onClick={() => router.back()} className="p-2 text-ink" aria-label="Back">
          ←
        </button>
      </div>
      <div className="flex-1 overflow-y-auto p-6 pt-1">
        <p className="font-mono text-[11px] font-bold uppercase tracking-widest text-rust">
          Before you go
        </p>
        <h2 className="mt-1 font-display text-2xl font-medium text-ink">Your checklist</h2>
        <p className="text-sm text-inkSoft">
          {loading ? "Building your list…" : `${doneCount} of ${items.length} done`}
        </p>

        <div className="mt-4 space-y-2">
          {items.map((item) => (
            <div
              key={item.id}
              className={`flex items-center gap-2.5 rounded-lg border-[1.5px] px-3.5 py-3 ${
                item.checked ? "border-pine bg-paper2" : "border-ink bg-cream"
              }`}
            >
              <button
                onClick={() => handleToggle(item)}
                className={`flex h-5 w-5 flex-shrink-0 items-center justify-center rounded-full border-[1.5px] text-[10px] ${
                  item.checked ? "border-pine bg-pine text-cream" : "border-ink text-transparent"
                }`}
              >
                ✓
              </button>
              <span
                className={`flex-1 text-[13px] font-bold text-ink ${
                  item.checked ? "line-through opacity-60" : ""
                }`}
              >
                {item.label}
              </span>
              {item.source === "ai" && (
                <span className="rounded-full border border-rust px-1.5 py-0.5 font-mono text-[8px] uppercase text-rust">
                  AI
                </span>
              )}
              <button onClick={() => handleRemove(item.id)} className="text-inkSoft">
                ✕
              </button>
            </div>
          ))}
        </div>

        <div className="mt-4 flex gap-2">
          <input
            value={newLabel}
            onChange={(e) => setNewLabel(e.target.value)}
            onKeyDown={(e) => e.key === "Enter" && handleAdd()}
            placeholder="Add your own item…"
            className="flex-1 rounded-lg border-[1.5px] border-ink bg-cream px-3.5 py-2.5 text-sm text-ink outline-none"
          />
          <button
            onClick={handleAdd}
            className="rounded-lg bg-pine px-4 font-mono text-[11px] uppercase text-cream"
          >
            Add
          </button>
        </div>
      </div>
    </>
  );
}

export default function ChecklistPage() {
  return (
    <Suspense fallback={<p className="p-6 text-inkSoft">Loading…</p>}>
      <ChecklistContent />
    </Suspense>
  );
}
