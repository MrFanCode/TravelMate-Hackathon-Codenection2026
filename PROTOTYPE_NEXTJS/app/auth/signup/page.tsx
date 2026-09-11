"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import Link from "next/link";
import AirmailHeader from "@/components/AirmailHeader";
import PrimaryButton from "@/components/PrimaryButton";

/**
 * Fully fake — no real Firebase Auth/NextAuth call, matches the "feel
 * without the backend" pattern used everywhere else in this prototype.
 * Real implementation: Firebase Auth (email/password + Google), per
 * backend-architecture.md's auth flow section.
 */
export default function SignupPage() {
  const router = useRouter();
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [submitting, setSubmitting] = useState(false);

  async function handleSignup() {
    setSubmitting(true);
    await new Promise((r) => setTimeout(r, 500));
    router.push("/onboarding/trip-setup");
  }

  return (
    <>
      <AirmailHeader />
      <div className="flex flex-1 flex-col p-6">
        <p className="font-mono text-[11px] font-bold uppercase tracking-widest text-rust">
          Step 1
        </p>
        <h2 className="mt-1 font-display text-2xl font-medium text-ink">Create your account</h2>
        <p className="text-sm text-inkSoft">Takes a few seconds — no verification needed to try it.</p>

        <div className="mt-6 space-y-3">
          <button
            onClick={handleSignup}
            disabled={submitting}
            className="flex w-full items-center justify-center gap-2 rounded-lg border-[1.5px] border-ink bg-cream py-3.5 font-semibold text-ink disabled:opacity-50"
          >
            <span>G</span> Continue with Google
          </button>

          <div className="flex items-center gap-2 py-1">
            <div className="h-px flex-1 bg-line" />
            <span className="font-mono text-[10px] uppercase text-inkSoft">or</span>
            <div className="h-px flex-1 bg-line" />
          </div>

          <label className="block rounded-lg border-[1.5px] border-ink bg-cream px-3.5 py-2">
            <span className="font-mono text-[10px] uppercase tracking-wide text-inkSoft">Email</span>
            <input
              type="email"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              placeholder="you@example.com"
              className="block w-full bg-transparent text-base text-ink outline-none placeholder:text-inkSoft/50"
            />
          </label>
          <label className="block rounded-lg border-[1.5px] border-ink bg-cream px-3.5 py-2">
            <span className="font-mono text-[10px] uppercase tracking-wide text-inkSoft">Password</span>
            <input
              type="password"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              placeholder="••••••••"
              className="block w-full bg-transparent text-base text-ink outline-none placeholder:text-inkSoft/50"
            />
          </label>
        </div>

        <div className="mt-auto pt-6">
          <PrimaryButton
            label={submitting ? "Creating account…" : "Create account →"}
            disabled={submitting}
            onClick={handleSignup}
          />
          <p className="mt-4 text-center text-sm text-inkSoft">
            Already have an account?{" "}
            <Link href="/auth/login" className="font-semibold text-ink underline">
              Log in
            </Link>
          </p>
        </div>
      </div>
    </>
  );
}
