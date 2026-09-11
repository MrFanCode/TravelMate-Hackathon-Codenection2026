import Link from "next/link";

/** Same visual as PrimaryButton, but for simple page-to-page navigation. */
export default function PrimaryButtonLink({ href, label }: { href: string; label: string }) {
  return (
    <div className="relative">
      <Link
        href={href}
        className="block w-full rounded-md bg-rust px-5 py-4 text-center font-mono text-[13px] uppercase tracking-wide text-cream"
      >
        {label}
      </Link>
      <span className="absolute -left-[7px] top-1/2 h-3.5 w-3.5 -translate-y-1/2 rounded-full bg-paper" />
      <span className="absolute -right-[7px] top-1/2 h-3.5 w-3.5 -translate-y-1/2 rounded-full bg-paper" />
    </div>
  );
}
