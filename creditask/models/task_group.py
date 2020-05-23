from django.db import models


class TaskGroup(models.Model):
    class Meta:
        db_table = 'task_groups'
