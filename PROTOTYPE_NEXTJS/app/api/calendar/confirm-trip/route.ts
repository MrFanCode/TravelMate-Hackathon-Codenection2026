import { NextRequest, NextResponse } from "next/server";
import { google } from "googleapis";
import { getServerSession } from "next-auth";

/**
 * Once a trip's dates are confirmed, block them on the (currently
 * signed-in) user's calendar. In production: loop over every group
 * member's stored refresh_token and create the event on each of their
 * calendars, same constraint as freebusy — you can only write to a
 * calendar you have an authorized token for.
 */
export async function POST(req: NextRequest) {
  const session = await getServerSession();
  const accessToken = (session as any)?.accessToken;

  if (!accessToken) {
    return NextResponse.json({ error: { code: "not_connected", message: "Connect Google Calendar first" } }, { status: 401 });
  }

  const { destination, departDate, returnDate } = await req.json();

  const oauth2Client = new google.auth.OAuth2();
  oauth2Client.setCredentials({ access_token: accessToken });
  const calendar = google.calendar({ version: "v3", auth: oauth2Client });

  const event = await calendar.events.insert({
    calendarId: "primary",
    requestBody: {
      summary: `Trip: ${destination}`,
      start: { date: departDate },
      end: { date: returnDate },
    },
  });

  return NextResponse.json({ event_id: event.data.id, html_link: event.data.htmlLink });
}
