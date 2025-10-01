from menu_item import MenuItem
from menu_manager import MenuManager
from db import init_db

def add_item_to_menu():
    name = input('Item name: ').strip()
    price = int(input('Item price: ').strip())
    item = MenuItem(name, price)
    if item.save():
        print('item was added successfully')
    else:
        print('error adding item')

def remove_item_from_menu():
    name = input('Item name to delete: ').strip()
    item = MenuItem(name, 0)
    if item.delete():
        print('item was deleted successfully')
    else:
        print('error deleting item')

def update_item_from_menu():
    name = input('Current item name: ').strip()
    price = int(input('Current item price: ').strip())
    new_name = input('New item name: ').strip()
    new_price = int(input('New item price: ').strip())
    item = MenuItem(name, price)
    if item.update(new_name, new_price):
        print('item was updated successfully')
    else:
        print('error updating item')

def show_restaurant_menu():
    items = MenuManager.all_items()
    for it in items:
        print(f"{it['item_id']:3d} | {it['item_name']:<20} | {it['item_price']:>5}")

def show_user_menu():
    init_db()
    while True:
        print('\nV) View an Item  A) Add an Item  D) Delete an Item  U) Update an Item  S) Show the Menu  Q) Quit')
        choice = input('Choose: ').strip().upper()
        if choice == 'V':
            name = input('Item name to view: ').strip()
            it = MenuManager.get_by_name(name)
            if it:
                print(f"{it['item_id']} | {it['item_name']} | {it['item_price']}")
            else:
                print('item not found')
        elif choice == 'A':
            add_item_to_menu()
        elif choice == 'D':
            remove_item_from_menu()
        elif choice == 'U':
            update_item_from_menu()
        elif choice == 'S':
            show_restaurant_menu()
        elif choice == 'Q':
            print('Final menu:')
            show_restaurant_menu()
            break
        else:
            print('invalid option')

if __name__ == '__main__':
    show_user_menu()
