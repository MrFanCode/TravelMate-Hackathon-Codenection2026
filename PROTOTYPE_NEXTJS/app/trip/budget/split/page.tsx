"use client";

import { useEffect, useState, Suspense } from "react";
import { useRouter } from "next/navigation";
import AirmailHeader from "@/components/AirmailHeader";
import { fetchSettleUp, Balance } from "@/lib/mockBudgetService";

function SplitContent() {
  const router = useRouter();
  const [balances, setBalances] = useState<Balance[]>([]);
  const [yourNet, setYourNet] = useState(0);
  const [sending, setSending] = useState(false);

  useEffect(() => {
    fetchSettleUp().then(({ balances, your_net_usd }) => {
      setBalances(balances);
      setYourNet(your_net_usd);
    });
  }, []);

  async function handleSend() {
    setSending(true);
    await new Promise((r) => setTimeout(r, 400));
    alert("Settle-up requests sent.");
    setSending(false);
  }

  return (
    <>
      <AirmailHeader />
      <div className="flex items-center px-2 pt-1">
        <button onClick={() => router.back()} className="p-2 text-ink" aria-label="Back">
          ←
        </button>
      </div>
      <div className="flex-1 p-6 pt-1">
        <p className="font-mono text-[11px] font-bold uppercase tracking-widest text-rust">
          Settle up
        </p>
        <h2 className="mt-1 font-display text-2xl font-medium text-ink">Who owes whom</h2>

        <div className="mt-4 space-y-2.5">
          {balances.map((b, i) => (
            <Row key={i} label={`${b.from_name} owes ${b.to_name}`} amount={`$${b.amount_usd}`} color="text-rust" />
          ))}
          <Row label="You are owed" amount={`$${yourNet}`} color="text-pine" />
        </div>
      </div>
      <div className="p-6 pt-0">
        <button
          onClick={handleSend}
          disabled={sending}
          className="w-full rounded-md bg-rust px-5 py-4 font-mono text-[13px] uppercase tracking-wide text-cream disabled:opacity-50"
        >
          {sending ? "Sending…" : "Send settle-up requests"}
        </button>
      </div>
    </>
  );
}

function Row({ label, amount, color }: { label: string; amount: string; color: string }) {
  return (
    <div className="flex items-center justify-between rounded-lg border-[1.5px] border-ink bg-cream px-3.5 py-3">
      <span className="text-[13px] font-bold text-ink">{label}</span>
      <span className={`font-mono text-[13px] font-bold ${color}`}>{amount}</span>
    </div>
  );
}

export default function SplitPage() {
  return (
    <Suspense fallback={<p className="p-6 text-inkSoft">Loading…</p>}>
      <SplitContent />
    </Suspense>
  );
}
