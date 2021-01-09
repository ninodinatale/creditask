from creditask.models import Error


# TODO test
def save_error(current_user_id: int, stack_trace: str) -> Error:
    return Error.objects.create(user_id=current_user_id,
                                stack_trace=stack_trace)
