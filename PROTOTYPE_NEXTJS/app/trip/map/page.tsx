"use client";

import { useEffect, useState, Suspense } from "react";
import { useSearchParams } from "next/navigation";
import AirmailHeader from "@/components/AirmailHeader";
import BottomNav from "@/components/BottomNav";
import { fetchMemberLocations, fetchLatestSos, triggerSos, MemberLocation, SosAlert } from "@/lib/mockLocationService";
import { sendAnnouncement, fetchLatestAnnouncement, dismissAnnouncement, Announcement } from "@/lib/mockAnnouncementService";

// Real Lisbon coordinates, matching the itinerary's activities.
const ITINERARY_PINS = [
  { label: "1", top: "72%", left: "10%" },
  { label: "2", top: "38%", left: "26%" },
  { label: "3", top: "50%", left: "55%" },
  { label: "4", top: "18%", left: "62%" },
  { label: "5", top: "6%", left: "88%" },
];
const SUGGESTION_PINS = [
  { top: "58%", left: "40%" },
  { top: "28%", left: "76%" },
];

function MapContent() {
  const params = useSearchParams();
  const tripId = params.get("tripId") ?? "trip_9f2a";
  // Demo: always show the group layer here so every feature is visible in
  // the prototype. A real build would gate this on trip.trip_type === "group"
  // (see the Flutter version's isGroupTrip guard for the real pattern).
  const isGroup = true;

  const [members, setMembers] = useState<MemberLocation[]>([]);
  const [sos, setSos] = useState<SosAlert | null>(null);
  const [announcement, setAnnouncement] = useState<Announcement | null>(null);
  const [sharing, setSharing] = useState(true);
  const [showAnnounceModal, setShowAnnounceModal] = useState(false);
  const [message, setMessage] = useState("");

  useEffect(() => {
    fetchMemberLocations().then(setMembers);
    fetchLatestSos().then(setSos);
    fetchLatestAnnouncement().then(setAnnouncement);
  }, []);

  async function handleSos() {
    if (!confirm("Alert the group? This shares your current location with everyone on the trip immediately.")) return;
    await triggerSos(38.705, -9.148);
    alert("Alert sent to the group.");
  }

  async function handleSendAnnouncement() {
    if (!message.trim()) return;
    const a = await sendAnnouncement(message.trim());
    setAnnouncement(a);
    setShowAnnounceModal(false);
    setMessage("");
  }

  return (
    <>
      <AirmailHeader />
      <div className="p-6 pb-2">
        <div className="flex items-center justify-between">
          <p className="font-mono text-[11px] font-bold uppercase tracking-widest text-rust">
            Day 1 · 5 stops
          </p>
          <div className="flex items-center gap-2.5 font-mono text-[9.5px] uppercase text-inkSoft">
            <Legend color="bg-rust" label="Your plan" />
            <Legend color="border-[1.5px] border-pine bg-cream" label="Nearby" />
            {isGroup && <Legend color="bg-mustard border-[1.5px] border-ink" label="Group" />}
          </div>
        </div>
        {isGroup && (
          <div className="mt-1.5 flex items-center gap-2">
            <button
              onClick={() => setSharing(!sharing)}
              className={`h-[18px] w-[34px] rounded-full border-[1.5px] border-ink ${sharing ? "bg-pine" : "bg-line"} relative`}
            >
              <span
                className={`absolute top-0.5 h-[13px] w-[13px] rounded-full bg-cream transition-all ${sharing ? "left-4" : "left-0.5"}`}
              />
            </button>
            <span className="flex-1 font-mono text-[9.5px] text-inkSoft">
              {sharing ? "Sharing your location with the group" : "Share your location with the group"}
            </span>
            <button
              onClick={() => setShowAnnounceModal(true)}
              className="font-mono text-[9.5px] uppercase text-pine"
            >
              📢 Announce
            </button>
          </div>
        )}
        {isGroup && sos && (
          <div className="mt-1.5 flex items-center gap-2 rounded-lg bg-rust px-3 py-2">
            <span className="text-cream">⚠</span>
            <span className="flex-1 text-[12px] font-bold text-cream">{sos.from_name} needs help</span>
            <a href={`/group/sos?tripId=${tripId}`} className="font-mono text-[9px] uppercase text-cream">
              View
            </a>
          </div>
        )}
        {isGroup && announcement && (
          <div className="mt-1.5 flex items-center gap-2 rounded-lg bg-pine px-3 py-2">
            <span className="text-cream">📢</span>
            <span className="flex-1 text-[11.5px] font-bold text-cream">
              {announcement.from_name}: {announcement.message}
            </span>
            <button onClick={() => { dismissAnnouncement(); setAnnouncement(null); }} className="text-cream">
              ✕
            </button>
          </div>
        )}
      </div>

      {/* Real map — an embedded OpenStreetMap view, actual live map data, no API key.
          Swap this <iframe> for MapLibre GL + OpenFreeMap tiles once ready for a fully
          interactive/native map; the pin overlay logic below stays the same either way. */}
      <div className="relative mx-6 h-[230px] overflow-hidden rounded-xl border-[1.5px] border-ink">
        <iframe
          title="Lisbon map"
          className="pointer-events-none h-full w-full"
          src="https://www.openstreetmap.org/export/embed.html?bbox=-9.225%2C38.695%2C-9.10%2C38.725&layer=mapnik"
        />
        {ITINERARY_PINS.map((p) => (
          <div
            key={p.label}
            className="absolute flex h-6 w-6 -translate-x-1/2 -translate-y-1/2 items-center justify-center rounded-full border-[1.5px] border-inkSoft bg-rust font-mono text-[10px] text-cream shadow"
            style={{ top: p.top, left: p.left }}
          >
            {p.label}
          </div>
        ))}
        {SUGGESTION_PINS.map((p, i) => (
          <div
            key={i}
            className="absolute flex h-5 w-5 -translate-x-1/2 -translate-y-1/2 items-center justify-center rounded-full border-[1.5px] border-dashed border-pine bg-cream font-mono text-[11px] font-bold text-pine"
            style={{ top: p.top, left: p.left }}
          >
            +
          </div>
        ))}
        {isGroup &&
          members.map((m, i) => (
            <div
              key={m.user_id}
              className="absolute flex h-6 w-6 -translate-x-1/2 -translate-y-1/2 items-center justify-center rounded-full border-[1.5px] border-ink bg-mustard font-mono text-[10px] font-bold text-ink shadow"
              style={{ top: `${40 + i * 22}%`, left: `${65 - i * 15}%` }}
            >
              {m.initial}
            </div>
          ))}
        {isGroup && (
          <button
            onClick={handleSos}
            className="absolute bottom-3 right-3 flex items-center gap-1.5 rounded-full border-[1.5px] border-rustDark bg-rust px-3.5 py-2.5 font-mono text-[10px] uppercase text-cream shadow-lg"
          >
            🚨 I need help
          </button>
        )}
      </div>

      <div className="flex-1 overflow-y-auto p-6 pt-3">
        <SheetRow tag="10:00 AM" title="Belém Tower" />
        <SheetRow tag="1:00 PM" title="Time Out Market" />
        <SheetRow tag="nearby" title="LX Factory — creative quarter" addable />
        <SheetRow tag="hotel" title="Hotel Alfama Rio · $86/night" addable />
      </div>

      {showAnnounceModal && (
        <div className="fixed inset-0 z-10 flex items-end justify-center bg-black/40">
          <div className="w-full max-w-md rounded-t-2xl border-t-[1.5px] border-ink bg-paper p-6">
            <p className="font-display text-lg font-semibold text-ink">Tell the group something</p>
            {["Leaving in 5 minutes — meet at the lobby", "Running 10 min late, don't wait for me"].map((preset) => (
              <button
                key={preset}
                onClick={() => setMessage(preset)}
                className="mt-2 block w-full rounded-lg border-[1.5px] border-pine bg-cream px-3 py-2.5 text-left text-[12.5px] font-bold text-ink"
              >
                {preset}
              </button>
            ))}
            <textarea
              value={message}
              onChange={(e) => setMessage(e.target.value)}
              placeholder="Or type your own…"
              className="mt-2 w-full rounded-lg border-[1.5px] border-ink bg-cream p-3 text-sm text-ink outline-none"
              rows={2}
            />
            <div className="mt-3 flex gap-2">
              <button
                onClick={() => setShowAnnounceModal(false)}
                className="flex-1 rounded-lg border-[1.5px] border-ink py-3 font-semibold text-ink"
              >
                Cancel
              </button>
              <button
                onClick={handleSendAnnouncement}
                className="flex-1 rounded-lg bg-rust py-3 font-mono text-[13px] uppercase text-cream"
              >
                Send
              </button>
            </div>
          </div>
        </div>
      )}

      <BottomNav tripId={tripId} />
    </>
  );
}

function Legend({ color, label }: { color: string; label: string }) {
  return (
    <span className="flex items-center gap-1">
      <span className={`h-2.5 w-2.5 rounded-full ${color}`} />
      {label}
    </span>
  );
}

function SheetRow({ tag, title, addable = false }: { tag: string; title: string; addable?: boolean }) {
  return (
    <div
      className={`mb-2.5 flex items-center gap-2.5 rounded-lg border-[1.5px] px-3 py-2.5 ${
        addable ? "border-pine border-dashed bg-cream" : "border-ink bg-cream"
      }`}
    >
      <span className="font-mono text-[9px] text-inkSoft">{tag}</span>
      <span className="flex-1 text-[12.5px] font-bold text-ink">{title}</span>
      {addable && (
        <span className="rounded-full bg-pine px-2.5 py-1 font-mono text-[9.5px] uppercase text-cream">
          + Add
        </span>
      )}
    </div>
  );
}

export default function MapPage() {
  return (
    <Suspense fallback={<p className="p-6 text-inkSoft">Loading…</p>}>
      <MapContent />
    </Suspense>
  );
}
