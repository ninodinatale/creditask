from datetime import datetime
from math import ceil
from typing import List

from django.core.exceptions import ValidationError
from django.utils.timezone import utc

from creditask.models import Task, User, Approval, TaskState, TaskChange, \
    ApprovalState, ChangeableTaskProperty, CreditsCalc
from creditask.validators import MinLenValidator


def get_task_by_id(task_id: int) -> Task:
    return Task.objects.get(id=task_id)


def get_todo_tasks_by_user_email(user_mail: str) -> List[Task]:
    return list(
        Task.objects.filter(user__email=user_mail).exclude(
            state=TaskState.DONE).order_by('period_end'))


def get_to_approve_tasks_of_user(user_mail: str) -> List[Task]:
    # TODO solve this without raw query
    return list(Task.objects.raw(
        '''
        SELECT * from tasks t 
        inner join users u on t.user_id = u.id
        inner join approvals a on t.id = a.task_id
        inner join users au on a.user_id = au.id
         where t.state = %s and u.email <> %s and au.email = %s and a.state = %s
         order by t.period_end
         ''',
        ['TO_APPROVE', user_mail, user_mail, 'NONE']))


def get_unassigned_tasks(group_id: int) -> List[Task]:
    return list(Task.objects.filter(group_id=group_id, user=None).order_by(
        'period_end'))


def get_all_todo_tasks(group_id: int) -> List[Task]:
    return list(
        Task.objects.filter(group_id=group_id, state=TaskState.TO_DO).order_by(
            'period_end'))


def save_task(current_user: User, **kwargs) -> Task:
    if current_user is None:
        raise ValidationError('current_user may not be None')

    if 'id' in kwargs and kwargs.get('id') is not None:
        # updating task
        if 'group' in kwargs or 'group_id' in kwargs:
            raise ValidationError('group or group_id may not be changed')

        if 'created_by' in kwargs or 'created_by_id' in kwargs:
            raise ValidationError('created_by or created_by_id may not be '
                                  'changed')

        task_to_update = Task.objects.get(id=kwargs.get('id'))

        validate_state_change(task_to_update, **kwargs)
        validate_new_properties_based_on_task_state(task_to_update,
                                                    **kwargs)

        merge_values(task_to_update, current_user, **kwargs).save()
        return task_to_update
    else:
        # new task
        validate_task_properties(**kwargs)
        task_to_save = Task(**kwargs)
        if 'created_by' in kwargs:
            created_by = kwargs.get('created_by')
            if 'created_by_id' in kwargs:
                created_by_id = kwargs.get('created_by_id')
                if created_by.id != created_by_id:
                    raise ValidationError(
                        'different created_by.id and created_by_id provided. '
                        'Cannot determine what to favor.')
            task_to_save.created_by = created_by
        elif 'created_by_id' in kwargs:
            task_to_save.created_by_id = kwargs.get('created_by_id')
        else:
            task_to_save.created_by = current_user
        if 'group' in kwargs:
            group = kwargs.get('group')
            if 'group_id' in kwargs:
                group_id = kwargs.get('group_id')
                if group.id != group_id:
                    raise ValidationError(
                        'different group.id and group_id provided. '
                        'Cannot determine what to favor.')
            task_to_save.group = group
        elif 'group_id' in kwargs:
            task_to_save.group_id = kwargs.get('group_id')
        else:
            task_to_save.group = current_user.group
        task_to_save.save()
        TaskChange.objects.create(
            task_id=task_to_save.id,
            user=current_user,
            previous_value=None,
            current_value=current_user.id,
            changed_property=ChangeableTaskProperty.CreatedById,
            timestamp=datetime.utcnow().replace(tzinfo=utc)
        )

        # creating approvals for new task
        users = User.objects.filter(group_id=task_to_save.group_id)
        for user in users:
            Approval.objects.create(state=ApprovalState.NONE,
                                    task=task_to_save,
                                    user=user)
        return task_to_save


