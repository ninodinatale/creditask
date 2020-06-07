from typing import List

from django.core.exceptions import ValidationError

from creditask.models import Task, User, TaskGroup
from creditask.validators import MinLenValidator


def get_task_by_id(task_id: int) -> Task:
    return Task.objects.get(id=task_id)


def get_task_by_task_group_id(task_group_id: int) -> Task:
    return (Task.objects.filter(task_group_id=task_group_id)
            .order_by('-created_at')
            .first())


def get_todo_tasks_by_user_email(user_mail: str) -> List[Task]:
    """Get each newest task by task group of provided user"""
    query = '''
        SELECT t.*
        FROM (
                 SELECT *
                 FROM (SELECT ROW_NUMBER()
                              OVER (PARTITION BY t2.task_group_id ORDER BY t2.created_at DESC) AS r,
                              t2.*
                       FROM tasks t2
                      ) t3
                 WHERE t3.r <= 1) t
                 INNER JOIN users u ON t.user_id = u.id
        WHERE t.state = %(task_state)s
          AND u.email = %(user_mail)s;
        '''
    rows = Task.objects.raw(query, params={'user_mail': user_mail,
                                           'task_state': Task.State.TO_DO})
    return list(map(lambda row: row, rows))


# TODO function is not tested entirely yet
def save_task(created_by: User, **kwargs) -> Task:
    if created_by is None:
        raise ValidationError('created_by may not be None')

    if 'task_group_id' in kwargs:
        task_to_save = get_task_by_task_group_id(kwargs.get('task_group_id'))

        validate_state_change(task_to_save, dict(**kwargs))

        if task_to_save.state == Task.State.TO_DO:
            # everything may be changed
            validate_task_properties(task_to_save)
        else:
            if 'period_start' in kwargs:
                raise ValidationError(
                    f'period_start may not be changed if task has'
                    f' state [{kwargs.get("state")}]')
            if 'period_end' in kwargs:
                raise ValidationError(
                    f'period_end may not be changed if task has'
                    f' state [{kwargs.get("state")}]')

            for key, value in kwargs:
                # todo test
                if key != 'task_group_id' and key != 'state':
                    if value != task_to_save[key]:
                        raise ValidationError(
                            f'Column [{key}] of Task with state '
                            f'[{task_to_save.state}] may not be changed')

        merge_values(task_to_save, kwargs).save()
        return task_to_save
    else:
        # new task means new task group needed
        # TODO TEST
        task_group = TaskGroup.objects.create()
        task_to_create = Task(created_by=created_by,
                              task_group=task_group,
                              **kwargs)
        validate_task_properties(task_to_create)
        task_to_create.save()
        return task_to_create


def merge_values(existing_task: Task, values_to_merge: dict) -> Task:
    for key, value in values_to_merge.items():
        setattr(existing_task, key, value)
    return existing_task


def validate_task_properties(task: Task):
    if (task.period_end is not None and
            task.period_start is not None and
            task.period_end < task.period_start):
        raise ValidationError(
            f'period_start [{task.period_start}] may not be after '
            f'period_end [{task.period_end}]')

    MinLenValidator(3)(task.name)
    if task.state is not None:
        if not hasattr(Task.State, task.state):
            raise ValidationError(f'"{task.state}" is an invalid '
                                  'type of task state')


def validate_state_change(old_task: Task, new_task_dict: dict):
    if 'state' in new_task_dict:
        new_state = new_task_dict.get('state')
        if new_state is None:
            raise ValidationError('Task state may not be None')
        if (old_task.state == Task.State.TO_DO and
                new_state != Task.State.TO_APPROVE):
            raise ValidationError(f'Task state after [{Task.State.TO_DO}] '
                                  f'needs to be [{Task.State.TO_APPROVE}],'
                                  f'but was [{new_state}]')
        if old_task.state == Task.State.TO_APPROVE:
            if (new_state != Task.State.APPROVED and
                    new_state != Task.State.UNDER_CONDITIONS and
                    new_state != Task.State.DECLINED):
                raise ValidationError(
                    f'Task state after [{Task.State.TO_APPROVE}] '
                    f'needs to be [{Task.State.APPROVED}], '
                    f'[{Task.State.UNDER_CONDITIONS}] or '
                    f'[{Task.State.DECLINED}],'
                    f'but was [{new_state}]')
