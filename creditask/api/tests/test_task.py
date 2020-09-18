import json
import random
from typing import List
from unittest import mock
from unittest.mock import MagicMock

from creditask.models import User, Task, TaskState
from creditask.api import schema
from creditask.api.tests.creditask_test_base import CreditaskTestBase


class ResolveTaskTest(CreditaskTestBase):
    GRAPHQL_SCHEMA = schema

    def setUp(self):
        self.query_under_test = \
            '''
            query task($id: ID!) {
                task(id: $id) {
                    id
                    name
                }
            }
            '''
        self.op_name = 'task'

        create_user = User.objects.create_user
        self.user_1_credentials = {
            'email': 'user_1@email.com',
            'password': 'pwuser1'
        }
        self.user_1 = create_user(**self.user_1_credentials,
                                  public_name='user_1')

        self.login(self.user_1_credentials.get('email'),
                   self.user_1_credentials.get('password'))

    def test_should_require_login(self):
        self.should_require_login(self.query_under_test, op_name=self.op_name,
                                  variables={'id': '1'})

    def test_should_require_task_id(self):
        response = self.gql(self.query_under_test,
                            op_name=self.op_name,
                            variables={'id': None})

        self.assertEquals(response.status_code, 400)

    @mock.patch('creditask.api.schema_def.get_task_by_id')
    def test_should_succeed(self, mock_get_task_by_id: MagicMock):
        mock_task = Task(id=random.randint(1, 9999),
                         name='name')
        mock_get_task_by_id.return_value = mock_task

        response = self.gql(self.query_under_test,
                            op_name=self.op_name,
                            variables={'id': str(mock_task.id)})

        self.assertResponseNoErrors(response)

        task: dict = json.loads(response.content).get(
            'data').get(self.op_name)

        self.assertIsNotNone(task)
        self.assertEquals(int(task.get('id')), mock_task.id)
        self.assertEquals(task.get('name'), mock_task.name)


class ResolveTodoTasksOfUserTest(CreditaskTestBase):
    GRAPHQL_SCHEMA = schema

    def setUp(self):
        self.query_under_test = \
            '''
            query todoTasksOfUser($userEmail: String!) {
                todoTasksOfUser(userEmail: $userEmail) {
                    id
                    name
                }
            }
            '''
        self.op_name = 'todoTasksOfUser'

        create_user = User.objects.create_user
        self.user_1_credentials = {
            'email': 'user_1@email.com',
            'password': 'pwuser1'
        }
        self.user_1 = create_user(**self.user_1_credentials,
                                  public_name='user_1')

        self.login(self.user_1_credentials.get('email'),
                   self.user_1_credentials.get('password'))

    def test_should_require_login(self):
        self.should_require_login(self.query_under_test, op_name=self.op_name,
                                  variables={'userEmail': 'user@mail.com'})

    def test_should_require_user_email(self):
        response = self.gql(self.query_under_test,
                            op_name=self.op_name,
                            variables={'userEmail': None})

        response_content: dict = json.loads(response.content)
        errors: List = response_content.get('errors')

        self.assertEquals(response.status_code, 400)
        self.assertIsNotNone(errors)
        self.assertEquals(errors[0].get('message'),
                          "Variable \"$userEmail\" "
                          "of required type \"String!\" was not provided.")

    @mock.patch('creditask.api.schema_def.get_todo_tasks_by_user_email')
    def test_should_succeed(self, mock_fn: MagicMock):
        user_email = 'user@mail.com'

        mock_task_list = [Task(id=random.randint(1, 9999), name='name')]
        mock_fn.return_value = mock_task_list

        response = self.gql(self.query_under_test,
                            op_name=self.op_name,
                            variables={'userEmail': user_email})

        self.assertResponseNoErrors(response)

        task_list: List[dict] = json.loads(response.content).get(
            'data').get(self.op_name)

        self.assertIsNotNone(task_list)
        self.assertTrue(len(task_list) == 1)

        self.assertEqual(1, mock_fn.call_count)

        first_call_args = mock_fn.call_args[0]
        self.assertEqual(1, len(first_call_args))
        self.assertEqual(user_email, first_call_args[0])

        self.assertEquals(int(task_list[0].get('id')), mock_task_list[0].id)
        self.assertEquals(task_list[0].get('name'), mock_task_list[0].name)


