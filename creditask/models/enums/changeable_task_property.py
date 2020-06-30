from enum import Enum


class ChangeableTaskProperty(Enum):
    Name = 'name'
    NeededTimeSeconds = 'needed_time_seconds'
    State = 'state'
    Factor = 'factor'
    UserId = 'user_id'
    PeriodStart = 'period_start'
    PeriodEnd = 'period_end'
    Approval = 'approval'
