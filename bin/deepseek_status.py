#!/usr/bin/env python3
import json
import sys
from datetime import datetime, timezone

def check_deepseek_status():
    # Evaluate directly against UTC to avoid local timezone/DST drift
    now_utc = datetime.now(timezone.utc)
    weekday = now_utc.weekday()  # Monday = 0, Sunday = 6
    current_time = now_utc.time()

    # Peak hours: Monday to Friday
    # Window 1: 01:00 - 04:00 UTC (02:00 - 05:00 UTC+1)
    # Window 2: 06:00 - 10:00 UTC (07:00 - 11:00 UTC+1)
    is_weekday = weekday < 5
    in_w1 = datetime.strptime("01:00", "%H:%M").time() <= current_time < datetime.strptime("04:00", "%H:%M").time()
    in_w2 = datetime.strptime("06:00", "%H:%M").time() <= current_time < datetime.strptime("10:00", "%H:%M").time()

    is_peak = is_weekday and (in_w1 or in_w2)

    # Format for status bars (supports plain text or Waybar/Polybar JSON)
    if is_peak:
        data = {
            "text": "⚡ Peak",
            "tooltip": "DeepSeek: Peak Hours Active\n• UTC: 01:00–04:00 & 06:00–10:00\n• UTC+1: 02:00–05:00 & 07:00–11:00",
            "class": "peak"
        }
    else:
        data = {
            "text": "🟢 Off-Peak",
            "tooltip": "DeepSeek: Off-Peak (Discounts active / Low traffic)",
            "class": "offpeak"
        }

    # Print JSON if requested via flag, otherwise clean plain text
    if "--json" in sys.argv:
        print(json.dumps(data))
    else:
        print(data["text"])

if __name__ == "__main__":
    check_deepseek_status()

