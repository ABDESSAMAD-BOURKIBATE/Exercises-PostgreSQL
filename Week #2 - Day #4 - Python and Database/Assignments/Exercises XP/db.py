import os
from pathlib import Path
import psycopg
from dotenv import load_dotenv

# Always load .env located next to this file (works regardless of CWD)
ENV_PATH = Path(__file__).with_name('.env')
load_dotenv(dotenv_path=ENV_PATH, override=False)

def get_conn():
    return psycopg.connect(
        host=os.getenv('PGHOST', 'localhost'),
        port=os.getenv('PGPORT', '5432'),
        dbname=os.getenv('PGDATABASE', 'menu_db'),
        user=os.getenv('PGUSER', 'postgres'),
        password=os.getenv('PGPASSWORD', '')
    )

def init_db():
    with get_conn() as conn:
        with conn.cursor() as cur:
            cur.execute("""
                CREATE TABLE IF NOT EXISTS menu_items (
                    item_id SERIAL PRIMARY KEY,
                    item_name VARCHAR(30) NOT NULL,
                    item_price SMALLINT DEFAULT 0
                );
            """)
            conn.commit()

if __name__ == '__main__':
    init_db()
    print('DB initialized')
