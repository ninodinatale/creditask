from django.core.exceptions import ValidationError

from creditask.models import Approval, ApprovalState, User, TaskState
from .task_service import save_task


def save_approval(current_user: User, approval_id: int,
                  new_state: ApprovalState, message: str = None,
                  for_reset: bool = False) -> Approval:
    """
    Since approvals are created on creating tasks, approvals can only be altered
    on the state column.
    :param for_reset: defines if the approval should be reset. This is used if
    a task is in state DECLINED and is being set back to TO_DO, therefor the
    approval should also be set back to NONE, which is the only valid state in
    this case. Also, calculating and setting the task state will be omitted.
    :param message: The message to the approval. If ApprovalState is declined,
    the message is mandatory.
    :param new_state: The new state the approval should have.
    :param current_user: The current user.
    :param approval_id: The approval id to be its state altered.
    :return: The altered approval.
    """
    if approval_id is None:
        raise ValidationError('approval_id may not be None')

    if new_state is None:
        raise ValidationError('new_state may not be None')

    if new_state == ApprovalState.DECLINED and message is None:
        raise ValidationError('if new_state is DECLINED, '
                              'the message may not be None')

    approval = Approval.objects.get(id=approval_id)

    if (not (approval.task.state == TaskState.TO_APPROVE) and (not (
            for_reset and approval.task.state == TaskState.DECLINED
            and new_state == ApprovalState.NONE))):
        raise ValidationError(
            f'task state needs to be {TaskState.TO_APPROVE} or for_reset should'
            f' be True, TashState should be {TaskState.DECLINED} and the new '
            f'approval state needs to be {ApprovalState.NONE} in'
            f'order to change an approval')

    approval.state = new_state
    approval.message = message if message is not None else ''
    approval.save()

    approvals = list(approval.task.approvals.exclude(
        # approval state of owning user is always 'NONE', so filter it out
        user=approval.task.user
    ))

    if not for_reset:
        if (len(approvals) > 0 and next(
                (a for a in approvals if a.state == ApprovalState.NONE),
                None) is None):
            if all(a.state == ApprovalState.APPROVED for a in approvals):
                approval.task.state = TaskState.APPROVED
            else:
                approval.task.state = TaskState.DECLINED
            save_task(current_user, id=approval.task.id, state=approval.task.state)

    return approval
