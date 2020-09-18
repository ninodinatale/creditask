import datetime
import random
from unittest import mock
from unittest.mock import MagicMock

from django.core.exceptions import ValidationError
from django.test import TransactionTestCase

from creditask.models import Task, User, Approval, TaskState, \
    ApprovalState
from creditask.models.enums.changeable_task_property import \
    ChangeableTaskProperty
from creditask.models.task_change import TaskChange
from creditask.services.task_service import get_task_by_id, \
    get_todo_tasks_by_user_email, save_task, \
    validate_state_change, validate_task_properties, merge_values, \
    get_to_approve_tasks_of_user


class TestTaskService(TransactionTestCase):

    @mock.patch('creditask.services.task_service.Task.objects.get')
    def test_get_task_by_id(self, mock_fn: MagicMock):
        mock_task = Task(id=random.randint(1, 9999))
        mock_fn.return_value = mock_task

        task = get_task_by_id(mock_task.id)

        self.assertIs(mock_task, task)
        self.assertIsNotNone(mock_fn.call_args[1].get('id'))
        self.assertEquals(mock_fn.call_args[1]['id'], mock_task.id)
        self.assertTrue(1, len(mock_fn.call_args[1]))

    def test_get_task_by_id(self):
        user = User.objects.create(
            email='test_get_task_by_id@user.com',
            password='password'
        )

        task_0 = Task.objects.create(
            needed_time_seconds=0,
            name='name',
            created_by=user,

        )
        task_1 = Task.objects.create(
            needed_time_seconds=0,
            name='name',
            created_by=user
        )
        task_2 = Task.objects.create(
            needed_time_seconds=0,
            name='name',
            created_by=user
        )
        task_3 = Task.objects.create(
            needed_time_seconds=0,
            name='name',
            created_by=user
        )
        task_4 = Task.objects.create(
            needed_time_seconds=0,
            name='name',
            created_by=user
        )
        task_5 = Task.objects.create(
            needed_time_seconds=0,
            name='name',
            created_by=user
        )
        task_6 = Task.objects.create(
            needed_time_seconds=0,
            name='name',
            created_by=user
        )
        task_7 = Task.objects.create(
            needed_time_seconds=0,
            name='name',
            created_by=user
        )

        task = get_task_by_id(task_6.id)

        self.assertEquals(task_6.id, task.id)

    def test_get_todo_tasks_by_user_email(self):
        user_1 = User.objects.create(
            email='test_get_task_by_id@user_1.com',
            password='password'
        )
        user_2 = User.objects.create(
            email='test_get_task_by_id@user_2.com',
            password='password'
        )

        # all good
        task_1 = Task.objects.create(
            needed_time_seconds=0,
            name='name',
            user=user_1,
            created_by=user_1,
            state=TaskState.TO_DO
        )

        # all good
        task_2 = Task.objects.create(
            needed_time_seconds=0,
            name='name',

            user=user_1,
            created_by=user_1,
            state=TaskState.TO_DO
        )

        # wrong state
        task_3 = Task.objects.create(
            needed_time_seconds=0,
            name='name',

            user=user_1,
            created_by=user_1,
            state=TaskState.APPROVED
        )

        # wrong user
        task_4 = Task.objects.create(
            needed_time_seconds=0,
            name='name',

            user=user_2,
            created_by=user_1,
            state=TaskState.TO_DO
        )

        # wrong state
        task_5 = Task.objects.create(
            needed_time_seconds=0,
            name='name',

            user=user_1,
            created_by=user_1,
            state=TaskState.APPROVED
        )

        # all good
        task_6 = Task.objects.create(
            needed_time_seconds=0,
            name='name',
            user=user_1,
            created_by=user_1,
            state=TaskState.TO_DO
        )

        # wrong user
        task_7 = Task.objects.create(
            needed_time_seconds=0,
            name='name',

            user=user_2,
            created_by=user_1,
            state=TaskState.TO_DO
        )

        # all good
        task_8 = Task.objects.create(
            needed_time_seconds=0,
            name='name',

            user=user_1,
            created_by=user_1,
            state=TaskState.TO_DO
        )

        # wrong user
        task_9 = Task.objects.create(
            needed_time_seconds=0,
            name='name',

            user=user_2,
            created_by=user_1,
            state=TaskState.TO_DO
        )

        # all good
        task_10 = Task.objects.create(
            needed_time_seconds=0,
            name='name',

            user=user_1,
            created_by=user_1,
            state=TaskState.TO_DO
        )

        # all good
        task_11 = Task.objects.create(
            needed_time_seconds=0,
            name='name',

            user=user_1,
            created_by=user_1,
            state=TaskState.TO_DO
        )

        # all good
        task_12 = Task.objects.create(
            needed_time_seconds=0,
            name='name',

            user=user_1,
            created_by=user_1,
            state=TaskState.TO_DO
        )

        tasks = get_todo_tasks_by_user_email(user_1.email)

        self.assertEquals(7, len(tasks))
        self.assertIn(task_1, tasks)
        self.assertIn(task_2, tasks)
        self.assertIn(task_6, tasks)
        self.assertIn(task_8, tasks)
        self.assertIn(task_10, tasks)
        self.assertIn(task_11, tasks)
        self.assertIn(task_12, tasks)

    def test_get_to_approve_tasks_of_user(self):
        user_1 = User.objects.create(
            email='test_get_task_by_id@user_1.com',
            password='password'
        )
        user_2 = User.objects.create(
            email='test_get_task_by_id@user_2.com',
            password='password'
        )

        # wrong state
        task_3 = Task.objects.create(
            needed_time_seconds=0,
            name='name',
            user=user_2,
            created_by=user_2,
            state=TaskState.TO_DO
        )

        # all good
        task_6 = Task.objects.create(
            needed_time_seconds=0,
            name='name',

            user=user_2,
            created_by=user_2,
            state=TaskState.TO_APPROVE
        )

        # wrong user
        task_9 = Task.objects.create(
            needed_time_seconds=0,
            name='name',
            user=user_1,
            created_by=user_1,
            state=TaskState.TO_APPROVE
        )

        # all good
        task_12 = Task.objects.create(
            needed_time_seconds=0,
            name='name',
            user=user_2,
            created_by=user_2,
            state=TaskState.TO_APPROVE
        )

        tasks = get_to_approve_tasks_of_user(user_1.email)

        self.assertEquals(2, len(tasks))
        self.assertIn(task_6, tasks)
        self.assertIn(task_12, tasks)

    @mock.patch('creditask.services.task_service.validate_task_properties')
    @mock.patch('creditask.services.task_service.get_task_by_id')
    @mock.patch('creditask.services.task_service.validate_new_properties_based_'
                'on_task_state')
    @mock.patch('creditask.services.task_service.Task.save')
    def test_save_task(self, mock_save,
                       mock_get_task_by_id,
                       mock_validate_new_properties_based_on_task_state,
                       mock_validate_task_properties):
        mock_user = User(email='user@email.com')
        args = {
            'name': 'created_task',
            'user': mock_user
        }

        with self.subTest('should throw if created_by is not given'):
            with self.assertRaises(ValidationError) as e:
                save_task(None, **args)

        with self.subTest('if is existing task'):
            pass  # TODO test needs to be written
            # with self.subTest('should validate state'):
            #     try:
            #         save_task(mock_user, **args)
            #     except ValidationError:
            #         self.fail('If state is None, no validation should be performed')
            #     try:
            #
            #         save_task(mock_user, **{**{'state': TaskState.TO_DO},
            #                                 **args})
            #     except ValidationError:
            #         self.fail('Should not fail if state is valid')
            #
            #     with self.assertRaises(ValidationError):
            #         save_task(mock_user,
            #                   **{**dict(state='SOME_INVALID_STATE'), **args})

        with self.subTest('if is new task'):
            pass  # TODO test needs to be written

        with self.subTest('save should be called'):
            mock_save.call_count = 0
            save_task(mock_user, **args)
            self.assertEquals(1, mock_save.call_count)

        with self.subTest('should return task'):
            task = save_task(mock_user, **args)
            self.assertIsNotNone(task)
            self.assertIsInstance(task, Task)

    @mock.patch('creditask.services.task_service.MinLenValidator')
    def test_validate_task_properties(self, mock_min_len_validator):
        mock_user = User(email='user@email.com')
        args = {
            'name': 'created_task',
            'user': mock_user
        }

        with self.subTest('should validate with period_end not before '
                          'period_start'):
            with self.assertRaises(ValidationError):
                validate_task_properties(Task(period_end='2020-01-10',
                                              period_start='2020-01-11'))

        with self.subTest('should validate with MinLenValidator'):
            validate_task_properties(Task(name='created_task'))
            self.assertEquals(mock_min_len_validator.call_args[0][0], 3,
                              'MinLeneValidator needs to be initialized with '
                              '3 (length of 3)')
            self.assertEquals(
                mock_min_len_validator.return_value.call_args[0][0],
                'created_task',
                'MinLeneValidator needs to be called with '
                'task name')
        with self.subTest('should raise error if invalid task state is '
                          'provided'):
            with self.assertRaises(ValidationError) as e:
                validate_task_properties(Task(name='created_task',
                                              state='SOME_UNKNOWN_TASK'))
                self.assertEquals('"SOME_UNKNOWN_TASK" is an invalid '
                                  'type of task state', e)

        with self.subTest('should not raise error if valid task state is '
                          'provided'):

            for state_under_test in TaskState.values:
                try:
                    validate_task_properties(Task(name='created_task',
                                                  state=state_under_test))
                except ValidationError:
                    self.fail('validate_task_properties should not have raised'
                              ' a validation error')

    def test_merge_values(self):
        with self.subTest('should add attributes if not existing yet and return'
                          'task'):
            existing_task = Task()
            values_to_merge = dict(needed_time_seconds=2, state='TO_DO')
            return_value = merge_values(existing_task, values_to_merge)

            self.assertEquals(values_to_merge.get('needed_time_seconds'),
                              return_value.needed_time_seconds)
            self.assertEquals(values_to_merge.get('state'),
                              return_value.state)

        with self.subTest('should override attributes if not existing yet and '
                          'return task'):
            existing_task = Task(needed_time_seconds=0, state='TO_DO')
            values_to_merge = dict(needed_time_seconds=2, state='APPROVED')

            return_value = merge_values(existing_task, values_to_merge)

            self.assertEquals(values_to_merge.get('needed_time_seconds'),
                              return_value.needed_time_seconds)
            self.assertEquals(values_to_merge.get('state'),
                              return_value.state)


