from db import get_conn

if __name__ == '__main__':
    try:
        with get_conn() as conn:
            with conn.cursor() as cur:
                cur.execute("SELECT 'ok'")
                print('DB connection: OK')
    except Exception as e:
        print('DB connection: FAIL')
        print(e)
        raise SystemExit(1)
