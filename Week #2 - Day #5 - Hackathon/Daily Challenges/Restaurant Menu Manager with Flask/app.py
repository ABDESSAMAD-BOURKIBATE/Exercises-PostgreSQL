import os
from pathlib import Path
from typing import Optional

from flask import Flask, render_template, request, redirect, url_for, flash
import psycopg
from psycopg.rows import dict_row
from dotenv import load_dotenv, dotenv_values

app = Flask(__name__)
app.secret_key = os.environ.get("FLASK_SECRET_KEY", "dev-secret")

# Reuse the same .env used in Day#4 project for DB credentials
ENV_PATH = Path(__file__).parents[3] / 'Week #2 - Day #4 - Python and Database' / 'Assignments' / 'Exercises XP' / '.env'
# Force override to ensure VS Code/terminal env vars don't mask .env values
load_dotenv(dotenv_path=ENV_PATH, override=True)
ENV_CFG = dotenv_values(ENV_PATH)


def get_conn():
    # Prefer .env values explicitly, then fall back to process env, then defaults
    host = ENV_CFG.get('PGHOST') or os.getenv('PGHOST', 'localhost')
    port = ENV_CFG.get('PGPORT') or os.getenv('PGPORT', '5432')
    dbname = ENV_CFG.get('PGDATABASE') or os.getenv('PGDATABASE', 'menu_db')
    user = ENV_CFG.get('PGUSER') or os.getenv('PGUSER', 'postgres')
    password = ENV_CFG.get('PGPASSWORD') or os.getenv('PGPASSWORD', '')

    if os.getenv('DEBUG_DB', '0') == '1':
        pw_preview = '*' * max(0, len(password) - 4) + (password[-4:] if password else '')
        print(f"Connecting to postgres: host={host} port={port} db={dbname} user={user} password~={pw_preview}")

    conn = psycopg.connect(
        host=host,
        port=port,
        dbname=dbname,
        user=user,
        password=password,
    )
    return conn


def init_db():
    with get_conn() as conn:
        with conn.cursor() as cur:
            cur.execute(
                """
                CREATE TABLE IF NOT EXISTS menu_items (
                    item_id SERIAL PRIMARY KEY,
                    item_name VARCHAR(30) NOT NULL,
                    item_price SMALLINT DEFAULT 0
                );
                """
            )
            conn.commit()


@app.get('/')
def home():
    return redirect(url_for('menu'))


@app.get('/menu')
def menu():
    try:
        with get_conn() as conn:
            with conn.cursor(row_factory=dict_row) as cur:
                cur.execute("SELECT item_id, item_name, item_price FROM menu_items ORDER BY item_id DESC")
                items = cur.fetchall()
        return render_template('menu.html', items=items)
    except Exception as e:
        flash(f'Database error: {e}', 'danger')
        return render_template('menu.html', items=[])


@app.route('/add', methods=['GET', 'POST'])
def add():
    if request.method == 'POST':
        name = (request.form.get('name') or '').strip()
        price_raw = (request.form.get('price') or '').strip()
        if not name:
            flash('Name is required', 'danger')
            return redirect(url_for('add'))
        try:
            price = int(price_raw)
            if price < 0:
                raise ValueError('Price must be non-negative')
        except Exception:
            flash('Price must be an integer >= 0', 'danger')
            return redirect(url_for('add'))

        try:
            with get_conn() as conn:
                with conn.cursor() as cur:
                    cur.execute(
                        "INSERT INTO menu_items (item_name, item_price) VALUES (%s, %s)",
                        (name, price),
                    )
                    conn.commit()
            flash('Item added', 'success')
            return redirect(url_for('menu'))
        except Exception as e:
            flash(f'Database error: {e}', 'danger')
            return redirect(url_for('add'))

    return render_template('add.html')


def _get_item(item_id: int) -> Optional[dict]:
    with get_conn() as conn:
        with conn.cursor(row_factory=dict_row) as cur:
            cur.execute("SELECT item_id, item_name, item_price FROM menu_items WHERE item_id = %s", (item_id,))
            row = cur.fetchone()
            return row if row else None


@app.route('/update/<int:item_id>', methods=['GET', 'POST'])
def update(item_id: int):
    try:
        item = _get_item(item_id)
    except Exception as e:
        flash(f'Database error: {e}', 'danger')
        return redirect(url_for('menu'))
    if not item:
        flash('Item not found', 'warning')
        return redirect(url_for('menu'))

    if request.method == 'POST':
        name = (request.form.get('name') or '').strip()
        price_raw = (request.form.get('price') or '').strip()
        if not name:
            flash('Name is required', 'danger')
            return redirect(url_for('update', item_id=item_id))
        try:
            price = int(price_raw)
            if price < 0:
                raise ValueError('Price must be non-negative')
        except Exception:
            flash('Price must be an integer >= 0', 'danger')
            return redirect(url_for('update', item_id=item_id))

        try:
            with get_conn() as conn:
                with conn.cursor() as cur:
                    cur.execute(
                        "UPDATE menu_items SET item_name = %s, item_price = %s WHERE item_id = %s",
                        (name, price, item_id),
                    )
                    conn.commit()
            flash('Item updated', 'success')
            return redirect(url_for('menu'))
        except Exception as e:
            flash(f'Database error: {e}', 'danger')
            return redirect(url_for('update', item_id=item_id))

    return render_template('update.html', item=item)


@app.post('/delete/<int:item_id>')
def delete(item_id: int):
    try:
        with get_conn() as conn:
            with conn.cursor() as cur:
                cur.execute("DELETE FROM menu_items WHERE item_id = %s", (item_id,))
                conn.commit()
        flash('Item deleted', 'info')
    except Exception as e:
        flash(f'Database error: {e}', 'danger')
    return redirect(url_for('menu'))


if __name__ == '__main__':
    try:
        init_db()
    except Exception as e:
        print('WARN: DB init failed:', e)
    app.run(debug=True, host='127.0.0.1', port=5000)
