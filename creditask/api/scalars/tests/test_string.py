from unittest import TestCase

from django.core.exceptions import ValidationError
from django.test import tag

from creditask.api.scalars import custom_string


@tag('unit')
class TestString(TestCase):

    def test_custom_string_min_len(self):
        scalar = custom_string(min_len=10)

        with self.assertRaises(ValidationError):
            scalar.parse_value('a bbb cccc')
            scalar.parse_value('five ')
            scalar.parse_value('')

        try:
            scalar.parse_value('a bb ccc d')
            scalar.parse_value('this is a rather long text compared to the '
                               'others.')
            scalar.parse_value('this is a even larger text, lol. Not yet, '
                               'but it is getting there. So now I am going'
                               ' to tell you a tale of some wale. Or no, '
                               'rather not.')
            scalar.parse_value(None)
        except ValidationError:
            self.fail("custom_string scalar raised ValidationError "
                      "unexpectedly")

    def test_custom_string_max_len(self):
        scalar = custom_string(max_len=2)

        with self.assertRaises(ValidationError):
            scalar.parse_value('aaa')
            scalar.parse_value(' a b c d')
            scalar.parse_value('103493.2')

        try:
            scalar.parse_value('')
            scalar.parse_value('a')
            scalar.parse_value('ab')
            scalar.parse_value(None)
        except ValidationError:
            self.fail("custom_string scalar raised ValidationError unexpectedly")

    def test_custom_string_max_len_and_min_len(self):
        scalar = custom_string(min_len=2, max_len=3)

        with self.assertRaises(ValidationError):
            scalar.parse_value('')
            scalar.parse_value('a')
            scalar.parse_value('some longer text.')
            scalar.parse_value('1234')
            scalar.parse_value('    ')

        try:
            scalar.parse_value('ab')
            scalar.parse_value('a b')
            scalar.parse_value('  ')
            scalar.parse_value('   ')
            scalar.parse_value(None)
        except ValidationError:
            self.fail("custom_string scalar raised ValidationError unexpectedly")
