from datetime import datetime
from typing import TypedDict, Optional

from . import User
from .enums.changeable_task_property import ChangeableTaskProperty


class TaskChange(TypedDict):
    current_value: Optional[str]
    previous_value: Optional[str]
    user: User
    timestamp: datetime
    changed_property: Optional[ChangeableTaskProperty]
