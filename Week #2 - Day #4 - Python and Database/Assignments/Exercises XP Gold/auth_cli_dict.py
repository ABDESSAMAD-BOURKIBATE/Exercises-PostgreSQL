def main():
    users = {
        'alice': 'alice123',
        'bob': 'bob456',
        'charlie': 'charlie789',
    }
    logged_in = None
    while True:
        cmd = input('(login/signup/exit): ').strip().lower()
        if cmd == 'exit':
            break
        elif cmd == 'login':
            username = input('username: ').strip()
            password = input('password: ').strip()
            if username in users and users[username] == password:
                print('you are now logged in')
                logged_in = username
            else:
                print('user not found or wrong password')
        elif cmd == 'signup':
            while True:
                username = input('choose username: ').strip()
                if username and username not in users:
                    break
                print('username invalid or already exists, try again')
            password = input('choose password: ').strip()
            users[username] = password
            print('signup successful')
        else:
            print('unknown command')
    if logged_in:
        print(f'logged_in={logged_in}')

if __name__ == '__main__':
    main()
