from unittest import mock

from django.core.exceptions import ValidationError
from django.test import TransactionTestCase

from creditask.models import ApprovalState, Task
from creditask.services.approval_service import save_approval


class TestApprovalService(TransactionTestCase):

    @mock.patch('creditask.services.approval_service.Approval.objects')
    @mock.patch('creditask.services.approval_service.copy_task')
    @mock.patch('creditask.services.approval_service.get_task_by_task_group_id')
    def test_save_approval(self, mock_get_task_by_task_group_id,
                           mock_copy_task,
                           mock_approval_objects):
        mock_task = Task()
        mock_approval_objects.approvals.get.return_value = mock_task
        mock_copy_task.return_value = mock_task
        mock_get_task_by_task_group_id.return_value = mock_task

        with self.subTest('should raised error if task_group_id is None'):
            with self.assertRaises(ValidationError) as e:
                save_approval(None, 1, ApprovalState.NONE)
                self.assertEquals('task_group_id may not be None',
                                  e.exception.message)

        with self.subTest('should raised error if user_id is None'):
            with self.assertRaises(ValidationError) as e:
                save_approval(1, None, ApprovalState.NONE)
                self.assertEquals('user_id may not be None',
                                  e.exception.message)

        with self.subTest('should raised error if state is None'):
            with self.assertRaises(ValidationError) as e:
                save_approval(1, 1, None)
                self.assertEquals('state may not be None',
                                  e.exception.message)
        # TODO can't mock task.approvals.get ... :(
        # with self.subTest('should not raise if args are valid'):
        #     try:
        #         save_approval(1, 1, ApprovalState.NONE)
        #     except ValidationError:
        #         self.fail('save_approval should not have been failed')
