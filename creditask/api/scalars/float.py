from graphene import Float

from creditask.validators import MinValueValidator, MaxValueValidator


def custom_float(min_value: float = None, max_value: float = None, *args,
    **kwargs):
    def assert_min_value(value):
        if min_value is None:
            return
        MinValueValidator(min_value=min_value)(value)

    def assert_max_value(value):
        if max_value is None:
            return
        MaxValueValidator(max_value=max_value)(value)

    class CustomFloat(Float):

        @staticmethod
        def parse_value(value):
            if value is not None:
                float_value = Float.coerce_float(value)
                assert_min_value(float_value)
                assert_max_value(float_value)
                return float_value
            else:
                return None

    return CustomFloat
