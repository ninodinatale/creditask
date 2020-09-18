from unittest import mock

from django.core.exceptions import ValidationError
from django.test import TransactionTestCase

from creditask.models import ApprovalState, Task
from creditask.services.approval_service import save_approval


class TestApprovalService(TransactionTestCase):

    @mock.patch('creditask.services.approval_service.Approval.objects.get')
    def test_save_approval(self, mock_approval_objects_get):
        mock_task = Task()
        mock_approval_objects_get.return_value = mock_task

        with self.subTest('should raised error if id is None'):
            with self.assertRaises(ValidationError) as e:
                save_approval(None, ApprovalState.NONE)
                self.assertEquals('id may not be None',
                                  e.exception.message)

        with self.subTest('should raised error if state is None'):
            with self.assertRaises(ValidationError) as e:
                save_approval(1, None)
                self.assertEquals('new_state may not be None',
                                  e.exception.message)
