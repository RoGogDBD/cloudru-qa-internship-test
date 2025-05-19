def partition(arr, low, high):
    pivot = arr[high]
    i = low - 1

    for j in range(low, high):
        if arr[j] <= pivot:
            i += 1
            arr[i], arr[j] = arr[j], arr[i]

    arr[i + 1], arr[high] = arr[high], arr[i + 1]
    return i + 1


def quick_sort_in_place(arr, low, high):
    if low < high:
        pi = partition(arr, low, high)
        quick_sort_in_place(arr, low, pi - 1)
        quick_sort_in_place(arr, pi + 1, high)


def main():
    try:
        user_input = input("Введите числа через запятую: ")
        numbers = [int(x.strip()) for x in user_input.split(",") if x.strip().isdigit()]

        if not numbers:
            print("Список чисел пуст или введены некорректные значения.")
            return

        even_numbers = [x for x in numbers if x % 2 == 0]
        max_number = max(numbers)
        min_number = min(numbers)

        quick_sort_in_place(numbers, 0, len(numbers) - 1)

        print("Четные числа:", even_numbers)
        print("Максимальное число:", max_number)
        print("Минимальное число:", min_number)
        print("Отсортированный список:", numbers)

    except Exception as e:
        print("Произошла ошибка:", e)


if __name__ == "__main__":
    main()
