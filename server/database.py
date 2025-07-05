import sqlite3
import os
from pathlib import Path

# Path to SQLite database file inside project directory
DB_PATH = Path(__file__).with_name("scores.db")

# Ensure database and table exist
def init_db():
    conn = sqlite3.connect(DB_PATH)
    cur = conn.cursor()
    cur.execute(
        """
        CREATE TABLE IF NOT EXISTS scores (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id TEXT,
            target TEXT,
            score INTEGER,
            timestamp DATETIME DEFAULT (datetime('now'))
        )
        """
    )
    conn.commit()
    conn.close()


def save_score(user_id: str, target: str, score: int):
    conn = sqlite3.connect(DB_PATH)
    cur = conn.cursor()
    cur.execute(
        "INSERT INTO scores (user_id, target, score) VALUES (?, ?, ?)",
        (user_id, target, score),
    )
    conn.commit()
    conn.close()


# Initialise DB at import time
init_db() 