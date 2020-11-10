from unittest import TestCase

from django.core.exceptions import ValidationError
from django.test import tag

from creditask.api.scalars import custom_float


@tag('unit')
class TestFloat(TestCase):

    def test_custom_float_min_value(self):
        scalar = custom_float('for_test', min_value=10)

        with self.assertRaises(ValidationError):
            scalar.parse_value(-1)
            scalar.parse_value(-1.9)
            scalar.parse_value(9.2)
            scalar.parse_value(5)
            scalar.parse_value(0.1)
            scalar.parse_value(-99999.5)

        try:
            scalar.parse_value(10)
            scalar.parse_value(20)
            scalar.parse_value(2000)
            scalar.parse_value(None)
        except ValidationError:
            self.fail("custom_float scalar raised ValidationError "
                      "unexpectedly")

    def test_custom_float_max_value(self):
        scalar = custom_float('for_test', max_value=20)

        with self.assertRaises(ValidationError):
            scalar.parse_value(20.0001)
            scalar.parse_value(30)
            scalar.parse_value(103493.2)

        try:
            scalar.parse_value(20)
            scalar.parse_value(20.00)
            scalar.parse_value(-200.9)
            scalar.parse_value(None)
        except ValidationError:
            self.fail("custom_float scalar raised ValidationError unexpectedly")

    def test_custom_float_max_value_and_min_value(self):
        scalar = custom_float('for_test', min_value=10, max_value=20)

        with self.assertRaises(ValidationError):
            scalar.parse_value(-1)
            scalar.parse_value(-1.9)
            scalar.parse_value(9.2)
            scalar.parse_value(5)
            scalar.parse_value(0.1)
            scalar.parse_value(-99999.5)
            scalar.parse_value(20.0001)
            scalar.parse_value(30)
            scalar.parse_value(103493.2)

        try:
            scalar.parse_value(10)
            scalar.parse_value(20)
            scalar.parse_value(10.1)
            scalar.parse_value(20.0)
            scalar.parse_value(19.99)
            scalar.parse_value(15)
            scalar.parse_value(None)
        except ValidationError:
            self.fail("custom_float scalar raised ValidationError unexpectedly")
