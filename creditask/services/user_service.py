from typing import List

from django.core.exceptions import ValidationError

from creditask.models import User, BaseModel


def get_users(group_id: int) -> List[User]:
    return User.objects.filter(group_id=group_id)


def save_user(user: User, **kwargs):
    if user is None:
        if 'id' not in kwargs:
            raise ValidationError('Either a user entity or the user id has to'
                                  ' be defined')
        user = User.objects.get(kwargs.get('id'))

    merge_values(user, **kwargs).save()
    return user


def merge_values(entity_to_merge_into: BaseModel, **kwargs) -> BaseModel:
    for key, value in kwargs.items():
        if key == 'id' or getattr(entity_to_merge_into, key) == value:
            # no changes
            continue
        setattr(entity_to_merge_into, key, value)

    return entity_to_merge_into


def get_other_users(email: str) -> List[User]:
    user = User.objects.get(email=email)
    return User.objects.filter(group=user.group).exclude(email=email)
