from typing import List, Optional
from db import get_conn

class MenuManager:
    @classmethod
    def get_by_name(cls, name: str) -> Optional[dict]:
        with get_conn() as conn:
            with conn.cursor() as cur:
                cur.execute(
                    "SELECT item_id, item_name, item_price FROM menu_items WHERE item_name = %s",
                    (name,),
                )
                row = cur.fetchone()
                if not row:
                    return None
                return {
                    'item_id': row[0],
                    'item_name': row[1],
                    'item_price': row[2],
                }

    @classmethod
    def all_items(cls) -> List[dict]:
        with get_conn() as conn:
            with conn.cursor() as cur:
                cur.execute("SELECT item_id, item_name, item_price FROM menu_items ORDER BY item_name")
                rows = cur.fetchall()
                return [
                    {'item_id': r[0], 'item_name': r[1], 'item_price': r[2]}
                    for r in rows
                ]
