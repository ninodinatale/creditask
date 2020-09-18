from typing import List

from django.core.exceptions import ValidationError

from creditask.models import Task, User, Approval, TaskState, \
    BaseModel, ApprovalState
from creditask.validators import MinLenValidator


def get_task_by_id(task_id: int) -> Task:
    return Task.objects.get(id=task_id)


def get_todo_tasks_by_user_email(user_mail: str) -> List[Task]:
    return list(
        Task.objects.filter(user__email=user_mail, state=TaskState.TO_DO))


# TODO TEST
def get_to_approve_tasks_of_user(user_mail: str) -> List[Task]:
    return list(
        Task.objects.filter(state=TaskState.TO_APPROVE).exclude(
            user__email=user_mail))


# TODO function is not tested entirely yet
def save_task(created_by: User, **kwargs) -> Task:
    if created_by is None:
        raise ValidationError('created_by may not be None')

    existing_task_id = kwargs.get('id')
    if existing_task_id is not None:
        task_to_update = Task.objects.get(id=existing_task_id)

        validate_state_change(task_to_update, kwargs)
        validate_new_properties_based_on_task_state(task_to_update, kwargs)

        merge_values(task_to_update, kwargs).save()
        return task_to_update
    else:
        # new task
        # TODO TEST
        task_to_create = Task(created_by=created_by,
                              **kwargs,
                              state=TaskState.TO_DO,
                              needed_time_seconds=0)
        validate_task_properties(task_to_create)
        task_to_create.save()

        # creating approvals for new task
        users = User.objects.filter(group_id=created_by.group_id)
        for user in users:
            Approval.objects.create(state=ApprovalState.NONE,
                                    task=task_to_create,
                                    created_by=created_by,
                                    user=user)
        return task_to_create


# TODO move to general service (?)
def merge_values(entity_to_merge_into: BaseModel,
                 values_to_merge: dict) -> BaseModel:
    for key, value in values_to_merge.items():
        setattr(entity_to_merge_into, key, value)
    return entity_to_merge_into


# TODO test
def validate_new_properties_based_on_task_state(
        task: Task, new_properties: dict) -> None:
    if task.state == TaskState.TO_DO:
        # everything may be changed
        validate_task_properties(task)
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
            if key != 'state' and value != task[key]:
                raise ValidationError(
                    f'Column [{key}] of Task with state '
                    f'[{task.state}] may not be changed')


def validate_task_properties(task: Task):
    if (task.period_end is not None and
            task.period_start is not None and
            task.period_end < task.period_start):
        raise ValidationError(
            f'period_start [{task.period_start}] may not be after '
            f'period_end [{task.period_end}]')

    MinLenValidator(3)(task.name)
    if task.state is not None:
        if not hasattr(TaskState, task.state):
            raise ValidationError(f'"{task.state}" is an invalid '
                                  'type of task state')


def validate_state_change(task_to_update: Task, properties_to_update: dict):
    if 'state' in properties_to_update:
        new_state = properties_to_update.get('state')
        if new_state is None:
            raise ValidationError('Task state may not be None')
        if (task_to_update.state == TaskState.TO_DO and
                new_state != TaskState.TO_APPROVE):
            raise ValidationError(f'Task state after [{TaskState.TO_DO}] '
                                  f'needs to be [{TaskState.TO_APPROVE}],'
                                  f'but was [{new_state}]')
        if task_to_update.state == TaskState.TO_APPROVE:
            if (new_state != TaskState.APPROVED and
                    new_state != TaskState.DECLINED):
                raise ValidationError(
                    f'Task state after [{TaskState.TO_APPROVE}] '
                    f'needs to be [{TaskState.APPROVED}] or '
                    f'[{TaskState.DECLINED}],'
                    f'but was [{new_state}]')


# TODO replace with task changes in new db table
def get_task_changes(task: Task) -> List:

    return []
    # changes: List[TaskChange] = []
#
#     tasks: List[Task] = list(Task.objects.filter(
#         task_group_id=task.task_group_id).order_by('created_at'))
#
#     for i, tsk in enumerate(tasks):
#         if i == 0:
#             changes.append(
#                 TaskChange(
#                     current_value=None,
#                     previous_value=None,
#                     user=tsk.created_by,
#                     timestamp=tsk.created_at,
#                     changed_property=None))
#         else:
#             for prop in ChangeableTaskProperty:
#                 if prop == ChangeableTaskProperty.Approval:
#                     continue
#
#                 current_value = getattr(tsk, prop.value)
#                 previous_value = getattr(tasks[i - 1], prop.value)
#
#                 if current_value != previous_value:
#                     changes.append(TaskChange(
#                         current_value=str(current_value),
#                         previous_value=str(previous_value),
#                         user=tsk.created_by,
#                         timestamp=tsk.created_at,
#                         changed_property=ChangeableTaskProperty(prop)
#                     ))
#             for approval in tsk.approvals.all():
#                 prev_approval = tasks[i - 1].approvals.filter(
#                     user=approval.user).first()
#                 if prev_approval is not None:
#                     if prev_approval.state != approval.state:
#                         changes.append(TaskChange(
#                             current_value=approval.state,
#                             previous_value=prev_approval.state,
#                             user=approval.user,
#                             timestamp=approval.created_at,
#                             changed_property=ChangeableTaskProperty.Approval
#                         ))
#                 elif approval.state != ApprovalState.NONE:
#                     changes.append(TaskChange(
#                         current_value=approval.state,
#                         previous_value=ApprovalState.NONE.value,
#                         user=approval.user,
#                         timestamp=approval.created_at,
#                         changed_property=ChangeableTaskProperty.Approval
#                     ))
#
#     changes.reverse()
#     return changes
