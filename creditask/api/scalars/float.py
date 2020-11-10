from graphene import Float

from creditask.validators import MinValueValidator, MaxValueValidator


def custom_float(scalar_name, min_value: float = None, max_value: float = None):
    """
    :param scalar_name: The name of the scalar. This is needed that there are
    no duplicate scalar names in the schema.
    :param min_value: The minimum value of the float. No minimum value if None.
    :param max_value: The maximum value of the float. No maximum value if None.
    :return: The custom float scalar.
    """

    def assert_min_value(value):
        if min_value is None:
            return
        MinValueValidator(min_value=min_value)(value)

    def assert_max_value(value):
        if max_value is None:
            return
        MaxValueValidator(max_value=max_value)(value)

    class CustomFloat(Float):
        class Meta:
            # Making sure there are no duplicate scalar names, like
            # "AssertionError: Found different types with the same name in the
            # schema: CustomFloat, CustomFloat."
            name = f'CustomFloat{scalar_name}'

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
