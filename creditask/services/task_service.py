from typing import List

from django.core.exceptions import ValidationError

from creditask.models import Task
from creditask.models import User
from creditask.validators import MinLenValidator


def get_task_by_id(task_id: int) -> Task:
    return Task.objects.get(id=task_id)


def get_todo_tasks_by_user_email(user_mail: str) -> List[Task]:
    return Task.objects.filter(user__email=user_mail,
                               state=Task.State.TO_DO)


def save_task(created_by: User, **kwargs) -> Task:
    if created_by is None:
        raise ValidationError('created_by may not be None')

    task_to_save = Task(created_by=created_by, **kwargs)

    MinLenValidator(3)(task_to_save.name)
    if task_to_save.state is not None:
        if not hasattr(Task.State, task_to_save.state):
            raise ValidationError(f'"{task_to_save.state}" is an invalid '
                                  'type of task state')

    task_to_save.save()
    return task_to_save
