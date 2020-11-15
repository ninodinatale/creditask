from unittest import mock

from django.test import TestCase

from creditask.services import get_all_not_in_cart


class TestGroceryService(TestCase):

    @mock.patch('creditask.services.grocery_service.Grocery')
    def test_get_all_not_in_cart(self, grocery_model_mock):
        group_id = 123456789
        mock_return_value = ['some', 'filtered', 'users']
        grocery_model_mock.objects.filter.return_value = mock_return_value
        return_value = get_all_not_in_cart(group_id)

        self.assertEquals(1, grocery_model_mock.objects.filter.call_count)
        self.assertEquals(dict(group_id=group_id, in_cart=False),
                          grocery_model_mock.objects.filter.call_args.kwargs)
        self.assertEquals(mock_return_value, return_value)
