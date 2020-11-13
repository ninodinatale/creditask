import datetime
from typing import List

from django.core.management.base import BaseCommand

import creditask_django.settings as settings
from creditask.models import Group, User, Task, TaskState, TaskChange, \
    ChangeableTaskProperty, Approval, CreditsCalc


class Command(BaseCommand):
    args = '<foo bar ...>'
    help = 'No args so far'

    def setup_dev_data(self):
        #
        # users
        #
        group_1 = Group.objects.create()

        all_user: List[User] = [
            User.objects.create(group=group_1, email='nino@mail.com',
                                public_name='Nino',
                                password='pbkdf2_sha256$216000$XDP0IK0mMdrw$zkF'
                                         'UIfNs5ObTgW9ryZv4uP65JODej2/XKass+U10'
                                         'O10='),
            User.objects.create(group=group_1, email='moro@mail.com',
                                public_name='Moro',
                                password='pbkdf2_sha256$216000$XDP0IK0mMdrw$zkF'
                                         'UIfNs5ObTgW9ryZv4uP65JODej2/XKass+U10'
                                         'O10='),
            User.objects.create(group=group_1, email='anna@mail.com',
                                public_name='Anna',
                                password='pbkdf2_sha256$216000$XDP0IK0mMdrw$zkF'
                                         'UIfNs5ObTgW9ryZv4uP65JODej2/XKass+U10'
                                         'O10=')
        ]

        rounded_now = datetime.datetime(
            *datetime.datetime.utcnow().replace(tzinfo=utc).timetuple()[:3])

        all_tasks: List[Task] = [
            Task.objects.create(
                name='Wischen',
                needed_time_seconds=0,
                state=TaskState.TO_DO,
                credits_calc=CreditsCalc.FIXED,
                fixed_credits=30,
                user=all_user[0],
                group=group_1,
                created_by=all_user[0],
                period_start=rounded_now + datetime.timedelta(days=1),
                period_end=rounded_now + datetime.timedelta(days=2)
            ),
            Task.objects.create(
                name='Putzen',
                needed_time_seconds=0,
                state=TaskState.TO_APPROVE,
                user=all_user[0],
                group=group_1,
                created_by=all_user[0],
                period_end=rounded_now
            ),
            Task.objects.create(
                name='Kochen',
                needed_time_seconds=0,
                state=TaskState.TO_DO,
                user=all_user[0],
                group=group_1,
                created_by=all_user[0],
                period_end=rounded_now
            ),
            Task.objects.create(
                name='Kacken',
                needed_time_seconds=0,
                state=TaskState.TO_DO,
                user=all_user[0],
                group=group_1,
                created_by=all_user[0],
                period_end=rounded_now + datetime.timedelta(days=1)
            ),
            Task.objects.create(
                name='Bislen',
                needed_time_seconds=0,
                state=TaskState.TO_DO,
                user=all_user[0],
                group=group_1,
                created_by=all_user[0],
                period_end=rounded_now + datetime.timedelta(days=4)
            ),
            Task.objects.create(
                name='Saugen',
                needed_time_seconds=0,
                state=TaskState.TO_DO,
                user=all_user[0],
                group=group_1,
                created_by=all_user[0],
                period_end=rounded_now + datetime.timedelta(days=8)
            ),
            Task.objects.create(
                name='Einkaufen',
                needed_time_seconds=0,
                state=TaskState.TO_DO,
                user=None,
                group=group_1,
                created_by=all_user[0],
                period_end=rounded_now + datetime.timedelta(days=1)
            ),
            Task.objects.create(
                name='Entsorgen',
                needed_time_seconds=0,
                state=TaskState.TO_DO,
                user=None,
                group=group_1,
                created_by=all_user[0],
                period_end=rounded_now + datetime.timedelta(days=1)
            ),
            Task.objects.create(
                name='Rasenmähen',
                needed_time_seconds=0,
                state=TaskState.TO_DO,
                user=None,
                group=group_1,
                created_by=all_user[0],
                period_end=rounded_now + datetime.timedelta(days=1)
            )
        ]

        for task in all_tasks:
            for user in all_user:
                Approval.objects.create(
                    created_by=user,
                    task=task,
                    user=user
                )
            TaskChange.objects.create(
                task=task,
                user=all_user[0],
                created_by=all_user[0],
                timestamp=task.created_at,
            )
            TaskChange.objects.create(
                task=task,
                user=all_user[1],
                timestamp=task.created_at,
                changed_property=ChangeableTaskProperty.Factor,
                previous_value=1,
                created_by=all_user[0],
                current_value=2
            )
            TaskChange.objects.create(
                task=task,
                user=all_user[0],
                timestamp=task.created_at,
                changed_property=ChangeableTaskProperty.NeededTimeSeconds,
                previous_value=120,
                created_by=all_user[0],
                current_value=560
            )
            TaskChange.objects.create(
                task=task,
                user=all_user[0],
                timestamp=task.created_at,
                changed_property=ChangeableTaskProperty.UserId,
                previous_value=(
                    task.user.public_name if task.user is not None else None),
                created_by=all_user[0],
                current_value=all_user[2].public_name
            )

    def handle(self, *args, **options):
        if getattr(settings, 'DEBUG') is True:
            self.setup_dev_data()
