from django.db import DataError, IntegrityError

from creditask.models import Task, User, TaskGroup
from .models_test_base import ModelsTestBase


class TestTaskModel(ModelsTestBase):
    _user_email = 'user@TestTaskModel.com'

    def setUp(self) -> None:
        self.entity_under_test = Task
        task_group = TaskGroup.objects.create()
        user = User.objects.create(email=TestTaskModel._user_email,
                                   public_name='user', password='password')
        task_dict = dict(
            task_group=task_group,
            name='Task name',
            user_id=user.id,
            needed_time_seconds=10, state=Task.State.TO_DO,
            factor=1, period_start='2020-01-01',
            period_end='2020-01-01')

        self.valid_entity_dict = task_dict
        super().setUp()

    def tearDown(self) -> None:
        User.objects.get(email=TestTaskModel._user_email).delete()
        super().tearDown()

    '''task_group
    '''

    def test_task_group_should_not_be_nunllable(self):
        with self.assertRaises(IntegrityError):
            self.valid_entity_dict['task_group'] = None
            Task.objects.create(**self.valid_entity_dict)

    '''name
    '''

    def test_name_should_not_be_nunllable(self):
        with self.assertRaises(IntegrityError):
            self.valid_entity_dict['name'] = None
            Task.objects.create(**self.valid_entity_dict)

    def test_name_should_have_max_length_30(self):
        with self.assertRaises(DataError):
            self.valid_entity_dict['name'] = 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
            Task.objects.create(**self.valid_entity_dict)

    '''needed_time_seconds
    '''

    def test_needed_time_seconds_should_not_be_nunllable(self):
        with self.assertRaises(IntegrityError):
            self.valid_entity_dict['needed_time_seconds'] = None
            Task.objects.create(**self.valid_entity_dict)

    '''state
    '''

    def test_state_should_have_default_value(self):
        del self.valid_entity_dict['state']
        created_task = Task.objects.create(**self.valid_entity_dict)
        self.assertEqual(Task.State.TO_DO, created_task.state)

    '''factor
    '''

    def test_factor_should_have_default_value(self):
        del self.valid_entity_dict['factor']
        created_task = Task.objects.create(**self.valid_entity_dict)
        self.assertEqual(0, created_task.factor)

    '''user
    '''

    def test_user_should_be_nullable(self):
        del self.valid_entity_dict['user_id']
        created_task = Task.objects.create(**self.valid_entity_dict)
        self.assertEqual(None, created_task.user)

    '''period_start
    '''

    def test_period_start_should_have_default_value_of_now(self):
        del self.valid_entity_dict['period_start']
        created_task = Task.objects.create(**self.valid_entity_dict)
        self.assertIsNotNone(created_task.period_start)

    '''period_start
    '''

    def test_period_end_should_have_default_value_of_now(self):
        del self.valid_entity_dict['period_end']
        created_task = Task.objects.create(**self.valid_entity_dict)
        self.assertIsNotNone(created_task.period_end)
