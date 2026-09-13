"use client";

import { useRouter } from "next/navigation";
import AirmailHeader from "@/components/AirmailHeader";
import ProgressRail from "@/components/ProgressRail";
import PrimaryButton from "@/components/PrimaryButton";
import { useOnboarding } from "@/lib/OnboardingContext";

const INTERESTS = [
  { tag: "food_drink", label: "Food & drink" },
  { tag: "museums", label: "Museums" },
  { tag: "nature_hikes", label: "Nature & hikes" },
  { tag: "history", label: "History" },
  { tag: "photography", label: "Photography" },
  { tag: "nightlife", label: "Nightlife" },
];

export default function InterestsPage() {
  const router = useRouter();
  const { data, setData } = useOnboarding();

  function toggle(tag: string) {
    const current = data.interests.includes(tag)
      ? data.interests.filter((t) => t !== tag)
      : [...data.interests, tag];
    setData({ ...data, interests: current });
  }

  return (
    <>
      <AirmailHeader />
      <div className="flex items-center px-2 pt-1">
        <button onClick={() => router.back()} className="p-2 text-ink" aria-label="Back">
          ←
        </button>
      </div>
      <div className="flex flex-1 flex-col p-6 pt-1">
        <ProgressRail step={2} />
        <p className="mt-3 font-mono text-[11px] font-bold uppercase tracking-widest text-rust">
          Step 2 of 3
        </p>
        <h2 className="mt-1 font-display text-2xl font-medium text-ink">What are you into?</h2>
        <p className="text-sm text-inkSoft">Pick a few — we&apos;ll shape your days around them.</p>

        <div className="mt-5 flex-1 grid grid-cols-2 gap-2.5">
          {INTERESTS.map((i) => {
            const selected = data.interests.includes(i.tag);
            return (
              <button
                key={i.tag}
                onClick={() => toggle(i.tag)}
                className={`rounded-lg border-[1.5px] p-3.5 text-left ${
                  selected ? "border-rustDark bg-rust text-cream" : "border-ink bg-cream text-ink"
                }`}
              >
                <div className="mt-6 flex items-center justify-between">
                  <span className="text-[13px] font-bold">{i.label}</span>
                  {selected && <span>✓</span>}
                </div>
              </button>
            );
          })}
        </div>

        <div className="pt-3">
          <PrimaryButton
            label={`${data.interests.length} selected · Continue`}
            disabled={data.interests.length === 0}
            onClick={() => router.push("/onboarding/trip-type")}
          />
        </div>
      </div>
    </>
  );
}
