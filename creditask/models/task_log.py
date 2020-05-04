from django.db import models

from .base import BaseModel
from .task import Task
from .user import User


class TaskLog(BaseModel):
    class State(models.TextChoices):
        CREATED = 'CREATED',
        APPROVED = 'APPROVED',
        DECLINED = 'DECLINED',
        DONE = 'DONE',
        UNDONE = 'UNDONE',
        UNDER_CONDITIONS = 'UNDER_CONDITIONS',
        NO_APPROVAL = 'NO_APPROVAL',
        ACCEPTED = 'ACCEPTED',

    type = models.CharField(choices=State.choices, null=False, max_length=64)
    triggered_by = models.ForeignKey(User, on_delete=models.CASCADE)
    task = models.ForeignKey(Task, on_delete=models.CASCADE)
    created_at = models.DateTimeField(auto_now_add=True)

    # @staticmethod
    # @receiver(post_save, sender=Task)
    # def task_changes_handler(sender, **kwargs):
    #     created: bool = kwargs.get('created')
    #
    #     task_log = TaskLog(triggered_by_id=get_session_user_id(),
    #                        task=kwargs.get('instance'))
    #
    #     if created:
    #         task_log.type = TaskLog.State.CREATE
    #     else:
    #         update_fields = kwargs.get('update_fields')
    #         print(update_fields)
    #     TaskLog.objects.create(task_log)
    #
    # @staticmethod
    # @receiver(post_save, sender=Approval)
    # def approval_changes_handler(sender, **kwargs):
    #     print('implement approval_changes_handler')

    class Meta:
        ordering = ['created_at']
