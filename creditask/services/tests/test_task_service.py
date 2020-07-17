import datetime
import random
from unittest import mock
from unittest.mock import MagicMock

from django.core.exceptions import ValidationError
from django.test import TransactionTestCase

from creditask.models import Task, User, TaskGroup, Approval, TaskState, \
    ApprovalState
from creditask.models.enums.changeable_task_property import \
    ChangeableTaskProperty
from creditask.models.task_change import TaskChange
from creditask.services.task_service import get_task_by_id, \
    get_todo_tasks_by_user_email, save_task, get_task_by_task_group_id, \
    validate_state_change, validate_task_properties, merge_values, get_task_changes, \
    copy_approvals


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
            created_by=user,

        )
        task_1 = Task.objects.create(
            task_group=task_group_1,
            needed_time_seconds=0,
            name='name',
            created_by=user
        )
        task_2 = Task.objects.create(
            task_group=task_group_2,
            needed_time_seconds=0,
            name='name',
            created_by=user
        )
        task_3 = Task.objects.create(
            task_group=task_group_1,
            needed_time_seconds=0,
            name='name',
            created_by=user
        )
        task_4 = Task.objects.create(
            task_group=task_group_1,
            needed_time_seconds=0,
            name='name',
            created_by=user
        )
        task_5 = Task.objects.create(
            task_group=task_group_2,
            needed_time_seconds=0,
            name='name',
            created_by=user
        )
        task_6 = Task.objects.create(
            task_group=task_group_1,
            needed_time_seconds=0,
            name='name',
            created_by=user
        )
        task_7 = Task.objects.create(
            task_group=task_group_2,
            needed_time_seconds=0,
            name='name',
            created_by=user
        )

        task = get_task_by_task_group_id(task_group_1.id)

        self.assertEquals(task_6.id, task.id)

    def test_get_todo_tasks_by_user_email(self):
        task_group_1 = TaskGroup.objects.create()
        task_group_2 = TaskGroup.objects.create()
        task_group_3 = TaskGroup.objects.create()
        task_group_4 = TaskGroup.objects.create()
        task_group_5 = TaskGroup.objects.create()
        task_group_6 = TaskGroup.objects.create()

        user_1 = User.objects.create(
            email='test_get_task_by_task_group_id@user_1.com',
            password='password'
        )
        user_2 = User.objects.create(
            email='test_get_task_by_task_group_id@user_2.com',
            password='password'
        )

        """
        task group 1: newest task has wrong state, therefore should not be
        returned
        """
        # all good
        task_1 = Task.objects.create(
            task_group=task_group_1,
            needed_time_seconds=0,
            name='name',
            user=user_1,
            created_by=user_1,
            state=TaskState.TO_DO
        )

        # all good
        task_2 = Task.objects.create(
            task_group=task_group_1,
            needed_time_seconds=0,
            name='name',

            user=user_1,
            created_by=user_1,
            state=TaskState.TO_DO
        )

        # wrong state
        task_3 = Task.objects.create(
            task_group=task_group_1,
            needed_time_seconds=0,
            name='name',

            user=user_1,
            created_by=user_1,
            state=TaskState.APPROVED
        )

        """
        task group 2: newest task has all good, therefore should be
        returned
        """
        # all good
        task_4 = Task.objects.create(
            task_group=task_group_2,
            needed_time_seconds=0,
            name='name',

            user=user_2,
            created_by=user_1,
            state=TaskState.TO_DO
        )

        # all good
        task_5 = Task.objects.create(
            task_group=task_group_2,
            needed_time_seconds=0,
            name='name',

            user=user_1,
            created_by=user_1,
            state=TaskState.APPROVED
        )

        # wrong state
        task_6 = Task.objects.create(
            task_group=task_group_2,
            needed_time_seconds=0,
            name='name',

            user=user_1,
            created_by=user_1,
            state=TaskState.TO_DO
        )

        """
        task group 3: newest task has wrong user, therefore should not be
        returned
        """
        # all good
        task_7 = Task.objects.create(
            task_group=task_group_3,
            needed_time_seconds=0,
            name='name',

            user=user_2,
            created_by=user_1,
            state=TaskState.TO_DO
        )

        # all good
        task_8 = Task.objects.create(
            task_group=task_group_3,
            needed_time_seconds=0,
            name='name',

            user=user_1,
            created_by=user_1,
            state=TaskState.TO_DO
        )

        # wrong state
        task_9 = Task.objects.create(
            task_group=task_group_3,
            needed_time_seconds=0,
            name='name',

            user=user_2,
            created_by=user_1,
            state=TaskState.TO_DO
        )

        """
        task group 4: all are good, therefore newest should be
        returned
        """
        # all good
        task_10 = Task.objects.create(
            task_group=task_group_4,
            needed_time_seconds=0,
            name='name',

            user=user_1,
            created_by=user_1,
            state=TaskState.TO_DO
        )

        # all good
        task_11 = Task.objects.create(
            task_group=task_group_4,
            needed_time_seconds=0,
            name='name',

            user=user_1,
            created_by=user_1,
            state=TaskState.TO_DO
        )

        # wrong state
        task_12 = Task.objects.create(
            task_group=task_group_4,
            needed_time_seconds=0,
            name='name',

            user=user_1,
            created_by=user_1,
            state=TaskState.TO_DO
        )

        tasks = get_todo_tasks_by_user_email(user_1.email)

        self.assertEquals(2, len(tasks))
        self.assertEquals(task_6.id, tasks[0].id)
        self.assertEquals(task_12.id, tasks[1].id)

    @mock.patch('creditask.services.task_service.copy_approvals')
    @mock.patch('creditask.services.task_service.validate_task_properties')
    @mock.patch('creditask.services.task_service.get_task_by_task_group_id')
    @mock.patch('creditask.services.task_service.validate_new_properties_based_'
                'on_task_state')
    @mock.patch('creditask.services.task_service.Task.save')
    def test_save_task(self, mock_save,
                       mock_get_task_by_task_group_id,
                       mock_validate_new_properties_based_on_task_state,
                       mock_validate_task_properties,
                       copy_approvals):
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

    def test_copy_approvals(self):
        with self.subTest('should copy all approvals to new task'):
            task_group = TaskGroup.objects.create()
            user_1 = User.objects.create(
                email='test_copy_approvals@user_1.com', password='password'
            )
            user_2 = User.objects.create(
                email='test_copy_approvals@user_2.com', password='password'
            )
            user_3 = User.objects.create(
                email='test_copy_approvals@user_3.com', password='password'
            )
            old_task = Task.objects.create(task_group=task_group,
                                           needed_time_seconds=0,
                                           name='name',
                                           created_by=user_1)
            approval_1 = Approval.objects.create(state=ApprovalState.NONE,
                                                 user=user_1,
                                                 task=old_task,
                                                 created_by=user_1)
            approval_2 = Approval.objects.create(state=ApprovalState.APPROVED,
                                                 user=user_2,
                                                 task=old_task,
                                                 created_by=user_2)
            approval_3 = Approval.objects.create(state=ApprovalState.DECLINED,
                                                 user=user_3,
                                                 task=old_task,
                                                 created_by=user_3)

            new_task = Task.objects.create(task_group=task_group,
                                           needed_time_seconds=0,
                                           name='name',
                                           created_by=user_1)

            copy_approvals(old_task, new_task)

            old_approvals = list((approval_1, approval_2, approval_3))
            copied_approvals = list(Approval.objects.filter(task=new_task))

            self.assertEquals(3, len(copied_approvals))

            for index, old_approval in enumerate(old_approvals):
                self.assertEqual(old_approval.state,
                                 copied_approvals[index].state)
                self.assertEqual(old_approval.user,
                                 copied_approvals[index].user)
                self.assertEqual(old_approval.created_by,
                                 copied_approvals[index].created_by)
                self.assertEqual(new_task,
                                 copied_approvals[index].task)

    def test_get_changes(self):
        task_group_1 = TaskGroup.objects.create()
        task_group_2 = TaskGroup.objects.create()
        user_1 = User.objects.create(
            email='test_get_changes@user_1.com',
            password='password'
        )
        user_2 = User.objects.create(
            email='test_get_changes@user_2.com',
            password='password'
        )
        user_3 = User.objects.create(
            email='test_get_changes@user_3.com',
            password='password'
        )

        now = datetime.date(2020, 1, 1)

        Task.objects.create(
            task_group=task_group_2,
            needed_time_seconds=200,
            name='abc',

            created_by=user_1,
            factor=2.2,
            period_start=now,
            period_end=now,
            state=TaskState.APPROVED,
            user=user_3
        )

        # created
        task_0 = Task.objects.create(
            task_group=task_group_1,
            needed_time_seconds=0,
            name='name',

            created_by=user_1,
            factor=1.1,
            period_start=now,
            period_end=now,
            state=TaskState.TO_DO,
            user=user_1
        )

        Task.objects.create(
            task_group=task_group_2,
            needed_time_seconds=200,
            name='abc',

            created_by=user_1,
            factor=2.2,
            period_start=now,
            period_end=now,
            state=TaskState.APPROVED,
            user=user_3
        )

        # factor
        task_1 = Task.objects.create(
            task_group=task_group_1,
            needed_time_seconds=0,
            name='name',

            created_by=user_2,
            factor=1.2,
            period_start=now,
            period_end=now,
            state=TaskState.TO_DO,
            user=user_1
        )

        Task.objects.create(
            task_group=task_group_2,
            needed_time_seconds=200,
            name='abc',

            created_by=user_1,
            factor=2.2,
            period_start=now,
            period_end=now,
            state=TaskState.APPROVED,
            user=user_3
        )

        # name + approval
        task_2 = Task.objects.create(
            task_group=task_group_1,
            needed_time_seconds=0,
            name='new name',

            created_by=user_3,
            factor=1.2,
            period_start=now,
            period_end=now,
            state=TaskState.TO_DO,
            user=user_1
        )
        approval_0 = Approval.objects.create(state=ApprovalState.APPROVED,
                                             task=task_2, user=user_1,
                                             created_by=user_1)

        Task.objects.create(
            task_group=task_group_2,
            needed_time_seconds=200,
            name='abc',

            created_by=user_1,
            factor=2.2,
            period_start=now,
            period_end=now,
            state=TaskState.APPROVED,
            user=user_3
        )

        # period_end
        task_3 = Task.objects.create(
            task_group=task_group_1,
            needed_time_seconds=0,
            name='new name',

            created_by=user_1,
            factor=1.2,
            period_start=now,
            period_end=now + datetime.timedelta(days=1),
            state=TaskState.TO_DO,
            user=user_1
        )
        approval_1 = Approval.objects.create(state=ApprovalState.APPROVED,
                                             task=task_3, user=user_1,
                                             created_by=user_1)

        Task.objects.create(
            task_group=task_group_2,
            needed_time_seconds=200,
            name='abc',

            created_by=user_1,
            factor=2.2,
            period_start=now,
            period_end=now,
            state=TaskState.APPROVED,
            user=user_3
        )

        # state + needed_time_seconds
        task_4 = Task.objects.create(
            task_group=task_group_1,
            needed_time_seconds=120,
            name='new name',

            created_by=user_2,
            factor=1.2,
            period_start=now,
            period_end=now + datetime.timedelta(days=1),
            state=TaskState.TO_APPROVE,
            user=user_1
        )
        approval_1 = Approval.objects.create(state=ApprovalState.APPROVED,
                                             task=task_4, user=user_1,
                                             created_by=user_1)

        Task.objects.create(
            task_group=task_group_2,
            needed_time_seconds=200,
            name='abc',

            created_by=user_1,
            factor=2.2,
            period_start=now,
            period_end=now,
            state=TaskState.APPROVED,
            user=user_3
        )

        # user
        task_5 = Task.objects.create(
            task_group=task_group_1,
            needed_time_seconds=120,
            name='new name',

            created_by=user_3,
            factor=1.2,
            period_start=now,
            period_end=now + datetime.timedelta(days=1),
            state=TaskState.TO_APPROVE,
            user=user_2
        )
        approval_1 = Approval.objects.create(state=ApprovalState.APPROVED,
                                             task=task_5, user=user_1,
                                             created_by=user_1)

        # approval
        task_6 = Task.objects.create(
            task_group=task_group_1,
            needed_time_seconds=120,
            name='new name',

            created_by=user_3,
            factor=1.2,
            period_start=now,
            period_end=now + datetime.timedelta(days=1),
            state=TaskState.TO_APPROVE,
            user=user_2
        )

        # no change!
        approval_1 = Approval.objects.create(state=ApprovalState.APPROVED,
                                             task=task_6, user=user_1,
                                             created_by=user_1)

        # no change!
        approval_2 = Approval.objects.create(state=ApprovalState.NONE,
                                             task=task_6, user=user_2,
                                             created_by=user_2)

        # change!
        approval_3 = Approval.objects.create(state=ApprovalState.APPROVED,
                                             task=task_6, user=user_3,
                                             created_by=user_3)

        # change!
        approval_4 = Approval.objects.create(state=ApprovalState.DECLINED,
                                             task=task_6, user=user_1,
                                             created_by=user_1)

        # change!
        approval_5 = Approval.objects.create(state=ApprovalState.DECLINED,
                                             task=task_6, user=user_2,
                                             created_by=user_2)

        Task.objects.create(
            task_group=task_group_2,
            needed_time_seconds=200,
            name='abc',

            created_by=user_1,
            factor=2.2,
            period_start=now,
            period_end=now,
            state=TaskState.APPROVED,
            user=user_3
        )

        task_changes = get_task_changes(task_5)
        self.assertEquals(11, len(task_changes))

        expected_result = list((
            TaskChange(
                current_value=None,
                previous_value=None,
                user=task_0.created_by,
                timestamp=task_0.created_at,
                changed_property=None
            ),
            TaskChange(
                current_value=str(task_1.factor),
                previous_value=str(task_0.factor),
                user=task_1.created_by,
                timestamp=task_1.created_at,
                changed_property=ChangeableTaskProperty.Factor
            ),
            TaskChange(
                current_value=str(task_2.name),
                previous_value=str(task_1.name),
                user=task_2.created_by,
                timestamp=task_2.created_at,
                changed_property=ChangeableTaskProperty.Name
            ),
            TaskChange(
                current_value=approval_0.state.value,
                previous_value=ApprovalState.NONE.value,
                user=approval_0.created_by,
                timestamp=approval_0.created_at,
                changed_property=ChangeableTaskProperty.Approval
            ),
            TaskChange(
                current_value=str(task_3.period_end),
                previous_value=str(task_2.period_end),
                user=task_3.created_by,
                timestamp=task_3.created_at,
                changed_property=ChangeableTaskProperty.PeriodEnd
            ),
            TaskChange(
                current_value=str(task_4.needed_time_seconds),
                previous_value=str(task_3.needed_time_seconds),
                user=task_4.created_by,
                timestamp=task_4.created_at,
                changed_property=ChangeableTaskProperty.NeededTimeSeconds
            ),
            TaskChange(
                current_value=str(task_4.state),
                previous_value=str(task_3.state),
                user=task_4.created_by,
                timestamp=task_4.created_at,
                changed_property=ChangeableTaskProperty.State
            ),
            TaskChange(
                current_value=str(task_5.user.id),
                previous_value=str(task_4.user.id),
                user=task_5.created_by,
                timestamp=task_5.created_at,
                changed_property=ChangeableTaskProperty.UserId
            ),
            TaskChange(
                current_value=approval_3.state.value,
                previous_value=ApprovalState.NONE.value,
                user=approval_3.created_by,
                timestamp=approval_3.created_at,
                changed_property=ChangeableTaskProperty.Approval
            ),
            TaskChange(
                current_value=approval_4.state.value,
                previous_value=approval_1.state.value,
                user=approval_4.created_by,
                timestamp=approval_4.created_at,
                changed_property=ChangeableTaskProperty.Approval
            ),
            TaskChange(
                current_value=approval_5.state.value,
                previous_value=approval_2.state.value,
                user=approval_5.created_by,
                timestamp=approval_5.created_at,
                changed_property=ChangeableTaskProperty.Approval
            ),

        ))
        expected_result.reverse()

        self.assertListEqual(expected_result, task_changes)


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
