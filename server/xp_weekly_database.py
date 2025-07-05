import sqlite3
from pathlib import Path

DB_PATH = Path(__file__).with_name("xp_weekly.db")


def init_db():
    """Create the weekly xp table if it does not exist."""
    conn = sqlite3.connect(DB_PATH)
    cur = conn.cursor()
    cur.execute(
        """
        CREATE TABLE IF NOT EXISTS xp_weekly (
            user_id TEXT PRIMARY KEY,
            xp INTEGER NOT NULL DEFAULT 0,
            updated_at DATETIME DEFAULT (datetime('now'))
        )
        """
    )
    conn.commit()
    conn.close()


def get_xp(user_id: str) -> int:
    conn = sqlite3.connect(DB_PATH)
    cur = conn.cursor()
    cur.execute("SELECT xp FROM xp_weekly WHERE user_id = ?", (user_id,))
    row = cur.fetchone()
    conn.close()
    return row[0] if row else 0


def add_xp(user_id: str, amount: int):
    """Add XP to a user in the weekly table (creates row if absent)."""
    if amount == 0:
        return
    conn = sqlite3.connect(DB_PATH)
    cur = conn.cursor()
    cur.execute(
        """
        INSERT INTO xp_weekly (user_id, xp)
        VALUES (?, ?)
        ON CONFLICT(user_id) DO UPDATE SET xp = xp + excluded.xp, updated_at = datetime('now')
        """,
        (user_id, amount),
    )
    conn.commit()
    conn.close()


def get_leaderboard(limit: int = 10):
    """Return top users by weekly XP."""
    conn = sqlite3.connect(DB_PATH)
    cur = conn.cursor()
    cur.execute("SELECT user_id, xp FROM xp_weekly ORDER BY xp DESC LIMIT ?", (limit,))
    rows = cur.fetchall()
    conn.close()
    return [{"user_id": uid, "xp": xp} for uid, xp in rows]


def get_user_position(user_id: str):
    """Return a user's rank in the weekly leaderboard (1-based)."""
    conn = sqlite3.connect(DB_PATH)
    cur = conn.cursor()
    cur.execute("SELECT COUNT(*) FROM xp_weekly WHERE xp > (SELECT xp FROM xp_weekly WHERE user_id = ?)", (user_id,))
    position = cur.fetchone()[0] + 1
    conn.close()
    return position


def db_reset_xp(user_id: str):
    """Reset a single user's weekly XP to 0."""
    conn = sqlite3.connect(DB_PATH)
    cur = conn.cursor()
    cur.execute("UPDATE xp_weekly SET xp = 0 WHERE user_id = ?", (user_id,))
    conn.commit()
    conn.close()


def reset_all_xp():
    """Zero out XP for all users (e.g., at the start of a new week)."""
    conn = sqlite3.connect(DB_PATH)
    cur = conn.cursor()
    cur.execute("UPDATE xp_weekly SET xp = 0")
    conn.commit()
    conn.close()


# Initialise on import
init_db()
