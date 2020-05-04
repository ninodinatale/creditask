from django.core.exceptions import ValidationError
from graphene import String

from creditask.validators import MinLenValidator


def custom_string(min_len: int = None, max_len: int = None, *args,
                  **kwargs):

    def assert_min_len(value):
        if min_len is None:
            return
        MinLenValidator(min_len)(value)

    def assert_max_len(value):
        if value is None or max_len is None:
            return
        if len(value) > max_len:
            raise ValidationError(
                f'length of "{value}" ({len(value)}) may not be greater than '
                f'{max_len})',
                params={'value': value},
            )

    class CustomString(String):

        @staticmethod
        def parse_value(value):
            if value is not None:
                string_value = String.coerce_string(value)
                assert_min_len(string_value)
                assert_max_len(string_value)
                return string_value
            else:
                return None

    return CustomString
