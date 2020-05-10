from typing import List

from creditask.models import User


def get_users(group_id: int) -> List[User]:
    return User.objects.filter(group_id=group_id)


def get_other_users(email: str) -> List[User]:
    user = User.objects.get(email=email)
    return User.objects.filter(group=user.group).exclude(email=email)
