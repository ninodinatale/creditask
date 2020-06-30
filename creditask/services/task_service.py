from typing import List

from django.core.exceptions import ValidationError

from creditask.models import Task, User, TaskGroup, Approval
from creditask.models.enums.changeable_task_property import \
    ChangeableTaskProperty
from creditask.models.task_change import TaskChange
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
        validate_new_properties_based_on_task_state(task_to_save,
                                                    dict(**kwargs))

        merge_values(task_to_save, kwargs).save()

        new_task = get_task_by_task_group_id(kwargs.get('task_group_id'))
        copy_approvals(task_to_save, new_task)

        return new_task
    else:
        # new task means new task group needed
        # TODO TEST
        task_group = TaskGroup.objects.create()
        task_to_create = Task(created_by=created_by,
                              task_group=task_group,
                              **kwargs,
                              state=Task.State.TO_DO,
                              needed_time_seconds=0)
        validate_task_properties(task_to_create)
        task_to_create.save()
        return task_to_create


def merge_values(existing_task: Task, values_to_merge: dict) -> Task:
    for key, value in values_to_merge.items():
        setattr(existing_task, key, value)
    return existing_task


def copy_approvals(old_task: Task, new_task: Task) -> None:
    for approval in list(Approval.objects.filter(task=old_task)):
        approval.task = new_task
        approval.save()


# TODO test
def validate_new_properties_based_on_task_state(
        task_to_save: Task, new_properties: dict) -> None:
    if task_to_save.state == Task.State.TO_DO:
        # everything may be changed
        validate_task_properties(task_to_save)
    else:
        if 'period_start' in new_properties:
            raise ValidationError(
                f'period_start may not be changed if task has'
                f' state [{new_properties.get("state")}]')
        if 'period_end' in new_properties:
            raise ValidationError(
                f'period_end may not be changed if task has'
                f' state [{new_properties.get("state")}]')

        for key, value in new_properties:
            # todo test
            if key != 'task_group_id' and key != 'state':
                if value != task_to_save[key]:
                    raise ValidationError(
                        f'Column [{key}] of Task with state '
                        f'[{task_to_save.state}] may not be changed')


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
                    new_state != Task.State.DECLINED):
                raise ValidationError(
                    f'Task state after [{Task.State.TO_APPROVE}] '
                    f'needs to be [{Task.State.APPROVED}] or '
                    f'[{Task.State.DECLINED}],'
                    f'but was [{new_state}]')


def get_changes(task: Task) -> List[TaskChange]:
    changes: List[TaskChange] = []

    tasks: List[Task] = list(Task.objects.filter(
        task_group_id=task.task_group_id).order_by('created_at'))

    for i, tsk in enumerate(tasks):
        if i == 0:
            changes.append(
                TaskChange(
                    current_value=None,
                    previous_value=None,
                    user=tsk.created_by,
                    timestamp=tsk.created_at,
                    changed_property=None))
        else:
            for prop in ChangeableTaskProperty:
                if prop == ChangeableTaskProperty.Approval:
                    continue

                current_value = getattr(tsk, prop.value)
                previous_value = getattr(tasks[i - 1], prop.value)

                if current_value != previous_value:
                    changes.append(TaskChange(
                        current_value=str(current_value),
                        previous_value=str(previous_value),
                        user=tsk.created_by,
                        timestamp=tsk.created_at,
                        changed_property=ChangeableTaskProperty(prop)
                    ))
            for approval in tsk.approvals.all():
                prev_approval = tasks[i - 1].approvals.filter(
                    user=approval.user).first()
                if prev_approval is not None:
                    if prev_approval.state != approval.state:
                        changes.append(TaskChange(
                            current_value=approval.state,
                            previous_value=prev_approval.state,
                            user=approval.user,
                            timestamp=approval.created_at,
                            changed_property=ChangeableTaskProperty.Approval
                        ))
                elif approval.state != Approval.State.NONE:
                    changes.append(TaskChange(
                        current_value=approval.state,
                        previous_value=Approval.State.NONE.value,
                        user=approval.user,
                        timestamp=approval.created_at,
                        changed_property=ChangeableTaskProperty.Approval
                    ))

    changes.reverse()
    return changes
