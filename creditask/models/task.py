import datetime

from django.db import models

from .user import User
from .task_group import TaskGroup
from .base import BaseModel


class TaskState(models.TextChoices):
    TO_DO = 'TO_DO'
    TO_APPROVE = 'TO_APPROVE'
    DECLINED = 'DECLINED'
    APPROVED = 'APPROVED'


class Task(BaseModel):
    task_group = models.ForeignKey(TaskGroup, on_delete=models.CASCADE)
    name: str = models.CharField(max_length=30)
    needed_time_seconds: int = models.IntegerField()
    state = models.CharField(choices=TaskState.choices,
                             max_length=64, default=TaskState.TO_DO)
    factor: int = models.FloatField(default=0)
    user: User = models.ForeignKey(User, null=True, on_delete=models.SET_NULL)
    period_start: datetime.date = models.DateField(
        default=datetime.datetime.now)
    period_end: datetime.date = models.DateField(default=datetime.datetime.now)

    class Meta:
        db_table = 'tasks'
