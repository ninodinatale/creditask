import datetime

from django.db import models

from .approval import Approval
from .base import BaseModel
from .user import User


class Task(BaseModel):
    class State(models.TextChoices):
        UNKNOWN = 'UNKNOWN'
        TO_DO = 'TO_DO'
        TO_APPROVE = 'TO_APPROVE'
        DECLINED = 'DECLINED'
        UNDER_CONDITIONS = 'UNDER_CONDITIONS'
        APPROVED = 'APPROVED'

    name: str = models.CharField(max_length=30, default='Unnamed task')
    needed_time_seconds: int = models.IntegerField(default=0)
    state = models.CharField(choices=State.choices,
                             max_length=64, default=State.TO_DO)
    factor: int = models.IntegerField(default=0)
    user: User = models.ForeignKey(User, null=True, on_delete=models.SET_NULL)
    period_start: str = models.DateField(default=datetime.datetime.now)
    period_end: str = models.DateField(default=datetime.datetime.now)
    done: bool = models.BooleanField(default=False)
    approvals = models.ManyToManyField(Approval, related_name='tasks')

    class Meta:
        db_table = 'tasks'
