import math
import sys
from pathlib import Path
from flask import Flask, render_template, request, redirect, url_for, flash

# Ensure imports work when running this file directly
sys.path.append(str(Path(__file__).parent))

from models.library import (
    list_books, get_book, create_book, update_book, delete_book,
    list_authors, get_author, create_author, update_author, delete_author,
    list_book_authors, set_book_authors, stats_counts, stats_books_by_year, PAGE_SIZE
)

app = Flask(__name__)
app.secret_key = 'dev-secret'

@app.route('/')
def home():
    return redirect(url_for('books_index'))

@app.get('/books')
def books_index():
    page = int(request.args.get('page', '1') or '1')
    q = (request.args.get('q') or '').strip() or None
    rows, total = list_books(page=page, q=q)
    pages = math.ceil(total / PAGE_SIZE) if total else 1
    return render_template('index.html', items=rows, entity='books', page=page, pages=pages, total=total, q=q)

@app.route('/books/create', methods=['GET', 'POST'])
def books_create():
    if request.method == 'POST':
        title = (request.form.get('title') or '').strip()
        year_raw = (request.form.get('year') or '').strip()
        au_ids = request.form.getlist('authors')
        if not title:
            flash('Title is required', 'error'); return redirect(url_for('books_create'))
        try:
            year = int(year_raw)
        except Exception:
            flash('Year must be an integer', 'error'); return redirect(url_for('books_create'))
        new_id = create_book(title, year)
        if new_id and au_ids:
            set_book_authors(new_id, [int(x) for x in au_ids])
        flash('Book created', 'success'); return redirect(url_for('books_index'))
@app.get('/books/<int:book_id>')
def books_details(book_id: int):
    book = get_book(book_id)
    if not book:
        flash('Book not found', 'error'); return redirect(url_for('books_index'))
    authors = list_book_authors(book_id)
    return render_template('details.html', item=book, authors=authors)
    # authors to pick
    authors, _ = list_authors(page=1, q=None)
    return render_template('create.html', entity='books', authors=authors)

@app.route('/books/<int:book_id>/edit', methods=['GET', 'POST'])
def books_edit(book_id: int):
    book = get_book(book_id)
    if not book:
        flash('Book not found', 'error'); return redirect(url_for('books_index'))
    if request.method == 'POST':
        title = (request.form.get('title') or '').strip()
        year_raw = (request.form.get('year') or '').strip()
        au_ids = request.form.getlist('authors')
        try:
            year = int(year_raw)
        except Exception:
            flash('Year must be integer', 'error'); return redirect(url_for('books_edit', book_id=book_id))
        update_book(book_id, title, year)
        set_book_authors(book_id, [int(x) for x in au_ids])
        flash('Book updated', 'success'); return redirect(url_for('books_index'))
    authors, _ = list_authors(page=1, q=None)
    selected = {a['author_id'] for a in list_book_authors(book_id)}
    return render_template('edit.html', entity='books', item=book, authors=authors, selected=selected)

@app.post('/books/<int:book_id>/delete')
def books_delete(book_id: int):
    delete_book(book_id); flash('Book deleted', 'info'); return redirect(url_for('books_index'))

@app.get('/authors')
def authors_index():
    page = int(request.args.get('page', '1') or '1')
    q = (request.args.get('q') or '').strip() or None
    rows, total = list_authors(page=page, q=q)
    pages = math.ceil(total / PAGE_SIZE) if total else 1
    return render_template('index.html', items=rows, entity='authors', page=page, pages=pages, total=total, q=q)

@app.route('/authors/create', methods=['GET', 'POST'])
def authors_create():
    if request.method == 'POST':
        name = (request.form.get('name') or '').strip()
        if not name:
            flash('Name is required', 'error'); return redirect(url_for('authors_create'))
        create_author(name); flash('Author created', 'success'); return redirect(url_for('authors_index'))
    return render_template('create.html', entity='authors')

@app.route('/authors/<int:author_id>/edit', methods=['GET', 'POST'])
def authors_edit(author_id: int):
    au = get_author(author_id)
    if not au:
        flash('Author not found', 'error'); return redirect(url_for('authors_index'))
    if request.method == 'POST':
        name = (request.form.get('name') or '').strip()
        update_author(author_id, name); flash('Author updated', 'success'); return redirect(url_for('authors_index'))
    return render_template('edit.html', entity='authors', item=au)

@app.post('/authors/<int:author_id>/delete')
def authors_delete(author_id: int):
    delete_author(author_id); flash('Author deleted', 'info'); return redirect(url_for('authors_index'))

@app.get('/stats')
def stats():
    counts = stats_counts()
    series = stats_books_by_year()
    years = [r['year'] for r in series]
    counts_by_year = [r['count'] for r in series]
    return render_template('stats.html', counts=counts, years=years, counts_by_year=counts_by_year)

if __name__ == '__main__':
    app.run(debug=True, host='127.0.0.1', port=5001)
