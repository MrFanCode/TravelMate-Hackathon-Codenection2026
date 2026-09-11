"use client";

/** Rust "ticket stub" CTA button — matches PrimaryButton from the Flutter build. */
export default function PrimaryButton({
  label,
  onClick,
  disabled = false,
}: {
  label: string;
  onClick?: () => void;
  disabled?: boolean;
}) {
  return (
    <div className="relative">
      <button
        onClick={onClick}
        disabled={disabled}
        className="w-full rounded-md bg-rust px-5 py-4 font-mono text-[13px] uppercase tracking-wide text-cream disabled:opacity-50"
      >
        {label}
      </button>
      <span className="absolute -left-[7px] top-1/2 h-3.5 w-3.5 -translate-y-1/2 rounded-full bg-paper" />
      <span className="absolute -right-[7px] top-1/2 h-3.5 w-3.5 -translate-y-1/2 rounded-full bg-paper" />
    </div>
  );
}
