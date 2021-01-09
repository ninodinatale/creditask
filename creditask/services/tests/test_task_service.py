from unittest import mock
from unittest.mock import Mock

from django.core.exceptions import ValidationError
from django.test import TestCase

from creditask.models import ApprovalState, User, TaskState, \
    ChangeableTaskProperty, CreditsCalc
from creditask.services.task_service import get_task_by_id, \
    get_todo_tasks_by_user_email, save_task, \
    validate_state_change, validate_task_properties, merge_values, \
    get_to_approve_tasks_of_user, get_done_tasks, \
    get_unassigned_tasks, validate_new_properties_based_on_task_state, \
    get_task_changes_by_task_id, get_task_changes_by_task, \
    get_task_approvals_by_task, get_all_todo_tasks
from creditask.tests.test_utils import create_user, create_task, create_group, \
    create_approval


class TestTaskService(TestCase):

    @mock.patch('creditask.services.task_service.Task')
    def test_get_task_by_id(self, mock_task):
        task_id = 123456789
        mock_return_value = []
        mock_task.objects.get.return_value = mock_return_value
        return_value = get_task_by_id(task_id)

        self.assertEquals(1, mock_task.objects.get.call_count)
        self.assertDictEqual(dict(id=task_id),
                          mock_task.objects.get.call_args[1])
        self.assertEquals(mock_return_value, return_value)

    @mock.patch('creditask.services.task_service.Task')
    def test_get_todo_tasks_by_user_email(self, mock_task):
        user_email = 'some_user_email'
        mock_return_value = ['some', 'return', 'value']
        mock_task.objects.filter().exclude().order_by.return_value = mock_return_value

        expected_call_count = mock_task.objects.filter.call_count + 1
        return_value = get_todo_tasks_by_user_email(user_email)

        self.assertEquals(expected_call_count,
                          mock_task.objects.filter.call_count)
        self.assertEquals(dict(user__email=user_email),
                          mock_task.objects.filter.call_args[1])
        self.assertEquals(dict(state=TaskState.DONE),
                          mock_task.objects.filter.return_value.exclude.call_args[1])
        self.assertEquals(1,
                          mock_task.objects.filter.return_value.exclude.return_value.order_by.call_count)
        self.assertEquals(('period_end',),
                          mock_task.objects.filter.return_value.exclude.return_value.order_by.call_args[0])
        self.assertEquals(mock_return_value, return_value)

    def test_get_to_approve_tasks_of_user(self):
        # TODO the implementation is done with a raw query. Replace with mocks
        #  once the raw query has been replaced with django's querying API
        group = create_group()
        user_1 = create_user(group=group)
        user_2 = create_user(group=group)
        user_3 = create_user(group=group)

        # wrong task state
        task_3 = create_task(
            group=group,
            user=user_2,
            state=TaskState.TO_DO
        )
        create_approval(
            state=ApprovalState.NONE,
            task=task_3,
            user=user_1
        )
        create_approval(
            state=ApprovalState.NONE,
            task=task_3,
            user=user_2
        )
        create_approval(
            state=ApprovalState.DECLINED,
            task=task_3,
            user=user_3
        )

        # all good
        task_6 = create_task(
            group=group,
            user=user_2,
            state=TaskState.TO_APPROVE
        )
        create_approval(
            state=ApprovalState.NONE,
            task=task_6,
            user=user_1
        )
        create_approval(
            state=ApprovalState.NONE,
            task=task_6,
            user=user_2
        )
        create_approval(
            state=ApprovalState.APPROVED,
            task=task_6,
            user=user_3
        )

        # wrong user in task
        task_9 = create_task(
            group=group,
            user=user_1,
            state=TaskState.TO_APPROVE
        )
        create_approval(
            state=ApprovalState.NONE,
            task=task_9,
            user=user_1
        )
        create_approval(
            state=ApprovalState.NONE,
            task=task_9,
            user=user_2
        )
        create_approval(
            state=ApprovalState.NONE,
            task=task_9,
            user=user_3
        )

        # all good
        task_12 = create_task(
            group=group,
            user=user_2,
            state=TaskState.TO_APPROVE
        )
        create_approval(
            state=ApprovalState.NONE,
            task=task_12,
            user=user_1
        )
        create_approval(
            state=ApprovalState.APPROVED,
            task=task_12,
            user=user_2
        )
        create_approval(
            state=ApprovalState.NONE,
            task=task_12,
            user=user_3
        )

        # already approved
        task_13 = create_task(
            group=group,
            user=user_2,
            state=TaskState.TO_APPROVE
        )
        create_approval(
            state=ApprovalState.APPROVED,
            task=task_12,
            user=user_1
        )
        create_approval(
            state=ApprovalState.NONE,
            task=task_12,
            user=user_2
        )
        create_approval(
            state=ApprovalState.NONE,
            task=task_12,
            user=user_3
        )

        tasks = get_to_approve_tasks_of_user(user_1.email)

        self.assertEquals(2, len(tasks))
        self.assertIn(task_6, tasks)
        self.assertIn(task_12, tasks)

    @mock.patch('creditask.services.task_service.Task')
    def test_get_unassigned_tasks(self, mock_task):
        group_id = 123456789
        mock_return_value = ['some', 'return', 'value']
        mock_task.objects.filter().order_by.return_value = mock_return_value

        expected_call_count = mock_task.objects.filter.call_count + 1
        return_value = get_unassigned_tasks(group_id)

        self.assertEquals(expected_call_count,
                          mock_task.objects.filter.call_count)
        self.assertEquals(dict(group_id=group_id, user=None),
                          mock_task.objects.filter.call_args[1])
        self.assertEquals(1,
                          mock_task.objects.filter.return_value.order_by.call_count)
        self.assertEquals(('period_end',),
                          mock_task.objects.filter.return_value.order_by.call_args[0])
        self.assertEquals(mock_return_value, return_value)

    @mock.patch('creditask.services.task_service.Task')
    def test_get_all_todo_tasks(self, mock_task):
        group_id = 123456789
        mock_return_value = ['some', 'return', 'value']
        mock_task.objects.filter().order_by.return_value = mock_return_value

        expected_call_count = mock_task.objects.filter.call_count + 1
        return_value = get_all_todo_tasks(group_id)

        self.assertEquals(expected_call_count,
                          mock_task.objects.filter.call_count)
        self.assertDictEqual(dict(group_id=group_id, state=TaskState.TO_DO),
                          mock_task.objects.filter.call_args[1])
        self.assertEquals(1,
                          mock_task.objects.filter.return_value.order_by.call_count)
        self.assertEquals(('period_end',),
                          mock_task.objects.filter.return_value.order_by.call_args[0])
        self.assertEquals(mock_return_value, return_value)

    @mock.patch('creditask.services.task_service.Task')
    def test_done_tasks(self, mock_task):
        group_id = 123456789
        mock_return_value = ['some', 'return', 'value']
        mock_task.objects.filter().order_by.return_value = mock_return_value

        expected_call_count = mock_task.objects.filter.call_count + 1
        return_value = get_done_tasks(group_id)

        self.assertEquals(expected_call_count,
                          mock_task.objects.filter.call_count)
        self.assertDictEqual(dict(group_id=group_id, state=TaskState.DONE),
                          mock_task.objects.filter.call_args[1])
        self.assertEquals(1,
                          mock_task.objects.filter.return_value.order_by.call_count)
        self.assertEquals(('period_end',),
                          mock_task.objects.filter.return_value.order_by.call_args[0])
        self.assertEquals(mock_return_value, return_value)

    @mock.patch('creditask.services.task_service.merge_values')
    @mock.patch(
        'creditask.services.task_service.validate_new_properties_based_on_task_state')
    @mock.patch('creditask.services.task_service.validate_state_change')
    @mock.patch('creditask.services.task_service.validate_task_properties')
    @mock.patch('creditask.services.task_service.Approval')
    @mock.patch('creditask.services.task_service.User')
    @mock.patch('creditask.services.task_service.Task')
    @mock.patch('creditask.services.task_service.TaskChange')
    def test_save_task(self, mock_task_change_model, mock_task_model,
                       mock_user_model,
                       mock_approval_model,
                       mock_validate_task_properties,
                       mock_validate_state_change,
                       mock_validate_new_properties_based_on_task_state,
                       mock_merge_values):

        mock_current_users_group = Mock()
        mock_current_user = Mock()
        mock_current_user.group = mock_current_users_group

        with self.assertRaises(ValidationError,
                               msg='should raise validation error if '
                                   'current_user is None'):
            save_task(None)

        with self.subTest('should update task if has been passed'):
            task_id = 123456789
            with self.assertRaises(ValidationError,
                                   msg='should raise error if '
                                       'group has been passed'):
                save_task(mock_current_user, id=task_id, group=Mock())
            with self.assertRaises(ValidationError,
                                   msg='should raise error if '
                                       'group_id has been passed'):
                save_task(mock_current_user, id=task_id, group_id=Mock())
            with self.assertRaises(ValidationError,
                                   msg='should raise error if '
                                       'created_by has been passed'):
                save_task(mock_current_user, id=task_id, created_by=Mock())
            with self.assertRaises(ValidationError,
                                   msg='should raise error if '
                                       'created_by_id has been '
                                       'passed'):
                save_task(mock_current_user, id=task_id, created_by_id=Mock())

            task_id = 123456789
            calling_kwargs = dict(id=task_id)
            mock_return_value = Mock()
            mock_task_model.objects.get.return_value = mock_return_value

            return_value = save_task(mock_current_user, **calling_kwargs)

            self.assertEquals(1, mock_task_model.objects.get.call_count)
            self.assertEquals(calling_kwargs,
                              mock_task_model.objects.get.call_args[1])

            self.assertEquals((mock_return_value,),
                              mock_validate_state_change.call_args[0],
                              'first argument of validate_state_change '
                              'needs to be to task to update')
            self.assertEquals(calling_kwargs,
                              mock_validate_state_change.call_args[1],
                              'second argument of validate_state_change '
                              'needs to be to kwargs')
            self.assertEquals((mock_return_value,),
                              mock_validate_new_properties_based_on_task_state.call_args[0],
                              'first argument of '
                              'mock_validate_new_properties_based_on_task_state'
                              ' needs to be to task to update')
            self.assertEquals(calling_kwargs,
                              mock_validate_new_properties_based_on_task_state.call_args[1],
                              'second argument of '
                              'mock_validate_new_properties_based_on_task_state'
                              ' needs to be to kwargs')
            self.assertEquals((mock_return_value, mock_current_user),
                              mock_merge_values.call_args[0],
                              'first argument of merge_values '
                              'needs to be to task to update')
            self.assertEquals(calling_kwargs,
                              mock_merge_values.call_args[1],
                              'third argument of merge_values '
                              'needs to be to kwargs')
            self.assertEquals(mock_return_value, return_value,
                              'should return updated task')

        with self.subTest('should create task if no id has been passed'):
            mock_user_1 = Mock()
            mock_user_2 = Mock()
            mock_group = Mock()
            mock_group_2 = Mock()

            mock_task_model_return_value = Mock()
            mock_task_model.return_value = mock_task_model_return_value

            with self.assertRaises(ValidationError,
                                   msg='should raise Validation error if different '
                                       'created_by.id and created_by_id provided'):
                mock_user_1.id.return_value = 1
                mock_user_2.return_value = User(id=2)
                save_task(mock_user_1, created_by=mock_user_2,
                          created_by_id=mock_user_1.id)

            with self.assertRaises(ValidationError,
                                   msg='should raise Validation error if different '
                                       'group.id and group_id provided'):
                mock_group.id.return_value = 1
                mock_group_2.id.return_value = 2
                save_task(mock_user_1, group=mock_group,
                          group_id=mock_group_2.id)

            with self.subTest('should set created_by and group if provided'):
                return_value = save_task(mock_current_user,
                                         created_by=mock_user_2,
                                         group=mock_group)
                self.assertEquals(mock_user_2, return_value.created_by)
                self.assertEquals(mock_group, return_value.group)

            with self.subTest(
                    'should set created_by and group to the current user\'s if not provided'):
                return_value = save_task(mock_current_user)

                self.assertEquals(mock_current_user, return_value.created_by)
                self.assertEquals(mock_current_user.group, return_value.group)

            with self.assertRaises(ValidationError,
                                   msg='should raise Validation error if different '
                                       'group.id and group_id provided'):
                mock_group.id.return_value = 1
                mock_group_2.id.return_value = 2
                save_task(mock_current_user, group=mock_group,
                          group_id=mock_group_2.id)

            with self.subTest('Should save the task'):
                expected_call_count = mock_task_model.return_value.save.call_count + 1
                save_task(mock_current_user)
                self.assertEquals(expected_call_count,
                                  mock_task_model.return_value.save.call_count)

            with self.subTest('Should create task change entry for type '
                              '"created"'):
                expected_call_count = mock_task_change_model.objects.create.call_count + 1
                with mock.patch(
                        'creditask.services.task_service.datetime') as  datetime_mock:
                    datetime_mock.utcnow().replace.return_value = 'some timestamp'
                    save_task(mock_current_user)
                    self.assertEquals(expected_call_count,
                                      mock_task_change_model.objects.create.call_count)
                    self.assertDictEqual(dict(
                        task_id=mock_task_model.return_value.id,
                        user=mock_current_user,
                        previous_value=None,
                        current_value=mock_current_user.id,
                        changed_property=ChangeableTaskProperty.CreatedById,
                        timestamp=datetime_mock.utcnow.return_value.replace.return_value
                    ),
                        mock_task_change_model.objects.create.call_args[1])

            with self.subTest('should create approvals for users in group'):
                mock_users = [Mock(), Mock(), Mock()]
                mock_user_model.objects.filter.return_value = mock_users

                save_task(mock_current_user)

                self.assertEquals(
                    dict(group_id=mock_task_model.return_value.group_id, ),
                    mock_user_model.objects.filter.call_args[1])

                self.assertEquals(3,
                                  mock_approval_model.objects.create.call_count)
                for i in range(3):
                    self.assertEquals(dict(state=ApprovalState.NONE,
                                           task=mock_task_model.return_value,
                                           user=mock_users[i]),
                                      mock_approval_model.objects.create.call_args_list[
                                          i][1])

    @mock.patch('creditask.services.task_service.validate_task_properties')
    def test_validate_new_properties_based_on_task_state(self,
                                                         mock_validate_task_properties):
        group_mock = Mock()
        user_id_mock = 123456789
        with self.subTest('should call validate_task_properties if current '
                          'task state is TO_DO'):
            task_1_mock = Mock(group=group_mock, state=TaskState.TO_DO)
            task_1_mock.to_dict.return_value = dict()
            mock_validate_task_properties.call_count = 0
            validate_new_properties_based_on_task_state(task_1_mock)
            self.assertEquals(1, mock_validate_task_properties.call_count)

        with self.subTest('if current task state is not TO_DO'):
            task_1_mock = Mock(group=group_mock, state=TaskState.TO_APPROVE)

            with self.subTest('task state should be changeable'):
                validate_new_properties_based_on_task_state(task_1_mock,
                                                            state=TaskState.TO_DO)
            with self.subTest('same values should be ignored'):
                properties = dict(needed_time_seconds=20,
                                  user_id=user_id_mock,
                                  factor=2.1)
                task_2_mock = Mock(group=group_mock, **properties)
                validate_new_properties_based_on_task_state(task_2_mock,
                                                            **properties)

    @mock.patch('creditask.services.task_service.MinLenValidator')
    def test_validate_task_properties(self, mock_min_len_validator):
        mock_user = Mock(email='user@email.com')

        with self.subTest('should validate with period_end not before '
                          'period_start'):
            with self.assertRaises(ValidationError):
                validate_task_properties(period_end='2020-01-10',
                                         period_start='2020-01-11')

        with self.subTest('should validate with MinLenValidator'):
            validate_task_properties(name='created_task')
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
                validate_task_properties(name='created_task',
                                         state='SOME_UNKNOWN_TASK')
                self.assertEquals('"SOME_UNKNOWN_TASK" is an invalid '
                                  'type of task state', e)

        with self.subTest('should not raise error if valid task state is '
                          'provided'):

            for state_under_test in TaskState:
                try:
                    validate_task_properties(name='created_task',
                                             state=state_under_test)
                except ValidationError:
                    self.fail('validate_task_properties should not have raised'
                              ' a validation error')

    @mock.patch('creditask.services.task_service.Task')
    @mock.patch('creditask.services.task_service.TaskChange')
    @mock.patch('creditask.services.task_service.datetime')
    @mock.patch('creditask.services.user_service.save_user')
    def test_merge_values(self, save_user_mock, datetime_mock,
                          task_change_model_mock,
                          mock_task_model):
        with self.subTest('should add attributes if not existing yet and return'
                          'task'):
            task_to_merge_into_mock = Mock()
            current_user_mock = Mock()
            user_1_mock = Mock(id=123456789)
            user_2_mock = Mock()

            values_to_merge = dict(needed_time_seconds=2,
                                   state=TaskState.TO_APPROVE,
                                   id=200000,
                                   user=user_1_mock,
                                   created_by=user_2_mock)

            expected_call_count = save_user_mock.call_count

            return_value = merge_values(task_to_merge_into_mock,
                                        current_user_mock,
                                        **values_to_merge
                                        )

            self.assertEquals(task_to_merge_into_mock, return_value,
                              'should return task to merge into')
            self.assertNotEquals(values_to_merge.get('id'),
                                 task_to_merge_into_mock.id,
                                 'id should not be merged')
            self.assertEquals(values_to_merge.get('state'),
                              task_to_merge_into_mock.state)
            self.assertEquals(values_to_merge.get('needed_time_seconds'),
                              task_to_merge_into_mock.needed_time_seconds)
            self.assertEquals(values_to_merge.get('user').id,
                              task_to_merge_into_mock.user_id)
            self.assertEquals(values_to_merge.get('created_by'),
                              task_to_merge_into_mock.created_by)
            self.assertEquals(expected_call_count, save_user_mock.call_count,
                              msg='save_user should not have been called')

        with self.subTest('should add task changes by merged values'):
            changing_attributes = dict(
                needed_time_seconds=0,
                state=TaskState.TO_DO,
                id=1,
                user=None,
                user_id=None,
                created_by=user_1_mock
            )
            task_to_merge_into_mock = Mock(**changing_attributes)
            current_user_mock = Mock()
            user_1_mock = Mock(id=123456789)
            user_2_mock = Mock()
            datetime_mock.utcnow().replace.return_value = 'some timestamp'
            values_to_merge = dict(needed_time_seconds=2,
                                   state=TaskState.TO_APPROVE,
                                   id=200000,
                                   user=user_1_mock,
                                   created_by=user_2_mock)

            task_change_model_mock.reset_mock()
            return_value = merge_values(task_to_merge_into_mock,
                                        current_user_mock,
                                        **values_to_merge
                                        )

            self.assertEquals(3,
                              task_change_model_mock.objects.create.call_count)
            self.assertDictEqual(
                dict(task_id=task_to_merge_into_mock.id,
                     user=current_user_mock,
                     previous_value=changing_attributes.get(
                         'needed_time_seconds'),
                     current_value=values_to_merge.get('needed_time_seconds'),
                     changed_property=ChangeableTaskProperty.NeededTimeSeconds,
                     timestamp=datetime_mock.utcnow.return_value.replace.return_value),
                task_change_model_mock.objects.create.call_args_list[0][1])
            self.assertDictEqual(
                dict(task_id=task_to_merge_into_mock.id,
                     user=current_user_mock,
                     previous_value=changing_attributes.get('state'),
                     current_value=values_to_merge.get('state'),
                     changed_property=ChangeableTaskProperty.State,
                     timestamp=datetime_mock.utcnow.return_value.replace.return_value),
                task_change_model_mock.objects.create.call_args_list[1][1])
            self.assertDictEqual(
                dict(task_id=task_to_merge_into_mock.id,
                     user=current_user_mock,
                     previous_value=None,
                     current_value=values_to_merge.get('user').id,
                     changed_property=ChangeableTaskProperty.UserId,
                     timestamp=datetime_mock.utcnow.return_value.replace.return_value),
                task_change_model_mock.objects.create.call_args_list[2][1])

        with self.subTest(
                'should save task and user and give credits to user if all approvals have state approved'):
            changing_attributes = dict(
                needed_time_seconds=0,
                state=TaskState.APPROVED,
                id=1,
                user=None,
                user_id=None,
                created_by=user_1_mock
            )
            task_to_merge_into_mock = Mock(**changing_attributes)
            current_user_mock = Mock()
            user_1_mock = Mock(id=123456789)
            user_2_mock = Mock()
            datetime_mock.utcnow().replace.return_value = 'some timestamp'
            values_to_merge = dict(needed_time_seconds=2,
                                   state=TaskState.DONE,
                                   id=200000,
                                   user=user_1_mock,
                                   created_by=user_2_mock)

            task_change_model_mock.reset_mock()

            task_to_merge_into_mock.state = TaskState.TO_APPROVE
            assigned_user_mock = Mock(credits=200)
            task_to_merge_into_mock.user = assigned_user_mock
            task_to_merge_into_mock.credits_calc = CreditsCalc.FIXED
            task_to_merge_into_mock.fixed_credits = 100
            expected_call_count_1 = save_user_mock.call_count + 1

            return_value = merge_values(task_to_merge_into_mock,
                                        current_user_mock,
                                        **values_to_merge
                                        )

            self.assertEquals(expected_call_count_1,
                              save_user_mock.call_count)
            self.assertTupleEqual((assigned_user_mock,),
                                  save_user_mock.call_args[0])
            self.assertDictEqual(dict(
                credits=300
            ), save_user_mock.call_args[1])

        with self.subTest(
                'should set user_id to None if passed non-number-string'):
            changing_attributes = dict(
                needed_time_seconds=0,
                state=TaskState.TO_DO,
                id=1,
                user=Mock(),
                user_id=123456789,
                created_by=user_1_mock
            )
            task_to_merge_into_mock = Mock(**changing_attributes)
            current_user_mock = Mock()
            user_1_mock = Mock(id=123456789)
            user_2_mock = Mock()
            datetime_mock.utcnow().replace.return_value = 'some timestamp'
            values_to_merge = dict(needed_time_seconds=2,
                                   state=TaskState.TO_APPROVE,
                                   id=200000,
                                   user_id='',
                                   created_by=user_2_mock)

            task_change_model_mock.reset_mock()
            return_value = merge_values(task_to_merge_into_mock,
                                        current_user_mock,
                                        **values_to_merge
                                        )

            self.assertEquals(None, task_to_merge_into_mock.user_id)

    def test_validate_state_change(self):
        with self.subTest('should not raise error if state has not changed'):
            mock_old_task = Mock()
            try:
                validate_state_change(mock_old_task, **{})
            except ValidationError:
                self.fail('validate_state_change should not have been failed')

        with self.subTest('should raise error if new state is None'):
            mock_old_task = Mock()
            new_task_dict = dict(state=None)
            with self.assertRaises(ValidationError) as e:
                validate_state_change(mock_old_task, **new_task_dict)
            self.assertEquals('Task state may not be None', e.exception.message)

        with self.subTest('should raise error if old task state is TO_DO and '
                          'new state is not TO_APPROVE'):
            mock_old_task = Mock(state=TaskState.TO_DO)
            new_task_dict = dict(state=TaskState.TO_DO)
            with self.assertRaises(ValidationError) as e:
                validate_state_change(mock_old_task, **new_task_dict)
            self.assertEquals(f'Task state after [{TaskState.TO_DO}] '
                              f'needs to be [{TaskState.TO_APPROVE}],'
                              f'but was [{TaskState.TO_DO}]',
                              e.exception.message)

        with self.subTest('should raise error if old task state is DECLINED'
                          ' and new state is not TO_DO'):
            mock_old_task = Mock(state=TaskState.DECLINED)
            for state in TaskState:
                new_task_dict = dict(state=state)
                if state in [TaskState.TO_DO]:
                    validate_state_change(mock_old_task, **new_task_dict)
                else:
                    with self.assertRaises(ValidationError) as e:
                        validate_state_change(mock_old_task, **new_task_dict)
                    self.assertEquals(f'Task state after [{TaskState.DECLINED}] '
                                      f'needs to be [{TaskState.TO_DO}], but was [{state}]',
                                      e.exception.message)

        with self.subTest('should raise error if old task state is DONE'):
            mock_old_task = Mock(state=TaskState.DONE)
            for state in TaskState:
                new_task_dict = dict(state=state)
                with self.assertRaises(ValidationError) as e:
                    validate_state_change(mock_old_task, **new_task_dict)
                self.assertEquals(f'Task state [{TaskState.DONE}] may not be '
                                  f'changed',
                                  e.exception.message)

        with self.subTest('should raise error if old task state is TO_APPROVE'
                          ' and new state is not DONE'):
            mock_old_task = Mock(state=TaskState.TO_APPROVE)
            new_task_dict = dict(state=TaskState.TO_DO)
            with self.assertRaises(ValidationError) as e:
                validate_state_change(mock_old_task, **new_task_dict)

        for state_under_test in TaskState:
            if not (state_under_test != TaskState.APPROVED and
                    state_under_test != TaskState.DECLINED):
                continue

            with self.subTest(f'should raise error if old task state is '
                              f'TO_APPROVE and new state is '
                              f'{state_under_test}'):
                mock_old_task = Mock(state=TaskState.TO_APPROVE)
                new_task_dict = dict(state=state_under_test)
                with self.assertRaises(ValidationError) as e:
                    validate_state_change(mock_old_task, **new_task_dict)

        for state_under_test in TaskState:
            if state_under_test == TaskState.TO_APPROVE:
                continue

            with self.subTest(f'should not raise error if old task state is '
                              f'not TO_APPROVE'):
                mock_old_task = Mock(state='SOME_UNKNOWN_STATE')
                new_task_dict = dict(state=state_under_test)
                try:
                    validate_state_change(mock_old_task, **new_task_dict)
                except ValidationError:
                    self.fail(
                        'validate_state_change should not have been failed')

        for state_under_test in TaskState:
            if (state_under_test != TaskState.APPROVED and
                    state_under_test != TaskState.DECLINED):
                continue

            with self.subTest(f'should not raise error if old task state is '
                              f'TO_APPROVE and new state is '
                              f'{state_under_test}'):
                mock_old_task = Mock(state=TaskState.TO_APPROVE)
                new_task_dict = dict(state=state_under_test)
                try:
                    validate_state_change(mock_old_task, **new_task_dict)
                except ValidationError:
                    self.fail(
                        'validate_state_change should not have been failed')

    @mock.patch('creditask.services.task_service.Task.objects.get')
    @mock.patch('creditask.services.task_service.get_task_changes_by_task')
    def test_get_task_changes_by_task_id(self, mock_get_task_changes_by_task,
                                         mock_task_get):
        task_id = 1
        with self.assertRaises(ValidationError):
            get_task_changes_by_task_id(None)

        mock_task = Mock()
        mock_task_get.return_value = mock_task
        get_task_changes_by_task_id(task_id)
        self.assertEquals(dict(id=task_id), mock_task_get.call_args[1])
        self.assertEquals((mock_task,),
                          mock_get_task_changes_by_task.call_args[0])

    def test_get_task_changes_by_task(self):
        mock_task = Mock()
        mock_return_value = ['some', 'return', 'value']
        mock_task.task_changes.all().order_by.return_value = mock_return_value

        with self.assertRaises(ValidationError):
            get_task_changes_by_task(None)

        expected_call_count = mock_task.task_changes.all.call_count + 1
        return_value = get_task_changes_by_task(mock_task)
        self.assertEquals(expected_call_count,
                          mock_task.task_changes.all.call_count)
        self.assertEquals(1,
                          mock_task.task_changes.all.return_value.order_by.call_count)
        self.assertTupleEqual(('timestamp',),
                          mock_task.task_changes.all.return_value.order_by.call_args[0])
        self.assertEquals(mock_return_value, return_value)

    def test_task_approvals_by_task(self):
        mock_task = Mock()
        mock_user = Mock()
        mock_return_value = ['some', 'return', 'value']
        mock_task.approvals.exclude.return_value = mock_return_value
        mock_task.user = mock_user

        with self.assertRaises(ValidationError):
            get_task_approvals_by_task(None)

        return_value = get_task_approvals_by_task(mock_task)
        self.assertEquals(1,
                          mock_task.approvals.exclude.call_count)
        self.assertEquals(dict(user=mock_user),
                          mock_task.approvals.exclude.call_args[1])
        self.assertEquals(mock_return_value, return_value)
