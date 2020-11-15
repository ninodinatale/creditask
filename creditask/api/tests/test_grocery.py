import json
from typing import List

from django.test import tag

from creditask.api import schema
from creditask.api.tests.creditask_test_base import CreditaskTestBase
from creditask.tests import create_user, create_group, create_grocery, \
    PreventStdErr


@tag('integration')
class ResolveAllNotInCartTest(CreditaskTestBase):
    GRAPHQL_SCHEMA = schema

    def setUp(self):
        self.op_name = 'allNotInCart'
        self.query_under_test = \
            f'''
            query {self.op_name} {{
              {self.op_name} {{
                id
                name
                inCart
                info
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

    def test_should_return_expected_results(self):
        group_1 = create_group()

        # ok
        grocery_1 = create_grocery(
            group=self.current_user.group,
            in_cart=False,
        )

        # wrong group
        grocery_2 = create_grocery(
            group=group_1,
            in_cart=False,
        )

        # ok
        grocery_3 = create_grocery(
            group=self.current_user.group,
            in_cart=False,
        )

        # wrong in_cart
        grocery_4 = create_grocery(
            group=group_1,
            in_cart=True,
        )

        # ok
        grocery_5 = create_grocery(
            group=self.current_user.group,
            in_cart=False,
        )

        # wrong group
        grocery_6 = create_grocery(
            group=group_1,
            in_cart=False,
        )

        # ok
        grocery_7 = create_grocery(
            group=self.current_user.group,
            in_cart=False,
        )

        # wrong in_cart
        grocery_8 = create_grocery(
            group=group_1,
            in_cart=True,
        )

        response = self.gql(self.query_under_test,
                            op_name=self.op_name)

        self.assertResponseNoErrors(response)

        groceries: dict = json.loads(response.content).get(
            'data').get(self.op_name)

        self.assertIsNotNone(groceries)
        self.assertEquals(4, len(groceries))
        self.assertCountEqual(list(map(lambda g: int(g.get('id')), groceries)),
                              [
                                  grocery_1.id,
                                  grocery_3.id,
                                  grocery_5.id,
                                  grocery_7.id,
                              ])


@tag('integration')
class CreateGroceryTest(CreditaskTestBase):
    GRAPHQL_SCHEMA = schema

    def get_valid_input(self, name='some name', info=''):
        return dict(
            name=name,
            info=info
        )

    def setUp(self):
        self.op_name = 'createGrocery'
        self.query_under_test = \
            f'''
            mutation {self.op_name}($input: GroceryCreateInput!) {{
                {self.op_name}(input: $input) {{
                    grocery {{
                        id
                        name
                        info
                        inCart
                    }}
                }}
            }}
            '''

        self.current_user_credentials = {
            'email': 'current_user@email.com',
            'password': 'pwuser1'
        }
        self.current_user = self.current_user = create_user(
            group=create_group(),
            **self.current_user_credentials)

        self.login(self.current_user_credentials.get('email'),
                   self.current_user_credentials.get('password'))

    def test_should_require_login(self):
        self.should_require_login(self.query_under_test, op_name=self.op_name,
                                  variables=dict(input={
                                      **self.get_valid_input()})),

    def test_validation(self):
        with self.subTest('name should be non null'):
            with PreventStdErr():
                response = self.gql(self.query_under_test,
                                    op_name=self.op_name,
                                    variables=dict(
                                        input=dict(
                                            **self.get_valid_input(name=None))))

            response_content: dict = json.loads(response.content)
            errors: List = response_content.get('errors')

            self.assertIsNotNone(errors)
            self.assertIn('In field "name": Expected "String!", found null.',
                          errors[0].get('message'))

        with self.subTest('info should be non null'):
            with PreventStdErr():
                response = self.gql(self.query_under_test,
                                    op_name=self.op_name,
                                    variables=dict(
                                        input=dict(
                                            **self.get_valid_input(info=None))))

            response_content: dict = json.loads(response.content)
            errors: List = response_content.get('errors')

            self.assertIsNotNone(errors)
            self.assertIn(
                'In field "info": Expected "String!", found null.',
                errors[0].get('message'))

    def test_should_return_expected_results(self):
        response = self.gql(self.query_under_test,
                            op_name=self.op_name,
                            variables={'input': self.get_valid_input(
                                name='new grocery',
                                info='new info')})

        self.assertResponseNoErrors(response)

        grocery: dict = json.loads(response.content).get(
            'data').get(self.op_name).get('grocery')

        self.assertIsNotNone(grocery)
        self.assertEqual(grocery.get('name'), 'new grocery')
        self.assertEqual(grocery.get('info'), 'new info')
        self.assertEqual(grocery.get('inCart'), True)


@tag('integration')
class UpdateGroceryTest(CreditaskTestBase):
    GRAPHQL_SCHEMA = schema

    def get_valid_input(self):
        return dict(
            id=self.existing_grocery.id
        )

    def setUp(self):
        self.op_name = 'updateGrocery'
        self.query_under_test = \
            f'''
            mutation {self.op_name}($input: GroceryUpdateInput!) {{
                {self.op_name}(input: $input) {{
                    grocery {{
                        id
                        name
                        info
                        inCart
                    }}
                }}
            }}
            '''

        self.current_user_credentials = {
            'email': 'current_user@email.com',
            'password': 'pwuser1'
        }
        self.current_user = self.current_user = create_user(
            group=create_group(),
            **self.current_user_credentials)

        self.existing_grocery = create_grocery(group=self.current_user.group)

        self.login(self.current_user_credentials.get('email'),
                   self.current_user_credentials.get('password'))

    def test_should_require_login(self):
        self.should_require_login(self.query_under_test, op_name=self.op_name,
                                  variables=dict(input={
                                      **self.get_valid_input()})),

    def test_validation(self):
        with self.subTest('id should be non null'):
            with PreventStdErr():
                response = self.gql(self.query_under_test,
                                    op_name=self.op_name,
                                    variables=dict(
                                        input=dict(id=None)))

            response_content: dict = json.loads(response.content)
            errors: List = response_content.get('errors')

            self.assertIsNotNone(errors)
            self.assertIn('In field "id": Expected "ID!", found null.',
                          errors[0].get('message'))

        with self.subTest('info should be nullable'):
            response = self.gql(self.query_under_test,
                                op_name=self.op_name,
                                variables=dict(
                                    input=dict(**self.get_valid_input(),
                                               info=None)))

            response_content: dict = json.loads(response.content)
            errors: List = response_content.get('errors')

            self.assertResponseNoErrors(response)

        with self.subTest('name should be nullable'):
            response = self.gql(self.query_under_test,
                                op_name=self.op_name,
                                variables=dict(
                                    input=dict(
                                        **self.get_valid_input(), name=None)))

            response_content: dict = json.loads(response.content)
            errors: List = response_content.get('errors')

            self.assertResponseNoErrors(response)

        with self.subTest('in_cart should be nullable'):
            response = self.gql(self.query_under_test,
                                op_name=self.op_name,
                                variables=dict(
                                    input=dict(
                                        **self.get_valid_input(), inCart=None)))

            response_content: dict = json.loads(response.content)
            errors: List = response_content.get('errors')

            self.assertResponseNoErrors(response)

    def test_should_return_expected_results(self):
        existing_grocery = create_grocery(group=self.current_user.group,
                                          name='name to update',
                                          info='Info to update', in_cart=False)
        response = self.gql(self.query_under_test,
                            op_name=self.op_name,
                            variables=dict(
                                input=dict(id=existing_grocery.id,
                                           name='updated name',
                                           info='updated info', inCart=True)))

        self.assertResponseNoErrors(response)

        grocery: dict = json.loads(response.content).get(
            'data').get(self.op_name).get('grocery')

        self.assertIsNotNone(grocery)
        self.assertEqual(grocery.get('id'), str(existing_grocery.id))
        self.assertEqual(grocery.get('name'), 'updated name')
        self.assertEqual(grocery.get('info'), 'updated info')
        self.assertEqual(grocery.get('inCart'), True)
