#include <stdio.h>
#include "lib.h"

int main() {
    char expression[100];

    printf("Введіть вираз: ");
    fgets(expression, 100, stdin);

    printf("Результат: %d\n", calculate_expression(expression));

    return 0;
}
