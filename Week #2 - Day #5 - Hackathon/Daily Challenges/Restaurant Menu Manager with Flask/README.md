# Restaurant Menu Manager (Flask)

A simple Flask web app to manage a restaurant menu using PostgreSQL.

## What it is

- Web remake of the Day #4 terminal project (Menu Manager)
- Demonstrates CRUD over a `menu_items` table:
  - View menu
  - Add item
  - Update item
  - Delete item

## How to run

1. Ensure PostgreSQL is running and your Day #4 `.env` has correct credentials at:
   `Week #2 - Day #4 - Python and Database/Assignments/Exercises XP/.env`

1. Install dependencies in your existing venv:

```powershell
& "C:\Users\LENOVO\Exercises PostgreSQL\.venv\Scripts\python.exe" -m pip install -r "C:\Users\LENOVO\Exercises PostgreSQL\Week #2 - Day #5 - Hackathon\Daily Challenges\Restaurant Menu Manager with Flask\requirements.txt"
```

1. Start the app:

```powershell
& "C:\Users\LENOVO\Exercises PostgreSQL\.venv\Scripts\python.exe" "C:\Users\LENOVO\Exercises PostgreSQL\Week #2 - Day #5 - Hackathon\Daily Challenges\Restaurant Menu Manager with Flask\app.py"
```

1. Open <http://127.0.0.1:5000/menu> in your browser.

The app auto-creates the `menu_items` table if it doesn't exist.

## Notes

- Uses psycopg v3 and reads DB credentials from the existing `.env`.
- Minimal Bootstrap UI.
- For deletion, we use POST to `/delete/<id>` with a small confirm.

Happy hacking!
