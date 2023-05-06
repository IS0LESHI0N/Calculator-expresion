#include <check.h>
#include <stdlib.h>
#include "lib.h"

START_TEST(test_calculate_expression) {
    char expression1[] = "1+2+3+4+5";
    ck_assert_int_eq(calculate_expression(expression1), 15);

    char expression2[] = "2*3+4*5";
    ck_assert_int_eq(calculate_expression(expression2), 26);

    char expression3[] = "10/2+3*4-5";
    ck_assert_int_eq(calculate_expression(expression3), 12);

    char expression4[] = "2^(3)";
    ck_assert_int_eq(calculate_expression(expression4), 8);

    char expression5[] = "3+5*2-67*3";
    ck_assert_int_eq(calculate_expression(expression5), -188);
} END_TEST

Suite *calculator_suite(void) {
    Suite *s;
    TCase *tc_core;

    s = suite_create("Calculator");
    tc_core = tcase_create("Core");

    tcase_add_test(tc_core, test_calculate_expression);
    suite_add_tcase(s, tc_core);

    return s;
}

int main(void) {
    int number_failed;
    Suite *s;
    SRunner *sr;

    s = calculator_suite();
    sr = srunner_create(s);

    srunner_run_all(sr, CK_NORMAL);
    number_failed = srunner_ntests_failed(sr);
    srunner_free(sr);

    return number_failed == 0 ? EXIT_SUCCESS : EXIT_FAILURE;
}