def merge_values(task_to_merge_into: Task,
                 current_user: User,
                 **kwargs) -> Task:
    for key, value in kwargs.items():
        if key == 'id' or getattr(task_to_merge_into, key) == value:
            # no changes
            continue

        # TODO this can be removed if TODO's in GraphQL's SaveTask are resolved:
        #  to set user_id to None, currently it's needed to pass '' (or
        #  something which can be parsed to int) due to None values being
        #  removed in SaveTask's mutate()
        if key == 'user_id':
            try:
                value = str(int(value))
            except ValueError:
                value = None
        if key == 'state':
            if value == TaskState.DONE:
                if task_to_merge_into.credits_calc == CreditsCalc.FIXED:
                    new_credits = ceil((task_to_merge_into.user.credits +
                                        task_to_merge_into.fixed_credits))
                elif task_to_merge_into.credits_calc == CreditsCalc.BY_FACTOR:
                    new_credits = ceil(task_to_merge_into.user.credits + (
                            task_to_merge_into.factor * (
                            task_to_merge_into.needed_time_seconds / 60)))
                else:
                    raise ValidationError(
                        'credits_calc of task has unknown value: cannot calculate '
                        'credits')
                # TODO import needs to be here due to cyclic imports, fix
                import creditask.services.user_service as userservice
                userservice.save_user(task_to_merge_into.user, credits=new_credits)

            # TODO test
            if getattr(task_to_merge_into, key) == TaskState.DECLINED:
                if value == TaskState.TO_DO:
                    # TODO import needs to be here due to cyclic imports, fix
                    import creditask.services.approval_service as approvalservice
                    for approval in list(task_to_merge_into.approvals.all()):
                        approvalservice.save_approval(current_user, approval.id,
                                      ApprovalState.NONE, for_reset=True)

        try:
            if key == 'user':
                # it's easier to just use the ID instead of the object,
                # so lets change the key and value here (ChangeableTaskProperty
                # does not have a member of User, only UserId)
                key = 'user_id'
                value = value.id if value is not None else None
            changed_property = ChangeableTaskProperty(key.upper())
            if changed_property is not None:
                TaskChange.objects.create(
                    task_id=task_to_merge_into.id,
                    user=current_user,
                    previous_value=getattr(task_to_merge_into, key),
                    current_value=value,
                    changed_property=changed_property,
                    timestamp=datetime.utcnow().replace(tzinfo=utc)
                )
        except ValueError:
            # if there's a value error, the enum does not contain a value for
            # the changed property name. This is ok since there are changes that
            # do not need to be in the history
            pass

        setattr(task_to_merge_into, key, value)

    return task_to_merge_into


def validate_new_properties_based_on_task_state(
        task: Task, **kwargs) -> None:
    if task.state == TaskState.TO_DO:
        # everything may be changed
        validate_task_properties(**task.to_dict())
    else:
        # Only property 'state' may be changed. If a value of
        # a property is the same as before, just ignore it.
        # Also, ignore the id.
        for key, value in kwargs.items():
            if key != 'state' and key != 'id' and value != getattr(task, key):
                raise ValidationError(
                    f'Column [{key}] of Task with state '
                    f'[{task.state}] may not be changed')


def validate_task_properties(**kwargs):
    period_start = kwargs.get('period_start', None)
    period_end = kwargs.get('period_end', None)
    name = kwargs.get('name', None)
    state = kwargs.get('state', None)
    if (period_end is not None and
            period_start is not None and
            period_end < period_start):
        raise ValidationError(
            f'period_start [{period_start}] may not be after '
            f'period_end [{period_end}]')

    if name is None:
        raise ValidationError('name may not be None')
    MinLenValidator(3)(name)
    if state is not None:
        if not hasattr(TaskState, state):
            raise ValidationError(f'"{state}" is an invalid '
                                  'type of task state')


def validate_state_change(task_to_update: Task, **kwargs):
    if 'state' in kwargs:
        new_state = kwargs.get('state')
        if new_state is None:
            raise ValidationError('Task state may not be None')
        if (task_to_update.state == TaskState.TO_DO and
                new_state != TaskState.TO_APPROVE):
            raise ValidationError(f'Task state after [{TaskState.TO_DO}] '
                                  f'needs to be [{TaskState.TO_APPROVE}],'
                                  f'but was [{new_state}]')
        if (task_to_update.state == TaskState.APPROVED and
                new_state != TaskState.DONE):
            raise ValidationError(f'Task state after [{TaskState.APPROVED}] '
                                  f'needs to be [{TaskState.DONE}],'
                                  f'but was [{new_state}]')
        if task_to_update.state == TaskState.TO_APPROVE:
            if (new_state != TaskState.APPROVED and
                    new_state != TaskState.DECLINED):
                raise ValidationError(
                    f'Task state after [{TaskState.TO_APPROVE}] '
                    f'needs to be [{TaskState.APPROVED}] or '
                    f'[{TaskState.DECLINED}],'
                    f'but was [{new_state}]')
        if task_to_update.state == TaskState.DECLINED:
            if new_state != TaskState.TO_DO:
                raise ValidationError(
                    f'Task state after [{TaskState.DECLINED}] '
                    f'needs to be [{TaskState.TO_DO}], but was [{new_state}]')
        if task_to_update.state == TaskState.DONE:
            raise ValidationError(
                f'Task state [{TaskState.DONE}] may not be changed')


def get_task_changes_by_task_id(task_id: int) -> List[TaskChange]:
    if task_id is None:
        raise ValidationError('task_id may not be None')
    return get_task_changes_by_task(Task.objects.get(id=task_id))


def get_task_changes_by_task(task: Task) -> List[TaskChange]:
    if task is None:
        raise ValidationError('task may not be None')
    return list(task.task_changes.all().order_by('timestamp'))


def get_task_approvals_by_task(task: Task) -> List[TaskChange]:
    if task is None:
        raise ValidationError('task may not be None')
    return list(task.approvals.exclude(user=task.user))
