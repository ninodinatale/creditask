from unittest import TestCase

from django.core.exceptions import ValidationError
from django.test import tag

from creditask.validators import MinLenValidator


@tag('unit')
class TestStringValidator(TestCase):

    def test_min_len_validator(self):
        validator = MinLenValidator(min_len=3)

        with self.assertRaises(ValidationError):
            validator('a')
            validator('ab')
            validator('a ')
            validator('')

        try:
            validator('abc')
            validator('ab ')
            validator(None)
            validator('this is a longer text than others and so on.')
        except ValidationError:
            self.fail("MinLenValidator raised ValidationError unexpectedly!")
