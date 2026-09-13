import "./globals.css";
import type { Metadata } from "next";
import { OnboardingProvider } from "@/lib/OnboardingContext";

export const metadata: Metadata = {
  title: "TravelMate",
  description: "One trip. One app. Zero chaos.",
};

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="en">
      <body className="font-body min-h-screen bg-paper">
        <div className="mx-auto max-w-md min-h-screen bg-paper flex flex-col">
          <OnboardingProvider>{children}</OnboardingProvider>
        </div>
      </body>
    </html>
  );
}
