import random
from unittest import mock
from unittest.mock import MagicMock

from django.core.exceptions import ValidationError
from django.test import TransactionTestCase

from creditask.models import Task, User, TaskGroup
from creditask.services.task_service import get_task_by_id, \
    get_todo_tasks_by_user_email, save_task, get_task_by_task_group_id, \
    validate_state_change, validate_task_properties


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

    def test_get_task_by_task_group_id(self):
        task_group_1 = TaskGroup.objects.create()
        task_group_2 = TaskGroup.objects.create()
        user = User.objects.create(
            email='test_get_task_by_task_group_id@user.com',
            password='password'
        )

        task_0 = Task.objects.create(
            task_group=task_group_2,
            needed_time_seconds=0,
            name='name',
            done=False,
            created_by=user,

        )
        task_1 = Task.objects.create(
            task_group=task_group_1,
            needed_time_seconds=0,
            name='name',
            done=False,
            created_by=user
        )
        task_2 = Task.objects.create(
            task_group=task_group_2,
            needed_time_seconds=0,
            name='name',
            done=False,
            created_by=user
        )
        task_3 = Task.objects.create(
            task_group=task_group_1,
            needed_time_seconds=0,
            name='name',
            done=False,
            created_by=user
        )
        task_4 = Task.objects.create(
            task_group=task_group_1,
            needed_time_seconds=0,
            name='name',
            done=False,
            created_by=user
        )
        task_5 = Task.objects.create(
            task_group=task_group_2,
            needed_time_seconds=0,
            name='name',
            done=False,
            created_by=user
        )
        task_6 = Task.objects.create(
            task_group=task_group_1,
            needed_time_seconds=0,
            name='name',
            done=False,
            created_by=user
        )
        task_7 = Task.objects.create(
            task_group=task_group_2,
            needed_time_seconds=0,
            name='name',
            done=False,
            created_by=user
        )

        task = get_task_by_task_group_id(task_group_1.id)

        self.assertEquals(task_6.id, task.id)

    @mock.patch('creditask.services.task_service.Task.objects')
    def test_get_todo_tasks_by_user_email(self, objects_mock):
        mock_tasks = [Task(id=random.randint(1, 9999))]

        objects_mock.filter.return_value = Task.objects.filter()

        user_email = 'user@mail.com'

        tasks = get_todo_tasks_by_user_email(user_email)

        self.assertIsNotNone(objects_mock.filter.call_args[1].get(
            'user__email'))
        self.assertEquals(user_email, objects_mock.filter.call_args[1].get(
            'user__email'))

        # TODO mocking chained .exclude() does not work somehow. Get it to work
        return

        self.assertTrue(1, len(objects_mock.filter.call_args[1]))
        self.assertIsNotNone(objects_mock.exclude.call_args[1].get('state'))
        self.assertEquals(Task.State.APPROVED, objects_mock.exclude.call_args[
            1].get(
            'state'))
        self.assertTrue(1, len(objects_mock.exclude.call_args[1]))

        self.assertIs(mock_tasks, tasks)

    @mock.patch('creditask.services.task_service.validate_task_properties')
    @mock.patch('creditask.services.task_service.get_task_by_task_group_id')
    @mock.patch('creditask.services.task_service.Task.save')
    def test_save_task(self, mock_save,
                       mock_get_task_by_task_group_id,
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
            #         save_task(mock_user, **{**{'state': Task.State.TO_DO},
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
            self.assertEquals(mock_min_len_validator.return_value.call_args[0][0],
                              'created_task',
                              'MinLeneValidator needs to be called with '
                              'task name')
        with self.subTest('should raise error if invalid task state is '
                          'provided'):
            with self.assertRaises(ValidationError) as e:
                validate_task_properties(Task(name='created_task',
                                              state='SOME_UNKNOWN_TASK'))
                self.assertEquals('"SOME_UNKNOWN_TASK" is an invalid '
                                  'type of task state')

        with self.subTest('should not raise error if valid task state is '
                          'provided'):

            for state_under_test in Task.State.values:
                try:
                    validate_task_properties(Task(name='created_task',
                                                  state=state_under_test))
                except ValidationError:
                    self.fail('validate_task_properties should not have raised'
                              ' a validation error')

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
            mock_old_task = Task(state=Task.State.TO_DO)
            new_task_dict = dict(state=Task.State.TO_DO)
            with self.assertRaises(ValidationError) as e:
                validate_state_change(mock_old_task, new_task_dict)
            self.assertEquals(f'Task state after [{Task.State.TO_DO}] '
                              f'needs to be [{Task.State.TO_APPROVE}],'
                              f'but was [{Task.State.TO_DO}]',
                              e.exception.message)

        for state_under_test in Task.State.values:
            if not (state_under_test != Task.State.APPROVED and
                    state_under_test != Task.State.UNDER_CONDITIONS and
                    state_under_test != Task.State.DECLINED):
                continue

            with self.subTest(f'should raise error if old task state is '
                              f'TO_APPROVE and new state is '
                              f'{state_under_test}'):
                mock_old_task = Task(state=Task.State.TO_APPROVE)
                new_task_dict = dict(state=state_under_test)
                with self.assertRaises(ValidationError) as e:
                    validate_state_change(mock_old_task, new_task_dict)
                self.assertEquals(f'Task state after [{Task.State.TO_APPROVE}] '
                                  f'needs to be [{Task.State.APPROVED}], '
                                  f'[{Task.State.UNDER_CONDITIONS}] or '
                                  f'[{Task.State.DECLINED}],'
                                  f'but was [{state_under_test}]',
                                  e.exception.message)

        for state_under_test in Task.State.values:
            if state_under_test == Task.State.TO_APPROVE:
                continue

            with self.subTest(f'should not raise error if old task state is '
                              f'not TO_APPROVE'):
                mock_old_task = Task(state='SOME_UNKNOWN_STATE')
                new_task_dict = dict(state=state_under_test)
                try:
                    validate_state_change(mock_old_task, new_task_dict)
                except ValidationError:
                    self.fail('validate_state_change should not have been failed')

        for state_under_test in Task.State.values:
            if (state_under_test != Task.State.APPROVED and
                    state_under_test != Task.State.UNDER_CONDITIONS and
                    state_under_test != Task.State.DECLINED):
                continue

            with self.subTest(f'should not raise error if old task state is '
                              f'TO_APPROVE and new state is '
                              f'{state_under_test}'):
                mock_old_task = Task(state=Task.State.TO_APPROVE)
                new_task_dict = dict(state=state_under_test)
                try:
                    validate_state_change(mock_old_task, new_task_dict)
                except ValidationError:
                    self.fail('validate_state_change should not have been failed')
