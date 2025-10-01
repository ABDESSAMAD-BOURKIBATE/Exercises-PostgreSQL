import os
import random
from pathlib import Path
import requests
import psycopg
from dotenv import load_dotenv, dotenv_values

# Load env from Exercises XP folder to reuse DB creds
ENV_PATH = Path(__file__).parents[1] / 'Exercises XP' / '.env'
# Ensure any existing env vars won't mask .env values; also read values explicitly
load_dotenv(dotenv_path=ENV_PATH, override=True)
ENV_CFG = dotenv_values(ENV_PATH)

API_URL = "https://restcountries.com/v3.1/all?fields=name,capital,flags,subregion,population"

DDL = """
CREATE TABLE IF NOT EXISTS countries (
    id SERIAL PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    capital VARCHAR(200),
    flag TEXT,
    subregion VARCHAR(200),
    population BIGINT
);
"""

INSERT_SQL = """
INSERT INTO countries (name, capital, flag, subregion, population)
VALUES (%s, %s, %s, %s, %s)
ON CONFLICT DO NOTHING;
"""

def get_conn():
    # Prefer values parsed from .env; fall back to process env; then defaults
    host = ENV_CFG.get('PGHOST') or os.getenv('PGHOST', 'localhost')
    port = ENV_CFG.get('PGPORT') or os.getenv('PGPORT', '5432')
    dbname = ENV_CFG.get('PGDATABASE') or os.getenv('PGDATABASE', 'menu_db')
    user = ENV_CFG.get('PGUSER') or os.getenv('PGUSER', 'postgres')
    password = ENV_CFG.get('PGPASSWORD') or os.getenv('PGPASSWORD', '')
    # Simple debug to ensure we loaded the expected values
    pw_preview = '*' * max(0, len(password) - 4) + (password[-4:] if password else '')
    print(f"Connecting to postgres: host={host} port={port} db={dbname} user={user} password~={pw_preview}")
    return psycopg.connect(
        host=host,
        port=port,
        dbname=dbname,
        user=user,
        password=password
    )


def normalize_country(rec: dict) -> tuple:
    name = (rec.get('name') or {}).get('common') or None
    capital_list = rec.get('capital') or []
    capital = capital_list[0] if capital_list else None
    flags = rec.get('flags') or {}
    flag = flags.get('png') or flags.get('svg') or None
    subregion = rec.get('subregion') or None
    population = rec.get('population') or None
    return (name, capital, flag, subregion, population)


def main():
    resp = requests.get(API_URL, timeout=30)
    resp.raise_for_status()
    all_countries = resp.json()
    if not isinstance(all_countries, list) or not all_countries:
        raise SystemExit('API returned no countries')

    sample = random.sample(all_countries, k=min(10, len(all_countries)))
    rows = [normalize_country(c) for c in sample]

    with get_conn() as conn:
        with conn.cursor() as cur:
            cur.execute(DDL)
            cur.executemany(INSERT_SQL, rows)
            conn.commit()
    print('Inserted', len(rows), 'countries')


if __name__ == '__main__':
    main()
