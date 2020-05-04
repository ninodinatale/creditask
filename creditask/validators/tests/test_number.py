from unittest import TestCase

from django.core.exceptions import ValidationError
from django.test import tag

from creditask.validators import MinValueValidator


@tag('unit')
class TestNumberValidator(TestCase):

    def test_min_value_validator(self):
        validator = MinValueValidator(min_value=10)

        with self.assertRaises(ValidationError):
            validator(-1)
            validator(9)
            validator(0)
            validator(-99999)

        try:
            validator(10)
            validator(20)
            validator(2000)
        except ValidationError:
            self.fail("MinValueValidator raised ValidationError unexpectedly!")
