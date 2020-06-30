from typing import List

from django.core.exceptions import ValidationError

from creditask.models import Approval, TaskGroup
from .task_service import get_task_by_task_group_id


# TODO TEST
def save_approval(task_group_id: int, user_id: int,
                  state: Approval.State) -> Approval:
    if task_group_id is None:
        raise ValidationError('task_group_id may not be None')

    if user_id is None:
        raise ValidationError('user_by may not be None')

    if state is None:
        raise ValidationError('state may not be None')

    affecting_task = get_task_by_task_group_id(task_group_id)

    # TODO currently a task's state can be changed any time, also if the task
    #  is actually already done, which means the approvals can also change
    #  anytime. Implement of task state if this business logic changes.

    return Approval.objects.create(task=affecting_task, user_id=user_id,
                                   created_by_id=user_id, state=state)


# TODO test
def get_approvals_by_task_group(task_group: TaskGroup) -> List[Approval]:
    return list(get_task_by_task_group_id(task_group.id).approvals.all())
