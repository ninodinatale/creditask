from unittest import mock, TestCase
from unittest.mock import Mock

from django.core.exceptions import ValidationError

from creditask.models import ApprovalState, TaskState, CreditsCalc
from creditask.services.approval_service import save_approval


class TestApprovalService(TestCase):

    @mock.patch('creditask.services.approval_service.save_task')
    @mock.patch('creditask.services.approval_service.save_user')
    @mock.patch('creditask.services.approval_service.Approval')
    def test_save_approval(self, approval_model_mock, save_user_mock,
                           save_task_mock):
        current_user_mock = Mock()
        approval_id = 1234567898
        new_state = ApprovalState.APPROVED
        fetched_approval_mock = Mock(state=ApprovalState.NONE)
        approvals_mock = [Mock(), Mock(), Mock()]
        fetched_approval_mock.task.approvals.exclude.return_value = approvals_mock
        approval_model_mock.objects.get.return_value = fetched_approval_mock

        with self.subTest('should raised error if approval_id is None'):
            with self.assertRaises(ValidationError) as e:
                save_approval(current_user_mock, None, new_state)
                self.assertEquals('approval_id may not be None',
                                  e.exception.message)

        with self.subTest('should raised error if new_state is None'):
            with self.assertRaises(ValidationError) as e:
                save_approval(current_user_mock, approval_id, None)
                self.assertEquals('new_state may not be None',
                                  e.exception.message)

        with self.subTest('should fetch approval by passed id'):
            expected_call_count = approval_model_mock.objects.get.call_count + 1
            save_approval(current_user_mock, approval_id, new_state)
            self.assertEquals(expected_call_count,
                              approval_model_mock.objects.get.call_count)
            self.assertEquals(dict(id=approval_id),
                              approval_model_mock.objects.get.call_args.kwargs)

        with self.subTest('should raise error if state does not change'):
            with self.assertRaises(ValidationError):
                fetched_approval_mock.state = ApprovalState.APPROVED
                save_approval(current_user_mock, approval_id, new_state)

        with self.subTest('should set state to new state and save entity'):
            fetched_approval_mock.state = ApprovalState.NONE
            expected_call_count = fetched_approval_mock.save.call_count + 1
            save_approval(current_user_mock, approval_id, new_state)
            self.assertEquals(new_state, fetched_approval_mock.state)
            self.assertEquals(expected_call_count,
                              fetched_approval_mock.save.call_count)

        with self.subTest('should fetch approvals excluding task owner\'s'):
            fetched_approval_mock.state = ApprovalState.NONE
            expected_call_count = fetched_approval_mock.task.approvals.exclude.call_count + 1
            save_approval(current_user_mock, approval_id, new_state)
            self.assertEquals(expected_call_count,
                              fetched_approval_mock.task.approvals.exclude.call_count)
            self.assertEquals(dict(user=fetched_approval_mock.task.user),
                              fetched_approval_mock.task.approvals.exclude.call_args.kwargs)

        with self.subTest(
                'should not do anything if any of the other approvals has state NONE'):
            fetched_approval_mock.state = ApprovalState.NONE
            fetched_approval_mock.task.approvals.exclude.return_value = [
                Mock(state=ApprovalState.APPROVED),
                Mock(state=ApprovalState.NONE),
                Mock(state=ApprovalState.APPROVED),
            ]
            expected_call_count_1 = save_user_mock.call_count
            expected_call_count_2 = save_task_mock.call_count
            save_approval(current_user_mock, approval_id, new_state)
            self.assertEquals(expected_call_count_1,
                              save_user_mock.call_count)
            self.assertEquals(expected_call_count_2,
                              save_task_mock.call_count)

        with self.subTest(
                'should save task if at least one approval state is declined and there are none with state None'):
            fetched_approval_mock.state = ApprovalState.NONE
            fetched_approval_mock.task.id._return_value = 123456789
            fetched_approval_mock.task.approvals.exclude.return_value = [
                Mock(state=ApprovalState.APPROVED),
                Mock(state=ApprovalState.DECLINED),
                Mock(state=ApprovalState.APPROVED),
            ]
            expected_call_count_1 = save_user_mock.call_count
            expected_call_count_2 = save_task_mock.call_count + 1
            save_approval(current_user_mock, approval_id, new_state)
            self.assertEquals(expected_call_count_1,
                              save_user_mock.call_count)
            self.assertEquals(expected_call_count_2,
                              save_task_mock.call_count)
            self.assertTupleEqual((current_user_mock,),
                                  save_task_mock.call_args.args)
            self.assertDictEqual(dict(
                id=fetched_approval_mock.task.id,
                state=TaskState.DECLINED
            ), save_task_mock.call_args.kwargs)

        with self.subTest(
                'should save task and user and give credits to user if all approvals have state approved'):
            fetched_approval_mock.state = ApprovalState.NONE
            assigned_user_mock = Mock(credits=200)
            fetched_approval_mock.task.user = assigned_user_mock
            fetched_approval_mock.task.credits_calc = CreditsCalc.FIXED
            fetched_approval_mock.task.fixed_credits = 100
            fetched_approval_mock.task.id._return_value = 123456789
            fetched_approval_mock.task.approvals.exclude.return_value = [
                Mock(state=ApprovalState.APPROVED),
                Mock(state=ApprovalState.APPROVED),
                Mock(state=ApprovalState.APPROVED),
            ]
            expected_call_count_1 = save_user_mock.call_count + 1
            expected_call_count_2 = save_task_mock.call_count + 1
            save_approval(current_user_mock, approval_id, new_state)
            self.assertEquals(expected_call_count_1,
                              save_user_mock.call_count)
            self.assertEquals(expected_call_count_2,
                              save_task_mock.call_count)
            self.assertTupleEqual((assigned_user_mock,),
                                  save_user_mock.call_args.args)
            self.assertDictEqual(dict(
                credits=300
            ), save_user_mock.call_args.kwargs)
            self.assertTupleEqual((current_user_mock,),
                                  save_task_mock.call_args.args)
            self.assertDictEqual(dict(
                id=fetched_approval_mock.task.id,
                state=TaskState.APPROVED
            ), save_task_mock.call_args.kwargs)

        with self.subTest('should return fetched approval'):
            fetched_approval_mock.task.approvals.exclude.return_value = approvals_mock
            fetched_approval_mock.state = ApprovalState.NONE
            return_value = save_approval(current_user_mock, approval_id,
                                         new_state)
            self.assertEquals(return_value, fetched_approval_mock)
