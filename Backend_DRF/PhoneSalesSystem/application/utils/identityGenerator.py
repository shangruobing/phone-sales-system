from random import shuffle


def generateId() -> str:
    items = [1, 2, 3, 4, 5, 6, 7, 8, 9]
    shuffle(items)
    identity = ""
    for num in items:
        identity += str(num)
    return identity
