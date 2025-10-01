import os
from pathlib import Path
import psycopg
from dotenv import load_dotenv

# load .env from Day 4 XP folder
ENV_PATH = Path(__file__).parents[1] / 'Exercises XP' / '.env'
load_dotenv(dotenv_path=ENV_PATH, override=False)

def get_conn():
    return psycopg.connect(
        host=os.getenv('PGHOST', 'localhost'),
        port=os.getenv('PGPORT', '5432'),
        dbname=os.getenv('PGDATABASE', 'menu_db'),
        user=os.getenv('PGUSER', 'postgres'),
        password=os.getenv('PGPASSWORD', '')
    )

def init_users_table():
    with get_conn() as conn:
        with conn.cursor() as cur:
            cur.execute(
                """
                CREATE TABLE IF NOT EXISTS auth_users (
                    user_id SERIAL PRIMARY KEY,
                    username VARCHAR(50) UNIQUE NOT NULL,
                    password_hash TEXT NOT NULL,
                    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
                );
                """
            )
            conn.commit()
