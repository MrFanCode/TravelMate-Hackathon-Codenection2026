export default function ProgressRail({ step, total = 3 }: { step: number; total?: number }) {
  return (
    <div className="flex gap-1.5">
      {Array.from({ length: total }).map((_, i) => (
        <div
          key={i}
          className={`h-1 flex-1 rounded-full ${i < step ? "bg-rust" : "bg-line"}`}
        />
      ))}
    </div>
  );
}
