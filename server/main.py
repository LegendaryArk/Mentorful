import os
from datetime import datetime, timedelta
from fastapi import FastAPI, Query
import requests

app = FastAPI()

@app.get("/get-calendar/")
async def get_calendar(token: str = Query(...)):
    """
    Get Google Calendar events for the next full week using a user's auth token.
    Returns a JSON with each day containing a list of events with title, start, and end times.
    """

    # Calculate the next full week (Monday to Sunday)
    today = datetime.now()
    days_until_monday = (7 - today.weekday()) % 7
    if days_until_monday == 0:
        days_until_monday = 7  # If today is Monday, get next Monday

    next_monday = today + timedelta(days=days_until_monday)
    next_sunday = next_monday + timedelta(days=6)

    # Format dates for Google Calendar API
    time_min = next_monday.replace(hour=0, minute=0, second=0, microsecond=0).isoformat() + 'Z'
    time_max = next_sunday.replace(hour=23, minute=59, second=59, microsecond=999999).isoformat() + 'Z'

    # Google Calendar API endpoint
    url = "https://www.googleapis.com/calendar/v3/calendars/primary/events"
    headers = {
        "Authorization": f"Bearer {token}",
        "Content-Type": "application/json"
    }
    params = {
        "timeMin": time_min,
        "timeMax": time_max,
        "singleEvents": True,
        "orderBy": "startTime"
    }

    try:
        response = requests.get(url, headers=headers, params=params)
        response.raise_for_status()

        events_data = response.json()
        calendar_events = {}

        # Initialize all days of the week
        for i in range(7):
            day_date = next_monday + timedelta(days=i)
            day_key = day_date.strftime("%Y-%m-%d")
            calendar_events[day_key] = []

        # Process events
        for event in events_data.get("items", []):
            start = event.get("start", {})
            end = event.get("end", {})

            # Handle both date and dateTime formats
            if "dateTime" in start:
                start_time = datetime.fromisoformat(start["dateTime"].replace("Z", "+00:00"))
                end_time = datetime.fromisoformat(end["dateTime"].replace("Z", "+00:00"))
                day_key = start_time.strftime("%Y-%m-%d")

                calendar_events[day_key].append({
                    "title": event.get("summary", "No Title"),
                    "start_time": start_time.strftime("%H:%M"),
                    "end_time": end_time.strftime("%H:%M")
                })
            elif "date" in start:
                # All-day events
                day_key = start["date"]
                calendar_events[day_key].append({
                    "title": event.get("summary", "No Title"),
                    "start_time": "All Day",
                    "end_time": "All Day"
                })

        return calendar_events

    except requests.exceptions.RequestException as e:
        return {"error": f"Failed to fetch calendar events: {str(e)}"}
    except Exception as e:
        return {"error": f"Unexpected error: {str(e)}"}