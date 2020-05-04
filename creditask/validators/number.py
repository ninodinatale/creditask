from django.core.exceptions import ValidationError
from django.utils.deconstruct import deconstructible


@deconstructible
class MinValueValidator:

    def __init__(self, min_value=None, ):
        if min_value is not None:
            self.min_value = min_value
        else:
            raise TypeError('min_value needs to be set.')

    def __call__(self, value):
        """
        Validate that the input has defined minimum value.
        """
        if value is None:
            return
        if value < self.min_value:
            raise ValidationError(
                f'value {value} needs to be greater than {self.min_value}.',
                params={'value': value},
            )

    def __eq__(self, other):
        return (
            isinstance(other, MinValueValidator) and
            self.min_value == other.min_value
        )


@deconstructible
class MaxValueValidator:

    def __init__(self, max_value=None, ):
        if max_value is not None:
            self.max_value = max_value
        else:
            raise TypeError('max_value needs to be set.')

    def __call__(self, value):
        """
        Validate that the input has defined maximum value.
        """
        if value is None:
            return
        if value > self.max_value:
            raise ValidationError(
                f'value {value} may not be greater than {self.max_value}.',
                params={'value': value},
            )

    def __eq__(self, other):
        return (
            isinstance(other, MaxValueValidator) and
            self.max_value == other.max_value
        )
