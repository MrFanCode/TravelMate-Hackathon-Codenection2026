import { NextRequest, NextResponse } from "next/server";
import { google } from "googleapis";
import { getServerSession } from "next-auth";

/**
 * Checks when the group is free, using each member's own connected
 * Google Calendar.
 *
 * IMPORTANT constraint: Google's freebusy.query can only see calendars
 * the authenticated token has access to — there's no way to check
 * someone else's calendar using your own token. That means EVERY group
 * member has to individually sign in with Google (via NextAuth) and
 * grant calendar.freebusy access before this can check their schedule.
 * In production: store each member's refresh_token in Firestore when
 * they connect, then loop over the group's stored tokens here — this
 * demo only checks the current signed-in user's own calendar, since
 * that's all a single request has access to.
 */
export async function POST(req: NextRequest) {
  const session = await getServerSession();
  const accessToken = (session as any)?.accessToken;

  if (!accessToken) {
    return NextResponse.json({ error: { code: "not_connected", message: "Connect Google Calendar first" } }, { status: 401 });
  }

  const { timeMin, timeMax } = await req.json();

  const oauth2Client = new google.auth.OAuth2();
  oauth2Client.setCredentials({ access_token: accessToken });
  const calendar = google.calendar({ version: "v3", auth: oauth2Client });

  const result = await calendar.freebusy.query({
    requestBody: {
      timeMin,
      timeMax,
      items: [{ id: "primary" }],
    },
  });

  const busy = result.data.calendars?.primary?.busy ?? [];

  return NextResponse.json({ busy });
}
