from django.db import models

from .base import BaseModel
from .user import User


class Approval(BaseModel):
    class States(models.TextChoices):
        NONE = 'NONE'
        APPROVED = 'APPROVED'
        UNDER_CONDITIONS = 'UNDER_CONDITIONS'
        DECLINED = 'DECLINED'

    state = models.CharField(choices=States.choices,
                             max_length=30, default=States.NONE)
    user = models.ForeignKey(User, on_delete=models.CASCADE)

    class Meta:
        db_table = 'approvals'

