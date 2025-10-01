import os
from pathlib import Path
import psycopg
from dotenv import load_dotenv, dotenv_values

ENV_PATH = Path(__file__).parents[1] / 'Exercises XP' / '.env'
load_dotenv(dotenv_path=ENV_PATH, override=True)
ENV_CFG = dotenv_values(ENV_PATH)

def get_conn():
    host = ENV_CFG.get('PGHOST') or os.getenv('PGHOST', 'localhost')
    port = ENV_CFG.get('PGPORT') or os.getenv('PGPORT', '5432')
    dbname = ENV_CFG.get('PGDATABASE') or os.getenv('PGDATABASE', 'menu_db')
    user = ENV_CFG.get('PGUSER') or os.getenv('PGUSER', 'postgres')
    password = ENV_CFG.get('PGPASSWORD') or os.getenv('PGPASSWORD', '')
    return psycopg.connect(host=host, port=port, dbname=dbname, user=user, password=password)

if __name__ == '__main__':
    try:
        with get_conn() as conn:
            with conn.cursor() as cur:
                cur.execute("SELECT COUNT(*) FROM countries")
                total = cur.fetchone()[0]
                print(f"countries rows: {total}")
                cur.execute("SELECT name, capital, subregion, population FROM countries ORDER BY id DESC LIMIT 5")
                for row in cur.fetchall():
                    print(row)
    except Exception as e:
        print('Verification failed:')
        print(e)
        raise SystemExit(1)
