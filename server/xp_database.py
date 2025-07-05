import sqlite3
from pathlib import Path

DB_PATH = Path(__file__).with_name("xp.db")


def init_db():
    """Create the xp table if it does not exist."""
    conn = sqlite3.connect(DB_PATH)
    cur = conn.cursor()
    cur.execute(
        """
        CREATE TABLE IF NOT EXISTS xp (
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
    cur.execute("SELECT xp FROM xp WHERE user_id = ?", (user_id,))
    row = cur.fetchone()
    conn.close()
    return row[0] if row else 0


def add_xp(user_id: str, amount: int):
    """Add XP to a user (will create the user row if not present)."""
    if amount == 0:
        return
    conn = sqlite3.connect(DB_PATH)
    cur = conn.cursor()
    cur.execute(
        """
        INSERT INTO xp (user_id, xp)
        VALUES (?, ?)
        ON CONFLICT(user_id) DO UPDATE SET xp = xp + excluded.xp, updated_at = datetime('now')
        """,
        (user_id, amount),
    )
    conn.commit()
    conn.close()


def get_leaderboard(limit: int = 10):
    """Return top users by XP as a list of dicts [{user_id, xp}]."""
    conn = sqlite3.connect(DB_PATH)
    cur = conn.cursor()
    cur.execute("SELECT user_id, xp FROM xp ORDER BY xp DESC LIMIT ?", (limit,))
    rows = cur.fetchall()
    conn.close()
    return [{"user_id": uid, "xp": xp} for uid, xp in rows]


def get_user_position(user_id: str):
    """Return the position of a user in the leaderboard."""
    conn = sqlite3.connect(DB_PATH)
    cur = conn.cursor()
    cur.execute("SELECT COUNT(*) FROM xp WHERE xp > (SELECT xp FROM xp WHERE user_id = ?)", (user_id,))
    position = cur.fetchone()[0] + 1
    conn.close()
    return position


def db_reset_xp(user_id: str):
    """Reset the XP of a user."""
    conn = sqlite3.connect(DB_PATH)
    cur = conn.cursor()
    cur.execute("UPDATE xp SET xp = 0 WHERE user_id = ?", (user_id,))
    conn.commit()
    conn.close()

# Initialise when the module is imported
init_db() 