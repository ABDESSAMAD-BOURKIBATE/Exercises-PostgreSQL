from typing import Any, Optional
from database.index import fetch_all, fetch_one, execute

PAGE_SIZE = 6

def list_books(page: int = 1, q: Optional[str] = None):
    where = ""
    params: list[Any] = []
    if q:
        where = "WHERE LOWER(b.title) LIKE LOWER(%s)"
        params.append(f"%{q}%")
    offset = (max(page, 1) - 1) * PAGE_SIZE
    sql = f"""
        SELECT b.book_id, b.title, b.year, array_remove(array_agg(a.name) FILTER (WHERE a.author_id IS NOT NULL), NULL) AS authors
        FROM books b
        LEFT JOIN books_authors ba ON ba.book_id = b.book_id
        LEFT JOIN authors a ON a.author_id = ba.author_id
        {where}
        GROUP BY b.book_id
        ORDER BY b.book_id DESC
        LIMIT {PAGE_SIZE} OFFSET %s
    """
    params2 = params + [offset]
    rows = fetch_all(sql, tuple(params2))

    # count total
    if q:
        cnt = fetch_one("SELECT COUNT(*) AS c FROM books b WHERE LOWER(b.title) LIKE LOWER(%s)", (f"%{q}%",))
    else:
        cnt = fetch_one("SELECT COUNT(*) AS c FROM books", ())
    total = (cnt or {}).get('c', 0)
    return rows, total

def get_book(book_id: int):
    return fetch_one("SELECT book_id, title, year FROM books WHERE book_id = %s", (book_id,))

def create_book(title: str, year: int) -> int:
    # Return new book id
    row = fetch_one("INSERT INTO books (title, year) VALUES (%s, %s) RETURNING book_id", (title, year))
    return int(row["book_id"]) if row else 0

def update_book(book_id: int, title: str, year: int):
    return execute("UPDATE books SET title = %s, year = %s WHERE book_id = %s", (title, year, book_id))

def delete_book(book_id: int):
    return execute("DELETE FROM books WHERE book_id = %s", (book_id,))

def list_authors(page: int = 1, q: Optional[str] = None):
    where = ""
    params: list[Any] = []
    if q:
        where = "WHERE LOWER(name) LIKE LOWER(%s)"
        params.append(f"%{q}%")
    offset = (max(page, 1) - 1) * PAGE_SIZE
    sql = f"SELECT author_id, name FROM authors {where} ORDER BY author_id DESC LIMIT {PAGE_SIZE} OFFSET %s"
    rows = fetch_all(sql, tuple(params + [offset]))
    if q:
        cnt = fetch_one("SELECT COUNT(*) AS c FROM authors WHERE LOWER(name) LIKE LOWER(%s)", (f"%{q}%",))
    else:
        cnt = fetch_one("SELECT COUNT(*) AS c FROM authors", ())
    total = (cnt or {}).get('c', 0)
    return rows, total

def get_author(author_id: int):
    return fetch_one("SELECT author_id, name FROM authors WHERE author_id = %s", (author_id,))

def create_author(name: str):
    return execute("INSERT INTO authors (name) VALUES (%s)", (name,))

def update_author(author_id: int, name: str):
    return execute("UPDATE authors SET name = %s WHERE author_id = %s", (name, author_id))

def delete_author(author_id: int):
    return execute("DELETE FROM authors WHERE author_id = %s", (author_id,))

def set_book_authors(book_id: int, author_ids: list[int]):
    execute("DELETE FROM books_authors WHERE book_id = %s", (book_id,))
    for aid in author_ids:
        execute("INSERT INTO books_authors (book_id, author_id) VALUES (%s, %s) ON CONFLICT DO NOTHING", (book_id, aid))

def list_book_authors(book_id: int):
    return fetch_all("""
        SELECT a.author_id, a.name
        FROM authors a
        JOIN books_authors ba ON ba.author_id = a.author_id
        WHERE ba.book_id = %s
        ORDER BY a.name
    """, (book_id,))

def stats_counts():
    b = fetch_one("SELECT COUNT(*) AS c FROM books", ()) or {"c": 0}
    a = fetch_one("SELECT COUNT(*) AS c FROM authors", ()) or {"c": 0}
    m = fetch_one("SELECT COUNT(*) AS c FROM books_authors", ()) or {"c": 0}
    return {"books": b["c"], "authors": a["c"], "links": m["c"]}

def stats_books_by_year():
    return fetch_all("SELECT year, COUNT(*) AS count FROM books GROUP BY year ORDER BY year")
