from math import ceil

from django.core.exceptions import ValidationError

from creditask.models import Approval, ApprovalState, User, TaskState, \
    CreditsCalc
from .task_service import save_task
from .user_service import save_user


def save_approval(current_user: User, approval_id: int,
                  new_state: ApprovalState) -> Approval:
    """
    Since approvals are created on creating tasks, approvals can only be altered
    on the state column.
    :param new_state: The new state the approval should have.
    :param current_user: The current user.
    :param approval_id: The approval id to be its state altered.
    :return: The altered approval.
    """
    if approval_id is None:
        raise ValidationError('approval_id may not be None')

    if new_state is None:
        raise ValidationError('new_state may not be None')

    approval = Approval.objects.get(id=approval_id)

    # this is not an actual problem, but since it's only possible to change
    # the state of an approval, it's pretty sure unwanted behavior if the state
    # keeps the same
    if approval.state == new_state:
        raise ValidationError('approval state has not been changed')

    if approval.task.state != TaskState.TO_APPROVE:
        raise ValidationError(
            f'task state needs to be {TaskState.TO_APPROVE} in'
            f'order to change an approval, but was {approval.task.state}')

    approval.state = new_state
    approval.save()

    approvals = list(approval.task.approvals.exclude(
        # approval state of owning user is always 'NONE', so filter it out
        user=approval.task.user
    ))

    if (len(approvals) > 0 and next(
            (a for a in approvals if a.state == ApprovalState.NONE),
            None) is None):
        if all(a.state == ApprovalState.APPROVED for a in approvals):
            approval.task.state = TaskState.APPROVED
            if approval.task.credits_calc == CreditsCalc.FIXED:
                new_credits = ceil((approval.task.user.credits +
                                    approval.task.fixed_credits))
            elif approval.task.credits_calc == CreditsCalc.BY_FACTOR:
                new_credits = ceil(approval.task.user.credits + (
                        approval.task.factor * (
                        approval.task.needed_time_seconds / 60)))
            else:
                raise ValidationError(
                    'credits_calc of task has unknown value: cannot calculate '
                    'credits')
            save_user(approval.task.user, credits=new_credits)
        else:
            approval.task.state = TaskState.DECLINED
        save_task(current_user, id=approval.task.id, state=approval.task.state)

    return approval
