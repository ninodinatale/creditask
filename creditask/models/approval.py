from django.db import models

from .task import BaseModel, Task


class ApprovalState(models.TextChoices):
    NONE = 'NONE'
    APPROVED = 'APPROVED'
    DECLINED = 'DECLINED'


class Approval(BaseModel):

    state = models.CharField(choices=ApprovalState.choices,
                             max_length=30, default=ApprovalState.NONE)
    message = models.TextField(max_length=240, default='')
    task = models.ForeignKey(Task, on_delete=models.CASCADE,
                             related_name='approvals')
    user = models.ForeignKey('User', on_delete=models.CASCADE)

    class Meta:
        db_table = 'approvals'
