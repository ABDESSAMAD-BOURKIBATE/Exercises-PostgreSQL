# Full-Stack Web Application – Library Manager

A Flask + PostgreSQL app demonstrating CRUD with pagination, search, many-to-many (books/authors), Tailwind UI, and a stats page using Chart.js.

## Structure

```
project/
  index.py              # Main Flask app (runs on 127.0.0.1:5001)
  models/library.py     # Data access functions
  database/
    index.py            # DB connection helpers (reads Day 4 .env)
    seed/index.sql      # Schema + seed data (10 books, 10 authors)
  templates/
    base.html, index.html, create.html, edit.html, stats.html
requirements.txt
```

## Setup

1) Ensure PostgreSQL is running, and your Day 4 `.env` has correct credentials at:
`Week #2 - Day #4 - Python and Database/Assignments/Exercises XP/.env`

2) Install requirements in your venv:
```powershell
& "C:\Users\LENOVO\Exercises PostgreSQL\.venv\Scripts\python.exe" -m pip install -r "C:\Users\LENOVO\Exercises PostgreSQL\Week #2 - Day #5 - Hackathon\Daily Challenges\Full-Stack Web Application\requirements.txt"
```

3) Seed the database (optional if tables already exist). You can run the SQL in pgAdmin/psql pointing to your target database from `.env`.

## Run

```powershell
& "C:\Users\LENOVO\Exercises PostgreSQL\.venv\Scripts\python.exe" "C:\Users\LENOVO\Exercises PostgreSQL\Week #2 - Day #5 - Hackathon\Daily Challenges\Full-Stack Web Application\project\index.py"
```

Visit:
- Books: <http://127.0.0.1:5001/books>
- Authors: <http://127.0.0.1:5001/authors>
- Stats: <http://127.0.0.1:5001/stats>

## Notes
- Pagination: 6 items per page
- Search: query param `?q=` filters by book title or author name (depending on list)
- Foreign keys include ON DELETE CASCADE for M:N link table
- Flash messages display success/error feedback

***

If DB auth fails, align your postgres password with `.env` (same as your Day 4 projects). You can also export `PGPASSWORD` in your shell for a single run.

***