class ResolveToApproveTasksOfUserTest(CreditaskTestBase):
    GRAPHQL_SCHEMA = schema

    def setUp(self):
        self.query_under_test = \
            '''
            query toApproveTasksOfUser($userEmail: String!) {
                toApproveTasksOfUser(userEmail: $userEmail) {
                    id
                    name
                }
            }
            '''
        self.op_name = 'toApproveTasksOfUser'

        create_user = User.objects.create_user
        self.user_1_credentials = {
            'email': 'user_1@email.com',
            'password': 'pwuser1'
        }
        self.user_1 = create_user(**self.user_1_credentials,
                                  public_name='user_1')

        self.login(self.user_1_credentials.get('email'),
                   self.user_1_credentials.get('password'))

    def test_should_require_login(self):
        self.should_require_login(self.query_under_test, op_name=self.op_name,
                                  variables={'userEmail': 'user@mail.com'})

    def test_should_require_user_email(self):
        response = self.gql(self.query_under_test,
                            op_name=self.op_name,
                            variables={'userEmail': None})

        response_content: dict = json.loads(response.content)
        errors: List = response_content.get('errors')

        self.assertEquals(response.status_code, 400)
        self.assertIsNotNone(errors)
        self.assertEquals(errors[0].get('message'),
                          "Variable \"$userEmail\" "
                          "of required type \"String!\" was not provided.")

    @mock.patch('creditask.api.schema_def.get_to_approve_tasks_of_user')
    def test_should_succeed(self, mock_fn: MagicMock):
        user_email = 'user@mail.com'

        mock_task_list = [Task(id=random.randint(1, 9999), name='name')]
        mock_fn.return_value = mock_task_list

        response = self.gql(self.query_under_test,
                            op_name=self.op_name,
                            variables={'userEmail': user_email})

        self.assertResponseNoErrors(response)

        task_list: List[dict] = json.loads(response.content).get(
            'data').get(self.op_name)

        self.assertIsNotNone(task_list)
        self.assertTrue(len(task_list) == 1)

        self.assertEqual(1, mock_fn.call_count)

        first_call_args = mock_fn.call_args[0]
        self.assertEqual(1, len(first_call_args))
        self.assertEqual(user_email, first_call_args[0])

        self.assertEquals(int(task_list[0].get('id')), mock_task_list[0].id)
        self.assertEquals(task_list[0].get('name'), mock_task_list[0].name)


@mock.patch('creditask.api.schema_def.save_task', return_value=Task(
    id=371827391,
    name='returning task'))
