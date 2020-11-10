import inspect

from creditask.models import User, Task, Group, Approval

user_count = 0
task_count = 0
dummy_created_by_user = None


def create_user(**kwargs):
    r"""Creates a user for testing purposes and returns it.

        :Keyword Arguments:
            * *email* (``str``) --
            * *public_name* (``str``) --
            * *password* (``str``) --
            * *group* (``Group``) --
            * *group_id* (``int``) --
            * *credits* (``int``) --
    """
    assert not ('group' in kwargs and 'group_id' in kwargs)
    assert 'group' in kwargs or 'group_id' in kwargs

    global user_count
    user_count += 1

    if 'email' not in kwargs:
        caller_fn_name = inspect.stack()[1].function
        short_caller_fn_name = (caller_fn_name[:15]) if len(
            caller_fn_name) > 15 else caller_fn_name
        email = f'{short_caller_fn_name}_{user_count}@user.com'
    else:
        email = kwargs.get('email')
    if 'public_name' not in kwargs:
        caller_fn_name = inspect.stack()[1].function
        short_caller_fn_name = (caller_fn_name[:15]) if len(
            caller_fn_name) > 15 else caller_fn_name
        public_name = f'user_{short_caller_fn_name}_{user_count}'
    else:
        public_name = kwargs.get('public_name')
    if 'password' not in kwargs:
        password = ''
    else:
        password = kwargs.get('password')

    return User.objects.create(
        email=email,
        public_name=public_name,
        password=password,
        **kwargs
    )


def create_task(**kwargs):
    assert not ('user' in kwargs and 'user_id' in kwargs)
    assert not ('group' in kwargs and 'group_id' in kwargs)
    assert ('group' in kwargs) or ('group_id' in kwargs)

    global task_count
    task_count += 1

    if 'name' not in kwargs:
        caller_fn_name = inspect.stack()[1].function
        short_caller_fn_name = (caller_fn_name[:15]) if len(
            caller_fn_name) > 15 else caller_fn_name
        kwargs['name'] = f'task_{short_caller_fn_name}_{task_count}'

    return Task.objects.create(
        created_by_id=get_created_by_id(**kwargs),
        **kwargs
    )


def create_approval(**kwargs):
    assert not ('user' in kwargs and 'user_id' in kwargs)
    assert not ('task' in kwargs and 'task_id' in kwargs)

    return Approval.objects.create(
        created_by_id=get_created_by_id(**kwargs),
        **kwargs
    )


def get_created_by_id(**kwargs):
    assert not ('created_by' in kwargs and 'created_by_id' in kwargs)
    if 'created_by' in kwargs or 'created_by_id' in kwargs:
        if 'created_by' in kwargs:
            return kwargs.get('created_by').id
        else:
            return kwargs.get('created_by_id')
    else:
        return get_dummy_user().id


def create_group(**kwargs) -> Group:
    return Group.objects.create(**kwargs)


def get_dummy_user() -> User:
    global dummy_created_by_user
    if dummy_created_by_user is None:
        dummy_created_by_user = create_user(group=create_group())
    return dummy_created_by_user
