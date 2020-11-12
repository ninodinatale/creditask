from datetime import datetime

from django.db import models

from . import User, BaseModel, Task


class ChangeableTaskProperty(models.TextChoices):
    Name = 'NAME'
    NeededTimeSeconds = 'NEEDED_TIME_SECONDS'
    State = 'STATE'
    CreditsCalc = 'CREDITS_CALC'
    FixedCredits = 'FIXED_CREDITS'
    Factor = 'FACTOR'
    UserId = 'USER_ID'
    PeriodStart = 'PERIOD_START'
    PeriodEnd = 'PERIOD_END'
    Approval = 'APPROVAL'
    CreatedById = 'CREATED_BY_ID'


class TaskChange(BaseModel):
    current_value: str = models.CharField(max_length=120, null=True)
    previous_value: str = models.CharField(max_length=120, null=True)
    user: User = models.ForeignKey(User, on_delete=models.CASCADE)
    task: Task = models.ForeignKey(Task, on_delete=models.CASCADE,
                                   related_name='task_changes')
    timestamp: datetime.timestamp = models.DateTimeField()
    changed_property = models.CharField(choices=ChangeableTaskProperty.choices,
                                        null=True, max_length=30)

    class Meta:
        db_table = 'task_changes'
