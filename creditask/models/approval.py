from django.db import models

from creditask.models import BaseModel, Task


class Approval(BaseModel):
    class State(models.TextChoices):
        NONE = 'NONE'
        APPROVED = 'APPROVED'
        DECLINED = 'DECLINED'

    state = models.CharField(choices=State.choices,
                             max_length=30, default=State.NONE)
    task = models.ForeignKey(Task, on_delete=models.CASCADE,
                             related_name='approvals')
    user = models.ForeignKey('User', on_delete=models.CASCADE)

    class Meta:
        db_table = 'approvals'
