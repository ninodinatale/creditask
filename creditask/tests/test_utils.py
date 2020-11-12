import inspect
import uuid

from creditask.models import User, Task, Group, Approval


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

    if 'email' not in kwargs:
        unique_id = str(uuid.uuid1())
        unique_id = (unique_id[:15]) if len(
            unique_id) > 15 else unique_id
        email = f'{unique_id}@user.com'
    else:
        email = kwargs.get('email')
    if 'public_name' not in kwargs:
        unique_id = inspect.stack()[1].function
        unique_id = (unique_id[:15]) if len(
            unique_id) > 15 else unique_id
        kwargs.update(public_name=f'user_{unique_id}')
    if 'password' not in kwargs:
        password = ''
    else:
        password = kwargs.get('password')

    kwargs.pop('email', None)
    kwargs.pop('password', None)

    return User.objects.create_user(
        email,
        password,
        **kwargs
    )


def create_task(**kwargs):
    assert not ('user' in kwargs and 'user_id' in kwargs)
    assert not ('group' in kwargs and 'group_id' in kwargs)
    assert ('group' in kwargs) or ('group_id' in kwargs)

    if 'name' not in kwargs:
        unique_id = str(uuid.uuid1())
        unique_id = (unique_id[:15]) if len(
            unique_id) > 15 else unique_id
        kwargs['name'] = f'task_{unique_id}'

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
        return User.objects.first().id


def create_group(**kwargs) -> Group:
    return Group.objects.create(**kwargs)


