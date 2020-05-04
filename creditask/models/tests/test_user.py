from django.contrib.auth import get_user_model
from django.db.utils import DataError, IntegrityError
from django.test import TestCase, TransactionTestCase

from creditask.models import Group, User
from creditask.models.tests.models_test_base import ModelsTestBase


class UsersManagersTests(TestCase):

    def test_create_user(self):
        user_model = get_user_model()
        user = user_model.objects.create_user(email='normal@user.com',
                                              password='foo')
        self.assertEqual(user.email, 'normal@user.com')
        self.assertTrue(user.is_active)
        self.assertFalse(user.is_staff)
        self.assertFalse(user.is_superuser)
        try:
            # username is None for the AbstractUser option
            # username does not exist for the AbstractBaseUser option
            self.assertIsNone(user.username)
        except AttributeError:
            pass
        with self.assertRaises(TypeError):
            user_model.objects.create_user()
        with self.assertRaises(TypeError):
            user_model.objects.create_user(email='')
        with self.assertRaises(ValueError):
            user_model.objects.create_user(email='', password="foo")

    def test_create_superuser(self):
        user_model = get_user_model()
        admin_user = user_model.objects.create_superuser('super@user.com',
                                                         'foo')
        self.assertEqual(admin_user.email, 'super@user.com')
        self.assertTrue(admin_user.is_active)
        self.assertTrue(admin_user.is_staff)
        self.assertTrue(admin_user.is_superuser)
        try:
            # username is None for the AbstractUser option
            # username does not exist for the AbstractBaseUser option
            self.assertIsNone(admin_user.username)
        except AttributeError:
            pass
        with self.assertRaises(ValueError):
            user_model.objects.create_superuser(
                email='super@user.com', password='foo', is_superuser=False)


class TestUserModel(TransactionTestCase):
    _user_email = 'user1@TestUserModel.com'

    def setUp(self) -> None:
        user = User.objects.create(email=TestUserModel._user_email)
        self.group_entity = Group.objects.create(created_by=user)
        self.valid_user_dict = dict(
            email=f'user2@TestUserModel.com',
            public_name='User',
            credits=0,
            group=self.group_entity, is_staff=False, is_superuser=False,
            is_active=True
        )

    def tearDown(self) -> None:
        User.objects.get(email=TestUserModel._user_email).delete()
        try:
            User.objects.get(email=self.valid_user_dict['email']).delete()
        except User.DoesNotExist:
            # tests with assertRaises did not create a user entry, so there's
            # nothing to delete.
            pass

    '''email
    '''

    def test_email_should_have_max_length_128(self):
        with self.assertRaises(DataError):
            self.valid_user_dict['email'] = \
                '123456789 123456789 123456789 123456789 123456789 123456789 ' \
                '123456789 123456789 123456789 123456789 123456789 123456789 ' \
                '123456789'
            User.objects.create(**self.valid_user_dict)

    def test_email_should_be_unique(self):
        User.objects.create(**self.valid_user_dict)
        with self.assertRaises(IntegrityError):
            User.objects.create(**self.valid_user_dict)

    '''public_name
    '''

    def test_type_should_have_max_length_30(self):
        with self.assertRaises(DataError):
            self.valid_user_dict['public_name'] = \
                'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
            User.objects.create(**self.valid_user_dict)

    '''group
    '''

    def test_group_should_be_nullable(self):
        del self.valid_user_dict['group']
        try:
            User.objects.create(**self.valid_user_dict)
        except DataError:
            self.fail('Group should be nullable')

    '''credits
    '''

    def test_credits_should_have_default_value(self):
        del self.valid_user_dict['credits']
        created_user = User.objects.create(**self.valid_user_dict)
        self.assertEqual(0, created_user.credits)

    '''is_staff
    '''

    def test_is_staff_should_have_default_value(self):
        del self.valid_user_dict['is_staff']
        created_user = User.objects.create(**self.valid_user_dict)
        self.assertEqual(False, created_user.is_staff)

    '''is_superuser
    '''

    def test_is_superuser_should_have_default_value(self):
        del self.valid_user_dict['is_superuser']
        created_user = User.objects.create(**self.valid_user_dict)
        self.assertEqual(False, created_user.is_superuser)

    '''is_active
    '''

    def test_is_active_should_have_default_value(self):
        del self.valid_user_dict['is_active']
        created_user = User.objects.create(**self.valid_user_dict)
        self.assertEqual(True, created_user.is_active)
