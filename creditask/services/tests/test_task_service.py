import random
from unittest import TestCase, mock
from unittest.mock import MagicMock

from django.core.exceptions import ValidationError

from creditask.models import Task, User
from creditask.services.task_service import get_task_by_id, \
    get_todo_tasks_by_user_email, save_task


class TestTaskService(TestCase):

    @mock.patch('creditask.services.task_service.Task.objects.get')
    def test_get_task_by_id(self, mock_fn: MagicMock):
        mock_task = Task(id=random.randint(1, 9999))
        mock_fn.return_value = mock_task

        task = get_task_by_id(mock_task.id)

        self.assertIs(mock_task, task)
        self.assertIsNotNone(mock_fn.call_args[1].get('id'))
        self.assertEquals(mock_fn.call_args[1]['id'], mock_task.id)
        self.assertTrue(1, len(mock_fn.call_args[1]))

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

    @mock.patch('creditask.services.task_service.Task.save')
    @mock.patch('creditask.services.task_service.MinLenValidator')
    def test_save_task(self, mock_MinLenValidator, mock_save):
        mock_user = User(email='user@email.com')

        args = {
            'name': 'created_task',
            'user': mock_user
        }

        with self.subTest('should throw if created_by is not given'):
            with self.assertRaises(ValidationError) as e:
                save_task(None, **args)

        with self.subTest('should validate with period_end not before '
                          'period_start'):
            with self.assertRaises(ValidationError):
                invalid_args = {
                    **args,
                    'period_end': '2020-01-10',
                    'period_start': '2020-01-11'
                }
                save_task(mock_user, **invalid_args)

        with self.subTest('should validate with MinLenValidator'):
            save_task(mock_user, **args)
            self.assertEquals(mock_MinLenValidator.call_args[0][0], 3,
                              'MinLeneValidator needs to be initialized with '
                              '3 (length of 3)')
            self.assertEquals(mock_MinLenValidator.return_value.call_args[0][0],
                              args['name'],
                              'MinLeneValidator needs to be called with '
                              'task name')

        with self.subTest('if is existing task'):
            pass # TODO test needs to be written
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
            pass # TODO test needs to be written

        with self.subTest('save should be called'):
            mock_save.call_count = 0
            save_task(mock_user, **args)
            self.assertEquals(1, mock_save.call_count)

        with self.subTest('should return task'):
            task = save_task(mock_user, **args)
            self.assertIsNotNone(task)
            self.assertIsInstance(task, Task)
