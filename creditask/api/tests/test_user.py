import json

from django.test import tag

from creditask.api import schema
from creditask.api.tests.creditask_test_base import CreditaskTestBase
from creditask.tests import create_user, create_group


@tag('integration')
class ResolveUserTest(CreditaskTestBase):
    GRAPHQL_SCHEMA = schema

    def setUp(self):
        self.op_name = 'user'
        self.query_under_test = \
            f'''
            query {self.op_name}($id: ID!) {{
              {self.op_name}(id: $id) {{
                id
                email
                publicName
                credits
              }}
            }}
            '''

        self.current_user_credentials = {
            'email': 'current_user@email.com',
            'password': 'pwuser1'
        }
        self.current_user = create_user(group=create_group(),
                                        **self.current_user_credentials)

        self.login(self.current_user_credentials.get('email'),
                   self.current_user_credentials.get('password'))

    def test_should_require_login(self):
        self.should_require_login(self.query_under_test, op_name=self.op_name,
                                  variables={'id': '1'})

    def test_should_require_user_id(self):
        response = self.gql(self.query_under_test,
                            op_name=self.op_name,
                            variables={'id': None})

        self.assertEquals(response.status_code, 400)

    def test_should_return_user(self):
        response = self.gql(self.query_under_test,
                            op_name=self.op_name,
                            variables={'id': str(self.current_user.id)})

        self.assertResponseNoErrors(response)

        task: dict = json.loads(response.content).get(
            'data').get(self.op_name)

        self.assertIsNotNone(task)
        self.assertEquals(int(task.get('id')), self.current_user.id)
        self.assertEquals(task.get('publicName'), self.current_user.public_name)
        self.assertEquals(task.get('email'), self.current_user.email)
        self.assertEquals(task.get('credits'), self.current_user.credits)


@tag('integration')
class ResolveUsersTest(CreditaskTestBase):
    GRAPHQL_SCHEMA = schema

    def setUp(self):
        self.op_name = 'users'
        self.query_under_test = \
            f'''
            query {self.op_name} {{
              {self.op_name} {{
                id
                email
                publicName
                credits
              }}
            }}
            '''

        self.current_user_credentials = {
            'email': 'current_user@email.com',
            'password': 'pwuser1'
        }
        self.current_user = create_user(group=create_group(),
                                        **self.current_user_credentials)

        self.login(self.current_user_credentials.get('email'),
                   self.current_user_credentials.get('password'))

    def test_should_require_login(self):
        self.should_require_login(self.query_under_test, op_name=self.op_name)

    def test_should_return_expected_users(self):
        incorrect_group = create_group()
        correct_user_1 = create_user(group=self.current_user.group)
        correct_user_2 = create_user(group=self.current_user.group)
        correct_user_3 = create_user(group=self.current_user.group)
        incorrect_user_1 = create_user(group=incorrect_group)
        incorrect_user_2 = create_user(group=incorrect_group)
        incorrect_user_3 = create_user(group=incorrect_group)

        response = self.gql(self.query_under_test,
                            op_name=self.op_name,
                            variables={'id': str(self.current_user.id)})

        self.assertResponseNoErrors(response)

        users: dict = json.loads(response.content).get(
            'data').get(self.op_name)

        self.assertIsNotNone(users)
        self.assertEquals(4, len(users))
        self.assertEquals(int(users[0].get('id')), self.current_user.id)
        self.assertEquals(int(users[1].get('id')), correct_user_1.id)
        self.assertEquals(int(users[2].get('id')), correct_user_2.id)
        self.assertEquals(int(users[3].get('id')), correct_user_3.id)


@tag('integration')
class ResolveOtherUsersTest(CreditaskTestBase):
    GRAPHQL_SCHEMA = schema

    def setUp(self):
        self.op_name = 'otherUsers'
        self.query_under_test = \
            f'''
            query {self.op_name}($userEmail: String!) {{
              {self.op_name}(userEmail: $userEmail) {{
                id
                email
                publicName
                credits
              }}
            }}
            '''

        self.current_user_credentials = {
            'email': 'current_user@email.com',
            'password': 'pwuser1'
        }
        self.current_user = create_user(group=create_group(),
                                        **self.current_user_credentials)

        self.login(self.current_user_credentials.get('email'),
                   self.current_user_credentials.get('password'))

    def test_should_require_login(self):
        self.should_require_login(self.query_under_test, op_name=self.op_name,
                                  variables={
                                      'userEmail': self.current_user.email})

    def test_should_require_user_email(self):
        response = self.gql(self.query_under_test,
                            op_name=self.op_name,
                            variables={'userEmail': None})

        self.assertEquals(response.status_code, 400)

    def test_should_return_expected_users(self):
        incorrect_group = create_group()
        correct_user_1 = create_user(group=self.current_user.group)
        correct_user_2 = create_user(group=self.current_user.group)
        correct_user_3 = create_user(group=self.current_user.group)
        incorrect_user_1 = create_user(group=incorrect_group)
        incorrect_user_2 = create_user(group=incorrect_group)
        incorrect_user_3 = create_user(group=incorrect_group)

        response = self.gql(self.query_under_test,
                            op_name=self.op_name,
                            variables={'userEmail': self.current_user.email})

        self.assertResponseNoErrors(response)

        users: dict = json.loads(response.content).get(
            'data').get(self.op_name)

        self.assertIsNotNone(users)
        self.assertEquals(3, len(users))

        self.assertCountEqual(
            [correct_user_1.id, correct_user_2.id, correct_user_3.id],
            list(map(lambda u: int(u.get('id')), users)))
