"use client";

import { useEffect, useState, Suspense } from "react";
import { useSearchParams } from "next/navigation";
import Link from "next/link";
import AirmailHeader from "@/components/AirmailHeader";
import BottomNav from "@/components/BottomNav";
import { fetchProposals, castVote, Proposal } from "@/lib/mockGroupService";

function VotingContent() {
  const params = useSearchParams();
  const tripId = params.get("tripId") ?? "trip_9f2a";
  const [proposals, setProposals] = useState<Proposal[]>([]);
  const [yourVote, setYourVote] = useState<string | null>(null);

  useEffect(() => {
    fetchProposals().then(({ proposals, your_vote }) => {
      setProposals(proposals);
      setYourVote(your_vote);
    });
  }, []);

  async function vote(id: string) {
    const result = await castVote(id);
    setProposals(result.proposals);
    setYourVote(result.your_vote);
  }

  return (
    <>
      <AirmailHeader />
      <div className="flex-1 overflow-y-auto p-6">
        <p className="font-mono text-[11px] font-bold uppercase tracking-widest text-rust">
          4 travelers voting
        </p>
        <h2 className="mt-1 font-display text-2xl font-medium text-ink">Vote on Day 3</h2>

        <div className="mt-4 space-y-3">
          {proposals.map((p) => (
            <button
              key={p.id}
              onClick={() => vote(p.id)}
              className={`w-full rounded-lg border-[1.5px] bg-cream px-3.5 py-3 text-left ${
                yourVote === p.id ? "border-2 border-rust" : "border-ink"
              }`}
            >
              <div className="flex justify-between">
                <span className="text-sm font-bold text-ink">{p.title}</span>
                <span className="font-mono text-[10.5px] text-inkSoft">
                  {p.votes}/{p.total_voters}
                </span>
              </div>
              <div className="mt-2 h-2 overflow-hidden rounded-full bg-line">
                <div
                  className={`h-full ${yourVote === p.id ? "bg-rust" : "bg-pine"}`}
                  style={{ width: `${(p.votes / p.total_voters) * 100}%` }}
                />
              </div>
            </button>
          ))}
        </div>

        <Link
          href={`/group/compromise?tripId=${tripId}`}
          className="mt-5 block w-full rounded-md bg-rust px-5 py-4 text-center font-mono text-[13px] uppercase tracking-wide text-cream"
        >
          See compromise
        </Link>
      </div>
      <BottomNav tripId={tripId} />
    </>
  );
}

export default function GroupVotingPage() {
  return (
    <Suspense fallback={<p className="p-6 text-inkSoft">Loading…</p>}>
      <VotingContent />
    </Suspense>
  );
}
