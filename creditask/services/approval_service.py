from django.core.exceptions import ValidationError

from creditask.models import Approval, ApprovalState


# TODO only validations are tested
def save_approval(id: int, new_state: ApprovalState) -> Approval:
    if id is None:
        raise ValidationError('id may not be None')

    if new_state is None:
        raise ValidationError('new_state may not be None')

    approval = Approval.objects.get(id=id)
    approval.state = new_state
    approval.save()

    return approval
