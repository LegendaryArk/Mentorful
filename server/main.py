import logging
import os
import base64
from fastapi import FastAPI, File, UploadFile, HTTPException, Form, Query
from openai import OpenAI

from dotenv import load_dotenv
from .database import save_score
from .xp_database import get_xp as db_get_xp, add_xp as db_add_xp, get_leaderboard, get_user_position, db_reset_xp
from .xp_weekly_database import (
    get_xp as db_get_xp_weekly,
    add_xp as db_add_xp_weekly,
    get_leaderboard as get_leaderboard_weekly,
    get_user_position as get_user_position_weekly,
    db_reset_xp as db_reset_xp_weekly,
    reset_all_xp as reset_all_xp_weekly,
)

from pydantic import BaseModel


class CalendarEvent(BaseModel):
    title: str
    start_time: str  # "HH:MM" or "All Day"
    end_time: str

load_dotenv()  # This will load variables from .env file into the environment

client = OpenAI(api_key=os.getenv("OPENAI_API_KEY"))

app = FastAPI()

logger = logging.getLogger('uvicorn.error')
logger.setLevel(logging.DEBUG)

from .prompts import DESK_PROMPT, BATHROOM_PROMPT
from .tutorials import DESK_TUTORIAL, BATHROOM_TUTORIAL

PROMPTS = {
    "desk": DESK_PROMPT,
    "bathroom": BATHROOM_PROMPT
}

TUTORIALS = {
    "desk": DESK_TUTORIAL,
    "bathroom": BATHROOM_TUTORIAL
}

@app.post("/rating/")
async def get_rating_from_image(target: str = Form(...), file: UploadFile = File(...), user_id: str = Form("anonymous")):

    image_bytes = await file.read()
    image_base64 = base64.b64encode(image_bytes).decode("utf-8")

    # get prompt injection based on target
    def get_prompt(target):
        match target:
            case "desk":
                return DESK_PROMPT
            case "bathroom":
                return BATHROOM_PROMPT
            case _:
                raise HTTPException(status_code=400, detail="Invalid target")

    logger.debug(file.content_type)

    if not file.content_type or not file.content_type.startswith("image/"):
        raise HTTPException(status_code=400, detail="File must be an image file")

    try:
        response = client.chat.completions.create(
            model="gpt-4o-mini-2024-07-18",
            messages=[
                {"role": "system", "content": get_prompt(target)},
                {"role": "user", "content": image_base64}
            ],
        )
    except Exception:
        raise HTTPException(status_code=500, detail='Something went wrong')
    try:
        score_int = int(response.choices[0].message.content.strip())
        save_score(user_id, target, score_int)
    except Exception:
        logger.exception("Failed to save score")

    return {"rating": response.choices[0].message.content}

@app.get("/tutorial/")
async def get_tutorial(target: str = Query(...)):
    match target:
        case "desk":
            return DESK_TUTORIAL
        case "bathroom":
            return BATHROOM_TUTORIAL
        case _:
            raise HTTPException(status_code=400, detail="Invalid target")
        
@app.get("/xp/")
async def read_xp(user_id: str = Query(...)):
    return {"xp": db_get_xp(user_id)}

@app.post("/add-xp/")
async def add_user_xp(user_id: str = Form(...), amount: int = Form(...)):
    db_add_xp(user_id, amount)
    return {"xp": db_get_xp(user_id)}

@app.get("/reset-xp/")
async def reset_xp(user_id: str = Query(...)):
    db_reset_xp(user_id)
    return {"xp": db_get_xp(user_id)}

@app.get("/global-leaderboard/")
async def global_leaderboard(limit: int = Query(10, ge=1, le=100)):
    return get_leaderboard(limit)

@app.get("/user-position/")
async def user_position(user_id: str = Query(...)):
    return {"position": get_user_position(user_id)}

@app.get("/xp-weekly/")
async def read_xp_weekly(user_id: str = Query(...)):
    return {"xp": db_get_xp_weekly(user_id)}


@app.post("/add-xp-weekly/")
async def add_user_xp_weekly(user_id: str = Form(...), amount: int = Form(...)):
    db_add_xp_weekly(user_id, amount)
    return {"xp": db_get_xp_weekly(user_id)}


@app.get("/reset-xp-weekly/")
async def reset_xp_weekly(user_id: str = Query(...)):
    db_reset_xp_weekly(user_id)
    return {"xp": db_get_xp_weekly(user_id)}


@app.get("/global-leaderboard-weekly/")
async def global_leaderboard_weekly(limit: int = Query(10, ge=1, le=100)):
    return get_leaderboard_weekly(limit)


@app.get("/user-position-weekly/")
async def user_position_weekly(user_id: str = Query(...)):
    return {"position": get_user_position_weekly(user_id)}


@app.get("/reset-all-xp-weekly/")
async def reset_all_xp_weekly_endpoint():
    reset_all_xp_weekly()
    return {"message": "All weekly XP has been reset"}

@app.get("/get-calendar/")
async def get_calendar(token: str = Query(...)):
    """
    Get Google Calendar events for the next full week using a user's auth token.
    Returns a JSON with each day containing a list of events with title, start, and end times.
    """
    import requests
    from datetime import datetime, timedelta
    import json

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


# Accepts a JSON array of events for one day (as returned by /get-calendar/)
# and returns any notifications that should be sent right now for desk/bathroom checkups.


@app.post("/daily-notification/")
async def daily_notification(events: list[CalendarEvent]):
    """Decide whether to send desk/bathroom check-up notifications.

    The client should POST the list that corresponds to *today* (or any day you want to check)
    from the `/get-calendar/` response.
    If an event title is exactly "Clean Desk" or "Clean Bathroom" and the current time is within
    its `[start_time, end_time]` window (inclusive), a notification object is returned.
    """

    from datetime import datetime, date, timedelta
    import random

    now = datetime.now()

    notifications = []  # will hold at most two notifications

    for ev in events:
        title = ev.title.strip()

        # Map calendar title to notification metadata
        if title == "Clean Desk":
            notif_title = "Desk Checkup"
            notif_desc = "Please take a picture of your desk."
        elif title == "Clean Bathroom":
            notif_title = "Bathroom Checkup"
            notif_desc = "Please take a picture of your bathroom."
        else:
            continue  # skip unrelated events

        # All-day event: always eligible – choose random time between 09:00 and 17:00
        if ev.start_time == "All Day":
            trigger_sec = random.randint(9 * 3600, 17 * 3600)  # seconds since midnight
            trigger_time = (datetime.combine(date.today(), datetime.min.time()) + timedelta(seconds=trigger_sec)).strftime("%H:%M")
            notifications.append({
                "title": notif_title,
                "description": notif_desc,
                "trigger_time": trigger_time,
            })
            continue

        try:
            start_dt = datetime.combine(date.today(), datetime.strptime(ev.start_time, "%H:%M").time())
            end_dt = datetime.combine(date.today(), datetime.strptime(ev.end_time, "%H:%M").time())
        except ValueError:
            # Could not parse time strings; skip this event
            continue

        if start_dt <= now <= end_dt:
            total_seconds = int((end_dt - start_dt).total_seconds())
            if total_seconds > 0:
                rand_offset = random.randint(0, total_seconds)
                trigger_time = (start_dt + timedelta(seconds=rand_offset)).strftime("%H:%M")
            else:
                trigger_time = ev.start_time  # fallback

            notifications.append({
                "title": notif_title,
                "description": notif_desc,
                "trigger_time": trigger_time,
            })

        # stop once we have both notifications
        if len(notifications) == 2:
            break

    return {"notifications": notifications}