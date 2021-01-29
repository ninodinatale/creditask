from django.core.exceptions import ValidationError
from firebase_admin import messaging


# TODO test
def notify_group(*, current_user_id: int, group_id: int, title: str, body: str,
                 payload: dict):
    if 'id' not in payload or payload['id'] is None:
        raise ValidationError('id must be set and cannot be None')
    if 'state' not in payload or payload['state'] is None:
        raise ValidationError('state must be set and cannot be None')
    if not isinstance(payload['state'], str):
        raise ValidationError('state must be the string value')
    if 'user' not in payload:
        raise ValidationError('user must be set')
    if payload['user'] is not None:
        if 'id' not in payload['user'] or payload['user']['id'] is None:
            raise ValidationError('user.id must be set and cannot be None')

    message = messaging.Message(
        notification=messaging.Notification(
            title=title,
            body=body,
        ),
        data=dict(
            current_user_id=str(current_user_id),
            payload=str(payload).replace('\'', '"')
        ),
        topic=f"group_{str(group_id)}",
    )

    messaging.send(message)

