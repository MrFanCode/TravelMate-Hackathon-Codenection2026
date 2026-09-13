import Link from "next/link";
import AirmailHeader from "@/components/AirmailHeader";
import PrimaryButtonLink from "@/components/PrimaryButtonLink";

export default function WelcomePage() {
  return (
    <>
      <AirmailHeader />
      <div className="flex flex-1 flex-col justify-between p-6">
        <div>
          <p className="font-mono text-[11px] font-bold uppercase tracking-widest text-rust">
            Trip planning, reimagined
          </p>
          <h1 className="mt-2 font-display text-4xl italic font-semibold leading-[1.05] text-ink">
            One trip.
            <br />
            One app.
            <br />
            Zero chaos.
          </h1>
          <p className="mt-4 text-sm leading-relaxed text-inkSoft">
            Itinerary, budget, group votes and disruption fixes — all stamped
            into a single passport.
          </p>
        </div>
        <div>
          <PrimaryButtonLink href="/auth/signup" label="Get started →" />
          <Link
            href="/auth/login"
            className="mt-4 block text-center text-sm font-semibold text-inkSoft underline"
          >
            I already have an account
          </Link>
        </div>
      </div>
    </>
  );
}
