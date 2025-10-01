import os
from pathlib import Path
from typing import Any
import psycopg
from psycopg.rows import dict_row
from dotenv import load_dotenv, dotenv_values

ENV_PATH = Path(__file__).parents[6] / 'Week #2 - Day #4 - Python and Database' / 'Assignments' / 'Exercises XP' / '.env'
load_dotenv(dotenv_path=ENV_PATH, override=True)
ENV_CFG = dotenv_values(ENV_PATH)

def get_conn():
    host = ENV_CFG.get('PGHOST') or os.getenv('PGHOST', 'localhost')
    port = ENV_CFG.get('PGPORT') or os.getenv('PGPORT', '5432')
    dbname = ENV_CFG.get('PGDATABASE') or os.getenv('PGDATABASE', 'menu_db')
    user = ENV_CFG.get('PGUSER') or os.getenv('PGUSER', 'postgres')
    password = ENV_CFG.get('PGPASSWORD') or os.getenv('PGPASSWORD', '')
    return psycopg.connect(host=host, port=port, dbname=dbname, user=user, password=password)

def fetch_all(sql, params: tuple[Any, ...] = ()): 
    with get_conn() as conn:
        with conn.cursor(row_factory=dict_row) as cur:
            cur.execute(sql, params)
            return cur.fetchall()

def fetch_one(sql, params: tuple[Any, ...] = ()): 
    with get_conn() as conn:
        with conn.cursor(row_factory=dict_row) as cur:
            cur.execute(sql, params)
            return cur.fetchone()

def execute(sql, params: tuple[Any, ...] = ()):  # returns rows affected
    with get_conn() as conn:
        with conn.cursor() as cur:
            cur.execute(sql, params)
            conn.commit()
            return cur.rowcount
