import datetime
from typing import List

from django.core.management.base import BaseCommand
from django.utils.timezone import utc

import creditask_django.settings as settings
from creditask.models import Group, User, Task, TaskState, TaskChange, \
    ChangeableTaskProperty, Approval, CreditsCalc, Grocery


class Command(BaseCommand):
    args = '<foo bar ...>'
    help = 'No args so far'

    def setup_dev_data(self):
        #
        # users
        #
        group_1 = Group.objects.create()

        all_user: List[User] = [
            User.objects.create(group=group_1, email='nino',
                                public_name='Nino',
                                password='pbkdf2_sha256$216000$XDP0IK0mMdrw$zkF'
                                         'UIfNs5ObTgW9ryZv4uP65JODej2/XKass+U10'
                                         'O10='),
            User.objects.create(group=group_1, email='moro',
                                public_name='Moro',
                                password='pbkdf2_sha256$216000$XDP0IK0mMdrw$zkF'
                                         'UIfNs5ObTgW9ryZv4uP65JODej2/XKass+U10'
                                         'O10='),
            User.objects.create(group=group_1, email='anna',
                                public_name='Anna',
                                password='pbkdf2_sha256$216000$XDP0IK0mMdrw$zkF'
                                         'UIfNs5ObTgW9ryZv4uP65JODej2/XKass+U10'
                                         'O10='),
            # User.objects.create(group=group_1, email='beni',
            #                     public_name='Beni',
            #                     password='pbkdf2_sha256$216000$XDP0IK0mMdrw$zkF'
            #                              'UIfNs5ObTgW9ryZv4uP65JODej2/XKass+U10'
            #                              'O10='),
            # User.objects.create(group=group_1, email='tinu',
            #                     public_name='Tinu',
            #                     password='pbkdf2_sha256$216000$XDP0IK0mMdrw$zkF'
            #                              'UIfNs5ObTgW9ryZv4uP65JODej2/XKass+U10'
            #                              'O10='),
            # User.objects.create(group=group_1, email='meli',
            #                     public_name='Meli',
            #                     password='pbkdf2_sha256$216000$XDP0IK0mMdrw$zkF'
            #                              'UIfNs5ObTgW9ryZv4uP65JODej2/XKass+U10'
            #                              'O10='),
            # User.objects.create(group=group_1, email='seppu',
            #                     public_name='Seppu',
            #                     password='pbkdf2_sha256$216000$XDP0IK0mMdrw$zkF'
            #                              'UIfNs5ObTgW9ryZv4uP65JODej2/XKass+U10'
            #                              'O10='),
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
                    task=task,
                    user=user,
                    message='Ein langer Text mit max_length=240, na wie siehts '
                            'wohl aus? Ein langer Text mit max_length=240, '
                            'na wie siehts wohl aus? Ein langer Text mit max_'
                            'length=240, na wie siehts wohl aus? Ein langer '
                            'Text mit max_length=240, na wie siehts wohl aus?'
                )
            TaskChange.objects.create(
                task=task,
                user=all_user[0],
                timestamp=rounded_now,
            )
            TaskChange.objects.create(
                task=task,
                user=all_user[1],
                timestamp=rounded_now,
                changed_property=ChangeableTaskProperty.Factor,
                previous_value="1",
                current_value="2"
            )
            TaskChange.objects.create(
                task=task,
                user=all_user[0],
                timestamp=rounded_now,
                changed_property=ChangeableTaskProperty.NeededTimeSeconds,
                previous_value="120",
                current_value="560"
            )
            TaskChange.objects.create(
                task=task,
                user=all_user[0],
                timestamp=rounded_now,
                changed_property=ChangeableTaskProperty.UserId,
                previous_value=(
                    task.user.id if task.user is not None else ''),
                current_value=all_user[2].id
            )

        Grocery.objects.create(
            name='Milch',
            in_cart=False,
            info='1 Liter',
            group=group_1
        )
        Grocery.objects.create(
            name='Poulet',
            in_cart=True,
            info='500g',
            group=group_1
        )
        Grocery.objects.create(
            name='Kornflakes',
            in_cart=False,
            info='1 Pkg',
            group=group_1
        )
        Grocery.objects.create(
            name='Tomatensauce',
            in_cart=False,
            info='2x Bolognese, 2x Napoletana',
            group=group_1
        )
        Grocery.objects.create(
            name='Früchte',
            in_cart=True,
            info='Äpfel, Birnen, Bananen',
            group=group_1
        )
        Grocery.objects.create(
            name='Spaghetti',
            in_cart=False,
            info='2 Packungen',
            group=group_1
        )
        Grocery.objects.create(
            name='Käse',
            in_cart=True,
            info='',
            group=group_1
        )

    def handle(self, *args, **options):
        if bool(getattr(settings, 'DEBUG')) is True:
            self.setup_dev_data()