class TaskMutationTests(CreditaskTestBase):
    GRAPHQL_SCHEMA = schema

    def setUp(self):
        self.op_name = 'saveTask'
        self.query_under_test = \
            f'''
            mutation {self.op_name}Task($createInput: TaskInputCreate) {{
              {self.op_name}(createInput: $createInput) {{
                task {{
                  id
                  name
                }}
              }}
            }}
            '''

        create_user = User.objects.create_user
        self.user_1_credentials = {
            'email': 'user_1@email.com',
            'password': 'pwuser1'
        }
        self.user_1 = create_user(**self.user_1_credentials,
                                  public_name='user_1')

        self.login(self.user_1_credentials.get('email'),
                   self.user_1_credentials.get('password'))

    def test_should_require_login(self, mock_fn):
        self.should_require_login(self.query_under_test, op_name=self.op_name,
                                  variables={'createInput':
                                                 dict(name='Task Name',
                                                      factor=1)})

    def test_validation(self, mock_fn):
        with self.subTest('should require only createInput or updateInput, '
                          'but not both'):
            self.query_under_test = \
                f'''
            mutation {self.op_name}Task($createInput: TaskInputCreate, 
                                        $updateInput: TaskInputUpdate) {{
              {self.op_name}(createInput: $createInput, updateInput: 
                                                            $updateInput) {{
                task {{
                  id
                  name
                }}
              }}
            }}
            '''
            response = self.gql(self.query_under_test,
                                op_name=self.op_name,
                                variables={'createInput':
                                               dict(name='Task Name',
                                                    factor=1),
                                           'updateInput':
                                               dict(name='Task Name',
                                                    id=1234567,
                                                    factor=1)})

            response_content: dict = json.loads(response.content)
            errors: List = response_content.get('errors')

            self.assertIsNotNone(errors)
            self.assertEquals(errors[0].get('message'),
                              'Only one of create_input or update_input may be '
                              'set')

    def test_create_input(self, mock_fn):
        with self.subTest('test_name_should_have_min_len_of_3'):
            create_input = dict(name='na', factor=1)

            response = self.gql(self.query_under_test,
                                op_name=self.op_name,
                                variables={'createInput': create_input})

            response_content: dict = json.loads(response.content)
            errors: List = response_content.get('errors')

            self.assertEquals(response.status_code, 400)
            self.assertIsNotNone(errors)
            self.assertEquals(errors[0].get('message'),
                              "['length of \"na\" (2) is shorter than min "
                              "length (3)']")

        with self.subTest('test_name_should_have_max_len_of_30'):
            create_input = dict(name='Very long task name, way too long',
                                factor=1)

            response = self.gql(self.query_under_test,
                                op_name=self.op_name,
                                variables={'createInput': create_input})

            response_content: dict = json.loads(response.content)
            errors: List = response_content.get('errors')

            self.assertEquals(response.status_code, 400)
            self.assertIsNotNone(errors)
            self.assertEquals(errors[0].get('message'),
                              "['length of \"Very long task name, way too "
                              "long\" (33) may not be greater than 30)']")

        with self.subTest('test_name_should_be_non_null'):
            create_input = dict(name=None, factor=1)

            response = self.gql(self.query_under_test,
                                op_name=self.op_name,
                                variables={'createInput': create_input})

            response_content: dict = json.loads(response.content)
            errors: List = response_content.get('errors')

            self.assertEquals(response.status_code, 400)
            self.assertIsNotNone(errors)
            self.assertIn("Expected \"CustomString!\", found null.",
                          errors[0].get('message'))

        with self.subTest('test_factor_should_be_float'):
            create_input = dict(name='Task Name', factor='abc')

            response = self.gql(self.query_under_test,
                                op_name=self.op_name,
                                variables={'createInput': create_input})

            response_content: dict = json.loads(response.content)
            errors: List = response_content.get('errors')

            self.assertEquals(response.status_code, 400)
            self.assertIsNotNone(errors)
            self.assertIn("Expected type \"CustomFloat\", found \"abc\".",
                          errors[0].get('message'))

        with self.subTest('test_factor_should_have_min_value_of_0'):
            create_input = dict(name='Task Name', factor=-1)

            response = self.gql(self.query_under_test,
                                op_name=self.op_name,
                                variables={'createInput': create_input})

            response_content: dict = json.loads(response.content)
            errors: List = response_content.get('errors')

            self.assertEquals(response.status_code, 400)
            self.assertIsNotNone(errors)
            self.assertEqual("['value -1.0 needs to be greater than 1.']",
                             errors[0].get('message'))

        with self.subTest('test_factor_should_be_non_null'):
            create_input = dict(name='Task Name', factor=None)

            response = self.gql(self.query_under_test,
                                op_name=self.op_name,
                                variables={'createInput': create_input})

            response_content: dict = json.loads(response.content)
            errors: List = response_content.get('errors')

            self.assertEquals(response.status_code, 400)
            self.assertIsNotNone(errors)
            self.assertIn("Expected \"CustomFloat!\", found null.",
                          errors[0].get('message'))

        with self.subTest('test_user_id_can_be_string'):
            create_input = dict(name='Task Name', factor=1, userId='1')

            response = self.gql(self.query_under_test,
                                op_name=self.op_name,
                                variables={'createInput': create_input})

            self.assertResponseNoErrors(response)

        with self.subTest('test_period_start_should_be_date'):
            create_input = dict(name='Task Name', factor=1, periodStart='abc')

            response = self.gql(self.query_under_test,
                                op_name=self.op_name,
                                variables={'createInput': create_input})

            response_content: dict = json.loads(response.content)
            errors: List = response_content.get('errors')

            self.assertEquals(response.status_code, 400)
            self.assertIsNotNone(errors)
            self.assertIn("Expected type \"Date\", found \"abc\".",
                          errors[0].get('message'))

        with self.subTest('test_period_end_should_be_date'):
            create_input = dict(name='Task Name', factor=1, periodEnd='abc')

            response = self.gql(self.query_under_test,
                                op_name=self.op_name,
                                variables={'createInput': create_input})

            response_content: dict = json.loads(response.content)
            errors: List = response_content.get('errors')

            self.assertEquals(response.status_code, 400)
            self.assertIsNotNone(errors)
            self.assertIn("Expected type \"Date\", found \"abc\".",
                          errors[0].get('message'))

        with self.subTest('test_should_succeed'):
            create_input = dict(name='Task Name', factor=1)

            mock_task = Task(id=random.randint(1, 9999), **create_input)
            mock_fn.return_value = mock_task
            mock_fn.call_count = 0

            response = self.gql(self.query_under_test,
                                op_name=self.op_name,
                                variables={'createInput': create_input})

            self.assertResponseNoErrors(response)

            task: dict = json.loads(response.content).get(
                'data').get(self.op_name).get('task')

            self.assertIsNotNone(task)
            self.assertEqual(1, mock_fn.call_count)

            first_call_args = mock_fn.call_args[1]
            self.assertEqual(len(create_input), len(first_call_args))
            self.assertEqual(create_input, first_call_args)

            self.assertEquals(int(task.get('id')), mock_task.id)
            self.assertEquals(task.get('name'), create_input.get('name'))

    def test_update_input(self, mock_fn):
        self.query_under_test = \
            f'''
            mutation {self.op_name}Task($updateInput: TaskInputUpdate) {{
              {self.op_name}(updateInput: $updateInput) {{
                task {{
                  id
                  name
                }}
              }}
            }}
            '''

        with self.subTest('test_name_should_have_min_len_of_3'):
            update_input = dict(name='na', type='type1', factor=1)

            response = self.gql(self.query_under_test,
                                op_name=self.op_name,
                                variables={'updateInput': update_input})

            response_content: dict = json.loads(response.content)
            errors: List = response_content.get('errors')

            self.assertEquals(response.status_code, 400)
            self.assertIsNotNone(errors)
            self.assertEquals(errors[0].get('message'),
                              "['length of \"na\" (2) is shorter than min "
                              "length (3)']")

        with self.subTest('test_name_should_have_max_len_of_30'):
            update_input = dict(name='Very long task name, way too long',
                                factor=1)

            response = self.gql(self.query_under_test,
                                op_name=self.op_name,
                                variables={'updateInput': update_input})

            response_content: dict = json.loads(response.content)
            errors: List = response_content.get('errors')

            self.assertEquals(response.status_code, 400)
            self.assertIsNotNone(errors)
            self.assertEquals(errors[0].get('message'),
                              "['length of \"Very long task name, way too "
                              "long\" (33) may not be greater than 30)']")

        with self.subTest('test_name_should_be_nullable'):
            update_input = dict(
                factor=1,
                id=random.randint(1, 9999)
            )

            response = self.gql(self.query_under_test,
                                op_name=self.op_name,
                                variables={'updateInput': update_input})

            self.assertResponseNoErrors(response)

        with self.subTest('test_factor_should_be_float'):
            update_input = dict(
                name='Task Name',
                factor='abc',
                id=random.randint(1, 9999)
            )

            response = self.gql(self.query_under_test,
                                op_name=self.op_name,
                                variables={'updateInput': update_input})

            response_content: dict = json.loads(response.content)
            errors: List = response_content.get('errors')

            self.assertEquals(response.status_code, 400)
            self.assertIsNotNone(errors)
            self.assertIn("Expected type \"CustomFloat\", found \"abc\".",
                          errors[0].get('message'))

        with self.subTest('test_factor_should_have_min_value_of_0'):
            update_input = dict(name='Task Name',
                                factor=-1,
                                id=random.randint(1, 9999)
                                )

            response = self.gql(self.query_under_test,
                                op_name=self.op_name,
                                variables={'updateInput': update_input})

            response_content: dict = json.loads(response.content)
            errors: List = response_content.get('errors')

            self.assertEquals(response.status_code, 400)
            self.assertIsNotNone(errors)
            self.assertEqual("['value -1.0 needs to be greater than 1.']",
                             errors[0].get('message'))

        with self.subTest('test_factor_should_be_nullable'):
            update_input = dict(name='Task Name', factor=None,
                                id=random.randint(1, 9999)
                                )

            response = self.gql(self.query_under_test,
                                op_name=self.op_name,
                                variables={'updateInput': update_input})

            self.assertResponseNoErrors(response)

        with self.subTest('test_user_id_can_be_string'):
            update_input = dict(name='Task Name', factor=1, userId='2',
                                id=random.randint(1, 9999)
                                )

            response = self.gql(self.query_under_test,
                                op_name=self.op_name,
                                variables={'updateInput': update_input})

            response_content: dict = json.loads(response.content)
            errors: List = response_content.get('errors')

            self.assertResponseNoErrors(response)

        with self.subTest('test_period_start_should_be_date'):
            update_input = dict(name='Task Name', factor=1, periodStart='abc')

            response = self.gql(self.query_under_test,
                                op_name=self.op_name,
                                variables={'updateInput': update_input})

            response_content: dict = json.loads(response.content)
            errors: List = response_content.get('errors')

            self.assertEquals(response.status_code, 400)
            self.assertIsNotNone(errors)
            self.assertIn("Expected type \"Date\", found \"abc\".",
                          errors[0].get('message'))

        with self.subTest('test_period_end_should_be_date'):
            update_input = dict(name='Task Name', factor=1, periodEnd='abc')

            response = self.gql(self.query_under_test,
                                op_name=self.op_name,
                                variables={'updateInput': update_input})

            response_content: dict = json.loads(response.content)
            errors: List = response_content.get('errors')

            self.assertEquals(response.status_code, 400)
            self.assertIsNotNone(errors)
            self.assertIn("Expected type \"Date\", found \"abc\".",
                          errors[0].get('message'))

        with self.subTest('test_should_succeed'):
            update_input = dict(
                                name='Task Name',
                                id=1234567.0,
                                factor=1.0
            )

            mock_task = Task(id=random.randint(1, 9999),
                             name=update_input.get('name'),
                             factor=update_input.get('factor'))

            mock_fn.call_count = 0
            mock_fn.return_value = mock_task

            response = self.gql(self.query_under_test,
                                op_name=self.op_name,
                                variables={'updateInput': update_input})

            self.assertResponseNoErrors(response)

            task: dict = json.loads(response.content).get(
                'data').get(self.op_name).get('task')

            self.assertIsNotNone(task)
            self.assertEqual(1, mock_fn.call_count)

            first_call_args = mock_fn.call_args[1]
            self.assertEqual(len(update_input), len(first_call_args))

            expected_call_args = dict(
                id=str(update_input.get('id')),
                name=update_input.get('name'),
                factor=update_input.get('factor')
            )
            self.assertEqual(expected_call_args, first_call_args)

            self.assertEquals(int(task.get('id')), mock_task.id)
            self.assertEquals(task.get('name'), update_input.get('name'))
