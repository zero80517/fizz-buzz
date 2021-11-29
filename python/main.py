for n in range(1, 101):
    print("Fizz" * (not n % 3) + "Buzz" * (not n % 5) or n)
