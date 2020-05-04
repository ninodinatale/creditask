import datetime

from django.db.models import DateField, BooleanField, CharField, IntegerField, \
    ForeignKey, FloatField
from django.test import TransactionTestCase

from creditask.models import User


class ModelsTestBase(TransactionTestCase):
    _user_email = 'user@modelstestbase.com'

    def __init__(self, *args, **kwargs):
        """
        entity_under_test: The entity under test
        valid_entity_dict: A dict which should be a valid row of the entity.
        """
        super().__init__(*args, **kwargs)
        self.entity_under_test = None
        self.valid_entity_dict = None

    def setUp(self) -> None:
        user = User.objects.create(email=f'{ModelsTestBase._user_email}',
                                   public_name='user')
        base_dict = dict(
            created_by=user,
            is_deleted=False
        )

        # TODO make this an abstract testing class. For now, this does the
        #  job.
        if self.entity_under_test is None or self.valid_entity_dict is None:
            self.skipTest('BaseClass cannot be tested on its own.')

        self.valid_entity_dict = {**self.valid_entity_dict, **base_dict}

    def tearDown(self) -> None:
        User.objects.get(email=ModelsTestBase._user_email).delete()

    def test_delete_should_not_be_possible(self):
        entity = self.entity_under_test.objects.create(**self.valid_entity_dict)

        with self.assertRaises(TypeError):
            entity.delete()

    def test_update_should_create_new_row_and_merge_old_values(self):

        record = self.entity_under_test.objects.create(
            **self.valid_entity_dict)

        fields = record._meta.concrete_fields

        with self.subTest('should apply changes if made any'):
            prev_record = self.entity_under_test.objects.get(id=record.id)

            # setting up, more or less randomly, which attributes are going
            # to be changed in order to test the data
            maintaining_fields = []
            changing_fields = []
            for i, field in enumerate(fields, start=0):
                if i % 2 == 0:
                    if field.column in ['id', 'created_at']:
                        continue
                    maintaining_fields.append(field)
                else:
                    # these fields may not be changed manually
                    if field.column in ['id', 'created_at', 'created_by_id']:
                        continue
                    changing_fields.append(field)

            for field in changing_fields:
                changed_value = None

                if field.column not in self.valid_entity_dict:
                    self.fail('Please provide the foreign key ID instead of '
                              'the objects in the valid_entity_dict: Instead '
                              f'of [{field.column[:(len(field.column) - 3)]}], '
                              f'provide [{field.column}].')

                elif isinstance(field,  ForeignKey):
                    changed_value = field.related_model.objects.create().id
                elif isinstance(field,  DateField):
                    changed_value = '2789-10-10'
                elif isinstance(field,  CharField):
                    changed_value = 'changed value'
                elif isinstance(field,  BooleanField):
                    changed_value = not self.valid_entity_dict[field.column]
                elif isinstance(field,  IntegerField):
                    changed_value = 4373729
                elif isinstance(field,  FloatField):
                    changed_value = 4373.729677
                else:
                    self.fail(f'Type '
                              f'{type(self.valid_entity_dict[field.column])} '
                              f'not supported. If it is a relation, put the '
                              f'ID instead of the objec, otherwise add the '
                              f'Field type to the test.')

                setattr(record, field.column, changed_value)

            record.save()
            new_record = self.entity_under_test.objects.get(id=record.id)

            for field in changing_fields:
                self.assertIsNotNone(getattr(new_record, field.column),
                                     f'field {field.column} should not be '
                                     f'None')
                self.assertNotEqual(getattr(prev_record, field.column),
                                    getattr(new_record, field.column),
                                    f'field {field.column} should have changed')

            for field in maintaining_fields:

                if isinstance(field, DateField):
                    pass

                self.assertEquals(getattr(prev_record, field.column),
                                  getattr(new_record, field.column),
                                  f'field {field.column} should not have '
                                  f'changed')

    def test_created_at_should_be_now(self):
        if 'created_at' in self.valid_entity_dict:
            del self.valid_entity_dict['created_at']
        created_entity = self.entity_under_test.objects.create(
            **self.valid_entity_dict
        )
        now = datetime.datetime.now()
        now_rounded = now - \
                      datetime.timedelta(minutes=now.minute % 1,
                                         seconds=now.second,
                                         microseconds=now.microsecond)

        created_at_now = created_entity.created_at
        created_at_now_rounded = created_at_now - \
                                 datetime.timedelta(
                                     minutes=created_at_now.minute % 1,
                                     seconds=created_at_now.second,
                                     microseconds=created_at_now.microsecond)

        # TODO make a better comparison of time instead of this bullshit,
        #  no time now
        self.assertEqual(now_rounded.minute,
                         created_at_now_rounded.minute)
        self.assertEqual(now_rounded.second,
                         created_at_now_rounded.second)

    def test_created_by(self):
        # TODO
        pass

    def test_is_deleted_should_have_default_value(self):
        if 'is_deleted' in self.valid_entity_dict:
            del self.valid_entity_dict['is_deleted']

        created_entity = self.entity_under_test.objects.create(
            **self.valid_entity_dict
        )
        self.assertEqual(False, created_entity.is_deleted)
