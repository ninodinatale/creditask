from unittest import mock
from unittest.mock import Mock

from django.core.exceptions import ValidationError
from django.test import TestCase

from creditask.services import get_users
from ..user_service import save_user, merge_values, get_other_users


class TestUserService(TestCase):

    @mock.patch('creditask.services.user_service.User')
    def test_get_users(self, mock_user_model):
        group_id = 123456789
        mock_return_value = ['some', 'filtered', 'users']
        mock_user_model.objects.filter.return_value = mock_return_value
        return_value = get_users(group_id)

        self.assertEquals(1, mock_user_model.objects.filter.call_count)
        self.assertEquals(dict(group_id=group_id),
                          mock_user_model.objects.filter.call_args.kwargs)
        self.assertEquals(mock_return_value, return_value)

    @mock.patch('creditask.services.user_service.merge_values')
    @mock.patch('creditask.services.user_service.User')
    def test_save_user(self, mock_user_model, merge_values_mock):
        user_mock = Mock()

        with self.assertRaises(ValidationError,
                               msg='Should raise error if no user and id are passed'):
            save_user(None)

        with self.subTest(
                'should fetch user from db uf passed user is None but id is passed'):
            user_mock_2 = Mock()
            mock_user_model.objects.get.return_value = user_mock_2
            return_value = save_user(None, id=123456789)
            self.assertEquals(1, mock_user_model.objects.get.call_count)
            self.assertEquals(1, merge_values_mock.call_count)
            self.assertEquals((123456789,),
                              mock_user_model.objects.get.call_args.args)
            self.assertEquals(user_mock_2, return_value)
            self.assertEquals(1, merge_values_mock.return_value.save.call_count)

        with self.subTest(
                'should fetch user from db uf passed user is None but id is passed'):
            mock_user_model.reset_mock()
            merge_values_mock.reset_mock()
            user_mock_2 = Mock()
            mock_user_model.objects.get.return_value = user_mock_2
            return_value = save_user(user_mock)
            self.assertEquals(0, mock_user_model.objects.get.call_count)
            self.assertEquals(1, merge_values_mock.call_count)
            self.assertEquals(user_mock, return_value)
            self.assertEquals(1, merge_values_mock.return_value.save.call_count)

    def test_merge_values(self):
        with self.subTest('should add attributes if not existing yet and return'
                          'task'):
            user_to_merge_into_mock = Mock()

            values_to_merge = dict(public_name='hello',
                                   email='email',
                                   id=200000,
                                   credits=1234)
            return_value = merge_values(user_to_merge_into_mock,
                                        **values_to_merge
                                        )

            self.assertEquals(user_to_merge_into_mock, return_value,
                              'should return task to merge into')
            self.assertNotEquals(values_to_merge.get('id'),
                                 user_to_merge_into_mock.id,
                                 'id should not be merged')
            self.assertEquals(values_to_merge.get('email'),
                              user_to_merge_into_mock.email)
            self.assertEquals(values_to_merge.get('public_name'),
                              user_to_merge_into_mock.public_name)
            self.assertEquals(values_to_merge.get('credits'),
                              user_to_merge_into_mock.credits)

    @mock.patch('creditask.services.user_service.User')
    def test_get_other_users(self, user_model_mock):
        email = 'some email'
        mock_group = Mock()
        mock_return_value = Mock(group=mock_group)
        mock_return_value_2 = ['some', 'return', 'value']
        user_model_mock.objects.get.return_value = mock_return_value
        user_model_mock.objects.filter().exclude.return_value = mock_return_value_2
        user_model_mock.objects.filter.reset_mock()
        return_value = get_other_users(email)

        self.assertEqual(1, user_model_mock.objects.get.call_count)
        self.assertDictEqual(dict(email=email), user_model_mock.objects.get.call_args.kwargs)
        self.assertEqual(1, user_model_mock.objects.filter.call_count)
        self.assertDictEqual(dict(group=mock_group), user_model_mock.objects.filter.call_args.kwargs)
        self.assertEqual(1, user_model_mock.objects.filter.return_value.exclude.call_count)
        self.assertDictEqual(dict(email=email), user_model_mock.objects.filter.return_value.exclude.call_args.kwargs)
        self.assertEquals(mock_return_value_2, return_value)
