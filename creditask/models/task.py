import datetime

from django.db import models

from .base import BaseModel
from .group import Group
from .user import User


class TaskState(models.TextChoices):
    TO_DO = 'TO_DO'
    TO_APPROVE = 'TO_APPROVE'
    DECLINED = 'DECLINED'
    APPROVED = 'APPROVED'
    DONE = 'DONE'


class CreditsCalc(models.TextChoices):
    BY_FACTOR = 'BY_FACTOR'
    FIXED = 'FIXED'


class Task(BaseModel):
    name: str = models.CharField(max_length=30)
    needed_time_seconds: int = models.IntegerField(default=0)
    state = models.CharField(choices=TaskState.choices,
                             max_length=64, default=TaskState.TO_DO)
    credits_calc = models.CharField(choices=CreditsCalc.choices,
                                    max_length=64,
                                    default=CreditsCalc.BY_FACTOR)
    factor: int = models.FloatField(default=1.0)
    fixed_credits: int = models.IntegerField(default=0)
    group: Group = models.ForeignKey(Group, on_delete=models.CASCADE)
    user: User = models.ForeignKey(User, null=True, on_delete=models.SET_NULL)
    created_by = models.ForeignKey(User, related_name='+',
                                   on_delete=models.CASCADE)
    period_start: datetime.date = models.DateField(
        default=datetime.datetime.utcnow)
    period_end: datetime.date = models.DateField(
        default=datetime.datetime.utcnow)

    class Meta:
        db_table = 'tasks'
