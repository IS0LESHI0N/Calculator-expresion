#include "lib.h"
#include <ctype.h>
#include <math.h>
#include <stdlib.h>

int calculate_expression_in_parentheses(char **expression_ptr) {
    char *expression = *expression_ptr;
    int result;

    if (*expression == '(') {
        expression++;
        result = calculate_expression_in_parentheses(&expression);
        expression++;
    } else {
        result = (int) strtol(expression, &expression, 10);
    }

    while (*expression) {
        char operator = *expression;
        if (operator == ')' || operator == '+' || operator == '-') {
            break;
        }
        expression++;

        int operand;
        if (operator == '^') {
            operand = calculate_expression_in_parentheses(&expression);
            result = (int) pow(result, operand);
        } else {
            operand = (int) strtol(expression, &expression, 10);
            if (operator == '*') {
                result *= operand;
            } else if (operator == '/') {
                result /= operand;
            } else if (operator == '%') {
                result %= operand;
            }
        }
    }

    *expression_ptr = expression;
    return result;
}

int calculate_expression(char *expression) {
    int result = calculate_expression_in_parentheses(&expression);

    while (*expression) {
        char operator = *expression;
        if (operator == '\0') {
            break;
        }
        expression++;

        int operand = calculate_expression_in_parentheses(&expression);
        if (operator == '+') {
            result += operand;
        } else if (operator == '-') {
            result -= operand;
        }
    }

    return result;
}