def test_validate_state_change(self):
    with self.subTest('should not raise error if state has not changed'):
        mock_old_task = Task()
        try:
            validate_state_change(mock_old_task, {})
        except ValidationError:
            self.fail('validate_state_change should not have been failed')

    with self.subTest('should raise error if new state is None'):
        mock_old_task = Task()
        new_task_dict = dict(state=None)
        with self.assertRaises(ValidationError) as e:
            validate_state_change(mock_old_task, new_task_dict)
        self.assertEquals('Task state may not be None', e.exception.message)

    with self.subTest('should raise error if old task state is TO_DO and '
                      'new state is not TO_APPROVE'):
        mock_old_task = Task(state=TaskState.TO_DO)
        new_task_dict = dict(state=TaskState.TO_DO)
        with self.assertRaises(ValidationError) as e:
            validate_state_change(mock_old_task, new_task_dict)
        self.assertEquals(f'Task state after [{TaskState.TO_DO}] '
                          f'needs to be [{TaskState.TO_APPROVE}],'
                          f'but was [{TaskState.TO_DO}]',
                          e.exception.message)

    for state_under_test in TaskState.values:
        if not (state_under_test != TaskState.APPROVED and
                state_under_test != TaskState.DECLINED):
            continue

        with self.subTest(f'should raise error if old task state is '
                          f'TO_APPROVE and new state is '
                          f'{state_under_test}'):
            mock_old_task = Task(state=TaskState.TO_APPROVE)
            new_task_dict = dict(state=state_under_test)
            with self.assertRaises(ValidationError) as e:
                validate_state_change(mock_old_task, new_task_dict)
            self.assertEquals(f'Task state after [{TaskState.TO_APPROVE}] '
                              f'needs to be [{TaskState.APPROVED}] or '
                              f'[{TaskState.DECLINED}],'
                              f'but was [{state_under_test}]',
                              e.exception.message)

    for state_under_test in TaskState.values:
        if state_under_test == TaskState.TO_APPROVE:
            continue

        with self.subTest(f'should not raise error if old task state is '
                          f'not TO_APPROVE'):
            mock_old_task = Task(state='SOME_UNKNOWN_STATE')
            new_task_dict = dict(state=state_under_test)
            try:
                validate_state_change(mock_old_task, new_task_dict)
            except ValidationError:
                self.fail(
                    'validate_state_change should not have been failed')

    for state_under_test in TaskState.values:
        if (state_under_test != TaskState.APPROVED and
                state_under_test != TaskState.DECLINED):
            continue

        with self.subTest(f'should not raise error if old task state is '
                          f'TO_APPROVE and new state is '
                          f'{state_under_test}'):
            mock_old_task = Task(state=TaskState.TO_APPROVE)
            new_task_dict = dict(state=state_under_test)
            try:
                validate_state_change(mock_old_task, new_task_dict)
            except ValidationError:
                self.fail(
                    'validate_state_change should not have been failed')
