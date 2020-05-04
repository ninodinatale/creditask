from typing import List

from creditask.models import User


def get_other_users(email: str) -> List[User]:
    user = User.objects.get(email=email)
    return User.objects.filter(group=user.group).exclude(email=email)
