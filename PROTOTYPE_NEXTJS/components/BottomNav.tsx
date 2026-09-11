"use client";

import Link from "next/link";
import { usePathname } from "next/navigation";

const TABS = [
  {
    href: "/trip",
    label: "Trip",
    icon: (
      <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.7">
        <rect x="3" y="5" width="18" height="16" rx="2" />
        <path d="M3 10h18M8 3v4M16 3v4" />
      </svg>
    ),
  },
  {
    href: "/trip/map",
    label: "Map",
    icon: (
      <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.7">
        <path d="M9 20l-6-3V4l6 3 6-3 6 3v13l-6-3-6 3z" />
      </svg>
    ),
  },
  {
    href: "/trip/budget",
    label: "Budget",
    icon: (
      <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.7">
        <rect x="3" y="6" width="18" height="13" rx="2" />
        <path d="M3 10h18M16 15h2" />
      </svg>
    ),
  },
  {
    href: "/group/voting",
    label: "Group",
    icon: (
      <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.7">
        <circle cx="8" cy="8" r="3" />
        <circle cx="16" cy="8" r="3" />
        <path d="M2 20c0-3.3 2.7-5.5 6-5.5s6 2.2 6 5.5M12.5 15c.9-.6 2-.9 3.3-.9 2.9 0 5.2 2 5.2 5.4" />
      </svg>
    ),
  },
];

export default function BottomNav({ tripId = "trip_9f2a" }: { tripId?: string }) {
  const pathname = usePathname();
  return (
    <div className="flex h-[74px] items-center justify-around border-t-[1.5px] border-ink bg-cream">
      {TABS.map((tab) => {
        const active = pathname === tab.href;
        return (
          <Link
            key={tab.href}
            href={`${tab.href}?tripId=${tripId}`}
            className={`flex flex-col items-center gap-1 ${active ? "text-rust" : "text-inkSoft"}`}
          >
            {tab.icon}
            <span className="font-mono text-[9px] uppercase">{tab.label}</span>
          </Link>
        );
      })}
    </div>
  );
}
