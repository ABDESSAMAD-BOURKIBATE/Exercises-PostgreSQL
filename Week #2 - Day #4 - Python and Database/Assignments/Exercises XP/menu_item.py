from typing import Optional
from db import get_conn

class MenuItem:
    def __init__(self, name: str, price: int):
        self.name = name
        self.price = int(price)

    def save(self) -> bool:
        with get_conn() as conn:
            with conn.cursor() as cur:
                cur.execute(
                    "INSERT INTO menu_items (item_name, item_price) VALUES (%s, %s) RETURNING item_id",
                    (self.name, self.price),
                )
                _id = cur.fetchone()[0]
                conn.commit()
                return _id is not None

    def delete(self) -> bool:
        with get_conn() as conn:
            with conn.cursor() as cur:
                cur.execute(
                    "DELETE FROM menu_items WHERE item_name = %s",
                    (self.name,),
                )
                deleted = cur.rowcount > 0
                conn.commit()
                return deleted

    def update(self, new_name: Optional[str] = None, new_price: Optional[int] = None) -> bool:
        fields = []
        params = []
        if new_name is not None:
            fields.append("item_name = %s")
            params.append(new_name)
        if new_price is not None:
            fields.append("item_price = %s")
            params.append(int(new_price))
        if not fields:
            return False
        params.append(self.name)
        with get_conn() as conn:
            with conn.cursor() as cur:
                cur.execute(
                    f"UPDATE menu_items SET {', '.join(fields)} WHERE item_name = %s",
                    tuple(params),
                )
                updated = cur.rowcount > 0
                conn.commit()
                if updated:
                    if new_name is not None:
                        self.name = new_name
                    if new_price is not None:
                        self.price = int(new_price)
                return updated
