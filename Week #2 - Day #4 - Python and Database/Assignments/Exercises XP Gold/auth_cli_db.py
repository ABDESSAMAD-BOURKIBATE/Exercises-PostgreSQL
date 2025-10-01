from getpass import getpass
from typing import Optional
from passlib.hash import bcrypt
from auth_db import get_conn, init_users_table


def find_user(username: str) -> Optional[tuple]:
    with get_conn() as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT user_id, username, password_hash FROM auth_users WHERE username=%s", (username,))
            return cur.fetchone()


def create_user(username: str, password: str) -> bool:
    pwd_hash = bcrypt.hash(password)
    with get_conn() as conn:
        with conn.cursor() as cur:
            try:
                cur.execute("INSERT INTO auth_users (username, password_hash) VALUES (%s, %s)", (username, pwd_hash))
                conn.commit()
                return True
            except Exception:
                conn.rollback()
                return False


def login_flow() -> Optional[str]:
    username = input('username: ').strip()
    password = getpass('password: ').strip()
    row = find_user(username)
    if row and bcrypt.verify(password, row[2]):
        print('you are now logged in')
        return username
    print('invalid credentials')
    return None


def signup_flow() -> Optional[str]:
    while True:
        username = input('choose username: ').strip()
        if username and not find_user(username):
            break
        print('username invalid or already exists, try again')
    password = getpass('choose password: ').strip()
    if create_user(username, password):
        print('signup successful')
        return username
    print('signup failed')
    return None


def main():
    init_users_table()
    logged_in = None
    while True:
        cmd = input('(login/signup/exit): ').strip().lower()
        if cmd == 'exit':
            break
        elif cmd == 'login':
            logged_in = login_flow()
        elif cmd == 'signup':
            logged_in = signup_flow()
        else:
            print('unknown command')
    if logged_in:
        print(f'logged_in={logged_in}')


if __name__ == '__main__':
    main()
