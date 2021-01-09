from unittest import mock, TestCase
from unittest.mock import Mock

from django.core.exceptions import ValidationError

from creditask.models import ApprovalState, TaskState
from creditask.services.approval_service import save_approval


class TestApprovalService(TestCase):

    @mock.patch('creditask.services.approval_service.save_task')
    @mock.patch('creditask.services.approval_service.Approval')
    def test_save_approval(self, approval_model_mock,
                           save_task_mock):
        current_user_mock = Mock()
        approval_id = 1234567898
        new_state = ApprovalState.APPROVED
        new_message = 'New message'
        fetched_approval_mock = Mock(state=ApprovalState.NONE,
                                     task=Mock(state=TaskState.TO_APPROVE))
        approvals_mock = [Mock(), Mock(), Mock()]
        fetched_approval_mock.task.approvals.exclude.return_value = approvals_mock
        approval_model_mock.objects.get.return_value = fetched_approval_mock

        with self.subTest('should raised error if approval_id is None'):
            with self.assertRaises(ValidationError) as e:
                save_approval(current_user_mock, None, new_state)
                self.assertEquals('approval_id may not be None',
                                  e.exception.message)
                fetched_approval_mock.task.state = TaskState.TO_APPROVE

        with self.subTest('should raised error if new_state is None'):
            with self.assertRaises(ValidationError) as e:
                fetched_approval_mock.task.state = TaskState.TO_DO
                save_approval(current_user_mock, approval_id, None)
                self.assertEquals('new_state may not be None',
                                  e.exception.message)
                fetched_approval_mock.task.state = TaskState.TO_APPROVE

        for task_state in TaskState:
            new_state = ApprovalState.APPROVED
            fetched_approval_mock.task.state = task_state
            if task_state == TaskState.TO_APPROVE:
                save_approval(current_user_mock, approval_id, new_state)
            with self.subTest(f'should raised error if task state is '
                              f'{task_state}'):
                with self.assertRaises(ValidationError) as e:
                    save_approval(current_user_mock, approval_id, new_state)
                    self.assertEquals(
                        f'task state needs to be {TaskState.TO_APPROVE} or for_reset should'
                        f' be True, TashState should be {TaskState.DECLINED} and the new '
                        f'approval state needs to be {ApprovalState.NONE} in'
                        f'order to change an approval',
                        e.exception.message)
                    fetched_approval_mock.task.state = TaskState.TO_APPROVE

        for task_state in TaskState:
            new_state = ApprovalState.NONE
            fetched_approval_mock.task.state = task_state
            fetched_approval_mock.state = ApprovalState.DECLINED
            if task_state in [TaskState.DECLINED, TaskState.TO_APPROVE]:
                save_approval(current_user_mock, approval_id, new_state,
                              for_reset=True)
            else:
                with self.subTest(f'should raise error if for_reset is True, '
                                  f'but task state is not {TaskState.DECLINED}'):
                    with self.assertRaises(ValidationError) as e:
                        save_approval(current_user_mock, approval_id, new_state,
                                      for_reset=True)
                    self.assertEquals(
                        f'task state needs to be {TaskState.TO_APPROVE} or for_reset should'
                        f' be True, TashState should be {TaskState.DECLINED} and the new '
                        f'approval state needs to be {ApprovalState.NONE} in'
                        f'order to change an approval',
                        e.exception.message)
                    fetched_approval_mock.task.state = TaskState.TO_APPROVE

        for new_state in ApprovalState:
            fetched_approval_mock.task.state = TaskState.DECLINED
            if new_state == ApprovalState.NONE:
                save_approval(current_user_mock, approval_id, new_state,
                              for_reset=True)
            else:
                with self.subTest(f'should raise error if for_reset is True, '
                                  f'task state is {TaskState.DECLINED}, but new '
                                  f'approval state is not {ApprovalState.NONE}'):
                    with self.assertRaises(ValidationError) as e:
                        save_approval(current_user_mock, approval_id, new_state,
                                      for_reset=True, message='some msg')
                    self.assertEquals(
                        f'task state needs to be {TaskState.TO_APPROVE} or for_reset should'
                        f' be True, TashState should be {TaskState.DECLINED} and the new '
                        f'approval state needs to be {ApprovalState.NONE} in'
                        f'order to change an approval',
                        e.exception.message)
                    fetched_approval_mock.task.state = TaskState.TO_APPROVE

        for new_state in TaskState:
            if new_state == TaskState.DECLINED:
                continue
            with self.subTest(f'should raised error if new_state is '
                              f'{new_state}'):
                with self.assertRaises(ValidationError) as e:
                    fetched_approval_mock.task.state = TaskState.TO_DO
                    save_approval(current_user_mock, approval_id, new_state)
                    self.assertEquals(
                        f'task state needs to be {TaskState.TO_APPROVE} or for_reset should'
                        f' be True, TashState should be {TaskState.DECLINED} and the new '
                        f'approval state needs to be {ApprovalState.NONE} in'
                        f'order to change an approval',
                        e.exception.message)
                    fetched_approval_mock.task.state = TaskState.TO_APPROVE

        with self.subTest(
                'should raised error if new_state is DECLINED and message is None'):
            with self.assertRaises(ValidationError) as e:
                fetched_approval_mock.task.state = TaskState.TO_DO
                save_approval(current_user_mock, approval_id,
                              ApprovalState.DECLINED)
                self.assertEquals('if new_state is DECLINED, '
                                  'the message may not be None',
                                  e.exception.message)
                fetched_approval_mock.task.state = TaskState.TO_APPROVE
            with self.assertRaises(ValidationError) as e:
                fetched_approval_mock.task.state = TaskState.TO_DO
                save_approval(current_user_mock, approval_id, None)
                self.assertEquals(
                    f'task state needs to be {TaskState.TO_APPROVE} in'
                    f'order to change an approval, but was {fetched_approval_mock.task.state}',
                    e.exception.message)
                fetched_approval_mock.task.state = TaskState.TO_APPROVE
            with self.assertRaises(ValidationError) as e:
                fetched_approval_mock.task.state = TaskState.DONE
                save_approval(current_user_mock, approval_id, None)
                self.assertEquals(
                    f'task state needs to be {TaskState.TO_APPROVE} in'
                    f'order to change an approval, but was {fetched_approval_mock.task.state}',
                    e.exception.message)
                fetched_approval_mock.task.state = TaskState.TO_APPROVE

            with self.assertRaises(ValidationError) as e:
                fetched_approval_mock.task.state = TaskState.DECLINED
                save_approval(current_user_mock, approval_id, None)
                self.assertEquals(
                    f'task state needs to be {TaskState.TO_APPROVE} in'
                    f'order to change an approval, but was {fetched_approval_mock.task.state}',
                    e.exception.message)
                fetched_approval_mock.task.state = TaskState.TO_APPROVE

        with self.subTest('should raise error if approval\'s task state is not '
                          'TO_APPROVE'):
            with self.assertRaises(ValidationError) as e:
                save_approval(current_user_mock, approval_id, None)
                self.assertEquals('new_state may not be None',
                                  e.exception.message)
                fetched_approval_mock.task.state = TaskState.TO_APPROVE

        with self.subTest('should fetch approval by passed id'):
            expected_call_count = approval_model_mock.objects.get.call_count + 1
            fetched_approval_mock.task.state = TaskState.TO_APPROVE
            save_approval(current_user_mock, approval_id, new_state)
            self.assertEquals(expected_call_count,
                              approval_model_mock.objects.get.call_count)
            self.assertEquals(dict(id=approval_id),
                              approval_model_mock.objects.get.call_args[1])
            fetched_approval_mock.task.state = TaskState.TO_APPROVE

        with self.subTest('should set state to new state and save entity'):
            fetched_approval_mock.state = ApprovalState.NONE
            fetched_approval_mock.task.state = TaskState.TO_APPROVE
            expected_call_count = fetched_approval_mock.save.call_count + 1
            save_approval(current_user_mock, approval_id, new_state)
            self.assertEquals(new_state, fetched_approval_mock.state)
            self.assertEquals(expected_call_count,
                              fetched_approval_mock.save.call_count)
            fetched_approval_mock.task.state = TaskState.TO_APPROVE

        with self.subTest('should set message to new message and save entity'):
            fetched_approval_mock.state = ApprovalState.NONE
            fetched_approval_mock.task.state = TaskState.TO_APPROVE
            expected_call_count = fetched_approval_mock.save.call_count + 1
            save_approval(current_user_mock, approval_id, new_state,
                          new_message)
            self.assertEquals(new_message, fetched_approval_mock.message)
            self.assertEquals(expected_call_count,
                              fetched_approval_mock.save.call_count)
            fetched_approval_mock.task.state = TaskState.TO_APPROVE

        with self.subTest(
                'should set message to empty if no new message provided'):
            fetched_approval_mock.state = ApprovalState.NONE
            fetched_approval_mock.task.state = TaskState.TO_APPROVE
            expected_call_count = fetched_approval_mock.save.call_count + 1
            save_approval(current_user_mock, approval_id, new_state)
            self.assertEquals('', fetched_approval_mock.message)
            self.assertEquals(expected_call_count,
                              fetched_approval_mock.save.call_count)
            fetched_approval_mock.task.state = TaskState.TO_APPROVE

        with self.subTest('should fetch approvals excluding task owner\'s'):
            fetched_approval_mock.task.state = TaskState.TO_APPROVE
            fetched_approval_mock.state = ApprovalState.NONE
            expected_call_count = fetched_approval_mock.task.approvals.exclude.call_count + 1
            save_approval(current_user_mock, approval_id, new_state)
            self.assertEquals(expected_call_count,
                              fetched_approval_mock.task.approvals.exclude.call_count)
            self.assertEquals(dict(user=fetched_approval_mock.task.user),
                              fetched_approval_mock.task.approvals.exclude.call_args[1])
            fetched_approval_mock.task.state = TaskState.TO_APPROVE

        with self.subTest(
                'should not do anything if any of the other approvals has state NONE'):
            fetched_approval_mock.task.state = TaskState.TO_APPROVE
            fetched_approval_mock.state = ApprovalState.NONE
            fetched_approval_mock.task.approvals.exclude.return_value = [
                Mock(state=ApprovalState.APPROVED),
                Mock(state=ApprovalState.NONE),
                Mock(state=ApprovalState.APPROVED),
            ]
            expected_call_count_2 = save_task_mock.call_count
            save_approval(current_user_mock, approval_id, new_state)
            self.assertEquals(expected_call_count_2,
                              save_task_mock.call_count)

        with self.subTest(
                'should save task if at least one approval state is declined and there are none with state None'):
            fetched_approval_mock.task.state = TaskState.TO_APPROVE
            fetched_approval_mock.state = ApprovalState.NONE
            fetched_approval_mock.task.id._return_value = 123456789
            fetched_approval_mock.task.approvals.exclude.return_value = [
                Mock(state=ApprovalState.APPROVED),
                Mock(state=ApprovalState.DECLINED),
                Mock(state=ApprovalState.APPROVED),
            ]
            expected_call_count_2 = save_task_mock.call_count + 1
            save_approval(current_user_mock, approval_id, new_state)
            self.assertEquals(expected_call_count_2,
                              save_task_mock.call_count)
            self.assertTupleEqual((current_user_mock,),
                                  save_task_mock.call_args[0])
            self.assertDictEqual(dict(
                id=fetched_approval_mock.task.id,
                state=TaskState.DECLINED
            ), save_task_mock.call_args[1])

        with self.subTest(
                'should not save task if for_reset is True'):
            fetched_approval_mock.task.state = TaskState.TO_APPROVE
            fetched_approval_mock.state = ApprovalState.NONE
            fetched_approval_mock.task.id._return_value = 123456789
            fetched_approval_mock.task.approvals.exclude.return_value = [
                Mock(state=ApprovalState.APPROVED),
                Mock(state=ApprovalState.DECLINED),
                Mock(state=ApprovalState.APPROVED),
            ]
            expected_call_count = save_task_mock.call_count
            save_approval(current_user_mock, approval_id, new_state, for_reset=True)
            self.assertEquals(expected_call_count,
                              save_task_mock.call_count)

        with self.subTest('should return fetched approval'):
            fetched_approval_mock.task.state = TaskState.TO_APPROVE
            fetched_approval_mock.task.approvals.exclude.return_value = approvals_mock
            fetched_approval_mock.state = ApprovalState.NONE
            return_value = save_approval(current_user_mock, approval_id,
                                         new_state)
            self.assertEquals(return_value, fetched_approval_mock)
