from django.core.exceptions import ValidationError
from django.utils.deconstruct import deconstructible


@deconstructible
class MinLenValidator:

    def __init__(self, min_len=None,):
        if min_len is not None:
            self.min_len = min_len
        else:
            raise TypeError('min_len needs to be set.')

    def __call__(self, value):
        """
        Validate that the input has defined minimum length.
        """
        if value is None:
            return
        if len(value) < self.min_len:
            raise ValidationError(
                f'length of "{value}" ({len(value)}) is shorter than min length ('
                f'{self.min_len})',
                params={'value': value},
            )

    def __eq__(self, other):
        return (
            isinstance(other, MinLenValidator) and
            self.min_len == other.min_len
        )


@deconstructible
class MaxLenValidator:

    def __init__(self, max_len=None,):
        if max_len is not None:
            self.max_len = max_len
        else:
            raise TypeError('max needs to be set.')

    def __call__(self, value):
        """
        Validate that the input has defined maximum length.
        """
        if value is None:
            return
        if len(value) > self.max_len:
            raise ValidationError(
                f'length of "{value}" ({len(value)}) is greater than max length ('
                f'{self.max_len})',
                params={'value': value},
            )

    def __eq__(self, other):
        return (
            isinstance(other, MaxLenValidator) and
            self.max_len == other.max_len
        )
